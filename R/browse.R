#' Open the LEMR Housing Monitor open data portal in your browser
#'
#' @inheritParams browse_package
#' @export
#'
#' @examples
#' \donttest{
#' browse_portal("en")
#' browse_portal("fr")
#' }
browse_portal <- function(lang = "en") {
  check_internet()
  if (interactive()) {
    url <- glue::glue("https://data.lemr.ca/{lang}/dataset")
    utils::browseURL(
      url = url,
      browser = getOption("browser")
    )
  }

  invisible(url)
}

#' Open the package's page in your browser
#'
#' Opens a browser to the package's page on the LEMR Housing Monitor open data portal
#'
#' @param package A way to identify the package. Either a package ID (passed as a character vector directly), a single package resulting from \code{\link{list_packages}} or \code{\link{search_packages}}, or the package's URL from the portal.
#' @param lang The language to open the portal in - "en" or "fr". Defaults to "en".
#'
#' @export
#'
#' @examples
#' \donttest{
#' toronto_data <- search_packages("Toronto")
#' browse_package(toronto_data)
#' }
browse_package <- function(package, lang = "en") {
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

  package_name <- package_res[["name"]]

  package_name_url <- parse_package_title(package_name)
  url <- paste0(lemr_ckan_url, lang, "/dataset/", package_name_url)
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
#' toronto_data <- search_packages("Toronto")
#' res <- list_package_resources(toronto_data)
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
