library(shinylive)

build_app <- function(dir_build = "site", overwrite = TRUE, verbose = TRUE) {
  # copy current app files to a temporary directory
  if (isFALSE(overwrite) && fs::dir_exists(dir_build)) {
    withr::with_options(
      list(rlang_backtrace_on_error = "none"),
      cli::cli_abort(
        c("Output directory {dir_build} already exists.",
          "Delete the directory or set {.code overwrite=TRUE}"
        ),
        call = NULL
      )
    )
  }


  temp_dir <- fs::file_temp("shinyapp-project-dir")
  on.exit(fs::dir_delete(temp_dir))

  temp_dir_source <- fs::path_join(c(temp_dir, "src"))
  temp_dir_source_www <- fs::path_join(c(temp_dir_source, "www"))
  temp_dir_out <- fs::path_join(c(temp_dir, "out"))

  fs::dir_create(temp_dir)
  fs::dir_create(temp_dir_source_www, recurse = TRUE)
  fs::dir_create(temp_dir_out, recurse = TRUE)
  fs::file_copy("app.R", fs::path(temp_dir_source, "app.R"))
  fs::dir_copy("R", fs::path(temp_dir_source, "R"))
  fs::dir_copy("www", fs::path(temp_dir_source))

  shinylive::export(
    temp_dir_source,
    temp_dir_out,
    verbose = verbose,
    wasm_packages = FALSE
  )

  fs::dir_copy(temp_dir_out, dir_build)
}

build_app()
