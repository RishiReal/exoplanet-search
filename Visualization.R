library(plotly)
library(dplyr)
library(readr)

# Load data
stage1 <- read_csv("/Users/rishi/Documents/GitHub/exoplanet-search/candidates_after_criteria_1.csv")
stage2 <- read_csv("/Users/rishi/Documents/GitHub/exoplanet-search/candidates_after_criteria_2.csv")
stage3 <- read_csv("/Users/rishi/Documents/GitHub/exoplanet-search/candidates_after_criteria_3.csv")
stage4 <- read_csv("/Users/rishi/Documents/GitHub/exoplanet-search/candidates_after_criteria_4.csv")
stage5 <- read_csv("/Users/rishi/Documents/GitHub/exoplanet-search/candidates_after_criteria_5.csv")

# Add a stage label to each dataset
stage1$stage <- "1: Flux"
stage2$stage <- "2: Temperature"
stage3$stage <- "3: Radius"
stage4$stage <- "4: Mass"
stage5$stage <- "5: Spectral Type"

# Combine into one dataset
all_stages <- bind_rows(stage1, stage2, stage3, stage4, stage5)
all_stages <- all_stages %>%
  filter(!is.na(pl_orbsmax), !is.na(pl_eqt), !is.na(pl_insol), !is.na(pl_rade))

# create 3d figure and animation
fig <- plot_ly(
  data = all_stages,
  x = ~pl_orbsmax,
  y = ~pl_eqt,
  z = ~pl_insol,
  frame = ~stage,
  type = 'scatter3d',
  mode = 'markers',
  marker = list(
    size = ~pl_rade * 3,
    color = ~pl_rade,
    colorscale = 'Viridis',
    opacity = 0.8
  )
) %>%
  layout(
    scene = list(
      xaxis = list(title = "Orbital Distance (AU)"),
      yaxis = list(title = "Equilibrium Temp (K)"),
      zaxis = list(title = "Insolation Flux")
    ),
    title = "Filtering Habitable Exoplanets by Criteria"
  )

fig