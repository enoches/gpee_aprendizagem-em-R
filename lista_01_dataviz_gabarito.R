# Exercícios de data visualization com ggplot2; Lista 01
# Nome: 
# Data: 



# Você vai fazer seguir as instruções abaixo, escrever os comandos neste script e devolvê-lo na plataforma do Google Classroom antes da aula nº 06 



# Carregar os pacotes -----------------------------------------------

library(ggplot2) # Create Elegant Data Visualisations Using the Grammar of Graphics
library(dplyr) # A Grammar of Data Manipulation
library(nycflights13) # Flights that Departed NYC in 2013



# DADOS: VOOS SAÍDOS DE NYC EM 2013 - nycflights13 -----------------

# Rode os comandos abaixo. Ao fazê-lo você vai obter 4 bancos 
# de dados: 2 originados do banco `flights` e 2 do bd `weather`:


data("flights")
alaska_flights <- flights %>% 
  filter(carrier == "AS")

flights_II <- flights %>% 
  filter(carrier %in% c("AS", "F9"))

data("weather")
early_january_weather <- weather %>% 
  filter(origin == "EWR" & month == 1 & day <= 15)

late_january_weather <- weather %>% 
  filter(origin %in% c("EWR", "JFK") & month == 1 & day > 15)


# Os bancos de dados recém criados são: 

# * alaska_flights = atrasos nas partidas e chegadas dos voos da
# companhia Alaska Airlines

# * flights_II = atrasos nas partidas e chegadas dos voos das
# companhias Alaska Airlines (AA) e Frontier Airlines (F9)

# * early_january_weather = condições climáticas no aeroporto EWR
# durante a PRIMEIRA quinzena de janeiro

# * late_january_weather = condições climáticas noS aeroportoS
# EWR e JFK durante a SEGUNDA quinzena de janeiro





# ATIVIDADES -------------------------------------------------



### 01 ----
# Bd alaska_flights: Replique o gráfico de dispersão feito na
# aula 05. O que o gráfico mostra?  Em seguida adicione uma
# terceira estética  (ex: cor ou tamanho) ao gráfico mapeando a
# outra variável

# > RESP:

# Gráfico original
ggplot(data = alaska_flights, mapping = aes(x = dep_delay, y = arr_delay)) +
  geom_point()

# Adicionando outra estética: ex: mês
ggplot(data = alaska_flights,
  mapping = aes(x = dep_delay, y = arr_delay, colour = month)) +
  geom_point()

# Para esta visualização fazer sentido, o meses precisam ser lidos fatores:
ggplot(data = alaska_flights, mapping = aes(x = dep_delay, y = arr_delay, colour = factor(month))) +
  geom_point()




### 02 ---- 
# Bd flights_II: Replique o gráfico de dispersão feito na
# aula 05, desta vez mapeando a variável `carrier` à estética de
# cor. No mesmo gráfico, aplique transparência nos pontos, e veja
# se melhora a visualização. 


# Resposta:
ggplot(
  data = flights_II,
  mapping = aes(
    x = dep_delay,
    y = arr_delay,
    colour = carrier
  )
) +
  geom_point(alpha = 0.5)


#### 03 ---- 
# Bd early_january_weather: Replique o gráfico de linha
# feito na aula 05. Em seguida acrescente a marcação dos pontos
# (cada par ordenado de `time_hour` e `temp`). 

# Resposta
ggplot(data = early_january_weather, 
  mapping = aes(x = time_hour, y = temp)) +
  geom_line() + 
  geom_point()


# Incluindo um frufru: 
ggplot(data = early_january_weather, 
  mapping = aes(x = time_hour, y = temp)) +
  geom_line() + 
  geom_point(aes(color = temp))


### 04 ---- 
# Bd late_january_weather: Começe fazendo um gráfico de
# linha como o da questão anterior. Porém, o banco de dados deste
# exercício possui informações para dois aeroportos (variável 
# `origin`). Diante disso, utilize uma FACETA para obter um
# gráfico de linha para cada um dos aeroportos.


#Resposta:
ggplot(data = late_january_weather, 
  mapping = aes(x = time_hour, y = temp)) +
  geom_line() + 
  facet_wrap(~ origin)