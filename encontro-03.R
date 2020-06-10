# Este scrip trata das atividades do terceiro encontro do grupo de estudos de 
# Data Science com R do GEES

# Hoje 2020/06/03 por Enoch




# 1) BOAS PRÁTICAS -------------------------


# É muito importante que o código seja legível (contenha espaços separando as coisas) e 
# seja comentado (porquê versus o quê)


# Mostra a área de trabalho
getwd()


rm(list = ls()) # limpa todas as variáveis do ambiente.
# ATT: isso era considerado boa prática colocar no início dos scripts mas
# hoje em dia não é mais recomendado


# De vez enquando é bom reiniciar o R: Crtl + Shift + F10



# 2) Sintaxe e outros  ------------------------------

# Aprendemos que a função skim() da library skimr pode substituir a função summary()
# para apresentar um sumário do banco de dados
skim(data)


# vimos que a função is.na() vai mostrar pra gente quais elementos do objeto 
# são valores faltantes (NA)
is.na(data$y)



## magrittr: pipe %>% 
# Atalho: Shift + Alt + M

data %>% 
  #select(y) %>% 
  summarise(mean(y))

data %>% skim() 



