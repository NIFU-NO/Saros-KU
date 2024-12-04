library(dplyr, warn.conflicts = FALSE)
conflicted::conflicts_prefer(dplyr::filter, dplyr::lag, .quiet=TRUE)

original_labels <- 
  paths$df_labels[[params$cycle]] %>% 
  readRDS() %>% 
  rename(arbniva_21_23 = arbniva_21)

survey_data[[params$cycle]] <-
  paths$data$survey[[params$cycle]] %>%
  haven::read_dta() %>% # Om vi benytter parquet-formatet og rio-pakken så får vi alt det gode samt slipper unlabelled?
  labelled::unlabelled()


survey_data[[params$cycle]] <-
  survey_data[[params$cycle]] %>% 
  dplyr::mutate(across(c(matches("samlvurd_[12]$"), matches("^spesvurd_[1234]$")) &
                         where(~!is.factor(.x)),
                       ~factor(.x, levels=1:5, 
                               labels = c("Svært misfornøyd", "Litt misfornøyd", "Verken eller",
                                              "Litt fornøyd", "Svært fornøyd"))),
                fagfelt = case_when(fagfelt == "Andre helse- og sosialfag" ~ "Helse- og sosialfag, ekskl. medisin",
                                    .default = fagfelt),
                fagfelt = forcats::fct_infreq(fagfelt),
                arbniva_21_23 = factor(arbniva_21_23, 
                                       levels = 1:5,
                                       labels = c("Ph.d.", "Master", "Bachelor", "Høyere yrkesfaglig utdanning (fagskole)",
                                                  "Trenger ikke høyere utdanning")),
                arbniva_21_23 = forcats::fct_rev(arbniva_21_23),
                horisontalt_samsvar = forcats::fct_rev(horisontalt_samsvar),
                skole = case_when(skole == "Nord universitet" ~ "Nord",
                                  skole == "Høgskolen i Østfold" ~ "HiØ",
                                  skole == "Høgskulen på Vestlandet" ~ "HVL",
                                  skole == "OsloMet - storbyuniversitetet" ~ "OsloMet",
                                  skole == "Norges teknisk-naturvitenskapelige universitet" ~ "NTNU",
                                  skole == "Høgskolen i Innlandet" ~ "HINN",
                                  skole == "UiT Norges arktiske universitet" ~ "UiT",
                                  skole == "Universitetet i Oslo" ~ "UiO",
                                  skole == "Universitetet i Bergen" ~ "UiB",
                                  skole == "Norges Handelshøyskole" ~ "NHH",
                                  skole == "Universitetet i Sørøst-Norge" ~ "USN",
                                  skole == "Norges miljø- og biovitenskapelige universitet" ~ "NMBU",
                                  skole == "Universitetet i Agder" ~ "UiA",
                                  skole == "Universitetet i Stavanger" ~ "UiS",
                                  skole == "Forsvarets høgskole" ~ "FHS",
                                  skole == "VID vitenskapelige høgskole" ~ "VID",
                                  skole == "Høyskolen Kristiania" ~ "Kristiania",
                                  skole == "Norges musikkhøgskole" ~ "NMH",
                                  skole == "Høgskolen i Molde - Vitenskapelig høgskole i logistikk" ~ "HiMolde",
                                  skole == "Kunsthøgskolen i Oslo" ~ "KhiO",
                                  skole == "Norges idrettshøgskole" ~ "NIH",
                                  skole == "Høgskulen i Volda" ~ "HiVolda",
                                  skole == "MF vitenskapelig høyskole for teologi, religion og samfunn" ~ "MF",
                                  skole == "NLA Høgskolen" ~ "NLA",
                                  skole == "Dronning Mauds Minne Høgskole for barnehagelærerutdanning" ~ "DMMH",
                                  skole == "Lovisenberg diakonale høgskole" ~ "LDH",
                                  skole == "Sámi allaskuvla/Sámi University of Applied Sciences" ~ "SAMAS",
                                  skole == "Fjellhaug Internasjonale Høgskole" ~ "FIH",
                                  skole == "Ansgar høyskole" ~ "Ansgar",
                                  skole == "" ~ NA_character_,
                                  .default = "UKJENT")
                # skole = forcats::fct_infreq(skole)
                ) %>% 
  labelled::copy_labels_from(original_labels) %>% 
  labelled::set_variable_labels(#bosted_1 = "Nåværende bostedsfylke",
                                #bosted_2 = "Bostedfylke da du var 17 år",
                                samtykke = "Har samtykket",
                                kull = "Kull",
                                fagfelt = "Fagfelt",
                                nifu_fagfelt = "Fagfelt",
                                skole = "Lærested",
                                sysselsatt = "Sysselsetting",
                                innvandrer_kat = "Innvandrerkategori",
                                undersyssel = "Under-sysselsetting",
                                tilfr_syssel = "Tilfredshet med sysselsetting",
                                mistilpasset = "Mistilpassethet",
                                mistilp2 = "Mistilpassethet p2",
                                foerste_jobb = "Hvordan fikk du ditt første inntektsgivende arbeid etter fullført utdanning våren 2023? (Regn ikke med feriejobber og småjobber)",
                                tiltak = "Var du i uken 13.-19. november 2023 engasjert i et arbeidsmarkeds- eller sysselsettingstiltak?",
                                
                                forventninger_23 = "Sammenlignet med forventningene du hadde som student, hvor lett eller vanskelig har det vært å finne arbeid i samsvar med din kompetanse?",
                                
                                forsok23 = "Har du fram til og med 19. november 2023 aktivt forsøkt å få arbeid, og i så fall i hvilke perioder søkte du?",
                                merarb_23 = "Hadde du i uken 13.-19. november 2023 mer enn én jobb? (ekstrajobb eller liknende)",
                                
                                #vid_uten ikke i 2023
                                
                                studakt1 = "Deltok du i noen av følgende aktiviteter i løpet av studietiden din? - Skrev prosjekt-, diplom- eller masteroppgave på oppdrag fra eller i samarbeid med en bedrift/virksomhet",
                                
                                studakt6 = "Deltok du i noen av følgende aktiviteter i løpet av studietiden din? - Hadde obligatorisk praksis i en bedrift/offentlig virksomhet",
                                
                                studakt7 = "Deltok du i noen av følgende aktiviteter i løpet av studietiden din? - Hadde frivillig praksis i en bedrift/offentlig virksomhet (ikke betalt arbeid)",
                                
                                studakt8 = "Deltok du i noen av følgende aktiviteter i løpet av studietiden din? - Hadde praksis i en virksomhet/bedrift i utlandet",
                                
                                #Finner ikke studakt9 og 10 noen sted -Frivillig hva da?
                                
                                #Finner ikke mod_eg1-7 heller, study_1-5, fin_eg1-5
                                #Finner ikke: I hvilken grad krever denne jobben mer kunnskap eller ferdigheter enn du faktisk (mer_kunn)
                                
                                
                                #DATO LABELS SPØRR STEPHAN
                                tidlfoer = "Når hadde du dette arbeidet, og var noe av arbeidet relevant for utdanningen du avsluttet våren 2020? Se bort fra obligatorisk praksis i forbindelse med studiet. - Før utdanningen ble påbegynt",
                                tidlunder = "Når hadde du dette arbeidet, og var noe av arbeidet relevant for utdanningen du avsluttet våren 2020? Se bort fra obligatorisk praksis i forbindelse med studiet. - Ved siden av utdanningen",
                                tidlavbrudd = "Når hadde du dette arbeidet, og var noe av arbeidet relevant for utdanningen du avsluttet våren 2020? Se bort fra obligatorisk praksis i forbindelse med studiet. - Som avbrudd i utdanningen",
                                
                                stud15 = "Var du i uken 13.-19. november 2023 beskjeftiget med studier? (Doktorgradsutdanning regnes også som studier.)",
                                
                                arbeidny = "Utførte du inntektsgivende arbeid av minst én times varighet i uken 13.-19. november 2023? Arbeid gjennom arbeidsmarkedstiltak skal her ikke regnes som inntektsgivende arbeid.",
                                
                                tiltakny = "Var du i uken 13.-19. november 2023 engasjert i et arbeidsmarkeds- eller sysselsettingstiltak?",
                                
                                merarb_a = "Hadde du i uken 13.-19. november 2023 mer enn én jobb? (ekstrajobb eller liknende)",
                                
                                deltdpro = "Du har svart at du jobber deltid i din hovedjobb. Hva er din stillingsprosent? Fyll inn stillingsprosent under.",
                                #Dato igjen
                                lonn = "Hva var din brutto, ordinære MÅNEDSLØNN (før skatt) for november 2023 i denne jobben? (Regn ikke med overtid, bonus eller ekstrainntekter.) Kroner per MÅNED:",
                                
                                offentli = "Var stillingen utlyst offentlig (f.eks. stillingsannonse på finn.no, nav.no etc.)" 
                                
                                ) %>% 
  dplyr::filter(kull == 2023)


