#install.packages(c("httr", "jsonlite"))
library(httr)
library(jsonlite)
setwd("C:/Users/delli/Desktop/Projet R")

ColAGarderExistants = c('Coût_auxiliaires,Conso_auxiliaires_é_finale,Conso_refroidissement,Coût_refroidissement,Coût_éclairage,Conso_éclairage_é_finale,Année_construction,_geopoint,Identifiant__BAN,N°DPE,Etiquette_DPE,Coordonnée_cartographique_X_(BAN),Coordonnée_cartographique_Y_(BAN),Nom__commune_(BAN),N°_département_(BAN),N°_région_(BAN),Code_postal_(BAN),Code_INSEE_(BAN),Conso_chauffage_dépensier_é_finale,Conso_chauffage_é_finale,Conso_5_usages_par_m²_é_primaire,Conso_5_usages_é_finale,Conso_ECS_é_primaire,Emission_GES_5_usages,Emission_GES_chauffage,Emission_GES_ECS,Emission_GES_5_usages_par_m²,Coût_total_5_usages,Coût_ECS,Coût_chauffage,Surface_habitable_logement,Date_établissement_DPE,Date_fin_validité_DPE,Etiquette_GES,Version_DPE,Type_énergie_n°1,Type_bâtiment,Conso_ECS_é_finale')

adresses_48 = read.csv("adresses_48.csv",header=T,sep= ";",dec=".")
code = unique(adresses_48$code_postal)
code
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
  
  print(content$total)
  
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
print("ccc")

df2 = data.frame()
#RECUPERE LES LOGEMENTS NEUFS
ColAGarderNeufs = c('Coût_auxiliaires,Conso_auxiliaires_é_finale,Conso_refroidissement,Coût_refroidissement,Coût_éclairage,Conso_éclairage_é_finale,_geopoint,Identifiant__BAN,N°DPE,Etiquette_DPE,Coordonnée_cartographique_X_(BAN),Coordonnée_cartographique_Y_(BAN),Nom__commune_(BAN),N°_département_(BAN),N°_région_(BAN),Code_postal_(BAN),Code_INSEE_(BAN),Conso_chauffage_dépensier_é_finale,Conso_chauffage_é_finale,Conso_5_usages_par_m²_é_primaire,Conso_5_usages_é_finale,Conso_ECS_é_primaire,Emission_GES_5_usages,Emission_GES_chauffage,Emission_GES_ECS,Emission_GES_5_usages_par_m²,Coût_total_5_usages,Coût_ECS,Coût_chauffage,Surface_habitable_logement,Date_établissement_DPE,Date_fin_validité_DPE,Etiquette_GES,Version_DPE,Type_énergie_n°1,Type_bâtiment,Conso_ECS_é_finale')

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
  
  print(content$total)
  
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

colnames(df2)
colnames(df)

#Assemblé les 2 df :

Lg = rbind(df,df2)

#Jointure avec adresses

Logements = merge(Lg,adresses_48, by.x ="Identifiant__BAN", by.y = "id")
