#' translate durations into bar width
#'
#' @param df_p dataset contains 4 columns "AOI" "dwell_duration" "re_reading_bar_length" "seq_bar_length"
#'
#' @return dataset with bar width information
#' @export
#' @importFrom magrittr "%<>%"
#'
alpscarf_width_trans <- function(df_p){

  # calculate the position of bars where bar width equals dewll duration
  df_p_trans <-
    df_p %>%
    mutate(trial = seq(length(df_p$AOI)),
           dwell_duration_category = 1 + round(log10(dwell_duration + 1)),
           bar_position = 0.5 * (cumsum(dwell_duration_category) + cumsum(c(0, dwell_duration_category[-length(dwell_duration_category)]))),
           dwell_lt_100ms = if_else(dwell_duration_category <= 3, 0, NULL))

  # combine seq_bar and re-reading bar into one bar
  df_p_trans %<>%
    mutate(re_reading_bar_length = -re_reading_bar_length) %>%
    gather(key = "bar_type", value = "bar_length", c("seq_bar_length", "re_reading_bar_length"))
    #gather(key = "bar_type", value = "bar_length", c("seq_bar_length_exp", "re_reading_bar_length"))

  # return
  df_p_trans

}
