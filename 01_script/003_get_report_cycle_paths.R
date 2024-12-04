# paths$df_labels[[params$cycle]] <-
#   fs::path(paths$data$rel, paste0("Data ", params$cycle), "arbeidsfiler", "labes_r.xls")

paths$data$survey[[params$cycle]] <-
  fs::path(paths$data$rel, "Data", params$cycle, paste0("2000_", params$cycle, "_tidsserie.dta"))

paths$df_labels[[params$cycle]] <-
  fs::path(paths$data$rel, "Data", params$cycle, paste0(params$cycle, "_fulle_labels.rds"))

paths$data$saros_ready[[params$cycle]] <-
  here::here(paths$data$rel, "Data", params$cycle, "Saros", "sarosdata")

fs::dir_create(fs::path_dir(paths$data$saros_ready[[params$cycle]]))

paths$chapter_overview[[params$cycle]] <-
  fs::path(paths$project_abs, paste0("Halvtårsundersøkelse ", params$cycle), "SAROS_Kapitteloversikt.xlsx")

paths$topic_overview[[params$cycle]] <-
  fs::path(paths$project_abs, paste0("Halvtårsundersøkelse ", params$cycle), "SAROS_Rapportering til læresteder.xlsx")
