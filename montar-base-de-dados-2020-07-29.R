# Este script vai criar um banco de dis arquivos Excel diferentes. 
# Enoch Filho, 29/07/2020

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
identical(sales$year...2, sales$year...7)



# Tambem checar se as colunas 4 e 5 estão mesmo em branco
all(is.na(sales$...4))
all(is.na(sales$...5))


# Agora que sabemos que está tudo ok vamos retirar as variáveis duplicadas/ em branco 

sales_drv <- sales %>% 
    select(name_of_country...1, year...2, bikes, total_turnover) 
    

# ATT: DEVER DE CASA: 
# -[] Juntar sales_drv + observations 








# Fonte -------------------------------------------------------------------

# https://github.com/RMHogervorst/unicorns_on_unicycles
