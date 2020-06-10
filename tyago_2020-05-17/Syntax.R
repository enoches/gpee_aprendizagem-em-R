# Exercícios do livro ISLR, cap 02, feitos por Tyago ----

## Na encontro 03, de 03-jun-2020, começamos a editar e rodar o código.



# Pacotes utilizados ------------------------------


# install.packages("readxl")

# library(tidyverse)
library(readxl) # ler arquivo excel
library(dplyr)
library(skimr)
library(here)
library(ggplot2)

# Leitura dos dados --------------------------------


# data <- read_xlsx("tyago_2020-05-17/graficos.xlsx")

data <- read_xlsx(here("tyago_2020-05-17", "graficos.xlsx"))


# Inspeção dos dados

## Primeira olhada: a estrutura do bd 

# dim(data) # mostra somente as dimensões do bd
# str(data) # função do R base que mostra a estrutura do objeto ou bd
glimpse(data) # função do tidyverse/dplyr que mostra a estrutura do objeto ou bd


# Quer fazer uma inspeção visual olhando numa tabela? 
View(data) 

# Sumário do banco de dados
skim(data) 
summary(data) # R base



## Alterações feitas no banco de dados os dados ----------------------

data[is.na(data)] <- 0 

# OBS: Queremos contar a quantidade de NA

is.na(data$x)
sum(data$x)

# TRUE = 1
# FALSE = 0

# usamos o argumento na.rm = TRUE para não dar erro caso tenha NA na variável x
sum(data$x, na.rm = TRUE) # Essa aqui

# Outro exemplo:
ex <-  c(1:3, NA)
ex

sum(ex, na.rm = TRUE)


## INDICADORES ------------------------------------------------ 

cor(data$y, data$x) 

mean(data$y, na.rm = TRUE)

var(data$y)

sqrt(var(data$y))

sd(data$y)



## GRAFICOS -----------------------------------

hist(data$y, col = "red", main="Custo")

hist(data$y, col = 2, breaks = 15, main = "Custo")

boxplot(data$y, data$x, col = rainbow(2))

boxplot(data$y, main = "Custo")

plot(data$y, data$x, col ="red", main ="Custo")

### ggplot2 -----

ggplot(data, aes(y, x, color = "sexo")) + 
  geom_point(position = position_jitter()) +
  stat_smooth(method = "lm") +
  NULL


ggplot(data = data, aes(x = x, y = y)) + 
  geom_point()


ggplot(subset(data),aes(factor(y),x))+geom_boxplot()

ggplot(data,aes(y,x,color="class"))+geom_point()

data$z<-(cos(data$x)/(1 + data$y^2))

install.packages("plotly")

library(plotly)
plot_ly(data, x = data$x,y = data$y, z = data$z, type="surface")


install.packages("writexl")

library(writexl)
write_xlsx(data,"novo.xlsx",col_names = TRUE)



