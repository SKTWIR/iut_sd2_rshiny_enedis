#Installation des packages
if (!requireNamespace("shiny", quietly = TRUE)) install.packages("shiny")
if (!requireNamespace("bslib", quietly = TRUE)) install.packages("bslib")
if (!requireNamespace("shinymanager", quietly = TRUE)) install.packages("shinymanager")
if (!requireNamespace("sf", quietly = TRUE)) install.packages("sf")
if (!requireNamespace("plotly", quietly = TRUE)) install.packages("plotly")
if (!requireNamespace("httr", quietly = TRUE)) install.packages("httr")
if (!requireNamespace("jsonlite", quietly = TRUE)) install.packages("jsonlite")
if (!requireNamespace("jsonlite", quietly = TRUE)) install.packages("shinydashboard")
if (!requireNamespace("jsonlite", quietly = TRUE)) install.packages("rsconnect")
if (!requireNamespace("jsonlite", quietly = TRUE)) install.packages("readr")
if (!requireNamespace("jsonlite", quietly = TRUE)) install.packages("leaflet")
if (!requireNamespace("jsonlite", quietly = TRUE)) install.packages("DT")
if (!requireNamespace("jsonlite", quietly = TRUE)) install.packages("shinythemes")
if (!requireNamespace("jsonlite", quietly = TRUE)) install.packages("shinydashboardPlus")

library(shiny)
library(bslib)
library(shinymanager)
library(sf)
library(httr)
library(jsonlite)
library(plotly)
library(shinydashboard)
library(readr)
library(leaflet)
library(DT)
library(shinythemes)
library(shinydashboardPlus)

#Apparence :

Nom_Etiquettes = c("A", "B", "C", "D", "E", "F", "G")
Nom_type_batiment = c("maison","appartement","immeuble")

#Utilisable seulement en local :
#code = sort(unique(Logements$code_postal))

code = sort(c("48200", "48220" ,"48800", "48400", "48340", "48500", "48310", "48100", "48700", "48230", "48170", "48150", "48600", "48160",
         "48140", "48190", "48240", "48370", "48120", "48300" ,"48330", "48000" ,"48210" ,"48320" ,"48110",
         "48260", "48250", "48130"))

