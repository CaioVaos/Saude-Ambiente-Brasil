
# Instalar e carregar pacotes necessários/ load or install packages needed
if(!require(terra)) install.packages("terra")
if(!require(rgdal)) install.packages("rgdal")
if(!require(dplyr)) install.packages("dplyr")
if(!require(openxlsx)) install.packages("openxlsx")
library(geobr)

# Caminhos e variáveis gerais/ General paths and variables
shapefile_municipios <- read_municipality(showProgress = F,
                                          year = 2022) |>
  select(code_muni, name_muni, code_state, abbrev_state, geom)
output_dir <- 'C:/Users/.../Downloads/Monthly-selected/Estatistica_zonal'
base_path <- "C:/Users/.../Downloads/Monthly-selected/Geotiff"

# Função personalizada para calcular as estatísticas/ Custom function to calculate statistics
estatisticas_fun <- function(values) {
  c(count = length(values),
    mean = mean(values, na.rm = TRUE),
    sd = sd(values, na.rm = TRUE),
    min = min(values, na.rm = TRUE),
    max = max(values, na.rm = TRUE))
}

# Abrir o shapefile dos municípios/ Open the municipalities shapefile
municipios <- vect(shapefile_municipios)
anos <- 2000:2022  # Defina os anos que você deseja processar/ Set the years you want to process 
meses <- 1:12      # Meses de janeiro a dezembro/ Set the months you want to process Months January to December

# Loop para calcular estatísticas zonais para vários anos e meses/ Loop to process multiple years and months

for (ano in anos) {
  for (mes in meses) {
    # Formatar os nomes dos arquivos no padrão YYYYMM.tif (sem o prefixo original)/ Format file names in the YYYYMM.tif pattern (without the original prefix)
    file_name <- sprintf("%s/%d%02d.tif", base_path, ano, mes)
    output_tif <- file_name
    
    # Verificar se o arquivo existe/ Check if file exists
    if (file.exists(output_tif)) {
      print(paste("Processando:", file_name))
      
      # Abrir o GeoTIFF do mês/ano atual/ Open the GeoTIFF of the current month/year
      raster_tif <- rast(output_tif)
      
      # Verificar o CRS do raster e do shapefile/ Check CRS of raster and shapefile
      crs_raster <- crs(raster_tif)
      crs_municipios <- crs(municipios)
      
      # Transformar o CRS do shapefile para o CRS do raster, se necessário/ Transform the shapefile CRS to the raster CRS if necessary
      if (!identical(crs_raster, crs_municipios)) {
        municipios <- terra::project(municipios, crs_raster)  # Reprojetar se necessário/ Redesign CRS if necessary
      }
      
      # Aplicar a função personalizada para extrair estatísticas zonais/ Apply custom function to extract zonal statistics
      estatisticas_zonais <- extract(raster_tif, municipios, fun = estatisticas_fun)
      
      # Adicionar as informações dos municípios à tabela de resultados/ Add municipality information to the results table 
      municipios_info <- as.data.frame(municipios)
      estatisticas_zonais_completo <- cbind(municipios_info, estatisticas_zonais)
      
      # Adicionar colunas de ano e mês/ Add year and month columns
      estatisticas_zonais_completo$Ano <- ano
      estatisticas_zonais_completo$Mes <- mes
      
      # Definir novos nomes de colunas mais descritivos/ Define new, more descriptive column names
      colnames(estatisticas_zonais_completo) <- c("code_muni", "NM_MUN", "SIGLA_UF", "AREA_KM2", 
                                                  "ID", "Mun.Celulas", "Media_PM25", "Desvio_Padrao_PM25", 
                                                  "Min_PM25", "Max_PM25", "Ano", "Mes")
      
      # Nome do arquivo de saída no formato YYYY.MM/ Output file name in YYYY.MM format
      output_xlsx <- sprintf("%s/%d.%02d.xlsx", output_dir, ano, mes)
      
      # Salvar o resultado em um arquivo Excel/ Save the result to an Excel file
      write.xlsx(estatisticas_zonais_completo, file = output_xlsx, overwrite = TRUE)
      
      print(paste("Arquivo salvo:", output_xlsx))
      
      # Limpar memória/ clean memmory
      gc()  # Garbage Collection para liberar memória
    } else {
      print(paste("Arquivo não encontrado:", file_name))
    }
  }
}

print("Processo completo para todos os meses e anos!")
