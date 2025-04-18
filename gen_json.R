library(datasetjson)

extract_xpt_meta <- function(n, .data, label = NULL) {
  
  attrs <- attributes(.data[[n]])
  
  out <- list()

  # Identify the variable type
  if (inherits(.data[[n]],"Date")) {
    out$dataType <- "date"
    out$targetDataType <- "integer"
  } else if (inherits(.data[[n]],"POSIXt")) {
    out$dataType <- "datetime"
    out$targetDataType <- "integer"
  } else if (inherits(.data[[n]],"numeric")) {
    if (any(is.double(.data[[n]]))) out$dataType <- "float"
    else out$dataType <- "integer"
  }  else if (inherits(.data[[n]],"hms")) {
    out$dataType <- "time"
    out$targetDataType <- "integer"
  } else {
    out$dataType <- "string"
    out$length <- max(purrr::map_int(.data[[n]], nchar))
  }
  
  out$itemOID <- n
  out$name <- n
  if (is.null(label)) {
    out$label <- attr(.data[[n]], 'label')
  } else {
    out$label <- label
  }
  out$label <- attr(.data[[n]], 'label')
  out$displayFormat <- attr(.data[[n]], 'format.sas')
  tibble::as_tibble(out)
  
}

#adsl_raw <- haven::read_xpt(file.path(system.file(package='datasetjson'), "adsl.xpt"))
adsl_raw <- haven::read_xpt(file.path("data", "adsl.xpt"))
adtte_raw <- haven::read_xpt(file.path("data", "adtte.xpt"))
adae_raw <- haven::read_xpt(file.path("data", "adae.xpt"))

# Loop the ADSL columns
adsl_meta <- purrr::map_df(names(adsl_raw), extract_xpt_meta, .data=adsl_raw, label = "Subject-level Analysis Data Set")
adtte_meta <- purrr::map_df(names(adtte_raw), extract_xpt_meta, .data=adtte_raw, label = "Data for the Time to Event Analyses")
adae_meta <- purrr::map_df(names(adae_raw), extract_xpt_meta, .data=adae_raw, label = "Adverse Event Analysis")

# Create the datasetjson object
adsl_json <- dataset_json(
  adsl_raw, 
  item_oid = "ADSL",
  name = "ADSL",
  dataset_label = "Subject-Level Analysis Data Set",
  columns = adsl_meta
)

adtte_json <- dataset_json(
  adtte_raw, 
  item_oid = "ADTTE",
  name = "ADTTE",
  dataset_label = "Data for the Time to Event Analyses",
  columns = adtte_meta
)

adae_json <- dataset_json(
  adae_raw, 
  item_oid = "ADAE",
  name = "ADAE",
  dataset_label = "Adverse Event Analysis",
  columns = adae_meta
)

# Write the JSON
write_dataset_json(adsl_json, file = "www/adsl.json")
write_dataset_json(adtte_json, file = "www/adtte.json")
write_dataset_json(adae_json, file = "www/adae.json")