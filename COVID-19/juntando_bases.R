# Juntando Bases
# Setup-------------------------------------------------------------------------
library(lubridate)
library(ggplot2)
library(dplyr)
library(reshape2)
library(ggpubr)
library(ggspatial)
#library(maptools)
library(viridis)
library(RColorBrewer)
#devtools::install_github("qspatialR/qspatial", force=TRUE)
#library(qspatial)
library(terra); library(sf)
#devtools::install_github("ipeaGIT/geobr", subdir = "r-package")
library(geobr)
library(lubridate)

# Processamento-----------------------------------------------------------------
##------------------------------------------------------------------------------
"
casos=read.csv('caso_full.csv')
city=casos[casos$place_type=='city',]
rm(casos)

city$Date=ymd(city$date)

ggplot(city,aes(x=Date,y=last_available_confirmed))+
  geom_line()

summary(city$new_confirmed)
summary(city$last_available_confirmed)
"
## 2020-------------------------------------------------------------------------
### Casos 1----
casos1<-read.csv2('COVID-19/base/COVID-19/HIST_PAINEL_COVIDBR_2020_Parte1_13jul2024.csv')
names(casos1)
head(casos1)

table(casos1$coduf)
casos1$Date=ymd(casos1$data)
casos1$Month=month(casos1$Date)
casos1$Year=year(casos1$Date)

table(casos1$Month)
table(casos1$Year)

summary(casos1$casosAcumulado)
summary(casos1$casosNovos)


#casos1=casos1|> 
#  dplyr::group_by(codmun) |> 
#  dplyr::mutate(
#    lag_casos = dplyr::lag(casosAcumulado)
#  )

#casos1$teste=ifelse(casos1$casosNovos<0,1,0)
#table(casos1$teste,casos1$semanaEpi)
casos1$case=ifelse(casos1$casosNovos>=0,casos1$casosNovos,0)

summary(casos1$case)

casos1_agg=casos1%>%group_by(codmun,Month)%>%
  summarise(case2020_1=sum(case,na.rm=T))

### Casos 2----
casos2<-read.csv2("COVID-19/base/COVID-19/HIST_PAINEL_COVIDBR_2020_Parte2_13jul2024.csv")
names(casos2)
head(casos2)

table(casos2$coduf)
casos2$Date=ymd(casos2$data)
casos2$Month=month(casos2$Date)
casos2$Year=year(casos2$Date)

table(casos2$Month)
table(casos2$Year)

casos2$case=ifelse(casos2$casosNovos>=0,casos2$casosNovos,0)

summary(casos2$case)

casos2_agg=casos2%>%group_by(codmun,Month)%>%
  summarise(case2020_1=sum(case,na.rm=T))



### Juntando 2020----
casos2020=rbind(casos1_agg,casos2_agg)
casos2020$Year=2020

table(casos2020$Month)

## 2021-------------------------------------------------------------------------
### Casos 3----
casos3<-read.csv2("COVID-19/base/COVID-19/HIST_PAINEL_COVIDBR_2021_Parte1_13jul2024.csv")
names(casos3)
head(casos3)

table(casos3$coduf)
casos3$Date=ymd(casos3$data)
casos3$Month=month(casos3$Date)
casos3$Year=year(casos3$Date)

table(casos3$Month)
table(casos3$Year)

summary(casos3$casosNovos)

casos3$case=ifelse(casos3$casosNovos>=0,casos3$casosNovos,0)

summary(casos3$case)

casos3_agg=casos3%>%group_by(codmun,Month)%>%
  summarise(case2021=sum(case,na.rm=T))

### Casos 4----
casos4<-read.csv2("COVID-19/base/COVID-19/HIST_PAINEL_COVIDBR_2021_Parte2_13jul2024.csv")
names(casos4)
head(casos4)

table(casos4$coduf)
casos4$Date=ymd(casos4$data)
casos4$Month=month(casos4$Date)
casos4$Year=year(casos4$Date)

table(casos4$Month)
table(casos4$Year)

summary(casos4$casosNovos)

casos4$case=ifelse(casos4$casosNovos>=0,casos4$casosNovos,0)

summary(casos4$case)

casos4_agg=casos4%>%group_by(codmun,Month)%>%
  summarise(case2021=sum(case,na.rm=T))

### Juntando 2021----
casos2021=rbind(casos3_agg,casos4_agg)
casos2021$Year=2021 

table(casos2021$Month)

rm(casos1,casos2,casos3,casos4)

## 2022------------------------------------------------------------------------
### Casos 5----
casos5<-read.csv2("COVID-19/base/COVID-19/HIST_PAINEL_COVIDBR_2022_Parte1_13jul2024.csv")
names(casos5)
head(casos5)

table(casos5$coduf)
casos5$Date=ymd(casos5$data)
casos5$Month=month(casos5$Date)
casos5$Year=year(casos5$Date)

table(casos5$Month)
table(casos5$Year)

summary(casos5$casosNovos)

casos5$case=ifelse(casos5$casosNovos>=0,casos5$casosNovos,0)

summary(casos5$case)

casos5_agg=casos5%>%group_by(codmun,Month)%>%
  summarise(case2022=sum(case,na.rm=T))

### Casos 6----
casos6<-read.csv2("COVID-19/base/COVID-19/HIST_PAINEL_COVIDBR_2022_Parte2_13jul2024.csv")
names(casos6)
head(casos6)

table(casos6$coduf)
casos6$Date=ymd(casos6$data)
casos6$Month=month(casos6$Date)
casos6$Year=year(casos6$Date)

table(casos6$Month)
table(casos6$Year)

