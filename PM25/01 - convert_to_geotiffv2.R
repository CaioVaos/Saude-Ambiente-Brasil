#######################################################
# Baixando:(https://wustl.app.box.com/s/kghklfbhbkpphw0nc3vbo2bcymjbn5kh/folder/273857999553)
#######################################################
# function to convert NetCDF[nc.] to raster [.tif] files based on Lijian Han's script
# available at:(https://wustl.app.box.com/s/9073l0k8go8kehtxd5ok46dmw1q63oav).
# 
# code struture is based on version V5.GL.04 of the dataset, 
# if you work with other versions of the dataset it will be necessary to adapt the function at: code line - 33.
# 
# the code respects the data nomenclature of version V5GL04 (V5GL04.HybridPM25.Global).
# If you work with version V6GL02.02 (V6GL02.02.CNNPM25.Global) the names must be replaced at: code line - 33.

# Instalar e carregar pacotes necessários/ load or install packages needed
if(!require(ncdf4)) install.packages("ncdf4")
if(!require(raster)) install.packages("raster")


# data path
base_path <- 'C:/Users/.../Downloads/Monthly-selected'  # Diretório onde os arquivos NetCDF estão/ Directory where NetCDF files are located
output_dir <- 'C:/Users/.../Downloads/Monthly-selected/Geotiff'  # Diretório onde os GeoTIFFs serão salvos/ Directory where GeoTIFFs will be saved

# Variáveis/ variables
varname <- 'PM25'  # Nome da variável no NetCDF/ Variable name in NetCDF
anos <- 2020     # Defina os anos que você deseja processar/ Set the years you want to process 
meses <- 1:12         # Defina os meses que você deseja processar/ Set the months you want to process Months January to December

# Loop para processar vários anos e meses/ Loop to process multiple years and months
for (ano in anos) {
  for (mes in meses) {
    
    # Início de um novo cálculo/ start new calculation
    print(paste("Start new calculation for:", sprintf("%d-%02d", ano, mes)))
    
    # Definir o caminho do arquivo NetCDF para o ano e mês atual/ set the NetCDF file path for the current year and month
    input_nc <- sprintf("%s/%d/V6GL02.02.0p10.CNNPM25.GL.%d%02d-%d%02d.nc", base_path, ano, ano, mes, ano, mes)
    
    # Verificar se o arquivo NetCDF existe/ Check if NetCDF file exists
    if (file.exists(input_nc)) {
      
      # Abrir o arquivo NetCDF/ Open the NetCDF file
      ncfile <- ncdf4::nc_open(input_nc)
      print(names(ncfile$var))
      
      # Carregar o raster do NetCDF/ Load NetCDF raster
      nc2raster <- raster(input_nc, varname = varname, band = 1)
      nc2raster <- stack(input_nc, varname = varname)
      
      # Definir o caminho de saída para o GeoTIFF/ Set the output path for GeoTIFF
      output <- sprintf("%s/%d%02d.tif", output_dir, ano, mes)
      
      # Salvar o GeoTIFF/ Save GeoTIFF
      writeRaster(nc2raster, output, format = 'GTiff', overwrite = TRUE)
      
      # Fechar o arquivo NetCDF/ Close the NetCDF file
      ncdf4::nc_close(ncfile)
      
      print(paste("Arquivo GeoTIFF salvo:", output))
      
      # Limpar variáveis desnecessárias, mas manter o loop funcionando/ Clear unnecessary variables but keep the loop running
      rm(ncfile, nc2raster)
      
    } else {
      print(paste("Arquivo não encontrado:", input_nc))
    }
    
    # Break para iniciar nova transformação/ Break to start a new transformation
    print(paste("Start new transformation for:", sprintf("%d-%02d", ano, mes)))
  }
  print(paste("Processo completo para todos os meses do ano", ano))
}
