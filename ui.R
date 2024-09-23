#chargement des packages
library(shiny)

# Define UI for application
fluidPage(

    # titre de l'application
    titlePanel("Greentech solution for Enedis"),
   
    #Barre latéral 
    page_sidebar(
      title = "Options",
      sidebar = sidebar("Barre latéral"),
      card(
        card_header(""),
        #insérez un graphique ?
      )
    ),
    #utilisation d'un theme prédefini
    theme = bs_theme(preset = "minty") 
)



