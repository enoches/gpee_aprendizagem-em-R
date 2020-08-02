x1 <-  data.frame(CodMun = c(123,456,789),Pop = (1:3)*10000)
x2  <- data.frame(CodMun = c(111,123,456,888), PIB = (5:8)*1000)

left_join(x1,x2,by="CodMun")
right_join(x1,x2,by="CodMun")
full_join(x1,x2,by="CodMun")
inner_join(x1,x2,by="CodMun")

