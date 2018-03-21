# alpscarf

`alpscarf` is an R package for visualizing AOI visits in augmented scarf plots.
The visualization is originally developed (but not limited) in the context of eye-tracking research.

##  Installation

You can install `alpscarf` from `github` using the `devtools` package.

```r
devtools::install_github("Chia-KaiYang/alpscarf")
```
## Usage

Read help information of `alpscarf`. 
Basically the package requires three inputs:
* AOI visits which contains at least 2 columns: "p_name" "AOI"
* Expected visit order, which contains at least two columns: "AOI" and "AOI_order"
* Color definition, which is a set of color definitions (in HEX code) with a 1-to-1 mapping to the expected visit order (AOI_order). 

The package would first calculate the height (`alpscarf_height_trans`) and position (`alpscarf_width_trans`) of each bar in Alpscarf, and visualize in scarf plots (`alpscarf_plot_gen`). In addition, the package also calculate several measures of sequence alignment (`alpscarf_calculate_statistics`) with the use of [stringdist](https://github.com/markvanderloo/stringdist)

## Example

In `/private/alpscarf_dev.Rmd` you would find an example which guides users to generate Alpscarf step by step.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
