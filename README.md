
<!-- README.md is generated from README.Rmd. Please edit that file -->

# lemropendata

`lemropendata` is an R interface to the [LEMR Open Data
Portal](http://20.220.163.227). The goal of the package is to help read
data directly into R without needing to manually download it via the
portal.

## Installation

You can install the development version from GitHub with:

``` r
devtools::install_github("purposeanalytics/lemr-open-data")
```

## Usage

Much of the data in the portal is private and requires an authentication
token. You can get this from the portal itself, and set up using
`set_token()`. Once your token is set up, subsequent functions will
automatically retrieve and use the token so that you get all data
available to your user.

In the portal, datasets are called **packages**. You can see a list of
available packages by using `list_packages()`. This will show metadata
about the package, including what tags, state, license, notes, version,
and number of resources.

``` r
library(lemropendata)
packages <- list_packages()
packages
#> # A tibble: 2 × 9
#>   title       id    num_resources state isopen license_title notes version tags 
#>   <chr>       <chr>         <int> <chr> <lgl>  <chr>         <chr> <chr>   <chr>
#> 1 Toronto Ap… f46c…             1 acti… FALSE  ""            ""    ""      poin…
#> 2 Toronto Ev… d99e…             7 acti… FALSE  "License not… "Acc… "1.0"   evic…
```

Within a package, there are a number of **resources** - e.g. CSV, XSLX,
JSON, SHP files, and more. Resources are the actual “data”.

For a given package, you can get a list of resources using
`list_package_resources()`. You can pass it the package:

``` r
to_app_layers <- packages[packages$title == "Toronto App Layers",] %>%
  list_package_resources()

to_app_layers
#> # A tibble: 1 × 4
#>   name                                      id              format last_modified
#>   <chr>                                     <chr>           <chr>  <date>       
#> 1 toronto_points_layers 20230719-202357.rds 6854804a-fab2-… RDS    2023-08-05
```

Finally (and most usefully!), you can download the resource (i.e., the
actual data) directly into R using `get_resource()`:

``` r
to_points_layers <- to_app_layers[to_app_layers$name == "toronto_points_layers 20230719-202357.rds",] %>%
  get_resource()

to_points_layers
#> Simple feature collection with 30308 features and 11 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: -123.8915 ymin: -26.21459 xmax: 1.371135 ymax: 53.60252
#> Geodetic CRS:  WGS 84
#> # A tibble: 30,308 × 12
#>    Address  Apartment Building P…¹ Apartment Has Air Co…² Apartment Barrier Fr…³
#>  * <chr>    <chr>                  <lgl>                                   <dbl>
#>  1 1 26th … <NA>                   NA                                         NA
#>  2 1 35th … <NA>                   NA                                         NA
#>  3 1 41st … <NA>                   NA                                         NA
#>  4 1 6th S… <NA>                   NA                                         NA
#>  5 1 Abbot… <NA>                   NA                                         NA
#>  6 1 Aberf… <NA>                   NA                                         NA
#>  7 1 Aberf… <NA>                   NA                                         NA
#>  8 1 Acorn… <NA>                   NA                                         NA
#>  9 1 Adra … <NA>                   NA                                         NA
#> 10 1 Adra … <NA>                   NA                                         NA
#> # ℹ 30,298 more rows
#> # ℹ abbreviated names: ¹​`Apartment Building Property Type`,
#> #   ²​`Apartment Has Air Conditioning`,
#> #   ³​`Apartment Barrier Free Accessible Units`
#> # ℹ 8 more variables: `Apartment Building Units` <dbl>,
#> #   `Apartment Year Built` <dbl>, `RentSafeTO Score` <dbl>,
#> #   `Evicting Organization` <chr>, Latitude <chr>, Longitude <chr>, …
```
