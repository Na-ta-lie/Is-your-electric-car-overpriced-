#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram


fluidPage(theme = shinytheme("slate"),
  navbarPage("Is Your Electric Car Overpriced?",
    tabPanel("Variable Relationships",
      sidebarLayout(
        sidebarPanel(
          tags$label(h3('Select Variables')),
          varSelectInput("xvar", 
                         "X variable", 
                         ecars_vars, 
                         selected = "Battery"),
          varSelectInput("yvar", 
                         "Y variable", 
                         ecars_vars, 
                         selected = "Price"),
          checkboxGroupInput("make", "Filter by Make",
                              choices = unique(ecars_make$Make), 
                              selected = unique(ecars_make$Make)),
          hr(), # Add a horizontal rule
          checkboxInput("by_make", "Show Make", TRUE),
          checkboxInput("smooth", "Add Smoother"),
          ),
        mainPanel(
          tags$label(h3('This collection of data on electric vehicles 
                        came from Kaggle. The original set included 
                        360 observations and 9 variables.')),
          tags$label(h6('https://www.kaggle.com/datasets/fatihilhan/electric-vehicle-specifications-and-prices/')),
          tags$label(h4('The visual below allows comparison of 
                        the quantitative variables from the dataset. 
                        Only data from car makes that have 10+ models are 
                        displayed.The variables included are the following:')),
          tags$label(h5("Battery: The capacity of the vehicle's battery in kilowatt-hours (kWh)")),
          tags$label(h5("Efficiency: The energy efficiency rating of the vehicle in watt-hours per kilometer (Wh/km).")),
          tags$label(h5("Fast_charge: The fast-charging capability of the vehicle in minutes for a certain charging percentage.")),
          tags$label(h5("Price: The price of the electric vehicle in Germany in euros.")),
          tags$label(h5("Range: The driving range of the vehicle on a single charge in kilometers.")),
          tags$label(h5("Top_speed: The maximum speed the vehicle can achieve in kilometers per hour.")),
          tags$label(h5("Acceleration: The acceleration time(s) from 0 to 100 kilometers per hour.")),
          fluidRow(plotOutput("scatter"))
                  )
                )
              ),
    tabPanel('Linear Model and Predictor',
        headerPanel('Price Predictor'),
        sidebarPanel(
          tags$label(h3('Input parameters')),
            numericInput("eff", 
                          label = "Efficiency", 
                          value = 200),
            numericInput("fc", 
                          label = "Fast Charge", 
                          value = 500),
            numericInput("range", 
                          label = "Range", 
                          value = 350),
            numericInput('ts', 
                          label = "Top Speed", 
                          value = 150),
            numericInput('acc', 
                         label = "Acceleration", 
                         value = 6),
            numericInput('ap', 
                         label = "Price", 
                         value = 50000),
            actionButton("submitbutton",
                         "Submit", 
                          class = "btn btn-primary \n"),
            sliderInput('xlab', 'x zoom', 0, 500, 150, ticks = TRUE),
            sliderInput('ylab', 'y zoom', 0, 500, 150, ticks = TRUE)
                        ),
        mainPanel(
            tags$label(h3('Predicted price in euros based on linear model')),
            tags$label(h4('Input the required fields for an electric vehicle. 
                          The model will predict its price using these fields. 
                          Compare the predicted price to the actual price of the 
                          vehicle to determine if the car is a good value.')),# Status/Output Text Box
            verbatimTextOutput('contents'),
            tableOutput('tabledata'),
            tags$label(h5('The yellow diamond in two visuals below displays 
                          the predicted price of the electric vehicle (based 
                          on the specifications entered) against its actual price.')),
            tags$label(h5('The blue line indicates the predicted price for all 
                          vehicles in the data set. The black dashed lines indicate  
                          the confidence interval and the the red dashed lines indicate 
                          the prediction interval.')),
            plotOutput('predicted'),
            plotOutput('predicted_mean')
            )
          )
        
      )
    )

