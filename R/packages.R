#' List packages
#'
#' List packages available on the portal.
#'
#'
#' @param limit The maximum number of packages to return. The default is 50.
#'
#' @export
#'
#' @return A tibble of available packages and metadata, including \code{title}, \code{id}, \code{topics}, \code{civic_issues}, \code{excerpt}, \code{publisher}, \code{dataset_category}, \code{num_resources} (the number of resources in the package), \code{formats} (the different formats of the resources), \code{refresh_rate} (how often the package is refreshed), and \code{last_refreshed} (the date it was last refreshed).
#'
#' @examples
#' \donttest{
#' list_packages(5)
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

#' Search packages by title
#'
#' Search portal packages by title.
#'
#' @param title Title to search (case-insensitive).
#' @param limit Maximum number of packages to return. The default is 50. The maximum limit is 1000.
#'
#' @export
#'
#' @return A tibble of matching packages along with package metadata, including \code{title}, \code{id}, \code{topics}, \code{civic_issues}, \code{excerpt}, \code{publisher}, \code{dataset_category}, \code{num_resources} (the number of resources in the package), \code{formats} (the different formats of the resources), \code{refresh_rate} (how often the package is refreshed), and \code{last_refreshed} (the date it was last refreshed).
#'
#' @examples
#' \donttest{
#' search_packages("ttc")
#' }
search_packages <- function(title, limit = 50, token = get_token()) {
  # TODO not working
  check_internet()
  packages <- ckanr::package_search(
    fq = paste0("title:", '"', title, '"'),
    rows = limit,
    url = lemr_ckan_url,
    as = "table",
    key = token
  )

  if (length(packages[["results"]]) == 0) {
    package_res_init
  } else {
    complete_package_res(packages[["results"]])
  }
}

#' Show a package's metadata
#'
#' Show a portal package's metadata.
#'
#' @param package A way to identify the package. Either a package ID (passed as a character vector directly) or the package's URL from the portal.
#'
#' @export
#'
#' @return A tibble including \code{title}, \code{id}, \code{topics}, \code{civic_issues}, \code{excerpt}, \code{publisher}, \code{dataset_category}, \code{num_resources} (the number of resources in the package), \code{formats} (the different formats of the resources), \code{refresh_rate} (how often the package is refreshed), and \code{last_refreshed} (the date it was last refreshed).
#'
#' @examples
#' \donttest{
#' show_package("c01c6d71-de1f-493d-91ba-364ce64884ac")
#' }
show_package <- function(package) {
  check_internet()
  # TODO not working
  package_id <- as_id(package)

  package_res <- try(
    ckanr::as.ckan_package(package_id, url = lemr_ckan_url),
    silent = TRUE
  )

  package_res <- check_found(package_res, package, "package")

  complete_package_res(package_res)
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
