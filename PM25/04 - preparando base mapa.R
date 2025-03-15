# Setup-------------------------------------------------------------------------
library(dplyr)
meses <- c("Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", 
           "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro")
df <- arrow::read_feather("PM2.5/Bases/pm2.5_municipios_0.feather")
shape_muni <- geobr::read_municipality(showProgress = F,
                                       year = 2022)
muni_regiao <- data.frame(code_muni = shape_muni$code_muni,
                          name_region = shape_muni$name_region)
# Preparando base---------------------------------------------------------------
df <- mutate(df,
             data = lubridate::ym(paste(df$Ano, df$Mes)),
             Mes = case_when(Mes == 1 ~ "Janeiro",
                                 Mes == 2 ~ "Fevereiro",
                                 Mes == 3 ~ "Março",
                                 Mes == 4 ~ "Abril",
                                 Mes == 5 ~ "Maio",
                                 Mes == 6 ~ "Junho",
                                 Mes == 7 ~ "Julho",
                                 Mes == 8 ~ "Agosto",
                                 Mes == 9 ~ "Setembro",
                                 Mes == 10 ~ "Outubro",
                                 Mes == 11 ~ "Novembro",
                                 Mes == 12 ~ "Dezembro"),
             Mes = factor(Mes, levels = unique(meses))) |> 
  left_join(muni_regiao, by = "code_muni") |> 
  select(code_muni, NM_MUN, SIGLA_UF, name_region, Ano, Mes, data, Media_PM25)
anyNA(df)
# Salvando----------------------------------------------------------------------
arrow::write_feather(df, "PM2.5/Bases/pm2.5_dashboard.feather")
