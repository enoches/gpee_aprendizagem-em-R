# Encontro 05 - Aprendizagem em R ----
# 2020-jun-17, Enoch Filho
# Atualizado em 2020-06-24


# Hoje vamos entrar no mundo das visualizações! Usaremos como base o capítulo 02
# do ModerDive.


# Carregar os pacotes -----------------------------------------------------

library(ggplot2) # Create Elegant Data Visualisations Using the Grammar of Graphics
library(dplyr) # A Grammar of Data Manipulation
library(nycflights13) # Flights that Departed NYC in 2013



# DADOS: VOOS SAÍDOS DE NYC EM 2013 ---------------------------------------

# O banco de dados `flights` está dentro do pacote `nycflights13`
data("flights")

# Antes de sair abrindo o bd (bando de dados) vale a pena dar uma olhada na 
# documentação, codebook, whatever
?flights 

# Em seguida vamos olhar a estrutura do bd. Variáveis, o tipo de cada uma delas
# (numérica, caractere, etc)

glimpse(flights)

View(flights)


# SINTAXE BÁSICA DO GGPLOT2 ------------------------------------------------

# dados
# mapeamento das variáveis (a estética!)
# geometria

# as variáveis são mapeadas para atributos estéticos (valor/nível, tamanho, 
# cor, ...) e em seguida representadas por geometrias/ objetos geométricos 
# (pontos, linhas, barras)


ggplot() + 
  geom_point()


ggplot(data = meus_dados, 
       mapping = aes(x = var1, y = var2), 
       color = red
       ) +
  geom_point()
  

# Não é necessário escrever o nome dos argumentos `data` = e `mapping =` . 
# É comum escrever:

ggplot(meus_dados, aes(x = var1, y = var2)) +
  geom_point()


# argumentos podem ser colocados dentro dos geoms. Para gráficos mais elaborados
# pode fazer diferença deixar na função ggplot() ou na geom_*()

ggplot() +
  geom_point(meus_dados, aes(x = var1, y = var2))


# Os dados podem ser levados para o gráfico usando o usando pipe: 

meus_dados %>% 

ggplot(aes(x = var1, y = var2)) +
  geom_point()



# OS CINCO PRINCIPAIS ------------------------------------------------------


## GRÁFICO DE DISPERSÃO ----------------------------------------------------

#Specifically, we will visualize the relationship between the following two numerical variables in the flights data frame included in the nycflights13 package:
  
#  dep_delay: departure delay on the horizontal “x” axis and
#  arr_delay: arrival delay on the vertical “y” axis

# Veja que iremos construir um banco de dados derivado primeiro:
alaska_flights <- flights %>% 
  filter(carrier == "AS")


ggplot(data = alaska_flights, 
       mapping = aes(x = dep_delay, y = arr_delay)) +
  geom_point(alpha = 0.7)



# (LC2.1) Take a look at both the flights and alaska_flights data frames by running View(flights) and View(alaska_flights). In what respect do these data frames differ? For example, think about the number of rows in each dataset.

ggplot(data = alaska_flights, mapping = aes(x = dep_delay, y = arr_delay)) + 
  geom_point()

# Versus
ggplot(data = flights, mapping = aes(x = dep_delay, y = arr_delay)) + 
  geom_point()


# Quantos carriers diferentes existem no banco?

unique(flights$carrier)

flights %>% filter(carrier) %>% distinct() # pq não deu certo?

flights %>% distinct(carrier) # ok

# Quantas carriers diferentes existem?

flights %>% distinct(carrier) %>% count()

