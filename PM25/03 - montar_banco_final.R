
# Instalar e carregar pacotes necessários/ load or install packages needed
if(!require(dplyr)) install.packages("dplyr")
if(!require(openxlsx)) install.packages("openxlsx")
if(!require(feather)) install.packages("feather")


# Diretório onde os arquivos .xlsx estão salvos/ Directory where .xlsx files are saved
output_dir <- 'C:/Users/.../Downloads/Monthly-selected/Estatistica_zonal'

# Listar todos os arquivos .xlsx no diretório/ List all .xlsx files in directory
file_list <- list.files(output_dir, pattern = "\\.xlsx$", full.names = TRUE)

# Inicializar um dataframe vazio para inserir os dados/ Initialize an empty dataframe to insert data
dados_completos <- data.frame()

# Loop para ler cada arquivo e acumular os dados/ Loop to read each file and accumulate the data 
for (file in file_list) {
  # Ler o arquivo .xlsx/ Read the .xlsx file
  dados <- read.xlsx(file)
  
  # Verificar a estrutura do arquivo/ Check file structure
  print(paste("Processando arquivo:", file))
  
  # Acumular os dados no dataframe final/ Accumulate the data into the final dataframe
  dados_completos <- bind_rows(dados_completos, dados)
}

# Ver a estrutura do banco consolidado no R/ View the consolidated bank structure in R
str(dados_completos)

# Salvar o dataframe consolidado em formato Excel (.xlsx)/ Save the consolidated dataframe in Excel format (.xlsx)
output_xlsx <- 'PM2.5/Bases/pm2.5_municipios_0.feather'
write.xlsx(dados_completos, file = output_xlsx, overwrite = TRUE)

# Salvar o dataframe consolidado em formato feather/ Save the consolidated dataframe in feather format
output_feather <- 'PM2.5/Bases/pm2.5_municipios_0.feather'
write_feather(dados_completos, output_feather)

print("Processo completo: Dados consolidados salvos em Excel e Feather!")
