#' Download a resource into your R session
#'
#' Download a resource from the portal directly into your R session. CSV, XLS, XLSX, XML, JSON, SHP, ZIP, GeoJSON, RDS, and YAML resources are supported.
#'
#' @param resource A way to identify the resource. Either a resource ID (passed as a character vector directly) or a single resource resulting from \code{\link{list_package_resources}}.
#' @inheritParams list_packages
#'
#' @export
#'
#' @return In most cases, the resource is returned as a tibble or list of tibbles.
#' If it is a spatial resource (i.e. SHP or GeoJSON), it is returned as an sf object.
#'
#' @examples
#' \donttest{
#' search_packages("Winnipeg Building Permits example layers") %>%
#'   list_package_resources() %>%
#'   head(1) %>%
#'   get_resource()
#' }
get_resource <- function(resource, token = get_token()) {
  check_internet()
  resource_id <- as_id(resource)

  resource_res <- try(
    ckanr::resource_show(resource_id,
      url = lemr_ckan_url,
      as = "list",
      key = token
    ),
    silent = TRUE
  )

  resource_res <- check_found(resource_res, resource_id, "resource")

  format <- check_format(resource_res[["format"]])

  if (tolower(format) == "rds") {
    temp <- tempfile(fileext = ".rds")
    ckanr::ckan_fetch(
      x = resource_res[["url"]],
      store = "disk",
      path = temp,
      format = format,
      key = token
    )
    res <- readRDS(temp)

    if (all(c("Longitude", "Latitude") %in% names(res))) {
      res %>%
        sf::st_as_sf(coords = c("Longitude", "Latitude"), remove = FALSE) %>%
        sf::st_set_crs(4326)
    } else {
      res
    }
  } else if (tolower(format) == "yaml") {
    temp <- tempfile(fileext = ".yml")
    ckanr::ckan_fetch(
      x = resource_res[["url"]],
      store = "disk",
      path = temp,
      format = format,
      key = token
    )
    yaml::read_yaml(temp)
  } else {
    res <- ckanr::ckan_fetch(
      x = resource_res[["url"]],
      store = "session",
      format = format,
      key = token
    )

    if (inherits(res, "sf")) {
      res_crs <- sf::st_crs(res)
      res <- tibble::as_tibble(res)
      sf::st_as_sf(res)
    } else if (is.data.frame(res)) {
      tibble::as_tibble(res, .name_repair = "minimal")
    } else {
      res <- nested_lapply_tibble(res)
      names(res) <- names(res)
      res
    }
  }
}

check_format <- function(format) {
  format <- toupper(format)
  if (!(format %in% c("CSV", "XLS", "XLSX", "XML", "JSON", "SHP", "ZIP", "GEOJSON", "RDS", "YAML"))) {
    stop(paste(format, "`format` can't be downloaded via package; please visit Open Data Portal directly to download. \n Supported `format`s are: CSV, XLS, XLSX, XML, JSON, SHP, ZIP, GEOJSON, RDS, YAML."),
      call. = FALSE
    )
  } else {
    format
  }
}

tibble_list_elements <- function(x) {
  if (is.list(x) && !inherits(x, "data.frame")) {
    lapply(x, FUN = tibble::as_tibble)
  } else {
    tibble::as_tibble(x)
  }
}

nested_lapply_tibble <- function(x) {
  lapply(x, FUN = tibble_list_elements)
}
