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

#create function for removing accents 
remove.accents <- function(s){
  #1 character substitutions
  old1 <- "ú"
  new1 <- "u"
  s1  <-chartr(old1,new1, s)
  
}
#apply function
inequality_data$country <- remove.accents(inequality_data$country)
#checking if function worked
head(inequality_data)

#sorting inequality_gini by lowest score
inequality_data <- inequality_data[order(inequality_data$inequality_gini),]
#the top 5
head(inequality_data, 5)

#finding the average inequality_gini
mean(inequality_data$inequality_gini, na.rm = TRUE)


#creating a new variable 
library(tidyverse)
#low inequality
inequality_data  <-
  inequality_data %>%
  mutate(low_inequality = 
           ifelse( inequality_gini < 36.81375, 
                  1, 0))
#high inequality 
inequality_data  <-
  inequality_data %>%
  mutate(high_inequality = 
           ifelse( inequality_gini >= 36.81375, 
                   1, 0))

#running a crosstab
library(doBy)
summaryBy(high_inequality ~ low_inequality, inequality_data, FUN = c(mean, length))

#created a vector with the names
reduce_inequality_africa <- c("World Bank", "African Development Bank", "Bill and Melida Gates")
#created for loop to print
for (i in reduce_inequality_africa){
  print(i)
}

#load the WDI
library(WDI)
#importing data
female_edu <- WDI(country = "all",
                  indicator =c ("SE.PRM.ENRL.FE.ZS"),
                  start = 2015, end = 2015, extra = FALSE, cache = NULL)

#loading data.table
library(data.table)
#changing variable name
setnames(female_edu, "SE.PRM.ENRL.FE.ZS", "female_enrollment")

#mergeing the data together 
merged_df <- left_join(inequality_data, female_edu,
                        by = c("iso2c", "year", "country"))

#removing NA based on ig
merged_df <- na.omit(merged_df, 
                     select <- "inequality_gini")
#check if it worked
any(is.na(merged_df))


#using filter and piping to select data
#that is greater than 30
#loading dplyr
library(dplyr)
data_greater_30 <-
  merged_df %>%
  dplyr::filter(inequality_gini > 30)

#find count of cournty with "ai"
length(grep("ai", data_greater_30$country))

#taking the sum of inequality-gini
sapply(data_greater_30$inequality_gini, sum)
#this would be the acutal sum 
sum(data_greater_30$inequality_gini)


#labelling the variables 
#load labelled
library(labelled)
var_label(merged_df) <- list(`iso2c` = "iso2c",
                             `country` = "country",
                             `inequality_gini` = "inequality Gini Index",
                             `year` = "year",
                             `low_inequality` = "below average inequality gini",
                             `high_inequality` = "abover average inequality gini",
                             `female_enrollment` = "% of femaled enrolled in primary education")



#save the data fram as a stata dataset
library(rio)
export(merged_df, "final_data.dta")
