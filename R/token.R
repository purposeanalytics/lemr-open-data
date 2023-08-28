#' Get or set LEMR Open Data token
#'
#' @param token LEMR Open Data token
#' @param var Environment to store token in, defaults to \code{LEMROPENDATA_KEY}
#'
#' @export
#'
#' @rdname token
#'
#' @examples
#' set_token("test")
#' get_token()
#' # [1] "test"
set_token <- function(token, var = "LEMROPENDATA_KEY") {
  token <- list(token)
  names(token) <- var
  do.call(Sys.setenv, token)
}

#' @rdname token
get_token <- function(var = "LEMROPENDATA_KEY") {
  Sys.getenv(var)
}
