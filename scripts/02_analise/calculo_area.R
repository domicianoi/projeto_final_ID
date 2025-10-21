
#calcular a area por classe em ha, sendo que o calculo da area esta multiplicado por 0.1 porque a resolucao do mapbiomas é de 10m, quando a funcao freq retornar quantos pixels existem para cada codigo de classe do mapbiomas, o mutate vai multiplicar por 0.01 para obter a area em ha#

tab2017 <- freq(uso2017) %>%
  as.data.frame() %>%
  mutate(
    area_ha = count * 0.01,
    ano = 2017
  )

tab2020 <- freq(uso2020) %>%
  as.data.frame() %>%
  mutate(
    area_ha = count * 0.01,
    ano = 2020
  )

tab2023 <- freq(uso2023) %>%
  as.data.frame() %>%
  mutate(
    area_ha = count * 0.01,
    ano = 2023
  )

#fazendo uma tabela e combinando todas as outras tabelas, ou seja, criando uma tabela unica#

tabela_uso <- bind_rows(tab2017, tab2020, tab2023)

#aqui eu dei uma legenda para cada valor de uso de classe, de acordo com a propria tabela de legenda do mapbiomas#

legenda_mapbiomas <- tibble::tibble(
  value = c(3, 11, 15, 21, 33, 36),
  classe = c(
    "Formação Florestal",       # 3
    "Campo Alagado e Área Pantanosa",  # 11
    "Pastagem",                 # 15
    "Agricultura",              # 21
    "Mosaico de Usos",          # 33
    "Área Urbana"               # 36
  )
)

#juntando a legenda à tabela de uso#

tabela_uso_legenda <- tabela_uso %>%
  dplyr::left_join(legenda_mapbiomas, by = "value")

#vendo se esta tudo ok#

View(tabela_uso_legenda)

#calculando a mudanca do uso da terra entre 2017-2023

mudanca <- tabela_uso_legenda %>%
  select(ano, classe, area_ha) %>%
  pivot_wider(names_from = ano, values_from = area_ha)

#calculando a variacao entre os anos#

mudanca <- mudanca %>%
  mutate(
    var_17_20_ha = `2020` - `2017`,
    var_20_23_ha = `2023` - `2020`,
    var_17_23_ha = `2023` - `2017`
  )

#vendo a tabela# 

View(mudanca)

#visualizacao de tabela bonita#

#mas antes, é preciso ler esses pacotes para fazer o layout#
library(knitr)
library(kableExtra)

#agora sim#

mudanca %>%
  rename(
    `Classe de uso e cobertura` = classe,
    `Área (ha) 2017` = `2017`,
    `Área (ha) 2020` = `2020`,
    `Área (ha) 2023` = `2023`,
    `Δ 2017–2020 (ha)` = var_17_20_ha,
    `Δ 2020–2023 (ha)` = var_20_23_ha,
    `Δ 2017–2023 (ha)` = var_17_23_ha
  ) %>%
  kable(format = "html", align = "lcccccc", caption = "Mudança no uso e cobertura do solo (2017–2023)") %>%
  kable_styling(
    bootstrap_options = c("striped", "hover", "condensed", "responsive"),
    full_width = FALSE,
    font_size = 13
  ) %>%
  column_spec(1, bold = TRUE) %>%
  row_spec(0, bold = TRUE, background = "#f2f2f2") %>%
  add_header_above(c(" " = 1, "Área (ha)" = 3, "Variação de área (ha)" = 3))

#exportando o arquivo em csv#

write.csv(mudanca, "resultados/tabelas/mudanca_uso_2017_2020_2023.csv", row.names = FALSE)

