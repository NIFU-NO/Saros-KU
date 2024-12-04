library(dplyr)

# Read in survey_data from disk - to ease caching
survey_data[[params$cycle]] <-
  qs::qread(file = here::here(paste0(paths$data$saros_ready[[params$cycle]], ".qs")),
            strict = TRUE, nthreads = 4)

#### MESOS ######

######################## Make chapter_structure ###################
saros_data[[params$cycle]] <-
  survey_data[[params$cycle]] |>
  dplyr::filter(.data[[params$mesos_var]] != "") |>
  dplyr::filter(dplyr::n() >= 20, .by=c(skole, nifu_fagfelt))

config_refine_data_overview[[params$cycle]] <- 
  saros.base::read_default_draft_report_args(path = fs::path(paths$resources, "YAML", "_refine_data_overview_settings.yaml"))
config_refine_data_overview[[params$cycle]]$data <- saros_data[[params$cycle]]
config_refine_data_overview[[params$cycle]]$chunk_templates <- saros.base::get_chunk_template_defaults(2) |> dplyr::slice(c(2,1))
config_refine_data_overview[[params$cycle]]$chapter_overview <-
  paths$topic_overview[[params$cycle]] |>
  readxl::read_excel() |>
  dplyr::mutate(indep = stringr::str_replace(indep, ", skole", ""))

chapter_structure[[params$cycle]] <- 
  rlang::inject(saros.base::refine_chapter_overview(!!!config_refine_data_overview[[params$cycle]]))

######################## draft_report ###################
config_draft_report[[params$cycle]] <- 
  saros.base::read_default_draft_report_args(
    path = fs::path(paths$resources, "YAML", "_draft_report_settings.yaml")
  )
config_draft_report[[params$cycle]]$path <- 
  fs::path(paths$site_drafts_completed, params$cycle, params$mesos_var_pretty)
config_draft_report[[params$cycle]]$chapter_structure <- chapter_structure[[params$cycle]]
config_draft_report[[params$cycle]]$data <- saros_data[[params$cycle]]
#tryCatch(fs::dir_delete(fs::path(paths$site_drafts_completed, params$cycle, "Lærested")), error=function(e) cli::cli_warn(e))
rlang::inject(saros.base::draft_report(!!!config_draft_report[[params$cycle]]))



#########################
# Do once
fs::file_copy(path =
                c(file.path(paths$resources, "YAML", c("_quarto.yaml",
                                                       "_global.yaml")),
                  file.path(paths$resources, "CSS", c("styles.css",
                                                      "styles.scss")),
                  file.path(paths$resources, "CitationStyles", "bib_style.csl"),
                  file.path(paths$resources, "Rscripts", "general_formatting.R")
                ),
              new_path =
                c(file.path(paths$site, c("_quarto.yaml",
                                          "_global.yaml")),
                  file.path(paths$site, c("styles.css",
                                          "styles.scss")),
                  file.path(paths$site, "bib_style.csl"),
                  file.path(paths$site, "general_formatting.R")),
              overwrite = TRUE)


withr::with_dir(new = paths$site,
                code = {
                  quarto::quarto_add_extension(extension = "NIFU-NO/nifutypst", no_prompt = TRUE, quiet = TRUE)
                  quarto::quarto_add_extension(extension = "NIFU-NO/nifudocx", no_prompt = TRUE, quiet = TRUE)
                  quarto::quarto_add_extension(extension = "NIFU-NO/rename_duplicate_labels", no_prompt = TRUE, quiet = TRUE)
                  quarto::quarto_add_extension(extension = "NIFU-NO/remove_empty_headings", no_prompt = TRUE, quiet = TRUE)
                })

# ## Do per new cycle
cycles_to_copy_into <- vctrs::vec_c(
  "2023",
)
fs::file_copy(path =
                rep(file.path(paths$resources, "Rscripts", "general_formatting.R"),
                    length(fs::dir_ls(file.path(paths$site_drafts_completed),
                                      regexp = paste0(cycles_to_copy_into, collapse="|"),
                                      recurse = 0, type = "directory"))),
              new_path =
                file.path(paths$site, "Rapporter", cycles_to_copy_into, "general_formatting.R"),
              overwrite = TRUE)

paths_needing_images <-
  c(fs::dir_ls(file.path(paths$site, "Rapporter", cycles_to_copy_into),
               recurse = 2, type = "directory", regexp = params$mesos_var_pretty),
    fs::dir_ls(file.path(paths$site, "Rapporter", cycles_to_copy_into),
               recurse = FALSE, type = "directory")
  ) |>
  stringr::str_subset(pattern = "_images|Lærested", negate = TRUE)

fs::dir_copy(path = rep(file.path(paths$resources, "_images"),
                        length(paths_needing_images)),
             new_path = file.path(paths_needing_images, "_images"),
             overwrite = TRUE)
# fs::dir_copy(path = file.path(paths$resources, "_images"),
#              new_path = file.path(paths$site, "_images"),
#              overwrite = TRUE)


dir_path <- fs::path(paths$site, "Rapporter",
                     "2023", params$mesos_var_pretty)
rename_files <- 
  fs::dir_ls(path = dir_path, recurse = FALSE, regexp = "^[0-9]+_|^index") %>%
  paste0("_", .)
if(!all(rename_files == "_")) fs::file_move(path=names(rename_files), new_path = unname(rename_files))

create_mesos_qmd_files(dir_path = dir_path,
                       mesos_var = params$mesos_var,
                       mesos_groups = sort(unique(saros_data[[params$cycle]][[params$mesos_var]])))

