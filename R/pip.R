#' @export
pip_version <- function(python) {

  # if we don't have pip, just return a placeholder version
  if (!file.exists(python))
    return(numeric_version("0.0"))

  # otherwise, ask pip what version it is
  output <- system2(python, c("-m", "pip", "--version"), stdout = TRUE)
  parts <- strsplit(output, "\\s+")[[1]]
  version <- parts[[2]]
  numeric_version(version)

}

#' @export
pip_install <- function(python, packages, ignore_installed = TRUE) {

  # construct command line arguments
  args <- c("-m", "pip", "install", "--upgrade")
  if (ignore_installed)
    args <- c(args, "--ignore-installed")
  args <- c(args, packages)

  # run it
  result <- system2(python, args)
  if (result != 0L) {
    pkglist <- paste(shQuote(packages), collapse = ", ")
    msg <- paste("Error installing package(s):", pkglist)
    stop(msg, call. = FALSE)
  }

  invisible(packages)

}
#' @export
pip_uninstall <- function(python, packages) {

  # run it
  args <- c("-m", "pip", "uninstall", "--yes", packages)
  result <- system2(python, args)
  if (result != 0L) {
    pkglist <- paste(shQuote(packages), collapse = ", ")
    msg <- paste("Error removing package(s):", pkglist)
    stop(msg, call. = FALSE)
  }

  packages

}
#' @export
pip_freeze <- function(python) {
  
  args <- c("-m", "pip", "freeze")
  output <- system2(python, args, stdout = TRUE)
  splat <- strsplit(output, "==", fixed = TRUE)
  packages <- vapply(splat, `[[`, 1L, FUN.VALUE = character(1))
  versions <- vapply(splat, `[[`, 2L, FUN.VALUE = character(1))
  data.frame(
    package = packages,
    version = versions,
    stringsAsFactors = FALSE
  )
  
}
