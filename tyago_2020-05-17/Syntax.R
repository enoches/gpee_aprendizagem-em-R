# Exercícios do livro ISLR, cap 02, feitos por Tyago ----

## Na encontro 03, de 03-jun-2020, começamos a editar e rodar o código.



# Pacotes utilizados ------------------------------


# install.packages("readxl")

# library(tidyverse)
library(readxl) # ler arquivo excel
library(dplyr)
library(skimr)


# Leitura dos dados --------------------------------


data <- read_xlsx("tyago_2020-05-17/graficos.xlsx")


# Inspeção dos dados

## Primeira olhada: a estrutura do bd 

#dim(data) # mostra somente as dimensões do bd
# str(data) # função do R base que mostra a estrutura do objeto ou bd
glimpse(data) # função do tidyverse/dplyr que mostra a estrutura do objeto ou bd


# Quer fazer uma inspeção visual olhando numa tabela? 
View(data) 

# Sumário do banco de dados
skim(data) 
summary(data) # R base



## Alterações feitas no banco de dados os dados ----------------------

data[is.na(data)] <- 0 


# ATT ------------------------------------------------ 
## Na aula 03 viemos até aqui. Agora precisamos concluir a formatação do código e
## rodar os comandos também



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