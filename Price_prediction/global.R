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
most_makes = read.csv('most_makes.csv')
predicted_price = read.csv('predicted_price.csv')

price_model_initial = lm(Price ~ Efficiency + Fast_charge + 
                        Range + Top_speed + 
                        Acceleration, data = ecars)
bc = boxCox(price_model_initial)
lambda = bc$x[which(bc$y == max(bc$y))]

model <- readRDS("model.rds")
make_colors = c('#e6194b', '#3cb44b', '#ffe119', 
                '#4363d8', '#f58231', '#911eb4', 
                '#46f0f0', '#f032e6', '#bcf60c', 
                '#fabebe', '#008080', '#e6beff',
                '#000075', '#aaffc3')

