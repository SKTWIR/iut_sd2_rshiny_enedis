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

# Define server logic required to draw a histogram
function(input, output, session) {
  
  # call the server part
  # check_credentials returns a function to authenticate users
  #res_auth <- secure_server(
  #check_credentials = check_credentials(credentials))
  
  #output$auth_output <- renderPrint({
  #reactiveValuesToList(res_auth)})

  theme = bs_theme() #appelle de la fonction qui sert a avoir un thème
  
}
#shinyApp(ui, server)