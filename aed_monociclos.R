# Este script vai criar um banco de dis arquivos Excel diferentes. 
# Enoch Filho, 29/07/2020;  Atualizado em 02/09/2020


# OBS: Este script `montar-base-de-dados-2020-07-29.R` foi renomeado
# para `aed_monociclos.R`.  
# AED: análise exploratória dos dados = EDA: exploratory data analysis




# PARTE I - preparar banco de dados #######################################



# INSTRUÇÕES --------------------------------------------------------------


# Vamos juntos fazer um exercício de limpar e juntar os dados que estão em dois 
# arquivos Excel diferentes. Espera-se um script que possa ler os arquivos 
# originais e entregar um banco de dados único, pronto para a análise. 

# Objetivos:
# * montar uma base de dados arrumada (tidy)
# * criar um script reproduzível 
# * buscar ajuda na documentação dos pacotes


# Pacotes e funções sugeridas para entregar os objetivos:
# * readxl: para ler as planilhas
# * dplyr: mutate, rename, select, identical, *_join
# * stringr: str_to_upper, str_to_lower, str_to_title...


# Fonte 
# https://github.com/RMHogervorst/unicorns_on_unicycles


# Pacotes -----------------------------------------------------------------

library(tidyverse)
library(here) # lidar com caminhos de arquivos
library(readxl) # Ler as planilhas 
library(waldo) # comparar dois objetos


# Carregar e ler os dados -------------------------------------------------


observations <- read_xlsx(
    here("observations.xlsx")
    )

sales <- readxl::read_xlsx(here("sales.xlsx")) 


# Vamos olhar os dados? 

glimpse(observations)
glimpse(sales)

# Parece que tem algo estranho no objeto `sales`!


# Limpar e juntar os dados ------------------------------------------------

# `sales` parece que tem tem duas colunas duplicadas e duas colunas vazias.
# Precisamos verificar.

# Existe várias maneiras de comparar se o conteúdo de uma coluna é igual a 
# outra. Vamos experimentar algumas delas

# 1 -  Nome do país:

# Ex 01: all_equal(): Pra dar certo tem que transformar os vetores em dois data.frames
all_equal(
    target = data.frame(x1 = sales$name_of_country...1),
    current = data.frame(x1 = sales$name_of_country...6)
)

#Ex 02: Simplesmente usar `==`: vai me dar Trues e Falses
sales$name_of_country...1 == sales$name_of_country...6

# Ex 03: all()
all(sales$name_of_country...1 == sales$name_of_country...6)

# Ex 04: identical():
identical(sales$name_of_country...1, sales$name_of_country...6)

# Ex 05: compare()
waldo::compare(sales$name_of_country...1, sales$name_of_country...6)

# Ex 06: Cuidado! Eu achava que poderia ser usada a função isTRUE(), mas não.  
# A função isTRUE() compara a expressão, se é V ou F. Não funciona
# p/ nosso proposito... pois o nome dos vetores/ variáveis é diferente.  
isTRUE(sales$year...2 == sales$year...7)


# 2 - ano 

# Agora vamos verificar a variável para ano, que aparentemente também
# está duplicada:  
waldo::compare(sales$year...2, sales$year...7)


# 3 - colunas vazias

# Tambem checar se as colunas 4 e 5 estão mesmo em branco
all(is.na(sales$...4))
all(is.na(sales$...5))


# Agora que sabemos que está tudo bem vamos manter no objeto `sales` 
# apenas as variáveis que interessam, isto é, sem duplicidade nem 
# variáveis "em branco" e vamos salvá-las em um objeto intermediário
# que chamaremos de `sales_drv`: 

# Podemos declarar as variáveis que queremos manter:
sales_drv <- sales %>% 
    select(name_of_country...1, year...2, bikes, total_turnover) 

# Ou poderíamos declarar as variáveis que queremos retirar:
sales %>% 
    select( -c(...4, ...5, name_of_country...6, year...7) ) %>% # explicita os nomes 
    colnames()

sales %>% 
    select( -c(4:7) ) %>% # tirar quarta à sétima variável do bd sales
    colnames() 


# ATIVIDADE I (RESOLVIDA!)  ----
# -[x] Juntar sales_drv + observations 

# Primeiro quero saber quais são os nomes das variáveis em cada objeto: 
sales_drv %>% colnames()
observations %>% colnames()

# Quero saber quantos países diferentes existem no banco de dados 
sales_drv %>% distinct(name_of_country...1)


# Agora vou tentar juntar os dois objetos. Vou fazer algumas tentativas # pra ver o que acontece. Mas antes devo me perguntar: como eu espero 
# que seja o banco de dados após juntar os dois objetos?

# Perceba que nos comandos abaixo não estou salvando o resultado. 
# Estou fazendo as operações e verificando o que acontece.

sales_drv %>%  
    left_join(observations,
        by = c( "name_of_country...1" =  "countryname", "year...2" = "year")
    ) %>% View("left")

sales_drv %>%  
    inner_join(observations,
        by = c( "name_of_country...1" =  "countryname", "year...2" = "year")
    ) %>% View("inner")

sales_drv %>%  
    full_join(observations,
        by = c( "name_of_country...1" =  "countryname", "year...2" = "year")
    ) %>% View("full")


inner_join(sales_drv, observations, by = c("year...2" = "year")) %>% View("ex")

