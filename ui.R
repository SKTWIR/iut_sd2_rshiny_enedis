#verification du besoin d'installer des packages
if(!require(shiny)) install.packages("shiny")
if(!require(bslib)) install.packages("bslib")
if(!require(shinymanager)) install.packages("shinymanager")

#chargement des packages :

#sert au fonctionnement de l'application
library(shiny)
#theme de l'application
library(bslib)
#gestion des mots de passe
library(shinymanager)


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

    # titre de l'application
    titlePanel("Greentech solution for Enedis"),
   
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
    tabsetPanel(
      # Premier onglet
      tabPanel("Contexte", 
               h2("Contexte de l'application"),
               p("premier onglet")),
      
      # Deuxième onglet
      tabPanel("Onglet 2", 
               h2("Contenu du deuxième onglet"),
               p("Ceci est l'onglet 2")),
      
      # Troisième onglet
      tabPanel("Onglet 3", 
               h2("Contenu du troisième onglet"),
               p("Ceci est l'onglet 3")),
      
      # Quatrième onglet
      tabPanel("Onglet 4", 
               h2("Contenu du troisième onglet"),
               p("Ceci est l'onglet 4"))
    ),
    
    
    theme = bs_theme(preset = "darkly")
)