#set the working directory 
setwd("C:/Users/Divya Koothan/Desktop/GOV 355M/Exam_2")

#clear global environment 
rm(list = ls(all = TRUE))

#loading rio library to import ineqaulity excel sheet
library(rio)
inequality_data <- import("inequality.xlsx")

#viewing data set to determine cross sectional or not 
summary(inequality_data)


#subset Gini index for Sweden and Denmark
subset(inequality_data, select = c("country", "inequality_gini"), country == "Sweden"|country == "Denmark")

#subset gingi index for Brazil
subset(inequality_data, select = c("country", "inequality_gini"), country == "Brazil")

#peak at dataframe
head(inequality_data)

#create function
remove.accents <- function(s){
  #1 character substitutions
  old1 <- "ú"
  new1 <- "u"
  s1  <-chartr(old1,new1, s)
  
  #2 character substitutions 
  old2 <- c("ß")
  new2 <- c("ss")
  s2 <- s1
  for (i in seq_along(old2))
    s2 <-gsub(old2[1], new2[i], s2, fixed = TRUE )
  
  s2
}
