MChauf = mean(Logements$Conso_chauffage_é_finale[Logements$Conso_chauffage_é_finale>0])
MEclair = mean(Logements$Conso_éclairage_é_finale[Logements$Conso_éclairage_é_finale>0])
MECS = mean(Logements$Conso_ECS_é_finale[Logements$Conso_ECS_é_finale>0])
MRefroid = mean(Logements$Conso_refroidissement_é_finale[Logements$Conso_refroidissement_é_finale>0])
MAux = mean(Logements$Conso_auxiliaires_é_finale[Logements$Conso_auxiliaires_é_finale>0])
MTotal = mean(Logements$Conso_5_usages_é_finale[Logements$Conso_5_usages_é_finale>0])

install.packages("ggplot2")
install.packages("plotly")
# Load necessary libraries
library(ggplot2)
library(plotly)

# Create test data
data <- data.frame(
  category = c("Chauffage", "Eclairage", "ECS", "Refroidissemnt", "Auxilliaire"),
  count = c(MChauf, MEclair, MECS, MRefroid, MAux)
)

# Compute percentages
data$fraction <- data$count / MTotal
data$percentage <- round(data$fraction * 100, 1)

# Create an interactive pie chart
p_interactive <- plot_ly(data, labels = ~category, values = ~count, type = 'pie', 
                         textinfo = 'label+percent', hoverinfo = 'label+percent+value',
                        marker = list(colors = c('#FF9999', '#66B2FF', '#99FF99', '#FFCC99', '#FF66B2')),
                        hole = 0.4) %>%  # Create a hole to make it a donut
  layout(title = "Répartition des consommations énergétiques", showlegend = FALSE)

# Display the interactive plot
p_interactive