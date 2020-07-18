# AULA de Fábio Fernandes, 08-jul-2020



# Pacotes -------------------------------------------------------

library(tidyverse)
library(skimr)
library(ggplot2)
library(lubridate)
library(nycflights13)
library(plotly)
library(broom)


rm(list = ls()) 




# ANÁLISE EXPLORATÓRIA DOS DADOS --------------------------------


# Inspeciona dados do pacote nycflights13----
View(airlines)
skim(flights)
skim(weather)




# Agrupa os voos por mês, calcula o número de voos por mês, resultando em 1 linha por grupo

voosMensais <- flights %>%
  group_by(month) %>%
  summarise(numVoos = n())

ggplot(voosMensais, aes(x = month, y = numVoos)) +
  geom_line()


# Agrupa os voos por mês e por empresa, calcula o número de voos por mês, resultando em 1 linha por grupo

voosMensaisPorEmpresa <- flights %>%
  group_by(carrier, month) %>%
  summarise(numVoos = n())

ggplot(voosMensaisPorEmpresa, aes(x = month, y = numVoos, color = carrier)) +
  geom_line()


# Joins ----
# Realiza a juncao com a base de nomes de empresas

voosMensaisPorEmpresa <- voosMensaisPorEmpresa %>% 
  left_join(airlines, by = "carrier")

ggplot(voosMensaisPorEmpresa, aes(x = month, y = numVoos, color = name)) +
  geom_line()


# Teste da função de junção - Olhar os resultados para entender o efeito.

# Juncao sem especificar as variaveis - A funcao assume que todas as variaveis de mesmo nome são consideradas, mostra mensagem

voosMensaisPorEmpresa <- voosMensaisPorEmpresa %>% left_join(airlines)

# O que aconteceu aqui? - Erro
voosMensaisPorEmpresa <- voosMensaisPorEmpresa %>% left_join(airlines, by = "carrier")


# Cria a variável Data a partir de ano, mes e dia
voos <- flights %>% mutate(Data = as.Date(ISOdate(year, month, day)))

# @AQUI dep_delay_mean ----
# Agrupa os voos por data e aeroporto de origem, e calcula o número de voos e o atraso médio de partida para o dia
voosDiariosEAtrasos <- voos %>%
  group_by(Data, origin) %>%
  summarise(dep_delay = mean(dep_delay, na.rm = T), departures = n()) 

# Gráfico de atrasos por número de voos no dia para os 3 aeroportos da base
ggplot(voosDiariosEAtrasos, aes(x = departures, y = dep_delay, color = origin)) +
  geom_point() +
  facet_wrap(~origin, nrow = 3) +
  geom_smooth(method = "lm", formula = y ~ x)



# Criacao de uma função - recebe os vetores x e y,  realiza a regressão e retorna a tabela de coeficientes como um tibble
# Em R, uma função é gravada em uma variável como outra qualquer
coefsRegressao <- function(y, x) {
  regressao <- lm(y ~ x)
  resumoDaRegressao <- summary(regressao)
  M <- resumoDaRegressao$coefficients
  return(as_tibble(cbind(Variavel = rownames(M), M)))
}


# Agrupa os dados de voos diarios e atrasos por aeroporto e realiza a regressao dos valores por aeroporto,
voosDiariosEAtrasosRegressao <- voosDiariosEAtrasos %>%
  group_by(origin) %>%
  summarise(coefsRegressao(dep_delay, departures))

# Agrupa voos por hora e por aeroporto, e conta o número de voos em cada hora
voosPorHoraEAtrasos <- voos %>%
  group_by(time_hour, origin) %>%
  summarise(dep_delay = mean(dep_delay, na.rm = T), departures = n())

# gráfico do atraso em função do número de voos em cada hora
ggplot(voosPorHoraEAtrasos, aes(x = departures, y = dep_delay, color = origin)) +
  geom_point() +
  facet_wrap(~origin, nrow = 3) +
  geom_smooth(method = "lm", formula = y ~ x)


# guarda os coeficientes de regressão atraso por voos na hora
voosPorHoraEAtrasosRegressao <- voosPorHoraEAtrasos %>%
  group_by(origin) %>%
  summarise(coefsRegressao(dep_delay, departures))

# juncao da informação de voos e meteorologia. Liga cada voo aos dados meteorlogicos de sua hora de partida

# Rodar e verificar o resultado para perceber o problema de não ter incluido todas as variáveis relevantes
juncaoErrada <- left_join(voos, weather, by = c("origin", "time_hour"))

colnames(juncaoErrada) # Esta função retorna o vetor de nomes das colunas da data frame. Ajuda a ver o problema
colnames(juncaoErrada)[1]

# Também serve para renomear as colunas: (exemplos do que ela faz, a função rename do dplyr é bem mais adequada para isso)
colnames(juncaoErrada)[1] <- "Ano"
colnames(juncaoErrada)

colnames(juncaoErrada)[colnames(juncaoErrada) == "Ano"] <- "year.x"
colnames(juncaoErrada)

# Incusive múltiplas colunas de vez  - pode vir a ser útil
colnames(juncaoErrada) <- paste0("V", 1:ncol(juncaoErrada))
View(juncaoErrada)

# As funcoes paste e paste0 fazem concatenacao de strings e vetores de strings
# a diferenca entre as duas é que paste adiciona o separador entre as strings
teste <- paste0("Isto é ", "um teste")
print(teste)

teste <- paste0("Isto é ", c("um teste", "uma maneira de confundir a cabeça das pessoas"))
print(teste)

teste <- paste0(c("Isto é ", "Isto não é "), c("um teste", "uma maneira de confundir a cabeça das pessoas"))
print(teste)

teste <- paste0(" Teste ", 1:10)
print(teste)

