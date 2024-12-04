
username_folder_matching_df <-
  readxl::read_excel(fs::path(paths$saros, "_username_folder_matching_df.xlsx"))

saros.utils::setup_access_restrictions(
  remote_basepath = "/home/nifuno/domains/stephan/du.nifu.no/public_html/",
  local_basepath = file.path(paths$site, "_site"),
  rel_path_base_to_parent_of_user_restricted_folder =
    unlist(lapply(list.dirs(fs::path(paths$site, "Rapporter"), full.names=FALSE, recursive=FALSE),
                  function(cycle) {
                    sub_paths <-
                      list.dirs(path = fs::path(paths$site, "Rapporter", cycle), full.names = FALSE, recursive = FALSE)
                    sub_paths <-
                      stringr::str_subset(sub_paths, pattern = "^_", negate = TRUE)
                    fs::path("Rapporter", cycle, sub_paths, "Tilbyderrapporter")
                  })),
  local_main_password_path = file.path("..", "..", "Metode - Sensitivt - Sensitivt", ".main_htpasswd_private"),
  username_folder_matching_df = username_folder_matching_df,
  universal_usernames = c("admin", "nifu", "udir"))
