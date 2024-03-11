
<!-- README.md is generated from README.Rmd. Please edit that file -->

# lemropendata

`lemropendata` is an R interface to the [LEMR Housing Monitor open data
portal](https://data.lemr.ca/en/dataset). The goal of the package is to
help read data directly into R without needing to manually download it
via the portal.

## Installation

You can install the development version from GitHub with:

``` r
devtools::install_github("purposeanalytics/lemr-open-data")
```

## Usage

In the portal, datasets are called **packages**. There is one for each
region in the LEMR Housing Monitor. You can see a list of available
packages by using `list_packages()`.

``` r
library(lemropendata)
datasets <- list_packages()
packages
```

    #> # A tibble: 6 × 4
    #>   name                                     number_of_resources description id   
    #>   <chr>                                                  <int> <chr>       <chr>
    #> 1 Calgary                                                   10 "The Calga… 54ec…
    #> 2 Greater Montreal Area / Région du Grand…                  10 "The Montr… 0a0c…
    #> 3 Greater Toronto Area / Région du Grand …                  12 "The Toron… b7e2…
    #> 4 Halifax                                                   10 "The Halif… 9571…
    #> 5 Metro Vancouver Area / Région métropoli…                  12 "The Vanco… 9208…
    #> 6 Winnipeg                                                  10 "The Winni… 5702…

Within a package, there are a number of **resources**. Resources are the
actual “data”. the building or base layers in the tool.

We can filter down to the region of interest and then list the data
within it using `list_package_resources()`.

``` r
library(dplyr)

greater_toronto_area_data <- datasets %>%
  filter(name == "Greater Toronto Area / Région du Grand Toronto") %>%
  list_package_resources()

greater_toronto_area_data
#> # A tibble: 12 × 5
#>    name                                   id    format description last_modified
#>    <chr>                                  <chr> <chr>  <chr>       <date>       
#>  1 Building layer                         873b… CSV    "This data… 2024-03-11   
#>  2 Base layer - Census tract              ce65… CSV    "This data… 2024-03-11   
#>  3 Base layer - Forward sortation area    715c… CSV    "This data… 2024-03-11   
#>  4 Base layer - Rental Market Survey zone b49b… CSV    "This data… 2024-03-11   
#>  5 Base layer - Municipality              3ce4… CSV    "This data… 2024-03-11   
#>  6 Base layer - Region                    fb30… CSV    "This data… 2024-03-11   
#>  7 Couche de bâtiments                    e17a… CSV    "Cet ensem… 2024-03-11   
#>  8 Couche de base - Secteur de recenseme… a968… CSV    "Cet ensem… 2024-03-11   
#>  9 Couche de base - Région de tri d'ache… 3c11… CSV    "Cet ensem… 2024-03-11   
#> 10 Couche de base - Zone de l'enquête su… 8121… CSV    "Cet ensem… 2024-03-11   
#> 11 Couche de base - Municipalité          10cd… CSV    "Cet ensem… 2024-03-11   
#> 12 Couche de base - Région                9302… CSV    "Cet ensem… 2024-03-11
```

Finally (and most usefully!), you can download the actual data directly
into R using `get_resource()`:

``` r
greater_toronto_area_data %>%
  filter(name == "Building layer") %>%
  get_resource()
#> # A tibble: 4,480 × 24
#>    Address        Type  `Year built` Owner or property ma…¹ `Total rental units`
#>    <chr>          <chr>        <int> <chr>                                 <int>
#>  1 1 A Elm Grove… Prim…         1957 ""                                       12
#>  2 1 A Vermont A… Prim…         1913 ""                                       22
#>  3 1 Antrim Cres… Prim…         1970 ""                                      167
#>  4 1 Arbor Dell … Non-…         1957 "Toronto Community Ho…                   16
#>  5 1 Ardwick Blv… Non-…         1967 "Toronto Community Ho…                   18
#>  6 1 Biggin Crt,… Prim…         1955 ""                                       48
#>  7 1 Birchlea Av… Prim…         1955 ""                                       10
#>  8 1 Briarwood A… Prim…         1940 ""                                        9
#>  9 1 Brimley Rd,… Prim…         1961 ""                                       58
#> 10 1 Canyon Ave,… Prim…         1960 ""                                      202
#> # ℹ 4,470 more rows
#> # ℹ abbreviated name: ¹​`Owner or property manager`
#> # ℹ 19 more variables: `Accessible units` <int>, `Primary market units` <int>,
#> #   `Non-market units` <int>, `Non-market type` <chr>,
#> #   `Evictions per 100 rental units` <chr>, `Air conditioning type` <chr>,
#> #   `Apartment building evaluation score history` <chr>,
#> #   `Evictions filed (2010-2022)` <int>, `Eviction filing types` <chr>, …
```
