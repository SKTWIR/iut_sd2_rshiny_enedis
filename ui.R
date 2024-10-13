#Installation des packages
if (!requireNamespace("shiny", quietly = TRUE)) install.packages("shiny")
if (!requireNamespace("bslib", quietly = TRUE)) install.packages("bslib")
if (!requireNamespace("shinymanager", quietly = TRUE)) install.packages("shinymanager")
if (!requireNamespace("sf", quietly = TRUE)) install.packages("sf")
if (!requireNamespace("plotly", quietly = TRUE)) install.packages("plotly")
if (!requireNamespace("httr", quietly = TRUE)) install.packages("httr")
if (!requireNamespace("jsonlite", quietly = TRUE)) install.packages("jsonlite")
if (!requireNamespace("jsonlite", quietly = TRUE)) install.packages("shinydashboard")

library(shiny)
library(bslib)
library(shinymanager)
library(sf)
library(httr)
library(jsonlite)
library(plotly)
library(shinydashboard)

#Apparence :

dashboardPage(
  dashboardHeader(title = "GreenTech Solution"),
  
  
  dashboardSidebar(
      sidebarMenu(
      menuItem("Contexte", tabName = "contexte", icon = icon("poo")),
      menuItem("Globale", tabName = "globale", icon = icon("th"))
  )),
  
  
  dashboardBody(
    

    tags$style(HTML("
    .custom-icon {
      font-size: 30px; /* Changez cette valeur pour ajuster la taille */
      vertical-align: middle; /* Aligne l'icône verticalement au centre */
    }
  ")),
    
    
    tags$style(HTML("
    .big-text:not(.custom-icon) {
      font-size: 40px; /* Changez cette valeur pour ajuster la taille */
      text-align: center; /* Centre le texte */
    }
  ")),
    
    
      tabItems(
        # CONTEXTE
        tabItem(tabName = "contexte",h2("Contexte"),
          fluidRow(
      
                box(h4("Les DPE de la Lozère \n"),
                p("Enedis a fait ceci machin truc et bla bla bla"),height=250),
                
                
                column(3, selectInput(inputId = "type_batiment_choix",
                            label = "Sélectionner le type de logement",
                            choices = c("Tout", Nom_type_batiment),
                            width = 350) ),
                
                column(3, selectInput(inputId = "etiquette_dpe_choix",
                            label = "Sélectionner le DPE",
                            choices = c("Tout", Nom_Etiquettes),
                            width = 350) ),
                
          
                box(div(class = "big-text", icon("home", class = "custom-icon") ,textOutput("nbLogements")),h4("Logements", align = "center"),height = 175,width=3),
                box(div(class = "big-text", icon("building", class = "custom-icon") ,textOutput("moyAnneeConstru")),h4("Moyenne d'année de construction", align = "center"),height = 175,width=3),
                
                  
                box(div(style = "display: flex; justify-content: center;",  # Centre horizontalement
                        plotlyOutput("RepartitionDPE", height = "375px")  # Ajoute le graphique ici
                ), height = 400)
          )
        ),
        
        # Stats Globale
        tabItem(tabName = "globale",
                h2("globale"),
                fluidRow(box(plotlyOutput("RepartitionConso", height = 400)))
        )
      )
  )
)
