#' Alpscarf plot generation
#'
#' @param df_p dataset contains the bar width/height info of Alpscarf, contains at least 6 columns "AOI" "trial" "bar_position" "dwell_duration_category" "seq_bar_length" "re_reading_bar_length"
#' @param my_palette the color definition
#' @param TRANSITION_FOCUS to select between transition-focus (TRUE) and duration-focus (FALSE) mode, default = TRUE
#' @param max_y_value the range (in y-axis) to plot
#' @param ALPSCARF_EN to select between Alpscarf plot (TRUE) or traditional scarf plot (FALSE), default = TRUE
#' @param creek_offset to adjust the position of creeks, default = 0.04
#' @param creek_size to adjust the size of creeks, default = 2
#' @param TITLE_EN print participant name, default = TRUE
#'
#' @return Alpscarf plot
#' @export
#'
alpscarf_plot_gen <- function(df_p = NULL, my_palette = NULL, TRANSITION_FOCUS = TRUE, max_y_value = 4, ALPSCARF_EN = TRUE, creek_offset = 0.04, creek_size = 2, TITLE_EN = TRUE) {
  # check if all necessary arguments existed
  if(missing(df_p)) stop("df_p is required")
  if(missing(my_palette)) stop("my_palette is required")

  # combine seq_bar and re-reading bar into one bar
  df_p %<>%
    mutate(re_reading_bar_length = -re_reading_bar_length) %>%
    gather(key = "bar_type", value = "bar_length", c("seq_bar_length", "re_reading_bar_length"))

  # alpscarf information collection
  if (TRANSITION_FOCUS){
    df_p %<>%
      mutate(x_alp = trial,
             width_alp = 1)
    x_start_alp <- 0.5
    x_end_alp <- max(df_p$trial) + 0.5
  } else {
    df_p %<>%
      mutate(x_alp = bar_position,
             width_alp = dwell_duration_category)
    x_start_alp <- 0
    x_end_alp <- sum(df_p$dwell_duration_category) / 2
  }
  if (ALPSCARF_EN){
    df_p %<>%
      mutate(y_alp = bar_length)
    creek_alpha <- 0.01
  } else {
    df_p %<>%
      mutate(y_alp = 1)
    creek_alpha <- 0
  }

  # plot generation
  a_p_name <- df_p$p_name[1]

  max_y <- if_else(max_y_value > max(df_p$y_alp), max_y_value, max(df_p$y_alp))

  alpscarf_plot <-
    df_p %>%
    ggplot(aes(x = x_alp, y = y_alp, fill = AOI, width = width_alp)) +
    geom_bar(stat = "identity", position = "identity") +
    scale_x_continuous() +
    scale_fill_manual(values = my_palette, drop = TRUE, limits = levels(df_p$AOI)) +
    theme(legend.position="none",
          #panel.grid.major.y = element_line(size = 0.1, colour = "grey80"),
          panel.grid.major = element_blank(), # get rid of major grid
          panel.grid.minor = element_blank(), # get rid of minor grid
          panel.background = element_rect(fill = "transparent"), # bg of the panel
          plot.background = element_rect(fill = "transparent"), # bg of the plot
          plot.title = element_text(color="black", size=80, face="bold", vjust = -500),
          axis.line=element_blank(),
          axis.title.x= element_blank(),
          axis.title.y = element_blank(),
          axis.text.x = element_blank(),
          axis.text.y = element_blank(),
          axis.ticks.x = element_blank(),
          axis.ticks.y = element_blank()) +
    #coord_fixed(ratio = 0.25 * max(df_p_temp$trial) / (1 + max_y_value), xlim = c(0, max(df_p_temp$trial)), ylim = c(-1, max_y_value)) +
    geom_segment(aes(x = x_start_alp, xend = x_end_alp, y = creek_offset, yend = creek_offset), size = creek_size, colour = "white", alpha = creek_alpha) +
    geom_segment(aes(x = x_start_alp, xend = x_end_alp, y = 1 - creek_offset, yend = 1 - creek_offset), size = creek_size, colour = "white", alpha = creek_alpha) +
    {if(TITLE_EN) ggtitle(a_p_name)} +
    #geom_point(aes(y = no_order_follow_nor_re_reading), color = "green", size = 2) +
    #geom_point(aes(y = graph_AOI), color = "red", size = 2)
    #geom_point(aes(y = dwell_lt_100ms), color = "red", size = 2)
    ylim(-1, max_y)

  # return
  alpscarf_plot

}
