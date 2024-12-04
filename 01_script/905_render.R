## Post-PISVEEP (rendering of website and report PDF)
### Render
withr::with_envvar(new = c(LC_ALL="C"),
                   action = "replace",
                   code = {
                     system.time(
                       quarto::quarto_render(
                         input = if(is.null(paths$site)) cli::cli_abort("paths$site is NULL") else paths$site,
                         as_job = F,
                         output_format = c("all")
                       )
                     )
                   })

## Post-processing: Remove unnecessary sidebar items
# Experimental, take a copy of _site first!
saros.utils::remove_reports_from_sidebars(path = fs::path(paths$site, "_site"))