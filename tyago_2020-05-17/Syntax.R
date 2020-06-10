# Exercícios do livro ISLR cap 02 feitos por Tyago


# Pacotes utilizados ------------------------------


# install.packages("readxl")
library(readxl) # ler arquivo excel
# library(tidyverse)
library(dplyr)
library(skimr)


# Início ---- 


## Carrega os dados

data <- read_xlsx("tyago_2020-05-17/graficos.xlsx")


## Olha os dados

str(data)

glimpse(data)

View(data)

skim::skim(data) # sumário do banco de dados

summary(data)


glimpse(x = data)
skim(data = data)


magrittr::pipe

data %>% skim() 

# Atalho: %>% Shift + Alt + M


## Modicar os dados? ----

data[is.na(data)] <- 0 

is.na(data$y)




data %>% 
  #select(y) %>% 
  summarise(mean(y))

cor(data$y,data$x)
mean(data$y)
var(data$y)
sqrt(var(data$y))
sd(data$y)
hist(data$y ,col = "red", main="Custo")
hist(data$y ,col = 2, breaks =15, main="Custo")
boxplot(data$y, data$x, col = rainbow(2))
boxplot(data$y, main="Custo")
plot(data$y , data$x, col="red", main="Custo")
summary(data)
install.packages("ggplot2")
library(ggplot2)
ggplot(data, aes(y,x,colour="species_id"))+geom_point(position = position_jitter())+stat_smooth(method = "lm")
ggplot(subset(data),aes(factor(y),x))+geom_boxplot()
ggplot(data,aes(y,x,color="class"))+geom_point()
data$z<-(cos(data$x)/(1 + data$y^2))
install.packages("plotly")
library(plotly)
plot_ly(data,x=x,y=y,z=z, type="surface")
install.packages("writexl")
library(writexl)
write_xlsx(data,"novo.xlsx",col_names = TRUE)