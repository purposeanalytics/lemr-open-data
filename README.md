
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

In the Portal, datasets are called **packages**. You can see a list of
available packages by using `list_packages()`. This will show metadata
about the package, including what topics (i.e. tags) the package covers,
any civic issues it addresses, a description of it, how many resources
there are (and their formats), how often it is is refreshed and when it
was last refreshed.

``` r
library(lemropendata)
packages <- list_packages()
packages
#> # A tibble: 3 × 11
#>   title        id         topics civic_issues publisher excerpt dataset_category
#>   <chr>        <chr>      <chr>  <chr>        <chr>     <chr>   <chr>           
#> 1 Winnipeg Bu… a9f0e25f-… <NA>   <NA>         <NA>      <NA>    <NA>            
#> 2 Toronto Apa… 6b69da01-… <NA>   <NA>         <NA>      <NA>    <NA>            
#> 3 Test data 1  3cfb4234-… <NA>   <NA>         <NA>      <NA>    <NA>            
#> # … with 4 more variables: num_resources <int>, formats <chr>,
#> #   refresh_rate <chr>, last_refreshed <date>
```

You can also search packages by title:

``` r
to_building_registry_package <- search_packages("Toronto Apartment Building Registry")

to_building_registry_package
#> # A tibble: 1 × 11
#>   title       id          topics civic_issues publisher excerpt dataset_category
#>   <chr>       <chr>       <chr>  <chr>        <chr>     <chr>   <chr>           
#> 1 Toronto Ap… 6b69da01-b… <NA>   <NA>         <NA>      <NA>    <NA>            
#> # … with 4 more variables: num_resources <int>, formats <chr>,
#> #   refresh_rate <chr>, last_refreshed <date>
```

Within a package, there are a number of **resources** - e.g. CSV, XSLX,
JSON, SHP files, and more. Resources are the actual “data”.

For a given package, you can get a list of resources using
`list_package_resources()`. You can pass it the package:

``` r
to_building_registry_resources <- to_building_registry_package %>%
  list_package_resources()

to_building_registry_resources
#> # A tibble: 4 × 4
#>   name                                           id         format last_modified
#>   <chr>                                          <chr>      <chr>  <date>       
#> 1 toronto_apartment_building_registry-point.csv  de64426f-… CSV    2023-04-18   
#> 2 toronto_apartment_building_registry-zone.csv   f42e30de-… CSV    2023-04-18   
#> 3 toronto_apartment_building_registry-city.csv   eca12407-… CSV    2023-04-18   
#> 4 toronto_apartment_building_registry-region.csv 6a5b3b70-… CSV    2023-04-18
```

Finally (and most usefully!), you can download the resource (i.e., the
actual data) directly into R using `get_resource()`:

``` r
library(dplyr)

to_building_registry_zone <- to_building_registry_resources %>%
  filter(name == "toronto_apartment_building_registry-zone.csv") %>%
  get_resource()

to_building_registry_zone
#> # A tibble: 1,049 × 13
#>     .zone .year CONFIRMED_STOREYS CONFIRMED_UNITS NO_BARRIER_FREE_AC… YEAR_BUILT
#>     <int> <int>             <int>           <int>               <int>      <int>
#>  1 227001  2017                 3              10                   0       1989
#>  2 227001  2017                 3              10                   2       1838
#>  3 227001  2017                 3              11                   1       1993
#>  4 227001  2017                 3              12                   0       1910
#>  5 227001  2017                 3              12                   1       1980
#>  6 227001  2017                 3              13                   0       1880
#>  7 227001  2017                 3              15                   0       1911
#>  8 227001  2017                 3              15                   0       1930
#>  9 227001  2017                 3              15                   0       1990
#> 10 227001  2017                 3              16                   0       1888
#> # … with 1,039 more rows, and 7 more variables: YEAR_REGISTERED <int>,
#> #   AIR_CONDITIONING_TYPE <chr>, n <int>, .cleaner_class_name <chr>,
#> #   .data_type <chr>, .folder_path <chr>, .region <chr>
```
