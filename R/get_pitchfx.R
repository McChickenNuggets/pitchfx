#' @import jsonlite
#' @import plyr
#' @import stringr
#' @import curl
#' @details
#' PITCHf/x is a system using three permanently mounted cameras in the stadium to track the speed and location of a pitched baseball from the pitcher's mound to home plate with an accuracy of better than one mile per hour and one inch. With PITCHf/x, statistics such as the pitcher with the fastest fastball, or the pitcher with the sharpest-breaking curve, etc., can be analyzed. This package provides a convenient way to obtain PITCHf/x dataset.
"_PACKAGE"
#'
#' Scrape PITCHf/x data
#'
#' @param date_start The starting date. Optional, if you only want to scrape specific games
#' @param date_end The ending date. Optional, if you only want to scrape for a single day
#' @param game_id Game ids. Optional, if you want to scrape given days
#'
#' @return PITCHf/x data for within starting date and ending date
#' @export
#'
#' @examples
#' get_pitchfx(date_start = "2020-7-23")
#' get_pitchfx(date_start = "2020-7-23", date_end = "2020-7-24")
#' get_pitchfx(game_id = "630851")
get_pitchfx<-function(date_start = 0, date_end = 0, game_id = NULL){
  if(is.null(game_id)){
    game_ids<-get_game_ids(date_start,date_end)
  }else{
    game_ids<-game_id
  }
  game_urls<-get_game_urls(game_ids)
  pitchfx_df<-c()
  for(i in 1:length(game_urls)){
    json_data <- fromJSON(game_urls[i])
    breaksList = list()
    events <- json_data$liveData$plays$allPlays$playEvents
    if (is.null(events)) return(NULL)

    for(i in 1:length(events)){
      isPitch <- events[[i]]$isPitch
      if(is.null(isPitch)) {isPitch <- NA}
      # extract the pitch breaks data.frame (this is at the pitch level)

      breaks <- events[[i]]$pitchData$breaks #what if spinrate missing

      coord <- events[[i]]$pitchData$coordinates #should almost always contain x and y
      if ((ncol(coord) == 0)||is.null(coord)){ #how to handle having incomplete information? like only x and y
        fill <- rep(NA, length(isPitch)) #make into dataframe with this length and all column names of original coord
        coord <- data.frame(fill, fill, fill, fill, fill, fill, fill, fill, fill, fill, fill, fill, fill, fill,fill)
        names(coord) <- c(  "aY","aZ","pfxX","pfxZ", "pX", "pZ", "vX0", "vY0", "vZ0", "x", "y", "x0", "y0", "z0", "aX")
      }
      else if(ncol(coord) == 2) {
        fill <- rep(NA, length(isPitch))
        temp_coord <- data.frame(fill, fill, fill, fill, fill, fill, fill, fill, fill, fill, fill, fill, fill, fill,fill)
        names(temp_coord) <- c(  "aY","aZ","pfxX","pfxZ", "pX", "pZ", "vX0", "vY0", "vZ0", "x", "y", "x0", "y0", "z0", "aX")
        temp_coord$x <- coord$x
        temp_coord$y <- coord$y
        coord <- NULL
        coord <- temp_coord
      }
      if ((ncol(breaks) == 0)||is.null(breaks)){
        fill2 <- rep(NA, length(isPitch)) #make into dataframe with this length and all column names of original breaks
        breaks <- data.frame(fill2, fill2, fill2, fill2, fill2)
        names(breaks) <- c("breakAngle", "breakLength", "breakY", "spinRate", "spinDirection")
      }
      # both_coord_break <- data.frame(breaks) #combine both breaks and coord
      both_coord_break <- data.frame(breaks,coord)
      # the 1st entry in allplays contains event information
      result_type<-json_data$liveData$plays$allPlays[[1]]$type[i]
      result_event<-json_data$liveData$plays$allPlays[[1]]$event[i]
      result_event_type<-json_data$liveData$plays$allPlays[[1]]$eventType[i]

      # the 2nd entry in allplays about each event
      half_inning<-json_data$liveData$plays$allPlays[[2]]$halfInning[i]
      istop_inning<-json_data$liveData$plays$allPlays[[2]]$isTopInning[i]
      hasout<-json_data$liveData$plays$allPlays[[2]]$hasOut[i]
      captivating_index<-json_data$liveData$plays$allPlays[[2]]$captivatingIndex[i]

      # the 4th entry in allPlays contains pitcher and batter data at the event level (each at-bat)
      # if(nrow(both_coord_break)!=23){print(i)}
      pitcher.name <- json_data$liveData$plays$allPlays[[4]]$pitcher$fullName[i]
      pitcher.hand <- json_data$liveData$plays$allPlays[[4]]$pitchHand$code[i]
      batter.name <- json_data$liveData$plays$allPlays[[4]]$batter$fullName[i]
      batter.hand <- json_data$liveData$plays$allPlays[[4]]$batSide$code[i]

      # assign pitcher and batter to the breaks data.frame

      both_coord_break$pitcher <- pitcher.name
      both_coord_break$pitcher_hand <- pitcher.hand
      both_coord_break$batter <- batter.name
      both_coord_break$batter_hand <- batter.hand
      both_coord_break$isPitch <- isPitch

      # add event information
      both_coord_break$result_type<-result_type
      both_coord_break$result_event<-result_event

      # add about information
      both_coord_break$half_inning<-half_inning
      both_coord_break$isTopinning<-istop_inning
      both_coord_break$hasout<-hasout
      both_coord_break$capitivatingindex<-captivating_index

      #add in extra attributes
      both_coord_break$balls<-events[[i]]$count$balls
      both_coord_break$call_description<-events[[i]]$details$description
      both_coord_break$strikes<-events[[i]]$count$strikes
      both_coord_break$outs<-events[[i]]$count$outs
      both_coord_break$ballType <- events[[i]]$details$type$code
      both_coord_break$isinplay <- events[[i]]$details$isInPlay
      both_coord_break$isstrike <- events[[i]]$details$isStrike
      both_coord_break$isball <- events[[i]]$details$isBall
      both_coord_break$startSpeed <- events[[i]]$pitchData$startSpeed
      both_coord_break$endSpeed <- events[[i]]$pitchData$endSpeed
      both_coord_break$strikeZoneTop <- events[[i]]$pitchData$strikeZoneTop
      both_coord_break$strikeZoneBottom <- events[[i]]$pitchData$strikeZoneBottom
      both_coord_break$zone <- events[[i]]$pitchData$zone
      both_coord_break$typeConfidence <- events[[i]]$pitchData$typeConfidence
      both_coord_break$plateTime <- events[[i]]$pitchData$plateTime
      both_coord_break$extension <- events[[i]]$pitchData$extension

      # add in hit data
      both_coord_break$lanuch_speed <-events[[i]]$hitData$launchSpeed
      both_coord_break$lauch_angle <- events[[i]]$hitData$launchAngle
      both_coord_break$total_distance <- events[[i]]$hitData$totalDistance
      both_coord_break$trajectory <- events[[i]]$hitData$trajectory
      both_coord_break$hardness <- events[[i]]$hitData$hardness
      both_coord_break$location <- events[[i]]$hitData$location

      # put it into a list
      breaksList[[i]] <- both_coord_break
    }
    # combine the whole list into one data.frame
    breaksFrame <- rbind.fill(breaksList)
    # show only the pitches
    breaks_df <- breaksFrame[breaksFrame$isPitch,]
    pitchfx_df<-rbind(pitchfx_df,breaks_df)
  }
  return(pitchfx_df)
}
