#' Calculate statistics (order_following/rereading ratio, Levenshtein/Jaro distance) to assist in reading Alpscarf
#'
#' @param df_alp_p dataset with Alpscarf info, at least four columns "p_name" "AOI" "conformity_score" "revisiting_score"
#' @param aoi_names_pages_seq expected visit order, two columns "AOI" and "AOI_order"
#'
#' @return stats (order_following/rereading ratio, Levenshtein/Jaro distance)
#' @export
#' @import stringdist
#' @importFrom magrittr "%<>%"
#'
alpscarf_calculate_statistics <- function(df_alp_p = NULL, aoi_names_pages_seq = NULL){
  # check if all necessary arguments existed
  if(missing(df_alp_p)) stop("df_alp_p is required")
  if(missing(aoi_names_pages_seq)) stop("aoi_names_pages_seq is required")

  stat_table_df <- NULL
  for(a_p_name in unique(df_alp_p$p_name)){
    df_p <-
      df_alp_p %>%
      filter(p_name == a_p_name)
    # for indexing
    a_p_nr <-
      strsplit(a_p_name,"P")[[1]][2] %>%
      as.numeric()

    # descriptive stats
    stat_temp <-
      df_p %>%
      mutate(graph_AOI = if_else(AOI %in% c("G1_SUBJ", "G2_OBJ", "G3_DIFF"), TRUE,FALSE),
             spatial_order_following = if_else(conformity_score > 0, TRUE, FALSE),
             re_reading = if_else(revisiting_score > 0, TRUE, FALSE)) %>%
      group_by(re_reading, spatial_order_following, graph_AOI) %>%
      summarise(count = n()) %>%
      ungroup()

    count_re_reading <-
      stat_temp %>%
      filter(re_reading) %>%
      select(count) %>%
      sum()

    count_order_follow <-
      stat_temp %>%
      filter(spatial_order_following) %>%
      select(count) %>%
      sum()

    count_no_order_follow_nor_re_reading <-
      stat_temp %>%
      filter(!re_reading & !spatial_order_following) %>%
      select(count) %>%
      sum()

    count_graph_AOI <-
      stat_temp %>%
      filter(graph_AOI) %>%
      select(count) %>%
      sum()

    count_graph_AOI_re_reading <-
      stat_temp %>%
      filter(graph_AOI & re_reading) %>%
      select(count) %>%
      sum()

    count_all <-
      stat_temp %>%
      select(count) %>%
      sum()

    stat_table <-
      tibble(p_name = a_p_name,
             total =count_all,
             order_follow = count_order_follow,
             re_reading = count_re_reading,
             no_order_follow_nor_re_reading = count_no_order_follow_nor_re_reading,
             graphAOI = count_graph_AOI,
             graphAOI_rereading = count_graph_AOI_re_reading,
             ratio_order_follow = count_order_follow / count_all,
             ratio_re_reading = count_re_reading / count_all,
             ratio_no_order_follow_nor_re_reading = count_no_order_follow_nor_re_reading / count_all,
             ratio_graphAOI_rereading_in_graphAOI = count_graph_AOI_re_reading / count_graph_AOI)

    # expected order
    spatial_order <- aoi_names_pages_seq$AOI_order
    # merge with the expected visit order
    df_p %<>%
      left_join(.,aoi_names_pages_seq, by = c("AOI"))
    # actual order
    actual_reading_order <- df_p$AOI_order
    # count Levenshtein distance
    stat_table %<>%
      mutate(distance_LV = seq_dist(actual_reading_order, spatial_order, method = 'lv'),
             distance_LV_normalised = distance_LV / length(actual_reading_order),
             distance_OSA = seq_dist(actual_reading_order, spatial_order, method = 'osa'),
             distance_OSA_normalised = distance_OSA / length(actual_reading_order),
             distance_DL = seq_dist(actual_reading_order, spatial_order, method = 'dl'),
             distance_DL_normalised = distance_DL / length(actual_reading_order),
             distance_Jaro = seq_dist(actual_reading_order, spatial_order, method = 'jw'))

    stat_table_df %<>% bind_rows(stat_table)
  }

  # return
  stat_table_df

}
