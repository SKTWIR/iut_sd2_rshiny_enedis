library(shiny)

# Mise en place server
function(input, output, session) {

  setwd("C:/Users/delli/Desktop/Projet R")
  
  ColAGarderExistants = c('Coût_auxiliaires,Conso_auxiliaires_é_finale,Conso_refroidissement_é_finale,Coût_refroidissement,Coût_éclairage,Conso_éclairage_é_finale,Année_construction,_geopoint,Identifiant__BAN,N°DPE,Etiquette_DPE,Coordonnée_cartographique_X_(BAN),Coordonnée_cartographique_Y_(BAN),Nom__commune_(BAN),N°_département_(BAN),N°_région_(BAN),Code_postal_(BAN),Code_INSEE_(BAN),Conso_chauffage_dépensier_é_finale,Conso_chauffage_é_finale,Conso_5_usages_par_m²_é_primaire,Conso_5_usages_é_finale,Conso_ECS_é_primaire,Emission_GES_5_usages,Emission_GES_chauffage,Emission_GES_ECS,Emission_GES_5_usages_par_m²,Coût_total_5_usages,Coût_ECS,Coût_chauffage,Surface_habitable_logement,Date_établissement_DPE,Date_fin_validité_DPE,Etiquette_GES,Version_DPE,Type_énergie_n°1,Type_bâtiment,Conso_ECS_é_finale')
  
  adresses_48 = read.csv("adresses_48.csv",header=T,sep= ";",dec=".")
  code = unique(adresses_48$code_postal)
  annee = seq(2021,2024,1)
  
  df = data.frame()
  
  #RECUPERE LES LOGEMENTS EXISTANTS
  base_url <- "https://data.ademe.fr/data-fair/api/v1/datasets/dpe-v2-logements-existants/lines"
  
  for (i in code) {
    params <- list(
      size = 1,
      q = i,
      q_fields = "Code_postal_(BAN)"
    ) 
    url_encoded <- modify_url(base_url, query = params)
    response <- GET(url_encoded)
    content = fromJSON(rawToChar(response$content), flatten = FALSE)
    
    if (content$total < 10000) {
      params <- list(
        size = 10000,
        q = i,
        q_fields = "Code_postal_(BAN)",
        select = ColAGarderExistants
      ) 
      url_encoded <- modify_url(base_url, query = params)
      response <- GET(url_encoded)
      content = fromJSON(rawToChar(response$content), flatten = FALSE)
      
      df = rbind(df,content$result)}
    
    else { for (a in annee) {
      a=as.character(a)
      params <- list(
        size = 10000,
        q = i,
        q_fields = "Code_postal_(BAN)",
        qs = paste0("Date_réception_DPE:[",a,"-01-01 TO ",a,"-12-31]"),
        select = ColAGarderExistants
      ) 
      
      
      url_encoded <- modify_url(base_url, query = params)
      response <- GET(url_encoded)
      content = fromJSON(rawToChar(response$content), flatten = FALSE)
      
      df = rbind(df,content$result)}
    }
  }
  
  df2 = data.frame()
  #RECUPERE LES LOGEMENTS NEUFS
  ColAGarderNeufs = c('Coût_auxiliaires,Conso_auxiliaires_é_finale,Conso_refroidissement_é_finale,Coût_refroidissement,Coût_éclairage,Conso_éclairage_é_finale,_geopoint,Identifiant__BAN,N°DPE,Etiquette_DPE,Coordonnée_cartographique_X_(BAN),Coordonnée_cartographique_Y_(BAN),Nom__commune_(BAN),N°_département_(BAN),N°_région_(BAN),Code_postal_(BAN),Code_INSEE_(BAN),Conso_chauffage_dépensier_é_finale,Conso_chauffage_é_finale,Conso_5_usages_par_m²_é_primaire,Conso_5_usages_é_finale,Conso_ECS_é_primaire,Emission_GES_5_usages,Emission_GES_chauffage,Emission_GES_ECS,Emission_GES_5_usages_par_m²,Coût_total_5_usages,Coût_ECS,Coût_chauffage,Surface_habitable_logement,Date_établissement_DPE,Date_fin_validité_DPE,Etiquette_GES,Version_DPE,Type_énergie_n°1,Type_bâtiment,Conso_ECS_é_finale')
  
  base_url <- "https://data.ademe.fr/data-fair/api/v1/datasets/dpe-v2-logements-neufs/lines"
  
  for (i in code) {
    params <- list(
      size = 1,
      q = i,
      q_fields = "Code_postal_(BAN)"
    ) 
    url_encoded <- modify_url(base_url, query = params)
    response <- GET(url_encoded)
    content = fromJSON(rawToChar(response$content), flatten = FALSE)
    
    if (content$total < 10000) {
      params <- list(
        size = 10000,
        q = i,
        q_fields = "Code_postal_(BAN)",
        select = ColAGarderNeufs
      ) 
      url_encoded <- modify_url(base_url, query = params)
      response <- GET(url_encoded)
      content = fromJSON(rawToChar(response$content), flatten = FALSE)
      
      df2 = rbind(df2,content$result)}
    
    else { for (a in annee) {
      a=as.character(a)
      params <- list(
        size = 10000,
        q = i,
        q_fields = "Code_postal_(BAN)",
        qs = paste0("Date_réception_DPE:[",a,"-01-01 TO ",a,"-12-31]"),
        select = ColAGarderNeufs
      ) 
      
      
      url_encoded <- modify_url(base_url, query = params)
      response <- GET(url_encoded)
      content = fromJSON(rawToChar(response$content), flatten = FALSE)
      
      df2 = rbind(df2,content$result)}
    }
  }
  df2$Année_construction = 2024
  
  #Assemblé les 2 df :
  
  Lg = rbind(df,df2)
  
  #Jointure avec adresses
  
  Logements = merge(Lg,adresses_48, by.x ="Identifiant__BAN", by.y = "id")
  
  #GRAPHIQUES :
  
  #Calculer les moyennes
  MChauf <- round(mean(Logements$Conso_chauffage_é_finale[Logements$Conso_chauffage_é_finale > 0], na.rm = TRUE),2)
  MEclair <- round(mean(Logements$Conso_éclairage_é_finale[Logements$Conso_éclairage_é_finale > 0], na.rm = TRUE),2)
  MECS <- round(mean(Logements$Conso_ECS_é_finale[Logements$Conso_ECS_é_finale > 0], na.rm = TRUE),2)
  MRefroid <- round(mean(Logements$Conso_refroidissement_é_finale[Logements$Conso_refroidissement_é_finale > 0], na.rm = TRUE),2)
  MAux <- round(mean(Logements$Conso_auxiliaires_é_finale[Logements$Conso_auxiliaires_é_finale > 0], na.rm = TRUE),2)
  MTotal <- round(mean(Logements$Conso_5_usages_é_finale[Logements$Conso_5_usages_é_finale > 0], na.rm = TRUE),2)
  
  output$RepartitionConso <- renderPlotly({
    data <- data.frame(
      category = c("Chauffage", "Eclairage", "ECS", "Refroidissement", "Auxiliaire"),
      count = c(MChauf, MEclair, MECS, MRefroid, MAux)
    )
    
    # Calculer les pourcentages
    data$fraction <- data$count / MTotal
    data$percentage <- round(data$fraction * 100, 1)
    
    # Créer un graphique à secteurs interactif
    graph = plot_ly(data, labels = ~category, values = ~count, type = 'pie', 
    marker = list(colors = c('#FF9999', '#66B2FF', '#99FF99', '#FFCC99', '#FF66B2')),
    hole = 0.4) %>%  #trou pour faire un donut
      layout(
        title = list(
          text = "<b>Répartition des consommations énergétiques</b>",  # Titre en gras
          font = list(size = 15),  # Taille du titre
          yanchor = 'top',  # Ancre le titre en haut
          y = 0.95 
        ),
        showlegend = TRUE,
        legend = list(
          orientation = 'v',  # Orientation verticale
          xanchor = 'center',  # Centre la légende
          x = 1.1,  # Positionne la légende à droite
          y = 0.5   # Positionne la légende au milieu de la zone y
        ),
        margin = list(t = 60, b = 40, l = 40, r = 40)  # Ajustez les marges (t = top, b = bottom, l = left, r = right)
      )
  
    return(graph)
  })
  
  
}

