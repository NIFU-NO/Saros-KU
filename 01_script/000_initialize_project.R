here::i_am("01_script/000_initialize_project.R")


params <- list()
params$mesos_var <- "skole"
params$mesos_var_pretty <- "Lærested"

###########

paths <- list()
paths$project_abs <- fs::path(Sys.getenv("USERPROFILE"), "NIFU", "KU Halvtår - General")
paths$data <- list()
paths$data$rel <- fs::path("..", "..", "KU Halvtår - Lukket - Lukket")
paths$data$abs <- fs::path(Sys.getenv("USERPROFILE"), "NIFU", "KU Halvtår - Lukket - Lukket")
paths$data$population <- list()
paths$data$sampling_frame <- list()
paths$data$survey <- list()
paths$df_labels <- list()

paths$r <-
  fs::path("01_script")
paths$resources <-
  here::here("02_resources")
paths$drafts_produced <-
  here::here("03_draft_generations")
paths$drafts_completed <-
  here::here("Rapporter")


paths$site <-
  # fs::path(Sys.getenv("USERPROFILE"), "Saros", "KU")
  fs::path(paths$project_abs, "Saros")
paths$site_drafts_completed <-
  fs::path(paths$site, "Rapporter")

paths$topImagePath <- here::here("02_resources", "_images", "cover_ovre.png")

paths$saros <-
  here::here()

paths$map$fylker <- fs::path("..", "..", "Metode - General", "SAROS-core", "shared resources", "maps", "fylker2021.json")
paths$map$kommuner <- fs::path("..", "..", "Metode - General", "SAROS-core", "shared resources", "maps", "kommuner2021.json")

##################

df_labels <- list()
survey_data <- list()
# chapter_overview <- list()
chapter_structure <- list()
saros_data <- list()
config_macro <- list()
config_refine_data_overview <- list()
config_draft_report <- list()
config_mesos <- list()
output_files <- list()
check_labels <- list()

# copy_folder_contents_to_dir(from = system.file("templates", package = "nifutheme"),
#                             to = paths$resources, overwrite = TRUE)
