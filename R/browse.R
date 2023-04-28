#' Open the LEMR Open Data Portal in your browser
#'
#' @export
#'
#' @examples
#' \donttest{
#' browse_portal()
#' }
browse_portal <- function() {
  check_internet()
  if (interactive()) {
    utils::browseURL(
      url = lemr_ckan_url,
      browser = getOption("browser")
    )
  }

  invisible(lemr_ckan_url)
}

#' Open the package's page in your browser
#'
#' Opens a browser to the package's page on the LEMR Open Data Portal
#'
#' @param package A way to identify the package. Either a package ID (passed as a character vector directly), a single package resulting from \code{\link{list_packages}} or \code{\link{search_packages}}, or the package's URL from the portal.
#'
#' @export
#'
#' @examples
#' \donttest{
#' toronto_registry <- search_packages("Toronto Apartment Building Registry")
#' browse_package(toronto_registry)
#' }
browse_package <- function(package) {
  check_internet()
  package_id <- as_id(package)

  package_res <- try(
    ckanr::package_show(
      id = package_id,
      url = lemr_ckan_url,
      as = "list"
    ),
    silent = TRUE
  )
  package_res <- check_found(package_res, package_id, "package")

  package_title <- package_res[["title"]]

  package_title_url <- parse_package_title(package_title)
  url <- paste0(lemr_ckan_url, "/dataset/", package_title_url)
  if (interactive()) {
    utils::browseURL(url = url, browser = getOption("browser"))
  }

  invisible(url)
}

#' Open the resource's package page in your browser
#'
#' Opens a browser to the resource's package page on the LEMR Open Data Portal.
#'
#' @param resource A way to identify the resource. Either a resource ID (passed as a character vector directly) or a single resource resulting from \code{\link{list_package_resources}}.
#'
#' @export
#'
#' @examples
#' \donttest{
#' toronto_registry <- search_packages("Toronto Apartment Building Registry")
#' res <- list_package_resources(toronto_registry)
#' browse_resource(res[1, ])
#' }
browse_resource <- function(resource) {
  check_internet()
  resource_id <- as_id(resource)

  resource_res <- try(
    ckanr::resource_show(
      id = resource_id,
      url = lemr_ckan_url,
      as = "list"
    ),
    silent = TRUE
  )
  resource_res <- check_found(resource_res, resource_id, "resource")

  browse_package(resource_res[["package_id"]])
}
