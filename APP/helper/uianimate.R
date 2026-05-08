
# A helper function to create an animated number
ui_animate_number <- function(id, value, duration = 2000) {
  tagList(
    # 1. The HTML element that holds the number
    span(id = id, class = "count-up", "0"),
    
    # 2. The JavaScript to animate it
    tags$script(HTML(sprintf("
      $('#%s').prop('Counter', 0).animate({
        Counter: %s
      }, {
        duration: %d,
        easing: 'swing',
        step: function (now) {
          // Format with commas (e.g., 24,000)
          $(this).text(Math.ceil(now).toLocaleString('en-US'));
        }
      });
    ", id, value, duration)))
  )
}




### Team Summary funtion


get_teamstats = function(team,city,match_df){
  
  
  home_matchsplyd = match_df %>%
    dplyr::filter(team1 == team,str_detect(venue,city)) %>%
    dplyr::group_by(team1) %>%
    dplyr::summarise(Matches_played = n())%>%
    dplyr::pull(Matches_played)%>%
    sum()
  
  
  
  away_matchsplyd = match_df %>%
    dplyr::filter(team2 == team| team1 == team ,!str_detect(venue,city)) %>%
    dplyr::group_by(team2) %>%
    dplyr::summarise(Matches_played = n())%>%
    dplyr::pull(Matches_played)%>%
    sum()
  
  
  
  Ttl_matchsplyd = home_matchsplyd + away_matchsplyd
  
  wins = match_df %>%
    dplyr::filter(match_winner == team)%>%
    dplyr::group_by(match_winner) %>%
    dplyr::summarise(wins = n())%>%
    dplyr::pull(wins)
  
  TiedorNoReslt = match_df %>%
    dplyr::filter(team1 == team | team2 == team,match_result == "tied")%>%
    dplyr::group_by(match_result) %>%
    dplyr::summarise(tie = n())%>%
    dplyr::pull(tie)
  
  if(length(TiedorNoReslt) == 0){
    
    TiedorNoReslt = 0
    
  }
  
  
  lost_games = Ttl_matchsplyd -(wins+TiedorNoReslt)
  
  # browser()
  
  
  
  win_pct = scales::percent(x = (wins / Ttl_matchsplyd),accuracy = 0.01,scale = 100)
  
  success_ratio = scales::percent(x = (wins + (TiedorNoReslt*0.5))/Ttl_matchsplyd,accuracy = 0.01,scale = 100) 
  
  
  
  # browser()
  
  reslt = data.frame("Team" = team,
                     "win_pct" = win_pct,
                     "success_ratio" = success_ratio)
                     # "points_won" = points_won)
  
  
  
  return(reslt)
  
}




