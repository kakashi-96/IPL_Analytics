

library(shiny)
library(bslib)
library(bsicons)
library(dplyr)
library(reactable)

# --- 1. THEME DEFINITION ---
# We define a base theme, but the user can toggle Dark Mode on top of this.
my_theme <- bs_theme(
  version = 5,
  preset = "cyborg",       # A clean, modern font/color preset
  primary = "#1A237E",    # IPL Dark Blue
  danger = "red",
  "navbar-bg" = "#1A237E" ,# Make the top navbar blue
  "card-bg" = "#000000"  # Make the card background  black   
)

# --- 2. UI DEFINITION ---
ui <- page_navbar(
  
  
  title = "IPL 2025 Analytics",
  
  theme = my_theme,
  
  # title = div(
  #   img(src = "C:/Users/91884/Desktop/My_RProjects/IPL_App/images/tata_ipl_logo_png_white.png",
  #       height = "50px", style = "margin-right: 10px;"),
  #   "IPL 2025 Analytics"
  # ),
  # 
  # title = div(
  #   img(src = "C:/Users/91884/Desktop/My_RProjects/IPL_App/images/tata_ipl_logo_png_white.png"),
  #      
  #   "IPL 2025 Analytics"
  # ),
  
  # This adds the Dark Mode Toggle Switch to the top right
  nav_spacer(), 
  # nav_item(input_dark_mode(id = "theme_toggle", mode = "dark")),
  
  # --- TAB 1: OVERVIEW ---
  nav_panel(title = "Tournament Overview", icon = bs_icon("bar-chart-fill"),
            
            # ROW 1: The Stat Cards (Value Boxes)
            layout_columns(
              fill = FALSE, # Prevent cards from stretching too tall
              
              value_box(
                title = "Total Runs Scored",
                value = uiOutput("anim_total_runs"),#textOutput("total_runs"), # Dynamic value
                showcase = bs_icon("graph-up-arrow"),
                theme = "primary",
                p("Tournament Total", class = "fs-6")
              ),
              
              value_box(
                title = "Total Sixes",
                value = uiOutput("total_sixes"),
                showcase = bs_icon("fire"),
                theme = "primary", # Red for aggressive play
                p("Maximums Hit", class = "fs-6")
              ),
              
              value_box(
                title = "Total Boundaries (4s)",
                value = uiOutput("total_fours"),
                showcase = bs_icon("border-outer"), # Looks like a boundary rope
                theme = "primary", # Gold/Yellow
                p("Fours Hit", class = "fs-6")
              )
            ),
            
            # ROW 2: The Tables (Orange & Purple Cap)
            layout_columns(
              col_widths = c(6, 6), # Split screen 50/50
              
              # Orange Cap Card
              card(
                card_header(
                  class = "bg-warning text-white", # Gold Header
                  bs_icon("trophy-fill"), " Orange Cap Leaderboard (Most Runs)"
                ),
                reactableOutput("orange_cap_table",height = "100%"),full_screen = T
              ),
              
              # Purple Cap Card
              card(
                card_header(
                  class = "bg-danger text-white", # Blue Header
                  bs_icon("lightning-fill"), " Purple Cap Leaderboard (Most Wickets)"
                ),
                reactableOutput("purple_cap_table"),full_screen = T
              )
            )
  ),
  
  # --- TAB 2: TEAM ANALYSIS (Placeholder for future) ---
  nav_panel(title = "Team Stats", icon = bs_icon("people-fill"),
            card(
              card_header("Coming Soon"),
              p("Select a team to see deep-dive stats here.")
            )
  )
)