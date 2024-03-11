#' Create a resource
#'
#' @param description Resource description
#' @param format Resource format
#' @param file Path to local file to upload as resource
#' @inheritParams list_packages
#'
#' @noRd
create_resource <- function(package, name, description, format, file, token = get_token()) {
  check_internet()
  package_id <- as_id(package)

  ckanr::resource_create(package_id = package_id, name = name, description = description, format = format, upload = file, url = lemr_ckan_url, key = token)
}

#' Update the file in a resource
#'
#' @param resource A tibble of the resource to update, including its ID and existing description
#' @inheritParams create_resource
#'
#' @noRd
update_resource_file <- function(resource, file, token = get_token()) {
  check_internet()

  # Ensure `resource` has both ID and description
  if (!all(c("id", "description") %in% names(resource))) {
    stop("Resource must contain `id` and `description`.")
  }

  ckanr::resource_update(resource[["id"]], path = file, extras = list(description = resource[["description"]]), url = lemr_ckan_url, key = token)
}
