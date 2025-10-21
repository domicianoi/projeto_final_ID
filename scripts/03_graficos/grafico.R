
library(ggplot2)

#gráfico temporal do uso e cobertura do solo#
mudanca_temporal <- ggplot(
  data = tabela_uso_legenda,
  aes(
    x = factor(ano),
    y = area_ha,
    group = classe,
    color = classe
  )
) +
  geom_line(size = 1.2) +              
  geom_point(size = 3) +                 
  labs(
    x = "Ano",
    y = "Área (ha)",
    color = "Classe de uso do solo",
    title = "Mudança temporal no uso e cobertura do solo (2017–2023)"
  ) +
  theme_minimal(base_size = 13) +       
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    legend.position = "right",
    legend.title = element_text(face = "bold"),
    axis.text.x = element_text(face = "bold")
  ) +
  scale_color_manual(
    values = c(
      "Formação Florestal" = "darkgreen",
      "Campo Alagado e Área Pantanosa" = "blue",
      "Pastagem" = "grey",
      "Agricultura" = "red",
      "Mosaico de Usos" = "burlywood",
      "Área Urbana" = "brown"
    )
  )

ggsave("resultados/figuras/grafico_ggplot/mudanca_temporal.png")
