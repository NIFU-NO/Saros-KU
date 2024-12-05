

params$cycle <- "2023"
source(here::here(paths$r, paste0("002_specify_report_cycle_params_for_", params$cycle, ".R")))
source(here::here(paths$r, "003_get_report_cycle_paths.R"))
source(here::here(paths$r, paste0("200_prep_data_for_", params$cycle, ".R")))
source(here::here(paths$r, paste0("900_draft_macro_report_", params$cycle, ".R")))
source(here::here(paths$r, paste0("901_draft_mesos_reports.R")))

# Compose entire website and DOCX/PDF reports
source(here::here(paths$r, "902_copy_files_for_final_rendering.R"))
source(here::here(paths$r, "905_render.R"))
# source(here::here(paths$r, "906_setup_access_restrictions.R")) # Must be run after each render

## Only run for new cycles
#source(fs::path(paths$r, paste0("002_specify_report_cycle_params_for_", params$cycle, ".R")))
#source(here::here(paths$r, "907_post_process_docx_report.R"))
