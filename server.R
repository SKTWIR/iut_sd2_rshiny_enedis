library(shiny)

# Mise en place server
function(input, output, session) {

  #création de certaines variables
  annee = seq(2021,2024,1)
  trieEtiquette = ""
  trieBatiment = ""
  Nom_Etiquettes = c("A", "B", "C", "D", "E", "F", "G")
  
  #recupère le fichier des adresses :
  urlfile="https://raw.githubusercontent.com/SKTWIR/iut_sd2_rshiny_enedis/refs/heads/main/adresses_48.csv"
  adresses_48 = read.csv(url(urlfile),,header=T,sep= ";",dec=".")
  code = unique(adresses_48$code_postal)
  
  
  
  #RECUPERE LES LOGEMENTS EXISTANTS
  df = data.frame()
  
  base_url <- "https://data.ademe.fr/data-fair/api/v1/datasets/dpe-v2-logements-existants/lines"
  
  ColAGarderExistants = c('Coût_auxiliaires,Conso_auxiliaires_é_finale,Conso_refroidissement_é_finale,Coût_refroidissement,Coût_éclairage,Conso_éclairage_é_finale,Année_construction,_geopoint,Identifiant__BAN,N°DPE,Etiquette_DPE,Nom__commune_(BAN),N°_département_(BAN),N°_région_(BAN),Code_postal_(BAN),Code_INSEE_(BAN),Conso_chauffage_é_finale,Conso_5_usages_é_finale,Emission_GES_5_usages,Emission_GES_chauffage,Emission_GES_ECS,Coût_total_5_usages,Coût_ECS,Coût_chauffage,Surface_habitable_logement,Date_établissement_DPE,Date_fin_validité_DPE,Etiquette_GES,Version_DPE,Type_énergie_n°1,Type_bâtiment,Conso_ECS_é_finale')
  
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
  
  
  #RECUPERE LES LOGEMENTS NEUFS
  df2 = data.frame()
  
  ColAGarderNeufs = c('Coût_auxiliaires,Conso_auxiliaires_é_finale,Conso_refroidissement_é_finale,Coût_refroidissement,Coût_éclairage,Conso_éclairage_é_finale,_geopoint,Identifiant__BAN,N°DPE,Etiquette_DPE,Nom__commune_(BAN),N°_département_(BAN),N°_région_(BAN),Code_postal_(BAN),Code_INSEE_(BAN),Conso_chauffage_é_finale,Conso_5_usages_é_finale,Emission_GES_5_usages,Emission_GES_chauffage,Emission_GES_ECS,Coût_total_5_usages,Coût_ECS,Coût_chauffage,Surface_habitable_logement,Date_établissement_DPE,Date_fin_validité_DPE,Etiquette_GES,Version_DPE,Type_énergie_n°1,Type_bâtiment,Conso_ECS_é_finale')
  
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
  
  
  
  
  #OUTPUT POUR L'APP
  
  # POUR L'ONGLET CONTEXTE ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
  #création graph répartition DPE :
  
  output$RepartitionDPE = renderPlotly({
  
        dfContexte = Logements
        
        if (input$type_batiment_choix != "Tout") {
          dfContexte <- subset(dfContexte, Type_bâtiment == input$type_batiment_choix)}
        
        if (input$code_postal_choix != "Tout") {
          dfContexte <- subset(dfContexte, `Code_postal_(BAN)` == input$code_postal_choix)}
        
        dfContexte$Etiquette_DPE <- factor(dfContexte$Etiquette_DPE, levels = Nom_Etiquettes)
        plot_data <- table(dfContexte$Etiquette_DPE)
        plot_data
        plot_data = as.data.frame(plot_data)
        
        repartitionDPE = plot_ly(data = plot_data,x=~Var1, y=~Freq,text=~Freq, type= 'bar',
                                 marker = list(color = c('#519740', '#33cc33', '#ccff33', '#ffff00', '#ffcc00','#ff9a33','#ff0000')))%>%
          layout(
            title = ifelse(input$type_batiment_choix == "Tout", "Nombre de DPE pour tous les types de logements",
                           paste("Nombre de DPE pour le type de logement :", input$type_batiment_choix)),
            xaxis = list(title = "Étiquette DPE"),
            yaxis = list(title = "Nombre de logement"))%>%
            plotly::config(modeBarButtonsToRemove = list(
              'zoom2d', 'pan2d', 'select2d', 'lasso2d', 'zoomIn2d', 
              'zoomOut2d', 'autoScale2d', 'resetScale2d', 'hoverCompareCartesian', 'toggleSpikelines', 'toggleHover', 
              'resetViews', 'sendDataToCloud'),
              displaylogo = F)
        
    return(repartitionDPE)
    
  })

  
  #INFOS :
  
  output$nbLogements = renderText({
    
        dfContexte = Logements
        
        if (input$type_batiment_choix != "Tout") {
          dfContexte <- subset(dfContexte, Type_bâtiment == input$type_batiment_choix)}
        
        if (input$code_postal_choix != "Tout") {
          dfContexte <- subset(dfContexte, `Code_postal_(BAN)` == input$code_postal_choix)}
        
        nbLogements = nrow(dfContexte)
  
    return(nbLogements)

  })
  
  output$moyAnneeConstru = renderText({
    
        dfContexte = Logements
        
        if (input$type_batiment_choix != "Tout") {
          dfContexte <- subset(dfContexte, Type_bâtiment == input$type_batiment_choix)}
        
        if (input$code_postal_choix != "Tout") {
          dfContexte <- subset(dfContexte, `Code_postal_(BAN)` == input$code_postal_choix)}
    
        moyAnneeConstru = round(mean(dfContexte$Année_construction, na.rm = T),0)
 
    return(moyAnneeConstru)
  })
  
  #Carte avec points de couleur DPE
  
  output$carteContexte = renderLeaflet({
    
        pal <- colorFactor(palette = c('#519740', '#33cc33', '#ccff33', '#ffff00', '#ffcc00','#ff9a33','#ff0000'), domain = c("A", "B", "C", "D", "E", "F", "G"))
        
        dfContexte = Logements
        
        if (input$type_batiment_choix != "Tout") {
          dfContexte <- subset(dfContexte, Type_bâtiment == input$type_batiment_choix)}
        
        if (input$code_postal_choix != "Tout") {
          dfContexte <- subset(dfContexte, `Code_postal_(BAN)` == input$code_postal_choix)}
        
      leaflet(data = dfContexte) %>% addTiles() %>%
        addCircleMarkers(
          radius = 3,
          color = ~pal(Etiquette_DPE),
          stroke = FALSE, fillOpacity = 0.8
    )})
  
  
  #afficher tableaux trier avec colonne utilisés :
  output$tableauContexteUsed = DT::renderDataTable({
    
          dfContexte = Logements
          
          if (input$type_batiment_choix != "Tout") {
            dfContexte <- subset(dfContexte, Type_bâtiment == input$type_batiment_choix)}
          
          if (input$code_postal_choix != "Tout") {
            dfContexte <- subset(dfContexte, `Code_postal_(BAN)` == input$code_postal_choix)}
          
          dfContexte = select(dfContexte, c('Identifiant__BAN','Etiquette_DPE','Code_postal_(BAN)','Type_bâtiment','Année_construction','lat','lon'))
          
          dfContexte = datatable(dfContexte, extensions = 'Buttons', 
                                options = list(lengthMenu = c(5, 30, 50),
                                               dom = "Bfrtip",
                                               buttons = c('csv', 'excel'),
                                               scrollX = TRUE,
                                               scrollY = "250px"))
    
      return(dfContexte)
  })
  
  #afficher tableaux trier avec toutes les colonnes :
  output$tableauContexteAll = DT::renderDataTable({
    
          dfContexte = Logements
          
          if (input$type_batiment_choix != "Tout") {
            dfContexte <- subset(dfContexte, Type_bâtiment == input$type_batiment_choix)}
          
          if (input$code_postal_choix != "Tout") {
            dfContexte <- subset(dfContexte, `Code_postal_(BAN)` == input$code_postal_choix)}
          
          dfContexte = datatable(dfContexte, extensions = 'Buttons', 
                                 options = list(lengthMenu = c(5, 30, 50),
                                               dom = "Bfrtip",
                                               buttons = c('csv', 'excel'),
                                               scrollX = TRUE,
                                               scrollY = "250px"))
      
      return(dfContexte)
  })
  
  #-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
  
  #POUR PAGE GLOBALE _-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
  
  #graphique donut  ()())()()()()(())()()()()())()()()()(())()()(
  
  output$RepartitionConso <- renderPlotly({
    
      #Calculer les moyennes  
      
      #sans val ?
      if (input$valeurs_aberrantes == TRUE) {
        Logements=  subset(Logements,Coût_total_5_usages <  10000)}
      #TYPE
      if (input$type_logement_choix2 != "Tout") {
        Logements=  subset(Logements,Type_bâtiment == input$type_logement_choix2)}
      #DPE
      if (input$DPE_choix2 != "Tout") {
        Logements=  subset(Logements,Etiquette_DPE == input$DPE_choix2)}
      #Code
      if (input$code_postal_choix2 != "Tout") {
        Logements=  subset(Logements,`Code_postal_(BAN)` == input$code_postal_choix2)}
      
      Logements = Logements[Logements$Année_construction >= input$choix_annee[1] & 
                              Logements$Année_construction <= input$choix_annee[2], ]
    
              MChauf <- round(mean(Logements$Conso_chauffage_é_finale[Logements$Conso_chauffage_é_finale > 0], na.rm = TRUE),2)
              MEclair <- round(mean(Logements$Conso_éclairage_é_finale[Logements$Conso_éclairage_é_finale > 0], na.rm = TRUE),2)
              MECS <- round(mean(Logements$Conso_ECS_é_finale[Logements$Conso_ECS_é_finale > 0], na.rm = TRUE),2)
              MRefroid <- round(mean(Logements$Conso_refroidissement_é_finale[Logements$Conso_refroidissement_é_finale > 0], na.rm = TRUE),2)
              MAux <- round(mean(Logements$Conso_auxiliaires_é_finale[Logements$Conso_auxiliaires_é_finale > 0], na.rm = TRUE),2)
              MTotal <- round(mean(Logements$Conso_5_usages_é_finale[Logements$Conso_5_usages_é_finale > 0], na.rm = TRUE),2)
              
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
              text = "<b>Répartition des 5 usages</b>",  # Titre en gras
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
          ) %>%
          plotly::config(displaylogo = F)
    
    return(graph)
  })
  
  # ()())()()()()(())()()()()())()()()()(())()()()()())()()()
  
  #boite a moustachu
  
  output$boxplot = renderPlotly({
        logementsSansVal = Logements
        #sans val ?
        if (input$valeurs_aberrantes == TRUE) {
          logementsSansVal=  subset(Logements,Coût_total_5_usages <  10000)}
        #TYPE
        if (input$type_logement_choix2 != "Tout") {
          logementsSansVal=  subset(logementsSansVal,Type_bâtiment == input$type_logement_choix2)}
        #DPE
        if (input$DPE_choix2 != "Tout") {
          logementsSansVal=  subset(logementsSansVal,Etiquette_DPE == input$DPE_choix2)}
        #Code
        if (input$code_postal_choix2 != "Tout") {
          logementsSansVal=  subset(logementsSansVal,`Code_postal_(BAN)` == input$code_postal_choix2)}
        
        logementsSansVal = logementsSansVal[logementsSansVal$Année_construction >= input$choix_annee[1] & 
                                              logementsSansVal$Année_construction <= input$choix_annee[2], ]
    
              A = subset(logementsSansVal, Etiquette_DPE == "A")
              B = subset(logementsSansVal, Etiquette_DPE == "B")
              C = subset(logementsSansVal, Etiquette_DPE == "C")
              D = subset(logementsSansVal, Etiquette_DPE == "D")
              E = subset(logementsSansVal, Etiquette_DPE == "E")
              F = subset(logementsSansVal, Etiquette_DPE == "F")
              G = subset(logementsSansVal, Etiquette_DPE == "G")
              
    #assemblage boxplot
        fig <- plot_ly(y = na.omit(A$Coût_total_5_usages), type = "box",boxpoints = FALSE, marker = list(color = '#519740'),line = list(color = '#447a2b'),fillcolor = '#519740', quartilemethod="linear", name="A")
        
        fig <- fig %>% add_trace(y =na.omit(B$Coût_total_5_usages), quartilemethod="inclusive", name="B", marker = list(color = '#33cc33'),line = list(color = '#29a829'),fillcolor = '#33cc33' )
        
        fig <- fig %>% add_trace(y =na.omit(C$Coût_total_5_usages), quartilemethod="inclusive", name="C", marker = list(color = '#ccff33'),line = list(color = '#99cc00'),fillcolor = '#ccff33' )
        
        fig <- fig %>% add_trace(y =na.omit(D$Coût_total_5_usages), quartilemethod="exclusive", name="D", marker = list(color = '#ffff00'),line = list(color = '#b3b300'),fillcolor = '#ffff00' )
        
        fig <- fig %>% add_trace(y =na.omit(E$Coût_total_5_usages), quartilemethod="exclusive", name="E", marker = list(color = '#ffcc00'),line = list(color = '#d6a600'),fillcolor = '#ffcc00' )
        
        fig <- fig %>% add_trace(y =na.omit(F$Coût_total_5_usages), quartilemethod="exclusive", name="F", marker = list(color = '#ff9a33'),line = list(color = '#ff6f2a'),fillcolor = '#ff9a33' )
        
        fig <- fig %>% add_trace(y =na.omit(G$Coût_total_5_usages), quartilemethod="exclusive", name="G", marker = list(color = '#ff0000'),line = list(color = '#990000'),fillcolor = '#ff0000' )
        
        fig <- fig %>% layout(title = "<b>Boites à moustache du coût total par DPE</b>",
                              xaxis = list(title = "DPE"),
                              yaxis = list(title = "Consommation en kWhef/an")
                                )%>%
          plotly::config(modeBarButtonsToRemove = list(
            'zoom2d', 'pan2d', 'select2d', 'lasso2d', 'zoomIn2d', 
            'zoomOut2d', 'autoScale2d', 'resetScale2d', 'hoverCompareCartesian', 'toggleSpikelines', 'toggleHover', 
            'resetViews', 'sendDataToCloud'),
            displaylogo = F)
    
    return(fig)
  })
  
  
  #histrogramme annee construction :
  
  output$anneeConstru = renderPlotly({
    
        dfAnnee = Logements
            #sans val ?
            if (input$valeurs_aberrantes == TRUE) {
              dfAnnee=  subset(Logements,Coût_total_5_usages <  10000)}
            #TYPE
            if (input$type_logement_choix2 != "Tout") {
              dfAnnee=  subset(dfAnnee,Type_bâtiment == input$type_logement_choix2)}
            #DPE
            if (input$DPE_choix2 != "Tout") {
              dfAnnee=  subset(dfAnnee,Etiquette_DPE == input$DPE_choix2)}
            #Code
            if (input$code_postal_choix2 != "Tout") {
              dfAnnee=  subset(dfAnnee,`Code_postal_(BAN)` == input$code_postal_choix2)}
            
            dfAnnee = dfAnnee[dfAnnee$Année_construction >= input$choix_annee[1] & 
                                dfAnnee$Année_construction <= input$choix_annee[2], ]
        
        plot_data <- table(dfAnnee$Année_construction)
        plot_data = as.data.frame(plot_data)
  
      repartitionAnnee = plot_ly(data = plot_data,x=~Var1, y=~Freq,text=~Freq, type= 'bar')%>%
        layout(
          title = "<b>Répartition des logements en fonction de l'année de construction</b>",
          xaxis = list(title = "Années"),
          yaxis = list(title = "Nb logements"))%>%
        plotly::config(modeBarButtonsToRemove = list(
          'zoom2d', 'pan2d', 'select2d', 'lasso2d', 'zoomIn2d', 
          'zoomOut2d', 'autoScale2d', 'resetScale2d', 'hoverCompareCartesian', 'toggleSpikelines', 'toggleHover', 
          'resetViews', 'sendDataToCloud'),
          displaylogo = F)
      
      return(repartitionAnnee)
  })
  
  
  #afficher tableaux trier avec colonne utilisés info globale :
  
  output$tableauGlobaleUsed = DT::renderDataTable({
          
          dfGlobale = Logements
          #sans val ?
          if (input$valeurs_aberrantes == TRUE) {
            dfGlobale=  subset(Logements,Coût_total_5_usages <  10000)}
          #TYPE
          if (input$type_logement_choix2 != "Tout") {
            dfGlobale=  subset(dfGlobale,Type_bâtiment == input$type_logement_choix2)}
          #DPE
          if (input$DPE_choix2 != "Tout") {
            dfGlobale=  subset(dfGlobale,Etiquette_DPE == input$DPE_choix2)}
          #Code
          if (input$code_postal_choix2 != "Tout") {
            dfGlobale=  subset(dfGlobale,`Code_postal_(BAN)` == input$code_postal_choix2)}
          
          dfGlobale = dfGlobale[dfGlobale$Année_construction >= input$choix_annee[1] & 
                                  dfGlobale$Année_construction <= input$choix_annee[2], ]
    
        dfGlobale = select(dfGlobale, c('Identifiant__BAN','Etiquette_DPE','Code_postal_(BAN)','Type_bâtiment','Année_construction','Conso_chauffage_é_finale','Conso_éclairage_é_finale','Conso_ECS_é_finale','Conso_refroidissement_é_finale','Conso_auxiliaires_é_finale','Conso_5_usages_é_finale','Coût_total_5_usages',))
        
        dfGlobale = datatable(dfGlobale, extensions = 'Buttons', 
                               options = list(lengthMenu = c(5, 30, 50),
                                              dom = "Bfrtip",
                                              buttons = c('csv', 'excel'),
                                              scrollX = TRUE,
                                              scrollY = "250px"))
        
    
    return(dfGlobale)
  })
  
  #afficher tableaux trier avec toutes les colonnes :
  output$tableauGlobaleAll = DT::renderDataTable({
    
            dfGlobale = Logements
            #sans val ?
            if (input$valeurs_aberrantes == TRUE) {
              dfGlobale=  subset(Logements,Coût_total_5_usages <  10000)}
            #TYPE
            if (input$type_logement_choix2 != "Tout") {
              dfGlobale=  subset(dfGlobale,Type_bâtiment == input$type_logement_choix2)}
            #DPE
            if (input$DPE_choix2 != "Tout") {
              dfGlobale=  subset(dfGlobale,Etiquette_DPE == input$DPE_choix2)}
            #Code
            if (input$code_postal_choix2 != "Tout") {
              dfGlobale=  subset(dfGlobale,`Code_postal_(BAN)` == input$code_postal_choix2)}
            
            dfGlobale = dfGlobale[dfGlobale$Année_construction >= input$choix_annee[1] & 
                                    dfGlobale$Année_construction <= input$choix_annee[2], ]
    
        dfGlobale = datatable(dfGlobale, extensions = 'Buttons', 
                              options = list(lengthMenu = c(5, 30, 50),
                                             dom = "Bfrtip",
                                             buttons = c('csv', 'excel'),
                                             scrollX = TRUE,
                                             scrollY = "250px"))
    
    return(dfGlobale)
   
  })
  
  #_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
  
  
  #ONGLET CARTE _______________________________________________________________________________________________________________________________________________________________________________________
  
  
  output$ongletCarte = renderLeaflet({
    
    Logements$AdressesComplete = paste(Logements$numero," ",Logements$nom_voie,", ",Logements$nom_commune)
    
    carte = leaflet(Logements) %>% addTiles() %>% addMarkers(~lon, ~lat, popup = ~paste("<strong> Adresse: </strong>", AdressesComplete, "<br>",
                                                                                "<strong> DPE : </strong>", Etiquette_DPE, "<br>",
                                                                                "<strong> Conso total: </strong>", Conso_5_usages_é_finale, "kWhep/an<br>",
                                                                                "<strong> Cout total 5 usages: </strong>", Coût_total_5_usages, "€"),
                                                     clusterOptions = markerClusterOptions())
    return(carte)
  })
  
  #_______________________________________________________________________________________________________________________________________________________________________________________
  
  
  #POUR ONGLET REGRESSION : -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
  #graph
  output$RegressionGraph = renderPlot({
    
    dataX = select(Logements, input$choix_X)
    dataX = as.numeric(dataX[[1]])
    
    dataY = select(Logements, input$choix_Y)
    dataY = as.numeric(dataY[[1]])
    
    correlation = cor(x = dataX,
                      y = dataY,
                      method = "spearman")
    
    # Création du diagramme de dispersion
    plot(dataX, dataY,
         xlab = input$choix_X, ylab = input$choix_Y,
         main = "régression linéaire")
    # Ajout de la ligne de tendance
    abline(lm(dataY ~ dataX),
           col = "red", lwd = 2)
    
    # Ajout de la légende pour la corrélation de rang de Spearman
    legend("topright", legend = paste("Coefficient de Corrélation =", round(correlation, 3)),
           bty = "n")
  })
  
  #phrase en fonction du coef
  output$RegressionText = renderText({
    
    dataX = select(Logements, input$choix_X)
    dataX = as.numeric(dataX[[1]])
    
    dataY = select(Logements, input$choix_Y)
    dataY = as.numeric(dataY[[1]])
    
    correlation = round(cor(x = dataX,
                            y = dataY,
                            method = "spearman"),3)
    
    lien <- ifelse(correlation > 0.6, "fort",
                   ifelse(correlation > 0.3, "intermédiaire", "faible"))
    
    # Créer le texte final
    paste("Le coefficient de corrélation est de", round(correlation, 3), 
          ", donc on peut dire que le lien est", lien)
    
  })
  
  #-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
}

