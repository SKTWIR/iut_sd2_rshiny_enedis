# iut_sd2_rshiny_enedis

## Projet R Shiny donné par Monsieur Sardelliti

 - Le but de projet est de créer une application R shiny pour permettre de réaliser une étude sur les logement du département de la Lozère (48)

 - Le git contiendra plusieurs éléments :
 - [x] Un rapport d’étude RMarkdown
 - [x] Une documentation technique de l’application
 - [ ] Une documentation fonctionnelle de l’application
 - [ ] Captation vidéo de l’application pour installer l’application en local et présente les fonctionnalités majeures de l’application



 - Ce travail est réalisé en collaboration avec ...

## Ci dessous les fonctionnalités de l'application a avoir :
- [x] KPI sur les logement anciens/neufs
- [x] Filtre sur tout les KPI présents
- [x] Plusieurs onglets
- [x] Images et icônes
- [x] Cartographie
- [x] Bouton pour exporter les graphiques en .png
- [x] Bouton pour exporter les données en .csv
- [x] Choix d'un thème
- [x] Corrélation entre les variables quantitatives de notre choix
- [x] "L'utilisateur peut modéliser une variable X selon une variable Y avec la méthode de REGRESSION LINEAIRE SIMPLE"
- [x] Charte visuelles avec un script CSS
- [ ] Possibilité de rafraichir avec les dernière données présente sur le site du gouvernement
- [ ] Connexion utilisateur (id/mdp)

## Etapes :
- Analyse du jeu de données
- Réfléchir aux statistiques intéressante a afficher
- Comment répartir ces informations sur au minimum 2 onglets de l'application
- Créer chaque code individuellement pour les infos (branchs)
  <details>
  <summary></summary>
  Inclure pour les graphiques un bouton exporter en png / pour les données exporter en csv
  </details>
- NE PAS OUBLIER LA CARTOGRAPHIE
- Tout rassembler
- Rendre propre l'application sur R Shiny
- Faire un sorte que le filtre fonctionne sur toutes les infos
- Tenter un déploiement sur shinyapps.io
- Créer le choix de thème
- Le reste correspond aux dernieres fonctionnalités de l'application.
  
## Autres :
<details>
<summary>Notes quelconques :</summary>
 Pour faire la carte il faut faire une jointure avec le fichier des adresses récupérer ( pour avoir la longitude etc...)
 
 Cartes : des points cliquable pour les logements avec des informations (DPE, consommation, age du bâtiment)
</details>
exemple : https://github.com/slopp/scheduledsnow?tab=readme-ov-file
theme : https://rstudio.github.io/shinythemes/
carte cliquable qui set filter : https://www.r-bloggers.com/2024/06/interactive-map-filter-in-shiny/#google_vignette
