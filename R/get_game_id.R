#' Get Game Ids for MLB
#' @param date_start The starting date
#' @param date_end The ending date. Optional, if you only want to scrape for a single day
#'
#' @return game_ids between starting date and ending date
#' @export
#'
#' @examples
#' get_game_ids(date_start = "2020-7-23")
#' get_game_ids(date_start = "2020-7-23", date_end = "2020-7-24")
get_game_ids<-function(date_start,date_end = 0){
  if(date_end == 0){
    html<-str_glue("https://statsapi.mlb.com/api/v1/schedule/games/?sportId=1&date={dateid}",dateid = date_start)
    r<-RETRY("GET",html,times = 10)
    info<-fromJSON(content(r, as = "text", encoding = "UTF-8"))
    if(info$totalGames == 0){
      stop("No Game this day")
    }else{
      game_ids<-info$dates$games[[1]]$gamePk
      return(game_ids)
    }
  }else{
    start <- as.Date(date_start)
    end <- as.Date(date_end)
    theDate <- start
    game_ids<-c()
    while(theDate<=end){
      html<-str_glue("https://statsapi.mlb.com/api/v1/schedule/games/?sportId=1&date={dateid}",dateid = theDate)
      r<-RETRY("GET",html, times = 10)
      info<-fromJSON(content(r, as = "text", encoding = "UTF-8"))
      if(info$totalGames == 0){
        stop("No Game this day")
      }else{
        game_id_temp<-info$dates$games[[1]]$gamePk
        game_ids<-c(game_ids,game_id_temp)
        theDate<-theDate+1
      }
    }
    return(game_ids)
  }
}
