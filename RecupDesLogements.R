#install.packages(c("httr", "jsonlite"))
library(httr)
library(jsonlite)

ColAGarder = c('N°DPE,Etiquette_DPE')

adresses_48 = read.csv("adresses_48.csv",header=T,sep= ";",dec=".")
code = unique(adresses_48$code_postal)
code
annee = seq(2021,2024,1)

base_url <- "https://data.ademe.fr/data-fair/api/v1/datasets/dpe-v2-logements-existants/lines"


df = data.frame()

for (i in code[1:1]) {
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
      size = 50,
      q = i,
      q_fields = "Code_postal_(BAN)",
      select = ColAGarder
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
    select = ColAGarder
     ) 
    
    
    url_encoded <- modify_url(base_url, query = params)
    response <- GET(url_encoded)
    content = fromJSON(rawToChar(response$content), flatten = FALSE)
    
    df = rbind(df,content$result)}
}
  }
