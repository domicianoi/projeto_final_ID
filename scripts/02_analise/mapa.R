#exportando mapa em formato raster e vetor#

library(terra)

legenda <- data.frame(
  classe = c(3, 11, 15, 21, 33, 36),        # códigos do MapBiomas
  nome   = c("Formação Florestal", "Campo Alagado e Área Pantanosa", "Pastagem", "Agricultura", "Mosaico de Usos", "Área Urbana"),
  cor    = c("darkgreen", "blue", "grey", "red", "burlywood", "brown")
)

cores <- legenda$cor
names(cores) <- legenda$classe

par(oma = c(0, 0, 4, 0), 
    mar = c(1, 1, 1, 1)) 

layout(matrix(1:4, nrow = 1, ncol = 4),
       widths = c(10, 10, 10, 4))

plot(uso2017, col = cores, main = "2017", axes = FALSE, legend = FALSE)
plot(uso2020, col = cores, main = "2020", axes = FALSE, legend = FALSE)
plot(uso2023, col = cores, main = "2023", axes = FALSE, legend = FALSE)

plot.new()

legend("topleft", 
       legend = legenda$nome,
       fill = legenda$cor,
       border = "black",
       title = "Classes de Uso", 
       bty = "n", 
       cex = 1.0)

mtext("Análise da Cobertura e Uso do Solo (MapBiomas)",
      outer = TRUE,
      cex = 1.5,
      line = 2)

#funções auxiliares para evitar repetição#

exportar_mapa <- function(raster_obj, ano, legenda_df) {
  
  cores_para_coltab <- legenda_df[, c("classe", "cor")]
  names(cores_para_coltab) <- c("value", "col")
  raster_fator <- as.factor(raster_obj)
  coltab(raster_fator) <- cores_para_coltab
  
  nome_raster <- paste0("dados/processed/mapbiomas_", ano, "_raster.tif")
  writeRaster(raster_fator, 
              filename = nome_raster, 
              datatype = "INT1U",
              overwrite = TRUE)
  cat(paste("Raster exportado com sucesso:", nome_raster, "\n"))
  vetor_obj <- as.polygons(raster_obj, 
                           dissolve = TRUE,
                           na.rm = TRUE)
  names(vetor_obj)[1] <- "classe" 
  vetor_obj <- merge(vetor_obj, 
                     legenda_df[, c("classe", "nome")], 
                     by = "classe", 
                     all.x = TRUE)
  nome_vetor <- paste0("dados/processed/mapbiomas_", ano, "_vetor.gpkg")
  writeVector(vetor_obj, 
              filename = nome_vetor, 
              overwrite = TRUE)
  
  cat(paste("Vetor exportado com sucesso:", nome_vetor, "\n"))
}

exportar_mapa(uso2017, 2017, legenda)
exportar_mapa(uso2020, 2020, legenda)
exportar_mapa(uso2023, 2023, legenda)

#exportando em formato png#

png("resultados/figuras/mapa/mapa_uso.png")

par(mfrow = c(1,3), mar = c(1,1,3,1))

plot(uso2017, col = cores, main = "2017", axes = FALSE, legend = FALSE)
plot(uso2020, col = cores, main = "2020", axes = FALSE, legend = FALSE)
plot(uso2023, col = cores, main = "2023", axes = FALSE, legend = FALSE)

mtext("Análise da Cobertura e Uso do Solo (MapBiomas)",
      outer = TRUE,
      cex = 1.5,
      line = 2)

legend("bottomleft", 
       legend = legenda$nome,
       fill = legenda$cor,
       border = "black",
       title = "Classes de Uso", 
       bty = "n", 
       cex = 1,      
       xpd = TRUE)

dev.off()
