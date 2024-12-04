for(cycle in c("2023")) {
    params$cycle <- cycle
    source(here::here(paths$r, paste0("002_specify_report_cycle_params_for_", params$cycle, ".R")))
    source(here::here(paths$r, "003_get_report_cycle_paths.R"))
    source(here::here(paths$r, paste0("200_prep_data_for_", params$cycle, ".R")))
    # source(here::here(paths$r, paste0("900_draft_macro_report_", params$cycle, ".R")))
    # source(here::here(paths$r, paste0("901_draft_mesos_reports.R")))
}


#source(here::here(paths$r, "905_render.R"))
