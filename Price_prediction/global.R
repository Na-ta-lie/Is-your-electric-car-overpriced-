library(dplyr)
library(ggplot2)
library(tidyr)
library(car)
library(MASS)
library(repr)
library(pals)
library(shinythemes)

ecars = read.csv('ecars.csv')
ecars_vars = ecars[,4:10]
ecars_make  = ecars %>% group_by(Make) %>%
  filter(n()>=10)
ecars_make
most_makes = read.csv('most_makes.csv')
predicted_price = read.csv('predicted_price.csv')

price_model_initial = lm(Price ~ Efficiency + Fast_charge + 
                        Range + Top_speed + 
                        Acceleration, data = ecars)
bc = boxCox(price_model_initial)
lambda = bc$x[which(bc$y == max(bc$y))]

model <- readRDS("model.rds")

             
make_colors = c('#e6194b', '#f58231',  '#ffe119', 
                '#bcf60c','#3cb44b', '#008080',
                '#aaffc3', '#4363d8', '#000075',
                '#46f0f0', '#911eb4', '#e6beff',
                '#f032e6', '#fabebe')