survey_data[[params$cycle]] %>% 
  select(sysselsatt, arbniva_21_23, utnyttel, horisontalt_samsvar, 
         matches("samlvurd_[12]$"), matches("^spesvurd_[1234]$"),
         fagfelt, skole) %>% 
  labelled::lookfor(details = T) %>% View()



check_labels[[params$cycle]] <-

  survey_data[[params$cycle]] %>%
  select(sysselsatt, arbniva_21_23, utnyttel, horisontalt_samsvar, 
         matches("samlvurd_[12]$"), matches("^spesvurd_[1234]$"),
         fagfelt, skole) %>% 
  labelled::lookfor(details = TRUE) %>%
  select(variable, label, col_type) %>%
  tidyr::separate(label, into=c("label_prefix", "label_suffix", "label_surplus"), sep = " - ", remove = FALSE) %>%
  group_by(label, label_prefix, label_suffix, label_surplus, col_type) %>%
  mutate(n = n()) %>%
  ungroup() %>%
  filter(n>1)
stopifnot()

qs::qsave(x = survey_data[[params$cycle]],
          file = here::here(paste0(paths$data$saros_ready[[params$cycle]], ".qs")), nthreads = 4)
# survey_data[[params$cycle]] %>% 
#   labelled::set_variable_labels(.strict = FALSE, .labels =
#                                   purrr::map(labelled::get_variable_labels(.),
#                                              ~{
#                                                if(length(.x)==0) return()
#                                                .x
#                                              })) %>%
#   haven::write_dta(path = here::here(paste0(paths$data$saros_ready[[params$cycle]], ".dta")))
