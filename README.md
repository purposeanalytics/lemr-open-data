
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

In the portal, datasets are called **packages**. There is one for each
region in the LEMR Housing Monitor. You can see a list of available
packages by using `list_packages()`.

``` r
library(lemropendata)
datasets <- list_packages()
packages
```

    #> # A tibble: 6 × 4
    #>   id                                   title     number_of_resources description
    #>   <chr>                                <chr>                   <int> <chr>      
    #> 1 54ec8e60-dde0-4c2f-bef1-d58f97781d28 Calgary                     1 ""         
    #> 2 0a0c2a2a-a2f8-4f51-b998-586a6d4694b6 Greater …                   1 ""         
    #> 3 b7e2d8fc-e234-4f49-bc7d-9a7b483aa073 Greater …                   2 "The Toron…
    #> 4 9571faf0-b2fc-4479-9c40-1144be8bd81c Halifax                     1 ""         
    #> 5 92088254-b20d-4c4e-b00b-9b5bf02dee40 Metro Va…                   1 ""         
    #> 6 57028a15-51f4-47ce-9fb9-8cdaeae50d02 Winnipeg                    1 ""

Within a package, there are a number of **resources**. Resources are the
actual “data”. the building or base layers in the tool.

We can filter down to the region of interest and then list the data
within it using `list_package_resources()`.

``` r
library(dplyr)

greater_toronto_area_data <- datasets %>%
  filter(title == "Greater Toronto Area / Grande région de Toronto") %>%
  list_package_resources()

greater_toronto_area_data
#> # A tibble: 2 × 4
#>   name                                           id         format last_modified
#>   <chr>                                          <chr>      <chr>  <date>       
#> 1 Building layer - Greater Toronto Area          873bd802-… CSV    2024-03-04   
#> 2 Couche de bâtiments - Grande région de Toronto e17ae14a-… CSV    2024-03-04
```

Finally (and most usefully!), you can download the actual data directly
into R using `get_resource()`:

``` r
greater_toronto_area_data %>%
  filter(name == "Building layer - Greater Toronto Area") %>%
  get_resource()
#> # A tibble: 4,559 × 24
#>    Address                   `Building type` `Year built` Owner or property ma…¹
#>    <chr>                     <chr>                  <int> <chr>                 
#>  1 1 A Elm Grove Ave, Toron… Primary market          1957 ""                    
#>  2 1 A Vermont Ave, Toronto  Primary market          1913 ""                    
#>  3 1 Antrim Crescent, Toron… Primary market          1970 ""                    
#>  4 1 Arbor Dell Rd, Toronto  Non-market              1957 "Toronto Community Ho…
#>  5 1 Ardwick Blvd, Toronto   Non-market              1967 "Toronto Community Ho…
#>  6 1 Biggin Crt, Toronto     Primary market          1955 ""                    
#>  7 1 Birchlea Ave, Toronto   Primary market          1955 ""                    
#>  8 1 Briarwood Ave, Mississ… Primary market          1940 ""                    
#>  9 1 Brimley Rd, Toronto     Primary market          1961 ""                    
#> 10 1 Canyon Ave, Toronto     Primary market          1960 ""                    
#> # ℹ 4,549 more rows
#> # ℹ abbreviated name: ¹​`Owner or property manager`
#> # ℹ 20 more variables: `Total rental units` <int>, `Accessible units` <int>,
#> #   `Primary market units` <int>, `Non-market units` <int>,
#> #   `Non-market type` <chr>, `Evictions per 100 rental units` <chr>,
#> #   `Air conditioning type` <chr>,
#> #   `Apartment building evaluation score history` <chr>, …
```
