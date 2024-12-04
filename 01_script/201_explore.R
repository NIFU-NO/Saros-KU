x <- 
  "C:/Users/py128/NIFU/KU Halvtår - Lukket - Lukket/Data 2023/2000_2023_tidsserie.dta" |>
  haven::read_dta() |>
  labelled::unlabelled()

y <-
x |> dplyr::select(59, 60, 70)
  dplyr::select(1:58, 61:69, 71:299) |> #Problem: 59-60, 70
  labelled::lookfor(details = F) |> 
  writexl::write_xlsx(path =here::here("kodebok.xlsx"))
