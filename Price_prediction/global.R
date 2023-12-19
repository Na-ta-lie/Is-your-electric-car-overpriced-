library(dplyr)
library(ggplot2)
library(tidyr)
library(car)
library(MASS)
library(repr)
library(pals)

ecars = read.csv('ecars.csv')
ecars_vars = ecars[,4:10]
getwd()

ecars_make  = ecars %>% group_by(Make) %>%
  filter(n()>=10)
