# Este script vai criar um banco de dis arquivos Excel diferentes. 
# Enoch Filho, 29/07/2020;  Atualizado em 12/08/2020

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

# Existe várias maneiras de comparar se o conteúdo de uma coluna é igual a outra

# Ex 01: Pra dar certo tem que transformar os vetores em dois data.frames
all_equal(
    target = data.frame(x1 = sales$name_of_country...1),
    current = data.frame(x1 = sales$name_of_country...6)
)

#Ex 02: vai me dar Trues e Falses
sales$name_of_country...1 == sales$name_of_country...6

# Ex 03:
all(sales$name_of_country...1 == sales$name_of_country...6)

# Ex 04: outra maneira:
identical(sales$name_of_country...1, sales$name_of_country...6)

# Ex 05: waldo
waldo::compare(sales$name_of_country...1, sales$name_of_country...6)

# Ex 06: Cuidado! a função abaixo compara a expressão, se é V ou F. Não funciona
# p/ nosso proposito
isTRUE(sales$year...2 == sales$year...7)



# Agora vamos verificar a variável para ano, que também parece duplicada:
waldo::compare(sales$year...2, sales$year...7)



# Tambem checar se as colunas 4 e 5 estão mesmo em branco
all(is.na(sales$...4))
all(is.na(sales$...5))


# Agora que sabemos que está tudo ok vamos manter apenas as variáveis que interessam,
# sem duplicidade nem variávei "em branco": 

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


# ATT: DEVER DE CASA: ----
# -[x] Juntar sales_drv + observations 

sales_drv %>% colnames()
observations %>% colnames()

sales_drv %>% distinct(name_of_country...1)

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



# Pra dar certo temos resolver a grafia dos nomes dos países

# library(stringr) 
# str_to_title("AUSTRIA") 

sales_drv <- 
mutate(sales_drv, 
    name_of_country...1 = str_to_title(name_of_country...1)
    )

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


# Dica: salvar no disco e carregar o banco de dados pronto ----------------

# Salvar ou carregar o banco de dados pronto para análise:

saveRDS(sales_tidy, file = here("sales_tidy.rds")) # salvar no disco

sales_tidy <- readRDS(here("sales_tidy.rds")) # carregar do disco




# ATIVIDADE PARA 12/08/2020 -----------------------------------------------


## Exercício 01 - 12/08/2020 ----
# Refaça o banco de dados sales_tidy, mas dessa vez faça o encadeamendo do código 
# "em uma única linha", isto é, evitando ao maximo salvar objetos intermediários 
# para chegar ao resultado final.   

# Ex: 
# sales_tidy <- 
#     passo1 %>% 
#     passo2 %>% 
#     . 
#     . 
#     . 
#     passo_n






## Exercício 02 - 12/08/2020 ----
# A partir do banco de dos sales_tidy, use a biblioteca tidyr, calcule o 
# preço médio do monociclo em cada ano para cada país. Em seguida monte essas 
# informações numa tabela assim: 

# pais    1670   1671   1672   ...
# pais1    a      b      c
# pais2    d      e      f













# Fonte -------------------------------------------------------------------

# https://github.com/RMHogervorst/unicorns_on_unicycles
