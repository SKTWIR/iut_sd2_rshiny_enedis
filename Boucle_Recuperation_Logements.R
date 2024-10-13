# Ce code contient uniquement la boucle pour récupéré un dataframe des logements sur le site ADEME
# Il y a 2 façon de récupéré les adresses, soit avec un fichier local, soit avec urlfile en ligne.

#Recup adresse en local :
  #setwd("votre chemin d'accès")
  #adresses_48 = read.csv("adresses_48",header=T,sep= ";",dec=".")
  #code = unique(adresses_48$code_postal)

#recupère le fichier des adresses (48) EN LIGNE :
urlfile="https://raw.githubusercontent.com/SKTWIR/iut_sd2_rshiny_enedis/refs/heads/main/adresses_48.csv"
adresses_48 = read.csv(url(urlfile),header=T,sep= ";",dec=".")
code = unique(adresses_48$code_postal)

#variable annee afin de pouvoir effectuer une boucle si il y a trop de ligne
annee = seq(2021,2024,1)

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