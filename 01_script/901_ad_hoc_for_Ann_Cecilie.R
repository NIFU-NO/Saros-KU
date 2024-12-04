library(tidyverse)

survey_data$`2023` %>% 
  filter(!is.na(bedrift_23)) %>% 
  mutate(bedrift_23 =
           forcats::fct_relabel(
             bedrift_23, ~stringr::str_replace_all(.x, 
                                                   pattern = "Informasjons- og kommunikasjonsvirksomhet \\(forlagsvirksomhet, video- og fjernsynsprogramproduksjon, forvaltning og drift av IT-systemer mm.\\)", 
                                                   replacement = "Informasjons- og kommunikasjonsvirksomhet"))) %>% 
  mutate(bedrift_23 =
           forcats::fct_relabel(
             bedrift_23, ~stringr::str_replace_all(.x, 
                                                   pattern = "Faglig og teknisk tjenesteyting i privat sektor \\(juridisk tjenesteyting, regnskap og revisjon, bedriftsrådgivning, teknisk konsulentvirksomhet, reklamebyråvirksomhet mm.\\)", 
                                                   replacement = "Faglig og teknisk tjenesteyting i privat sektor"))) %>% 
  
  mutate(bedrift_23 =
           forcats::fct_relabel(
             bedrift_23, ~stringr::str_replace_all(.x, 
                                                   pattern = "Finansiell og forretningsmessig tjenesteyting \\(bankvirksomhet, forsikringsvirksomhet, eiendomsdrift og forvaltning, utleie- og leasingvirksomhet, reisebyråvirksomhet mm.\\)", 
                                                   replacement = "Finansiell og forretningsmessig tjenesteyting"))) %>% 
  
  
mutate(utlstud = forcats::fct_rev(utlstud)) %>%
  mutate(bedrift_23_n = sum(as.character(utlstud)=="Ja", na.rm = TRUE)/n(), .by=bedrift_23) %>%
  arrange(desc(bedrift_23_n)) %>% 
  mutate(bedrift_23 = factor(bedrift_23, levels=unique(bedrift_23))) %>% 
  ggstats::gglikert_stacked(include = utlstud, 
                            y=bedrift_23, 
                            sort="descending", sort_method = "prop",
                    y_label_wrap = 40) +
  scale_fill_manual(values = c("#ffffff", nifutheme::nifu_cols()[1]))

survey_data$`2023` %>% 
  filter(!is.na(bedrift_23)) %>% 
  mutate(utlstud = forcats::fct_rev(utlstud)) %>%
  ggstats::gglikert_stacked()
  

survey_data$`2023` %>%
  filter(!is.na(bedrift_23)) %>% 
  mutate(id = 1) %>% 
  select(id, bedrift_23, utlstud) %>% 
  # pivot_wider(names_from = bedrift_23, values_from = bedrift_23, id_cols = c(id, utlstud)) %>% 
  # summarize(across(-c(id), ~sum(!is.na(.x))), .by=utlstud) %>%
  # mutate(across(-utlstud, ~.x/n()), .by=c(utlstud)) %>% 
  # pivot_longer(cols = -utlstud) %>% 
  ggplot(aes(y=bedrift_23, x=id, fill=utlstud)) +
  geom_bar(position = "fill", stat="identity") +
  scale_y_discrete(labels = label_wrap_gen(width = 35)) + 
  scale_x_continuous(labels = scales::percent) +
  theme_classic() +
  labs(x="%", y=NULL)

survey_data$`2023` %>% 
  filter(omsorgsansvar != "Nei") %>% 
  crosstable::crosstable(arbtidho, by="kjønn", 
                         percent_pattern = list(body="{p_col}", total_col="{p_row}", total_row="{p_col}", total_all="{p_tot}"), 
                         showNA = "no", total = "both", percent_digits = 0, test = T)
#############################
dat_bakgrunnskart <- 
  sf::read_sf(file.path(Sys.getenv("USERPROFILE"), "NIFU", "Metode - General", "SAROS-core", "shared resources", "maps", "fylker2021.json"), 
              layer = "fylker2021",
              stringsAsFactors = TRUE, as_tibble = TRUE) %>% 
  mutate(Fylkesnavn = case_when(Fylkesnavn == "Trøndelag – Trööndelage" ~ "Trøndelag",
                                Fylkesnavn == "Troms og Finnmark – Romsa ja Finnmárku – Tromssa ja Finmarkku" ~ "Troms og Finnmark",
                                .default = Fylkesnavn))

dat_kart_fokus <-
  survey_data$`2023` %>% 
  dplyr::filter(!is.na(arbfylke_23), 
                arbfylke_23 != "Utland eller offshore",
                !is.na(utlstud)) %>% 
  dplyr::mutate(arbfylke_23 = case_when(arbfylke_23 %in% c("Akershus", "Buskerud", "Østfold") ~ "Viken",
                                        arbfylke_23 %in% c("Troms", "Finnmark") ~ "Troms og Finnmark",
                                        arbfylke_23 %in% c("Vestfold", "Telemark") ~ "Vestfold og Telemark",
                                        .default = arbfylke_23)) %>% 
  dplyr::summarize(prosent = sum(utlstud == "Ja", na.rm=TRUE)/n(), 
                   # kvinne = sum(kjønn == "Kvinne", na.rm=TRUE)/n(), 
                   .by=arbfylke_23) %>% 
  rename(Fylkesnavn = arbfylke_23)

