library(rix)

# Choose the path to your project
path_default_nix <- "."

rix(
  #date = "2025-02-28", # We recommend using a date
  r_ver = "4.4.3",
  r_pkgs = c("fs", "datasetjson", "shiny", "shinyWidgets", "bslib", "jsonlite", "DT", "dplyr", "reactable", "plotly", "purrr", "reactR", "htmltools", "bsicons", "data.table", "DBI", "RSQLite", "shinylive"), # List all the packages you need
  system_pkgs = c("quarto"),
  ide = "none", # List whatever editor you need
  project_path = path_default_nix,
  overwrite = TRUE,
  print = FALSE
)
