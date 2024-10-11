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
  dashboardHeader(title = "Green Tech for Enedis"),
  
  
  dashboardSidebar(
      sidebarMenu(
      menuItem("Contexte", tabName = "contexte", icon = icon("poo")),
      menuItem("Globale", tabName = "globale", icon = icon("th"))
  )),
  
  
  dashboardBody(
      tabItems(
        # CONTEXTE
        tabItem(tabName = "contexte",h2("Contexte"),
          fluidRow(
                box(plotlyOutput("RepartitionDPE",height=350,width=600), height = 400),
                box(strong("Les DPE de la Lozère \n"),
                p("Enedis a fait ceci machin truc et bla bla bla"),
                height=250
                ),
            box(strong("2594\n"),p("Logements"),height = 150,width=3),
            box(height = 150,width=3)
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