dat_bakgrunnskart_koblet <-
  dplyr::left_join(x = dat_bakgrunnskart, 
                   y = dat_kart_fokus,
                   by = "Fylkesnavn") %>% 
  sf::st_as_sf(coords = c("_CX", "_CY"))
sf::st_crs(dat_bakgrunnskart_koblet) <- 25833
kart1 <-
  ggplot2::ggplot(data = dat_bakgrunnskart_koblet,
                  mapping = ggplot2::aes(data_id = Fylkesnavn, 
                                         tooltip = Fylkesnavn)) +
  ggplot2::theme_void() +
  ggplot2::geom_sf(mapping = ggplot2::aes(fill = prosent)) +
  ggplot2::geom_sf_label(mapping = ggplot2::aes(label = paste0(round(prosent*100, 0), " %"))) +
  ggplot2::scale_fill_gradient(low =  '#90D4E0', high = "#1B555F") +
  ggplot2::guides(fill = "none")
kart1


##
dat_kart_fokus <-
  survey_data$`2023` %>% 
  dplyr::filter(!is.na(arbfylke_23), 
                arbfylke_23 != "Utland eller offshore",
                !is.na(morsmål_23)) %>% 
  dplyr::mutate(arbfylke_23 = case_when(arbfylke_23 %in% c("Akershus", "Buskerud", "Østfold") ~ "Viken",
                                        arbfylke_23 %in% c("Troms", "Finnmark") ~ "Troms og Finnmark",
                                        arbfylke_23 %in% c("Vestfold", "Telemark") ~ "Vestfold og Telemark",
                                        .default = arbfylke_23)) %>% 
  dplyr::summarize(prosent = sum(morsmål_23 == "Annet", na.rm=TRUE)/n(), 
                   .by=arbfylke_23) %>% 
  rename(Fylkesnavn = arbfylke_23)

dat_bakgrunnskart_koblet <-
  dplyr::left_join(x = dat_bakgrunnskart, 
                   y = dat_kart_fokus,
                   by = "Fylkesnavn") %>% 
  sf::st_as_sf(coords = c("_CX", "_CY"))
sf::st_crs(dat_bakgrunnskart) <- 25833
kart2 <-
  ggplot2::ggplot(data = dat_bakgrunnskart_koblet,
                  mapping = ggplot2::aes(data_id = Fylkesnavn, 
                                         tooltip = Fylkesnavn)) +
  ggplot2::theme_void() +
  ggplot2::geom_sf(mapping = ggplot2::aes(fill = prosent)) +
  ggplot2::geom_sf_label(mapping = ggplot2::aes(label = paste0(round(prosent*100, 0), " %"))) +
  ggplot2::scale_fill_gradient(low =  '#90D4E0', high = "#1B555F") +
  ggplot2::guides(fill = "none")
kart2

#### 
dat_kart_fokus <-
  survey_data$`2023` %>% count(innvandrer_kat)
  dplyr::filter(!is.na(arbfylke_23), 
                arbfylke_23 != "Utland eller offshore",
                !is.na(utlstud)) %>% 
  dplyr::mutate(arbfylke_23 = case_when(arbfylke_23 %in% c("Akershus", "Buskerud", "Østfold") ~ "Viken",
                                        arbfylke_23 %in% c("Troms", "Finnmark") ~ "Troms og Finnmark",
                                        arbfylke_23 %in% c("Vestfold", "Telemark") ~ "Vestfold og Telemark",
                                        .default = arbfylke_23)) %>% 
  dplyr::summarize(prosent = sum(morsmål_23 == "Annet", na.rm=TRUE)/n(), 
                   .by=arbfylke_23) %>% 
  rename(Fylkesnavn = arbfylke_23)

dat_bakgrunnskart_koblet <-
  dplyr::left_join(x = dat_bakgrunnskart, 
                   y = dat_kart_fokus,
                   by = "Fylkesnavn") %>% 
  sf::st_as_sf(coords = c("_CX", "_CY"))
sf::st_crs(dat_bakgrunnskart) <- 25833
kart2 <-
  ggplot2::ggplot(data = dat_bakgrunnskart_koblet,
                  mapping = ggplot2::aes(data_id = Fylkesnavn, 
                                         tooltip = Fylkesnavn)) +
  ggplot2::theme_void() +
  ggplot2::geom_sf(mapping = ggplot2::aes(fill = prosent)) +
  ggplot2::geom_sf_label(mapping = ggplot2::aes(label = paste0(round(prosent*100, 0), " %"))) +
  ggplot2::scale_fill_gradient(low =  '#90D4E0', high = "#1B555F") +
  ggplot2::guides(fill = "none")
ggiraph::girafe(ggobj = kart2)