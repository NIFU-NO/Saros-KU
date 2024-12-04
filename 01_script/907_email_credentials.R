eposter <-
  saros::create_email_credentials(local_basepath = paths$drafts_completed,
                                rel_path_base_to_parent_of_user_restricted_folder =
                                  fs::path("Rapporter", params$cycle, params$response_group, "Mesos"),
                                email_data_frame = readxl::read_excel(paths$mesos_contacts[[params$cycle]][[params$response_group]],
                                                                      sheet = params$response_group),
                                email_col= "email",
                                username_col = "username",
                                ignore_missing_emails = TRUE,
                                local_main_password_path = file.path("..", "..", "Metode - Sensitivt - Sensitivt", ".main_htpasswd_private"),
                                email_body = "
Hei {Fornavn}!
NIFUs studiestedsspesifikke rapporter for Deltagerundersøkelsene (på oppdrag fra Udir) er nå tilgjengelig på https://du.nifu.no/. Her finnes både overordnede resultater, samt tilbyderspesifikke rapporter under Mesos på venstre side i hver rapport. Vi sender dette til deg da Udir har oppført deg som kontaktperson. Følgende brukernavn og passord er felles for alle ved {username} og du som kontaktperson er ansvarlig for behandling av tilgang internt.

  Brukernavn:   {username}
  Passord:      {password}

Der det er uoverensstemmelser for tall mellom disse nettsidene (kalt Saros) og publiserte rapporter på www.nifu.no er det sistnevnte som er de offisielle. For mer informasjon om publiseringssystemet, se https://saros.nifu.no.
Vi har dessverre ikke anledning til å tilby ytterligere analyser for din institusjon.


Vennlig hilsen prosjektgruppen i Deltakerundersøkelsene ved
Stephan Daus     | Cathrine Pedersen
Saros-ansvarlig   | Prosjektleder

NIFU Nordisk institutt for studier av innovasjon, forskning og utdanning
",
email_subject = "Innloggingsdetaljer for {username} til Deltagerundersøkelsenes tilbyderspesifikke rapporter")


if(nrow(eposter)>0) {
  for(i in seq_len(nrow(eposter))) {
    if(isTRUE(send_emails)) {
      ny_epost <-
        outlb$get_drafts()$create_email(body = eposter[i, "body"][[1]],
                                        subject = eposter[i, "subject"][[1]],
                                        to = eposter[i, "to"][[1]])$
      send() # Sett på dollartegnet på linjen ovenfor og send() her så sendes de. Ellers bare utkast
      cat(paste0("Eposter med passord er utsendt til ", params$cycle, "/", params$response_group, " den ", Sys.time()),
          file = here::here("_email_credentials_log.txt"), append = TRUE)
    } else {
      ny_epost <-
        outlb$get_drafts()$create_email(body = eposter[i, "body"][[1]],
                                        subject = eposter[i, "subject"][[1]],
                                        to = eposter[i, "to"][[1]])
    }
  }
} else cli::cli_warn("Ingen eposter genereres for {params$cycle}/{params$response_group}")
