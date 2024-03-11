#' List resources for a package
#'
#' List resources for a package on the portal.
#'
#' @param package A way to identify the package. Either a package ID (passed as a character vector directly), a single package resulting from \code{\link{list_packages}} or \code{\link{search_packages}}, or the package's URL from the portal.
#' @inheritParams list_packages
#'
#' @export
#'
#' @return A tibble of resources along with metadata.
#'
#' @examples
#' \donttest{
#' search_packages("Greater Toronto Area / Région du Grand Toronto") %>%
#'   list_package_resources()
#' list_package_resources("https://data.lemr.ca/fr/dataset/calgary")
#' }
list_package_resources <- function(package, token = get_token()) {
  check_internet()
  package_id <- as_id(package)

  package_res <- try(
    ckanr::package_show(
      id = package_id,
      url = lemr_ckan_url,
      as = "table",
      key = token
    ),
    silent = TRUE
  )

  package_res <- check_found(package_res, package_id, "package")

  if (package_res[["num_resources"]] == 0) {
    tibble::tibble(
      name = character(),
      id = character(),
      format = character(),
      description = character()
    )
  } else {
    resources <- package_res[["resources"]]
    res <- resources[, c("name", "id", "format", "description", "last_modified")]
    res[["last_modified"]] <- as.Date(res[["last_modified"]])
    tibble::as_tibble(res)
  }
}
