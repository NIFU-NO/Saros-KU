library(dplyr)

# Read in survey_data from disk - to ease caching
survey_data[[params$cycle]] <-
  qs::qread(file = here::here(paste0(paths$data$saros_ready[[params$cycle]], ".qs")),
            strict = TRUE, nthreads = 4)

### Chapter overview for main report
chapter_overview[[params$cycle]] <-
  paths$chapter_overview[[params$cycle]] %>%
  readxl::read_excel() %>% 
  dplyr::mutate(chapter = ifelse(!is.na(subchapter), subchapter, chapter)) %>% 
  dplyr::slice(1:6)

############################################################
## config_report.R
config_macro[[params$cycle]] <- 
  saros::read_default_draft_report_args(
  path = fs::path(paths$resources, "YAML", "_report_generation_setup.yaml")
  )

config_macro[[params$cycle]]$title <- cycle 
config_macro[[params$cycle]]$variables_always_at_bottom <-
  config_macro[[params$cycle]]$variables_always_at_bottom[
    config_macro[[params$cycle]]$variables_always_at_bottom %in% unname(unlist(labelled::var_label(survey_data[[params$cycle]])))
  ]

# tryCatch(fs::dir_delete(fs::path(paths$drafts_produced,
#                                  "Rapporter", params$response_group, params$cycle)), error=function(e) cli::cli_warn(e))
# tryCatch(fs::dir_delete(fs::path(paths$drafts_completed,
#                                  "Rapporter", params$response_group, params$cycle)), error=function(e) cli::cli_warn(e))

saros::draft_report(
    data = survey_data[[params$cycle]],
    chapter_overview = chapter_overview[[params$cycle]],
    !!!config_macro[[params$cycle]],
    path = fs::path(paths$drafts_produced, "Rapporter", params$cycle))
