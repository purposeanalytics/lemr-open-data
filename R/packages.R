#' Search packages by name
#'
#' Search portal packages by name
#'
#' @param name Name to search (case-insensitive)
#'
#' @export
#'
#' @return A tibble of matching packages along with package metadata.
#' @inheritParams list_packages
#'
#' @examples
#' \donttest{
#' search_packages("Toronto")
#' }
search_packages <- function(name, token = get_token()) {

  check_internet()

  packages <- ckanr::package_search(
    fq = paste0("title:", '"', name, '"'),
    rows = 50,
    url = lemr_ckan_url,
    as = "table",
    key = token
  )

  complete_package_res(packages[["results"]]) %>%
    dplyr::select(dplyr::all_of(packages_cols))
}

#' List packages
#'
#' List packages available on the portal.
#'
#' @param token An API key or token for the open data portal. Defaults to to the value in \code{get_token}, which can be set via \code{set_token}.
#'
#' @export
#'
#' @return A tibble of available packages and metadata.
#'
#' @examples
#' \donttest{
#' list_packages()
#' }
list_packages <- function(token = get_token()) {
  check_internet()

  packages <- ckanr::package_list_current(
    limit = 50,
    url = lemr_ckan_url,
    as = "table",
    key = token
  )

  complete_package_res(packages) %>%
    dplyr::select(dplyr::all_of(packages_cols))
}

packages_cols <- c("name" = "title", "number_of_resources" = "num_resources", "description" = "notes", "id")

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
  if (length(res) == 0) {
    res <- package_res_init
  } else {
    res <- res[, package_cols]
  }

  dplyr::as_tibble(res)
}
