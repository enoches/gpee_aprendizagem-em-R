
# Vamos instalar o pacote com o banco de dados nycflights13

install.packages("nycflights13")

library(nycflights13)
library(tidyverse) #  conjunto de pacotes
library(skimr) # sumarizar dados


x <- "Enoch" 

y = "Fábio"


z <- c(x, y)
z

numeros <- c(1, 5, 10, 25)

str(numeros)

listas <- list(x, y, letters[1:5])

listas[[3]]



Conditionals:
  Testing for equality in R using == (and not =, which is typically used for assignment). For example, 2 + 1 == 3 compares 2 + 1 to 3 and is correct R code, while 2 + 1 = 3 will return an error.
Boolean algebra: TRUE/FALSE statements and mathematical operators such as < (less than), <= (less than or equal), and != (not equal to). For example, 4 + 2 >= 3 will return TRUE, but 3 + 5 <= 1 will return FALSE.
Logical operators: & representing “and” as well as | representing “or.” For example, (2 + 1 == 3) & (2 + 1 == 4) returns FALSE since both clauses are not TRUE (only the first clause is TRUE). On the other hand, (2 + 1 == 3) | (2 + 1 == 4) returns TRUE since at least one of the two clauses is TRUE.


ifelse()

if_else(numeros > 5, "OK", "ERRADO")

if (condition) {
  
}

mutate()
case_when()


