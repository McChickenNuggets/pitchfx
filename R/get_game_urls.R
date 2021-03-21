#' Get Game Urls
#'
#' @param game_ids game_ids for MLB matches
#'
#' @return game urls
#'
get_game_urls<-function(game_ids){
  id_url<-c()
  for(i in 1:length(game_ids)){
    temp_stat_url<-str_glue("https://statsapi.mlb.com/api/v1.1/game/{game_id}/feed/live",game_id = game_ids[i])
    id_url<-rbind(id_url,temp_stat_url)
  }
  return(id_url)
}
