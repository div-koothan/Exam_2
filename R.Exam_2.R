#set the working directory 
setwd("C:/Users/Divya Koothan/Desktop/GOV 355M/Exam_2")

#clear global environment 
rm(list = ls(all = TRUE))

#loading rio library to import ineqaulity excel sheet
library(rio)
inequality_data <- import("inequality.xlsx")

#viewing data set to determine cross sectional or not 
summary(inequality_data)
