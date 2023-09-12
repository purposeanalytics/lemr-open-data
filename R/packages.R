#' List packages
#'
#' List packages available on the portal.
#'
#'
#' @param limit The maximum number of packages to return. The default is 50.
#' @param token An API key or token for the open data portal. Defaults to to the value in \code{get_token}, which can be set via \code{set_token}.
#'
#' @export
#'
#' @return A tibble of available packages and metadata, including \code{title}, \code{id}, \code{num_resources} (the number of resources in the package), \code{state}, \code{isopen}, \code{license_title}, \code{notes}, \code{version}, and \code{tags}.
#'
#' @examples
#' \donttest{
#' list_packages()
#' }
list_packages <- function(limit = 50, token = get_token()) {
  check_internet()
  limit <- check_limit(limit)

  packages <- ckanr::package_list_current(
    limit = limit,
    url = lemr_ckan_url,
    as = "table",
    key = token
  )

  complete_package_res(packages)
}

package_res_init <- tibble::tibble(
  title = character(),
  id = character(),
  num_resources = integer(),
  state = character(),
  isopen = integer(),
  license_title = character(),
  notes = character(),
  version = character(),
  tags = character()
)

package_cols <- names(package_res_init)

complete_package_res <- function(res) {
  res <- res[, package_cols]

  # Turn tags into a string
  res[["tags"]] <- purrr::map_chr(res[["tags"]], ~ paste0(.x[["display_name"]], collapse = "; "))

  dplyr::as_tibble(res)
}