summary(casos6$casosNovos)

casos6$case=ifelse(casos6$casosNovos>=0,casos6$casosNovos,0)

summary(casos6$case)

casos6_agg=casos6%>%group_by(codmun,Month)%>%
  summarise(case2022=sum(case,na.rm=T))

### Juntando 2022----
casos2022=rbind(casos5_agg,casos6_agg)
casos2022$Year=2022 

table(casos2022$Month)

rm(casos5,casos6)

## 2023-------------------------------------------------------------------------
### Casos 7----
casos7<-read.csv2("COVID-19/base/COVID-19/HIST_PAINEL_COVIDBR_2023_Parte1_13jul2024.csv")
names(casos7)
head(casos7)

table(casos7$coduf)
casos7$Date=ymd(casos7$data)
casos7$Month=month(casos7$Date)
casos7$Year=year(casos7$Date)

table(casos7$Month)
table(casos7$Year)

summary(casos7$casosNovos)

casos7$case=ifelse(casos7$casosNovos>=0,casos7$casosNovos,0)

summary(casos7$case)

casos7_agg=casos7%>%group_by(codmun,Month)%>%
  summarise(case2023=sum(case,na.rm=T))

### Casos 8----
casos8<-read.csv2("COVID-19/base/COVID-19/HIST_PAINEL_COVIDBR_2023_Parte2_13jul2024.csv")
names(casos8)
head(casos8)

table(casos8$coduf)
casos8$Date=ymd(casos8$data)
casos8$Month=month(casos8$Date)
casos8$Year=year(casos8$Date)

table(casos8$Month)
table(casos8$Year)

summary(casos8$casosNovos)

casos8$case=ifelse(casos8$casosNovos>=0,casos8$casosNovos,0)

summary(casos8$case)

casos8_agg=casos8%>%group_by(codmun,Month)%>%
  summarise(case2023=sum(case,na.rm=T))

### Juntando 2023----
casos2023=rbind(casos7_agg,casos8_agg)
casos2023$Year=2023 

table(casos2023$Month)

rm(casos7,casos8)

## 2024-------------------------------------------------------------------------

### Casos 9----

casos9<-read.csv2("COVID-19/base/COVID-19/HIST_PAINEL_COVIDBR_2024_Parte1_13jul2024.csv")
names(casos9)
head(casos9)

table(casos9$coduf)
casos9$Date=ymd(casos9$data)
casos9$Month=month(casos9$Date)
casos9$Year=year(casos9$Date)

table(casos9$Month)
table(casos9$Year)

summary(casos9$casosNovos)

casos9$case=ifelse(casos9$casosNovos>=0,casos9$casosNovos,0)

summary(casos9$case)

casos9_agg=casos9%>%group_by(codmun,Month)%>%
  summarise(case2024=sum(case,na.rm=T))

### Juntando 2024----
casos2024=casos9_agg
casos2024$Year=2024

table(casos2024$Month)

rm(casos9)

# Base única--------------------------------------------------------------------

## Juntando---------------------------------------------------------------------
colnames(casos2020)=c("codmun", "Month","NewCases","Year")
colnames(casos2021)=c("codmun", "Month","NewCases","Year")
colnames(casos2022)=c("codmun", "Month","NewCases","Year")
colnames(casos2023)=c("codmun", "Month","NewCases","Year")
colnames(casos2024)=c("codmun", "Month","NewCases","Year")

base=rbind(casos2020,casos2021,casos2022, casos2023, casos2024)
base1=base[order(base$codmun),]
base1= filter(base1, !is.na(codmun))


#base2=base[order(base$codmun, base$Month,base$Year),]
base2=base1[order(base1$Year,base1$codmun,base1$Month),]

## Apêndice------------------------------------------------------------------------
# Nome do Município e Região
#base2 <- arrow::read_feather('COVID-19/base/data_month_new_case_covid19_2024.1_2023_2022_2021_2020.feather')
shape_muni <- geobr::read_municipality(showProgress = F,
                                       year = 2020)
code_name_UF <- data.frame(code_muni = shape_muni$code_muni,
                           name_muni = shape_muni$name_muni,
                           UF = shape_muni$abbrev_state,
                           name_region = shape_muni$name_region) |> 
  mutate(code_muni = as.numeric(as.character(substr(code_muni, 1, 6))))
base2 <- base2 |> 
  mutate(data = ym(paste(Year, Month)),
         Month = case_when(Month == 1 ~ "Janeiro",
                           Month == 2 ~ "Fevereiro",
                           Month == 3 ~ "Março",
                           Month == 4 ~ "Abril",
                           Month == 5 ~ "Maio",
                           Month == 6 ~ "Junho",
                           Month == 7 ~ "Julho",
                           Month == 8 ~ "Agosto",
                           Month == 9 ~ "Setembro",
                           Month == 10 ~ "Outubro",
                           Month == 11 ~ "Novembro",
                           Month == 12 ~ "Dezembro"))
base2 <- left_join(base2, code_name_UF, by = c("codmun" = "code_muni")) |> 
  filter(!is.na(name_muni))
base2 <- base2[,c("codmun", "name_muni", "UF", "name_region", "Year", "Month", "data", "NewCases")]
anyNA(base2)
## Salvando---------------------------------------------------------------------
#write.csv(base2,"COVID-19/base/data_month_new_case_covid19_2024.1_2023_2022_2021_2020.csv")
arrow::write_feather(base2, 'COVID-19/base/data_month_new_case_covid19_2024.1_2023_2022_2021_2020.feather')

summary(base2$NewCases)
table(base2$Year)
table(base2$Month)
