install.packages(c("httr", "jsonlite"))

library(httr)
library(jsonlite)

base_url <- "https://data.ademe.fr/data-fair/api/v1/datasets/dpe-v2-logements-existants/lines"
# Paramètres de la requête
params <- list(
  page = 1,
  size = 5,
  select = "N°DPE,Code_postal_(BAN),Etiquette_DPE,Date_réception_DPE", #séléctions des champs 
  q = "69008", #filtrer le tout
  q_fields = "Code_postal_(BAN)", #sert a entrer les champs de filtre
  qs = "Date_réception_DPE:[2023-06-29 TO 2023-08-30]" #filtrage + précis avec colonnes + argument
) 

# Encodage des paramètres
url_encoded <- modify_url(base_url, query = params)
print(url_encoded)

# Effectuer la requête
response <- GET(url_encoded)

# Afficher le statut de la réponse
print(status_code(response))

# On convertit le contenu brut (octets) en une chaîne de caractères (texte). Cela permet de transformer les données reçues de l'API, qui sont généralement au format JSON, en une chaîne lisible par R
content = fromJSON(rawToChar(response$content), flatten = FALSE)

# Afficher le nombre total de ligne dans la base de données
print(content$total)

# Afficher les données récupérées
df <- content$result
dim(df)
View(df)





#1 - Effectuer une requête GET en récupérant les données de la page 1 avec 20 résultats et en sélectionnant les colonnes N°DPE, Etiquette_DPE et Date_réception_DPE et en filtrant par Etiquette_DPE égale à E, F ou G.

base_url <- "https://data.ademe.fr/data-fair/api/v1/datasets/dpe-v2-logements-existants/lines"
# Paramètres de la requête
params <- list(
  page = 1,
  size = 20,
  select = "N°DPE,Etiquette_DPE,Date_réception_DPE", #séléctions des champs 
  q = "E,F,G", #filtrer le tout
  q_fields = "Etiquette_DPE", #sert a entrer les champs de filtre
  qs = "" #filtrage + précis avec colonnes + argument
) 

# Encodage des paramètres
url_encoded <- modify_url(base_url, query = params)
print(url_encoded)

# Effectuer la requête
response <- GET(url_encoded)

# Afficher le statut de la réponse
print(status_code(response))

# On convertit le contenu brut (octets) en une chaîne de caractères (texte). Cela permet de transformer les données reçues de l'API, qui sont généralement au format JSON, en une chaîne lisible par R
content = fromJSON(rawToChar(response$content), flatten = FALSE)

# Afficher le nombre total de ligne dans la base de données
print(content$total)

# Afficher les données récupérées
df <- content$result
dim(df)
View(df)


#Effectuer une requête GET en récupérant les données de la page 1 avec 5 résultats et en sélectionnant les colonnes N°DPE, Etiquette_DPE et Date_réception_DPE et en filtrant par Date_réception_DPE après le 2024-07-31