# Outras combinações usando distinct (dica de Fábio)
origensDestinos <- flights %>% distinct(origin, dest)
origensDestinos2 <- flights %>% distinct(carrier, origin, dest)

                                     
# (LC2.2) What are some practical reasons why dep_delay and arr_delay have a positive relationship?
#   
# (LC2.3) What variables in the weather data frame would you expect to have a negative correlation (i.e., a negative relationship) with dep_delay? Why? Remember that we are focusing on numerical variables here. Hint: Explore the weather dataset by using the View() function.
# 
# (LC2.4) Why do you believe there is a cluster of points near (0, 0)? What does (0, 0) correspond to in terms of the Alaska Air flights?
#   
# (LC2.5) What are some other features of the plot that stand out to you?
#   
# (LC2.6) Create a new scatterplot using different variables in the alaska_flights data frame by modifying the example given.



# jitter
# alpha, color, size



## GRÁFICO DE LINHA --------------------------------------------------------

# Agora será usado o bd do clima em nyc: nycflights13::weather

data("weather")

glimpse(weather)

# E da mesma forma, criou-se um sub-bd:
early_january_weather <- weather %>% 
  filter(origin == "EWR" & month == 1 & day <= 15)

# (LC2.9) Take a look at both the weather and early_january_weather data frames by running View(weather) and View(early_january_weather). In what respect do these data frames differ?

# (LC2.10) View() the flights data frame again. Why does the time_hour variable uniquely identify the hour of the measurement, whereas the hour variable does not?

early_january_weather %>% select(time_hour, hour) %>% View()


ggplot(data = early_january_weather, 
  mapping = aes(x = time_hour, y = temp)) +
  geom_line() 





## HISTOGRAMA --------------------------------------------------------------

# Continuando com o mesmo bd de clima:

ggplot(data = weather, mapping = aes(x = temp)) +
  geom_histogram()

ggplot(data = weather, mapping = aes(x = temp)) +
  geom_histogram(color = "white")

ggplot(data = weather, mapping = aes(x = temp)) +
  geom_histogram(color = "white", 
                 fill = "steelblue", 
                 bins = 50)


ggplot(data = weather, mapping = aes(x = temp)) +
  geom_histogram(color = "white", 
                 fill = "steelblue", 
                 binwidth = 20)

min(weather$temp, na.rm = TRUE)
max(weather$temp, na.rm = TRUE)



## BOXPLOT -----------------------------------------------------------------


ggplot(data = weather, mapping = aes(x = month, y = temp)) +
  geom_boxplot()


ggplot(data = weather, mapping = aes(x = factor(month), y = temp)) +
  geom_boxplot()

# Dica: o pacote forcats permite que se manipule os fatores


## GRÁFICO DE BARRAS -------------------------------------------------------


fruits <- tibble(
  fruit = c("apple", "apple", "orange", "apple", "orange")
)

fruits_counted <- tibble(
  fruit = c("apple", "orange"),
  number = c(3, 2)
)




# There are two types of bar charts: geom_bar() and geom_col(). 
# 
# geom_bar() makes the height of the bar proportional to the number of cases in each group (or if the weight aesthetic is supplied, the sum of the weights). 
# 
# If you want the heights of the bars to represent values in the data, use geom_col() instead. 
# 
# geom_bar() uses stat_count() by default: it counts the number of cases at each x position. 
# 
# geom_col() uses stat_identity(): it leaves the data as is.
# 


ggplot(data = fruits, mapping = aes(x = fruit, fill = fruit)) +
  geom_bar() 

ggplot(data = fruits, mapping = aes(x = fruit, fill = fruit)) +
  geom_bar()

ggplot(data = fruits_counted, mapping = aes(x = fruit, y = number)) +
  geom_col()

ggplot(data = fruits_counted, mapping = aes(x = fruit, y = number)) +
  geom_bar(stat = "identity")

ggplot(data = fruits, mapping = aes(x = fruit)) +
  geom_col()

# Is not pre-counted in your data frame, we use geom_bar().

# Is pre-counted in your data frame, we use geom_col() with the y-position aesthetic mapped to the variable that has the counts.


nycflights13::flights 

ggplot(data = flights, mapping = aes(x = carrier)) +
  geom_bar() 