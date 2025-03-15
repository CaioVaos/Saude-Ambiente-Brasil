# Modificando Base
# Setup-------------------------------------------------------------------------
library(dplyr)
shape_muni <- geobr::read_municipality(showProgress = F,
                                       year = 2022)
muni_regiao <- data.frame(code_muni = shape_muni$code_muni,
                          name_region = shape_muni$name_region)
#df <- readr::read_csv("bases/All_Brazilian_SRAG_Data_2009A2023.csv")
df <- arrow::read_feather("bases/All_Brazilian_SRAG_Data_2009A2023_0.feather")

# df----------------------------------------------------------------------------

## Colunas identicas----
'
colunas_iguais <- list()
for (i in 1:(ncol(df) - 1)) {
  for (j in (i + 1):ncol(df)) {
    if (isTRUE(all.equal(df[[i]], df[[j]]))) {
      colunas_iguais <- append(colunas_iguais, list(c(names(df)[i], names(df)[j])))
    }
  }
}
colunas_iguais
'
## Processamento----
df <- select(df, -c(...1, cod6, X.1.y, # removendo duplicatas
                    X.1.x, X.x, X.y, ID_MN_RESI)) |> # removendo desnecessarias
  rename(code_muni = cod7,
         UF = UFcod) |> 
  mutate(month = case_when(month == 1 ~ "Janeiro",
                           month == 2 ~ "Fevereiro",
                           month == 3 ~ "Março",
                           month == 4 ~ "Abril",
                           month == 5 ~ "Maio",
                           month == 6 ~ "Junho",
                           month == 7 ~ "Julho",
                           month == 8 ~ "Agosto",
                           month == 9 ~ "Setembro",
                           month == 10 ~ "Outubro",
                           month == 11 ~ "Novembro",
                           month == 12 ~ "Dezembro"),
         UF = case_when(UF == 11 ~ "RO",
                        UF == 12 ~ "AC",
                        UF == 13 ~ "AM",
                        UF == 14 ~ "RR",
                        UF == 15 ~ "PA",
                        UF == 16 ~ "AP",
                        UF == 17 ~ "TO",
                        UF == 21 ~ "MA",
                        UF == 22 ~ "PI",
                        UF == 23 ~ "CE",
                        UF == 24 ~ "RN",
                        UF == 25 ~ "PB",
                        UF == 26 ~ "PE",
                        UF == 27 ~ "AL",
                        UF == 28 ~ "SE",
                        UF == 29 ~ "BA",
                        UF == 31 ~ "MG",
                        UF == 32 ~ "ES",
                        UF == 33 ~ "RJ",
                        UF == 35 ~ "SP",
                        UF == 41 ~ "PR",
                        UF == 42 ~ "SC",
                        UF == 43 ~ "RS",
                        UF == 50 ~ "MS",
                        UF == 51 ~ "MT",
                        UF == 52 ~ "GO",
                        UF == 53 ~ "DF"),
         # Calculando taxa de SARG * 10 mil
         popTotal = total/popTotal * 10000,
         popFemale = totalFemale/popFemale * 10000,
         popMale = totalMale/popMale * 10000,
         pop0A19 = total_1to19years/pop0A19 * 10000,
         pop20A59 = total_20to59years/pop20A59 * 10000,
         pop60plus = total_60moreyears/pop60plus * 10000) |> 
  rename(obs_total = total,
         obs_female = totalFemale,
         obs_male = totalMale,
         obs_1.19 = total_1to19years,
         obs_20.59 = total_20to59years,
         obs_60. = total_60moreyears,
         tx_total = popTotal,
         tx_female = popFemale,
         tx_male = popMale,
         tx_1.19 = pop0A19,
         tx_20.59 = pop20A59,
         tx_60. = pop60plus) |> 
  left_join(muni_regiao, by = "code_muni")
df <- df[, c("code_muni", "Municipio", "UF", "name_region", "year", "month", "Date",
             "obs_total", "obs_female", "obs_male", "obs_1.19", "obs_20.59", 
             "obs_60.", "tx_total", "tx_female", "tx_male", "tx_1.19",
             "tx_20.59","tx_60.")]
df <- df[df$year != 2023, ] # Removendo ano de 2023
df <- filter(df, !is.na(Municipio))
anyNA(df)

## Salvar----
#df <- data.table::setDT(df)
arrow::write_feather(df, 'bases/All_Brazilian_SRAG_Data_2009A2022.feather')

# Shapes------------------------------------------------------------------------

## Carreagar----
shape_muni <- geobr::read_municipality(showProgress = F,
                                       year = 2022) |> 
  st_simplify(dtolerance = 1000)
shape_br <- geobr::read_country(showProgress = F)

## Manipular----
shape_muni <- select(shape_muni, c(code_muni, geom))

## Salvar----
st_write(shape_muni, "bases/shapes.gpkg", layer = "shape_muni")
st_write(shape_br, "bases/shapes.gpkg", layer = "shape_br")
st_layers("bases/shapes.gpkg")

