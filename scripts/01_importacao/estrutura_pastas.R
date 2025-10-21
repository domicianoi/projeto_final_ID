dirs <- c(
  "dados/raw", "dados/processed", "scripts/01_importacao", "scripts/02_analise", "scripts/03_graficos", "resultados/figuras/mapa", "resultados/figuras/grafico_ggplot", "resultados/tabelas"
  )
for (d in dirs) if (!dir.exists(d)) dir.create (d, recursive = TRUE, showWarnings = FALSE)
