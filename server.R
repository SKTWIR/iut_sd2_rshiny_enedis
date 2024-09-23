#verification du besoin d'installer des packages
if(!require(shiny)) install.packages("shiny")
if(!require(bslib)) install.packages("bslib")

#chargement des packages
library(shiny)
library(bslib)

# Define server logic required to draw a histogram
function(input, output, session) {

  theme = bs_theme() #appelle de la fonction qui sert a avoir un thème
}
