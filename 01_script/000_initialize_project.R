here::i_am("01_script/000_initialize_project.R")

remotes::install_github(c("NIFU-NO/saros", "NIFU-NO/saros.base", "NIFU-NO/saros.utils"), quiet = TRUE,
                        upgrade = "always", force = FALSE)


params <- list()
params$mesos_var <- "skole"
params$mesos_var_pretty <- "Lærested"
params$reports <- "Rapporter"

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


## Modify per project
paths$site <- # Should be renamed "local_scratch"
  # "."
  fs::path(Sys.getenv("USERPROFILE"), "Saros", "KU")
paths$remote_basepath <- "/home/nifuno/domains/stephan/du.nifu.no/public_html/"


# FIXED ACROSS ALL SAROS-PROJECTS FOR CONVENIENCE FOR ADMINISTRATORS AND USERS
paths$r <-
  fs::path("01_script")
paths$resources <-
  here::here("02_resources")
paths$organization_global_draft_report_settings <-
  fs::path(Sys.getenv("USERPROFILE"), "NIFU", "Metode - General", "SAROS-core", "shared resources", "_draft_report_settings.yaml")
paths$organization_global_refine_chapter_overview_settings <-
  fs::path(Sys.getenv("USERPROFILE"), "NIFU", "Metode - General", "SAROS-core", "shared resources", "_refine_chapter_overview_settings.yaml")

paths$saros <-  here::here()
paths$site_drafts_completed <-  fs::path(paths$site, params$reports)
paths$local_basepath <- fs::path(paths$site, "_site")
paths$site_resources <- fs::path(paths$site, "_extensions")
paths$site_drafts_completed <- # rename "local_scratch_reports"
  fs::path(paths$site, params$reports)
paths$drafts_completed <- here::here(paths$saros, params$reports)

paths$topImagePath <- here::here("02_resources", "_images", "cover_ovre.png")


paths$map$fylker <- fs::path("..", "..", "Metode - General", "SAROS-core", "shared resources", "maps", "fylker2021.json")
paths$map$kommuner <- fs::path("..", "..", "Metode - General", "SAROS-core", "shared resources", "maps", "kommuner2021.json")
paths$local_main_password_path <- fs::path("..", "..", "Metode - Sensitivt - Sensitivt", ".main_htpasswd_private")
##################

df_labels <- list()
survey_data <- list()
# chapter_overview <- list()
chapter_structure <- list()
saros_data <- list()
config_refine_data_overview <- list()
config_draft_report <- list()
output_files <- list()
chunk_templates <- list()
config_macro <- list()
config_mesos <- list()
output_files <- list()
check_labels <- list()

# copy_folder_contents_to_dir(from = system.file("templates", package = "nifutheme"),
#                             to = paths$resources, overwrite = TRUE)