inner_join(sales_drv, observations, by = c("year...2" = "year")) %>% 
    filter(name_of_country...1 == "AUSTRIA", year...2 == 1671) %>% 
    View("ex2")



# Identificamos um problema com a grafia dos nomes dos países nos dois objetos. Então antes de juntar os dados, temos lidar com isso.

# library(stringr) # pacote já carregado junto com o tidyverse
# str_to_title("AUSTRIA") # exemplo

sales_drv <- 
mutate(sales_drv, 
    name_of_country...1 = str_to_title(name_of_country...1)
    )

# Ou: 
# sales_drv$pais <- str_to_title(sales$name_of_country...1)
# sales_drv$name_of_country...1 <- str_to_title(sales$name_of_country...1)

# Agora sim! Podemos fazer o join!


sales_drv <- sales_drv %>%  
    left_join(observations,
        by = c( "name_of_country...1" =  "countryname", "year...2" = "year")
    ) 

sales_tidy <- sales_drv %>% 
    rename(pais = name_of_country...1,
        year = year...2)



# Dica: salvar / carregar o objeto no disco -------------------------------

# Como salvar no disco e carregar o banco de dados pronto.
# OBS: veja que estamos usando a extensão *.rds, que é um dos formatos 
# em que o R salva os dados. Outra opção seria *.rda ou *.rdata


# Salvar ou carregar banco de dados pronto para análise:
saveRDS(sales_tidy, file = here("sales_tidy.rds")) # salvar no disco


# Carregar o objeto:
sales_tidy <- readRDS(here("sales_tidy.rds")) # carregar do disco




# PARTE II - análise exploratória ####################################


# Uma vez que os objetivos iniciais foram atingidos, vamos continuar a 
# exploração 



# ATIVIDADE II  -----------------------------------------------


## Exercício 01 ----  

# Refaça o banco de dados sales_tidy, mas dessa vez faça o encadeamendo 
# do código "em uma única linha", isto é, evitando ao maximo salvar objetos 
# intermediários para chegar ao resultado final.   

# Ex: 
# sales_tidy <- 
#     passo1 %>% 
#     passo2 %>% 
#     . 
#     . 
#     . 
#     passo_n


## RESPOSTA: 

# carregar as planilhas:

observations <- read_xlsx(
    here("observations.xlsx"))

sales <- readxl::read_xlsx(here("sales.xlsx")) 

# juntar as peças: 

sales_tidy2 <- 
    sales %>% 
    select(name_of_country...1, year...2, bikes, total_turnover) %>% 
    mutate(name_of_country...1 = str_to_title(name_of_country...1)) %>% 
    left_join(observations,
              by = c("name_of_country...1" = "countryname", 
                     "year...2" = "year")) %>% 
    rename(pais = name_of_country...1,
           year = year...2)

# conferir
waldo::compare(sales_tidy, sales_tidy2)



## Exercício 02 ----

# A partir do banco de dos sales_tidy, calcule o preço médio do monociclo 
# em cada ano para cada país. Em seguida monte um novo banco de dados com 
# as informações de país, ano e preço médio do monociclo, separando cada 
# ano em uma variárel. Salve o banco de dados final como `sales_long`.
# Espera-se um banco de dados mais ou menos no seguinte formato: 

#> pais    1670   1671   1672   ...
#> pais1    a      b      c     ...
#> pais2    d      e      f     ...
#> ...     ...    ...    ...    ...



## RESPOSTA: 

# Carregar o objeto sales_tidy (se já não estiver no enviroment):
sales_tidy <- readRDS(here("sales_tidy.rds")) 

# Preço médio do monociclo por país por ano (note as diferenças entre usar
# mutate ou summarise):

sales_tidy %>% 
    group_by(pais, year) %>% 
    mutate(preco_medio = total_turnover/bikes)


sales_tidy %>% 
    group_by(pais, year) %>% 
    summarise(preco_medio = total_turnover/bikes)
    

# Criar a nova tabela (mutate versus summarise - o que acontece?)

sales_wider1 <- 
    sales_tidy %>% 
    group_by(pais, year) %>% 
    mutate(preco_medio = total_turnover/bikes) %>% 
    pivot_wider(data = .,
                id_cols = c(pais, year, preco_medio),
                names_from = year,
                values_from = preco_medio) 



sales_wider2 <- sales_tidy %>% 
    group_by(pais, year) %>% 
    summarise(preco_medio = total_turnover/bikes) %>% 
    pivot_wider(data = .,
                names_from = year,
                values_from = preco_medio)



# EXTRA
# Explorando outras coisas... 

sales_tidy %>% 
    group_by(pais, year) %>% 
    summarise(preco_medio = total_turnover/bikes) %>% 
    pivot_wider(data = .,
                names_from = year,
                values_from = preco_medio) %>% 
    View("preco medio")

sales_tidy %>% 
    group_by(pais, year) %>% 
    select(pais, year, bikes) %>% 
    pivot_wider(data = .,
                #id_cols = c(pais, year, bikes),
                names_from = year,
                values_from = bikes) %>% 
    View("bikes select")

sales_tidy %>% 
    group_by(pais, year) %>% 
    # select(pais, year, bikes) %>% 
    pivot_wider(data = .,
                id_cols = c(pais, year, bikes),
                names_from = year,
                values_from = bikes) %>% 
    View("bikes id_cols")
