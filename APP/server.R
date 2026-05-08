

# source("C:/Users/91884/Desktop/My_RProjects/IPL_App/APP/db_functions.R")

source("helper/uianimate.R")

# --- 3. SERVER LOGIC ---
server <- function(input, output, session) {
  
  # 1. Load Data (Replace with your actual DB connection or CSV read)
  # For this example, I will generate a small dummy set matching your CSV structure
  # so you can run this immediately to see the UI.
  
  data <- reactive({
    # In your real app, use: df <- dbGetQuery(con, "SELECT * FROM ipl_data.deliveries")
    
    # delv_df  = get_tableFromDB(tablename = "ipl_deliveries",dbname = "bspos")
    delv_df = readRDS(file = "sourcedata/ipl_deliveries.RData")
    
    return(delv_df)
    
  })
  
  # --- CALCULATE METRICS ---
  
  output$anim_total_runs <- renderUI({
    real_value = sum(data()$runs_scored, na.rm = TRUE)
    ui_animate_number(id = "counter_runs", value = real_value)
  })
  
  output$total_sixes <- renderUI({
    # delv_df = data()
    
    six_value = data() %>%
      dplyr::group_by(runs_of_bat)%>%
      dplyr::summarise(count = n())%>%
      dplyr::filter(runs_of_bat ==6)%>%
      dplyr::pull(count)
    # browser()
    # six_value = sxs_count
    # return(as.character(sxs_count))
    
    ui_animate_number(id = "counter_sixes", value = six_value)
    # sxs_count = sxs_df %>%
    #   dplyr::pull(runs_of_bat)
    
    # sum(data()$runs_of_bat == 6, na.rm = TRUE)
  })
  
  output$total_fours <- renderUI({
    
    bndry_count = data() %>%
      dplyr::group_by(runs_of_bat)%>%
      dplyr::summarise(count = n())%>%
      dplyr::filter(runs_of_bat ==4)%>%
      dplyr::pull(count)
    
    # return(as.character(bndry_count))
    
    ui_animate_number(id = "counter_boundry", value = bndry_count)
    
  })
  
  # --- GENERATE TABLES ---
  
  output$orange_cap_table <- renderReactable({
    
    # df <- get_tableFromDB(tablename = "ipl_orangecap",dbname = "bspos")
    df = readRDS("sourcedata/ipl_orangecap.RData")%>%
      dplyr::select(c(Batsman,Team,Runs,Innings,Average,Strike_rate))%>%
      dplyr::rename("StrikeRate" = "Strike_rate")
      
      head(10) # Top 10
    
    reactable(df, 
              striped = TRUE, 
              highlight = TRUE,
              columns = list(
                Runs = colDef(
                  cell = function(value) {
                    # Add a small bar chart inside the cell
                    width <- paste0(value / max(df$Runs) * 100, "%")
                    div(
                      class = "bar-chart",
                      style = list(marginRight = "10px"),
                      div(class = "bar", style = list(width = width, backgroundColor = "#ffc107", height = "10px")),
                      div(value)
                    )
                  }
                )
              ),
              theme = reactableTheme(
                backgroundColor = "black" # Allows it to blend with Dark Mode
              )
    )
  })
  
  output$purple_cap_table <- renderReactable({
    
    # df <- get_tableFromDB(tablename = "ipl_purplecap",dbname = "bspos") %>%
    df = readRDS("sourcedata/ipl_purple.RData")%>%  
      dplyr::select(c(Bowler,Team,Wickets,Innings,Economy_rate,Best_bowling_figure))%>%
      dplyr::rename("EconomyRate" = "Economy_rate","Best" = "Best_bowling_figure")
    
    reactable(df, 
              striped = TRUE, 
              highlight = TRUE,
              theme = reactableTheme(
                backgroundColor = "black"
              )
    )
  })
}
# 
# shinyApp(ui, server)

# shinyApp(ui, server)