dashboardPage(
  
  dashboardHeader(title = "GreenTech Solution"),
  
  
  dashboardSidebar(
        sidebarMenu(
        menuItem("Contexte", tabName = "contexte", icon = icon("bookmark")),
        menuItem("Globale", tabName = "globale", icon = icon("dashboard")),
        menuItem("Carte", tabName = "carte", icon = icon("map")),
        menuItem("Régression Linéaire", tabName = "regression", icon = icon("chart-line"))
        )
  ),
  
  
  dashboardBody(
    
  #style CSS définition :
    
    tags$style(HTML("
      .custom-icon {
        font-size: 30px; /* Changez cette valeur pour ajuster la taille */
        vertical-align: middle; /* Aligne l'icône verticalement au centre */
      }")),
    
    
    tags$style(HTML("
      .big-text:not(.custom-icon) {
        font-size: 40px; /* Changez cette valeur pour ajuster la taille */
        text-align: center; /* Centre le texte */
      }")),
    
    tags$head(tags$style('.box-header{ display: none}')),
    
    
      tabItems(
        
        # CONTEXTE ONGLET 1
        tabItem(tabName = "contexte",h2("Contexte"),
          fluidRow(
            
                #Cadre avec texte :
                shinydashboard::box(h2("Les DPE de la Lozère \n"),
                h3("GreenTech Solutions vous propose un dashboard complet sur les données du département de la Lozère! \n"),
                h3("Pour mieux comprendre l'impact des DPE sur les consommation des logements !"),height=250),
                
               #Tri + info rapide
                fluidRow(
                  #Tri
                    column(3, selectInput(inputId = "type_batiment_choix",
                                label = "Sélectionner le type de logement",
                                choices = c("Tout", Nom_type_batiment),
                                width = 350 )),
                    
                    column(3, selectInput(inputId = "code_postal_choix",
                                label = "Sélectionner le code postal",
                                choices = c("Tout", code),
                                width = 350 )),
                    
                    #info rapide
                    shinydashboard::box(div(class = "big-text", icon("home", class = "custom-icon")
                            ,textOutput("nbLogements")),h4("Logements", align = "center"),
                            height = 175, width = 3),
                    
                    shinydashboard::box(div(class = "big-text", icon("building", class = "custom-icon")
                            ,textOutput("moyAnneeConstru")),h4("Moyenne d'année de construction", align = "center"),
                            height = 175, width = 3),
                    
                    height = 250, style="margin: 0;"),
                
                
               #Carte avec les points de couleurs :
                shinydashboard::box(p(style = "text-align: center;font-size: 20px;","Carte des adresses avec la couleurs des DPE") ,
                    leafletOutput("carteContexte", height = "375px" ), height= 450 ),
                
               #histogramme des DPE
                shinydashboard::box(div(style = "display: flex; justify-content: center;",  # Centre horizontalement
                        plotlyOutput("RepartitionDPE", height = "425px")), height = 450),
                
                
               #BAS DE PAGE, TABLEAUX DES DONNEES
                tabsetPanel(id="dataset",
                              tabPanel("Utilisé",DT::dataTableOutput("tableauContexteUsed")),
                              tabPanel("All",DT::dataTableOutput("tableauContexteAll")))
               
          )
        ),
        
        
        
        
        # Stats Globale ONGLET 2
        
        tabItem(tabName = "globale",
                h2("Informations globales"),
                #Graphie donut de la répartition conso :
                
                fluidRow(box(plotlyOutput("RepartitionConso", height = 400)),
                         
                         
                         #tris
                         fluidRow(h2(style = "text-align: center;","Vos tris"),
                             column(3, selectInput(inputId = "type_logement_choix2",
                                         label = "Sélectionner le type de logement",
                                         choices = c("Tout", Nom_type_batiment),
                                         width = 350 ),
                             
                             selectInput(inputId = "DPE_choix2",
                                         label = "Sélectionner le DPE",
                                         choices = c("Tout", Nom_Etiquettes),
                                         width = 350 ),
                             
                             selectInput(inputId = "code_postal_choix2",
                                         label = "Sélectionner le code postal",
                                         choices = c("Tout", code),
                                         width = 350 ),
                             
                             checkboxInput(inputId = "valeurs_aberrantes",
                                           label = "Ignorer les valeurs aberrantes",
                                           value = FALSE,
                                           width = 350),
                             
                             sliderInput(inputId = "choix_annee",
                                         label = "Choisissez une période",
                                         min = 1750, max = 2024, value = c(1750,2024)) )
                             
                          ,height = 400, style="margin: 0; "),
                         
                         
                         #graphiques :
                         box(plotlyOutput("boxplot", height = 375), height = 400),
                         
                         box(plotlyOutput("anneeConstru", height = 375), height = 400),
                         
                         
                         #bas de page tableaux de données
                         tabsetPanel(id="dataset",
                                     tabPanel("Utilisé",DT::dataTableOutput("tableauGlobaleUsed")),
                                     tabPanel("All",DT::dataTableOutput("tableauGlobaleAll")))
               )
        ),
        
        
        #CARTE ONGLET 3
        
        tabItem(tabName ="carte",
                leafletOutput("ongletCarte",height = 800)),
        
        
        
        #Régression linéaire ONGLET 4
        
        tabItem(tabName = "regression",
                h2("Régression Linéaire entre 2 variables aux choix !"),
                  
                selectInput(inputId = "choix_X",
                            label = "Sélectionner la variable X",
                            choices = c("Coût_auxiliaires", "Conso_auxiliaires_é_finale",
                                        "Coût_refroidissement", "Conso_refroidissement_é_finale",
                                        "Coût_éclairage", "Conso_éclairage_é_finale",
                                        "Coût_ECS",   "Conso_ECS_é_finale",
                                        "Coût_chauffage", "Conso_chauffage_é_finale",
                                        "Coût_total_5_usages",  "Conso_5_usages_é_finale", "Emission_GES_5_usages"),
                            width = 350 ),
                
                selectInput(inputId = "choix_Y",
                            label = "Sélectionner la variable Y",
                            choices = c("Coût_auxiliaires", "Conso_auxiliaires_é_finale",
                                        "Coût_refroidissement", "Conso_refroidissement_é_finale",
                                        "Coût_éclairage", "Conso_éclairage_é_finale",
                                        "Coût_ECS",   "Conso_ECS_é_finale",
                                        "Coût_chauffage", "Conso_chauffage_é_finale",
                                        "Coût_total_5_usages",  "Conso_5_usages_é_finale", "Emission_GES_5_usages"),
                            width = 350 ),
                
                plotOutput("RegressionGraph", height=400), 
                
                h2(textOutput("RegressionText"), style = "text-align: center;"))
        )
        
        
      ),
    #petit logo en haut a droite pour changer le style de l'app
    controlbar = dashboardControlbar(skinSelector())
  )

