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
The package requires three dataset as inputs:
1. AOI visits which contains at least 3 columns: "p_name" "AOI" "dwell_duration"
    * All AOIs belong to the same "p_name" should represent the AOI visit (in order) of the participant "p_name".
    * The dwell_duration corresponds to the total dwell time of one dwell.
1. Expected visit order, which contains at least two columns: "AOI" and "AOI_order"
    * The AOI_order should be continuous integers and correspond to the expected visit order of AOIs. For example, if one expected participants to visit the AOI "A" first, then move to "B" and "C", the AOI_order of "A" should be 1, "2" for "B", and "3" for "C".
1. Color definition, a set of color definitions in HEX code, is a 1-to-1 mapping to the expected visit order (AOI_order).
    * In above example, if red (#ff0000) is asssigned to "A", green (#00ff00) to "B", and blue (#0000ff) to "C", the color definition set = {#ff0000, #00ff00, #0000ff}

The package would first calculate the height (`alpscarf_height_trans`) and position (`alpscarf_width_trans`) of each bar in Alpscarf, and visualize in scarf plots with mountains and valleys (`alpscarf_plot_gen`). Additionally, the package calculates several descriptive stats, and measures of sequence alignment (`alpscarf_calculate_statistics`) with the use of [stringdist](https://github.com/markvanderloo/stringdist)

## Example

In `/vignettes/alpscarf.Rmd` you would find an example which guides users to generate Alpscarf step by step.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Resources

* [CHI 2018 Late Breaking Work](https://zpac.ch/chi2018/Alpscarf.pdf)
* [video preview (30 seconds)](https://zpac.ch/chi2018/Alpscarf.mp4)
