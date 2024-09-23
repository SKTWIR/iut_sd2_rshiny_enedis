library(shiny)

# Define UI for application that draws a histogram
fluidPage(

    # Application title
    titlePanel("Greentech solution for Enedis"),
    
    page_sidebar(
      title = "Options",
      sidebar = sidebar("Barre latéral",),
      card(
        card_header(""),
        #insérez un graphique ?
      )
    ),
    theme = bs_theme(preset = "minty")
)



