
library(lubridate)
library(dplyr)
library(stringr)

delv_df = read.csv("C:/Users/91884/Desktop/My_RProjects/IPL_App/IPL2025_KaggleData/deliveries.csv")

## Converting the date column character to date format using lubridate package.
delv_df$date = mdy(delv_df$date)


## Adiing an extra column runs_scored (runs scored per ball which includes extras and runs by bat)
## Renaming the over column name to over_num bcz over is a word usued in sql command.
delv_df = delv_df %>%
  dplyr::mutate(runs_scored = runs_of_bat + extras,
                year = year(date))%>%
  dplyr::rename("over_num" = "over",)

# saveRDS(object = delv_df,file = "C:/Users/91884/Desktop/My_RProjects/IPL_App/APP/sourcedata/ipl_deliveries.RData")



####

match_df = read.csv(file = "C:/Users/91884/Desktop/My_RProjects/IPL_App/IPL2025_KaggleData/matches.csv")

## Converting the date column character to date format using lubridate package.
match_df$date = mdy(match_df$date)
match_df$year = year(match_df$date)

# saveRDS(object = match_df,file = "C:/Users/91884/Desktop/My_RProjects/IPL_App/APP/sourcedata/ipl_matches.RData")



####

orngcap_df = read.csv(file = "C:/Users/91884/Desktop/My_RProjects/IPL_App/IPL2025_KaggleData/orange_cap.csv")
orngcap_df$year = 2025

# saveRDS(object = orngcap_df,file = "C:/Users/91884/Desktop/My_RProjects/IPL_App/APP/sourcedata/ipl_orangecap.RData")


#####

prplcap_df = read.csv(file = "C:/Users/91884/Desktop/My_RProjects/IPL_App/IPL2025_KaggleData/purple_cap.csv")
prplcap_df$year = 2025


# saveRDS(object = prplcap_df,file = "C:/Users/91884/Desktop/My_RProjects/IPL_App/APP/sourcedata/ipl_purple.RData")



####


## I want to get team and their home venue city name as a dataframe.
venue_team = match_df %>%
  dplyr::group_by(team1,venue)%>%
  dplyr::summarise(ttl = n())%>%
  dplyr::arrange(desc(ttl)) 

venue_team = venue_team[1:10,] %>%
  separate(venue, into = c("stadium", "city"), sep = ", ", remove = FALSE) %>%
  dplyr::select(-c(ttl,venue,stadium))%>%
  dplyr::rename("team" = "team1")


out = purrr::pmap_dfr(.l = venue_team,.f = function(team,city){
  
  get_teamstats(team = team,city = city,match_df = match_df)
  
}) %>% arrange(desc(points_won))




