# Exemplos de joins - por Fabio Fernandes
# Atualizado em 05/08/2020


# Dados -------------------------------------------------------------------


x1 <-  data.frame(CodMun = c(123, 456, 789), 
                  Pop = (1:3) * 10000
                  )

x2  <- data.frame(CodMun = c(111, 123, 456, 888), 
                  PIB = (5:8) * 1000
                  )

x3  <- data.frame(CodMun = c(111, 123, 456, 888, 123), 
                  PIB = (5:9) * 1000
                  )



# Juntar x1 e x2 ----------------------------------------------------------

library(dplyr) # para usar as funções `*_join()`

left_join(x1, x2, by = "CodMun")
right_join(x1, x2, by = "CodMun")

full_join(x1, x2, by = "CodMun") 
inner_join(x1, x2, by = "CodMun")




# Juntar x1 e x3, sendo que x3 contém CodMun repetido ---------------------

# library(dplyr)

left_join(x1, x3, by = "CodMun")
right_join(x1, x3, by = "CodMun")

full_join(x1, x3, by = "CodMun") 
inner_join(x1, x3, by = "CodMun")




# Extra -------------------------------------------------------------------


# Quais são todos os CodMun que existem nas duas bases?
union(x1$CodMun, x2$CodMun) # similar ao full_join()

# Quais são os codmun que existem nas duas bases ao mesmo tempo?
intersect(x1$CodMun, x2$CodMun) # similar (mas não igual) ao inner_join() 