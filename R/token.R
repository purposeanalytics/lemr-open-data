#' Get or set LEMR Open Data Portal token
#'
#' Get or set a token for reading private data from the LEMR Open Data Portal. Running \code{set_token()} will open your .Renviron file, with a message to set `LEMROPENDATA_KEY` with the token. Once R is restarted, \code{get_token()} will read the token from the file.
#'
#' @param scope Edit globally for the current user, or locally for the current project
#' @param var Environment variable to store token in, defaults to \code{LEMROPENDATA_KEY}
#'
#' @export
#'
#' @rdname token
#'
#' @examples
#' set_token()
#' • Modify '.Renviron'
#' • Restart R for changes to take effect
#' ℹ Set LEMROPENDATA_KEY to LEMR Open Data token in the opened .Renviron
#'
#' get_token()
#' # [1] "test"
set_token <- function(scope = c("project", "user"), var = "LEMROPENDATA_KEY") {
  usethis::edit_r_environ(scope)
  usethis::ui_info("Set {var} to LEMR Open Data token in the opened .Renviron")
}

#' @rdname token
get_token <- function(var = "LEMROPENDATA_KEY") {
  Sys.getenv(var)
}
