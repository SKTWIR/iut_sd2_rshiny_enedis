#verification du besoin d'installer des packages
if(!require(shiny)) install.packages("shiny")
if(!require(bslib)) install.packages("bslib")
if(!require(shinymanager)) install.packages("shinymanager")
if(!require(sf)) install.packages("sf")

#chargement des packages :

#sert au fonctionnement de l'application
library(shiny)
#theme de l'application
library(bslib)
#gestion des mots de passe
library(shinymanager)
#pr créer un map
library(sf)



# define some basic credentials (on data.frame) j'ai pas réussi a faire fonctionner le truc mdrrr
credentials <- data.frame(
  user = c("shiny", "administrateur"), # mandatory
  password = c("azerty", "administrateur"), # mandatory
  start = c("2019-04-15"), # optinal (all others)
  expire = c(NA, "2019-12-31"),
  admin = c(FALSE, TRUE),
  comment = "Simple and secure authentification mechanism 
  for single ‘Shiny’ applications.",
  stringsAsFactors = FALSE)
#https://datastorm-open.github.io/shinymanager/#usage source du truc au dessus

# Define UI for application
fluidPage(
  
  #côté UI mise en place de l'affichage
  #tags$h2("My secure application"),
  #verbatimTextOutput("auth_output"),
  

  
    # titre de l'application
    titlePanel("Greentech solution for Enedis"),
    
    
    tabsetPanel(
      # Premier onglet
      tabPanel("Contexte", 
               h2("Contexte de l'application"),
               p("premier onglet"),
               
               #création d'une carte du lozère
               #https://rstudio.github.io/leaflet/articles/markers.html
               ),
      
      # Deuxième onglet
      tabPanel("Onglet 2", 
               h2("Contenu du deuxième onglet"),
               #Barre latéral 
               page_sidebar(
                 title = "Options",
                 sidebar = sidebar("Barre latéral"),
                 card(
                   card_header(""),
                   card_header("graphique de je sais pas quoi"),
                   #insérez un graphique ?
                 )
               ),
               p("Ceci est l'onglet 2")),
      
      # Troisième onglet
      tabPanel("Onglet 3", 
               h3("Contenu du troisième onglet"),
               p("Ceci est l'onglet 3"),
               card(
                 card_header("flop"))),
      
      # Quatrième onglet
      tabPanel("Onglet 4", 
               h2("Contenu du troisième onglet"),
               p("Ceci est l'onglet 4"))
    ),

    theme = bs_theme(preset = "darkly")
)
#ui <- secure_app(ui)