teste <- paste("Teste", 1:10) # note a inclusão do espaço como separador
print(teste)

teste <- paste("Teste", 1:10, sep = " - ") # separador determinado na chamada
print(teste)

teste <- paste0(" Teste ", 1:10, collapse = ",") # collapse junta todos os strngs em um só, com a string definida em collapse entre eles
print(teste)

teste <- paste(" Teste", 1:10, collapse = ",", sep = " - ")
print(teste)


rm(juncaoErrada) # remove a variável não utilizada - poupa memória



# Outro erro - este ainda mais grave. O que ocorreu aqui?
juncaoErrada2 <- left_join(voos, weather, by = c("year", "month", "day", "hour", "time_hour"))

rm(juncaoErrada2)



# Juncao correta
voos <- left_join(voos, weather, by = c("year", "month", "day", "hour", "origin", "time_hour"))



# juncao da base de voos com a base de avioes - Notar as variaveis year no resultado
teste <- left_join(voos, planes, by = "tailnum")
rm(teste)

# Outro erro de juncao - Qual o problema desta juncao?
juncaoErrada3 <- left_join(voos, planes)
rm(juncaoErrada3)


# Força o R a  devolver memória de variáveis removidas. O R faz isso automaticamente na maior parte das vezes.
# Às vezes é bom quando se remove uma base muito grande, só para se assegurar que o tratamento da memória está send feito corretamente
gc()

# Solução
voos <- left_join(voos, planes %>% rename(yearPlane = year), by = "tailnum")


# Na base voos, acrescenta  as colunas : departuresPerDay , precipDay e departuresPerHour
# Note o uso de group_by seguido de mutate.
# Ao contrario do summarise, ele não utiliza uma função que resume cada grupo a um valor (ou um conjunto pequeno de valors)
# Em vez disso, retorna um valor para cada linha. O agrupamento faz com que o calculado dentro da função mutate
# leve em conta apenas as linhas da tabela contidas em cada grupo

# A funcao ungroup() desfaz o agrupamento, permitindo que linhas de código subsequentes tratem a tabela de maneira não agrupada
# O summarize já realiza o ungroup, mas não o mutate ou o filter
voos <- voos %>%
  group_by(Data, origin) %>%
  mutate(departuresPerDay = n(), precipDay = sum(precip, na.rm = T)) %>%
  ungroup() %>%
  group_by(time_hour, origin) %>%
  mutate(departuresPerHour = n()) %>%
  ungroup()


# Sem o group_by,  o que acontece com os valores de departuresPerDay , precipDay ?
voosErroDeAgrupamento <- voos %>%
  mutate(departuresPerDay = n(), precipDay = sum(precip, na.rm = T)) %>%
  group_by(time_hour, origin) %>%
  mutate(departuresPerHour = n()) %>%
  ungroup()


# A variável precipDay2 é a precipDay categorizada por faixas de valores de precipitação diária
# Note o uso da funcao cut, que requer a definicao do vetor breaks, com os limites de cada faixa
# Note também que utilizei  a funcao quantiles para gerar os limites das faixas
# Fiz tudo em uma linha para mostrar que é possível fazer isso em R
voos <- voos %>% mutate(precipDay2 = cut(precipDay, breaks = c(0, quantile(precipDay, c(.75, .8, .9, .95, 1), na.rm = T)), include.lowest = T))

# Boxplot para cada faixa de precipitação por dia e atraso
ggplot(voos, aes(x = precipDay2, y = dep_delay)) +
  geom_boxplot() +
  coord_cartesian(ylim = c(-10, 50))


# Scatterplot com regressão - gráfico lento pq tem um ponto por voo
ggplot(voos, aes(x = precip, y = dep_delay, color = origin)) +
  geom_point() +
  facet_wrap(~origin, nrow = 3) +
  geom_smooth(method = "lm", formula = y ~ x)


# Scatterplot com regressão - gráfico lento pq tem um ponto por voo
ggplot(voos, aes(x = seats, y = dep_delay)) +
  geom_point() +
  facet_wrap(~origin, nrow = 3) +
  geom_smooth(method = "lm", formula = y ~ x)




# Regressão de variáveis relevantes para uma análise do atraso de partida dos voos
# A funcao I() permite que a expressão não seja convertida em símbolos da regressão. Assim, criamos as dummies:
# velocidade de vento maior que 14.96014
# temperatura menor que 32F (0 grau C)

# A função factor transforma em categórica uma variável numérica, de modo que, na regressão, temos uma dummy para cada valor
m <- lm(data = voos, dep_delay ~ precipDay2 + I(wind_speed >= 14.96014) + I(temp <= 32) + origin + departuresPerDay +
  departuresPerHour + distance + carrier + seats + factor(hour) + factor(month))

# Sumário da regressão
summary(m)



# Calcula atraso médio por hora do dia
voos <- voos %>%
  group_by(hour) %>%
  mutate(meanDepDelay = mean(dep_delay, na.rm = T)) %>%
  ungroup()

# Boxplot atraso vs hora do dia
ggplot(voos, aes(x = factor(hour), y = dep_delay, fill = meanDepDelay)) +
  geom_boxplot() +
  coord_cartesian(ylim = c(-10, 50))

# Boxplot atraso vs mes
ggplot(voos, aes(x = factor(month), y = dep_delay)) +
  geom_boxplot() +
  coord_cartesian(ylim = c(-10, 50))


# Uso da funcao filter apos agrupamento:
# para cada dia e cada aeroporto de origem, deixar apenas os voos cujos atrasos são maiores que o percentil 99 daquele dia
pioresVoosdeCadaDia <- voos %>%
  group_by(Data, origin) %>%
  filter(dep_delay >= quantile(dep_delay, .99, na.rm = T)) %>%
  ungroup()


unite() 