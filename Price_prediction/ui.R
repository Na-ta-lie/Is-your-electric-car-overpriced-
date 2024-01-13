#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(bslib)

# Define UI for application that draws a histogram


fluidPage(theme = shinytheme('darkly'),
  navbarPage("Is Your Electric Car Overpriced?",
    tabPanel('Welcome!',
            h2("Welcome to the Electric Car Price Predictor!", 
                style="text-align:center"),
            h3("This Shiny App allows you to explore and compare the features of electric vehicles,
               and can predict the price of an electric vehicle given its features so you can avoid overpaying!", 
                style="text-align:center"),
            h6("* * * * * * * * * * * * * * * * * * * * * * * * * * *",
               style = 'text-align:center'),
            div(img(src='ecar.png', height="50%", width="50%"), style="text-align: center;")
        ),
    navbarMenu("Explore the Data", 
      tabPanel("About the Data",
        fluidRow(
          h2("This collection of data, Electric Vehicle Specifications and Prices, came from Kaggle.
          It is a collection of data scraped from EV Database."),
          uiOutput('tab1')
            ),
        fluidRow(
          column(5,
            h4("The original data set included 360 observation and 9 varibles.
               51 models that did not include prices and two models that did not have fast charge were filtered out.
               Makes with 10 or more models are highlighted in the visuals."),
            h4('The continuous variables included in the dataset are the following:'),
            h5("Battery: The capacity of the vehicle's battery in kilowatt-hours (kWh)"),
            h5("Efficiency: The energy efficiency rating of the vehicle in watt-hours per kilometer (Wh/km)."),
            h5("Fast_charge: The fast-charging capability of the vehicle in minutes for a certain charging percentage."),
            h5("Price: The price of the electric vehicle in Germany in euros."),
            h5("Range: The driving range of the vehicle on a single charge in kilometers."),
            h5("Top_speed: The maximum speed the vehicle can achieve in kilometers per hour."),
            h5("Acceleration: The acceleration time(s) from 0 to 100 kilometers per hour.")
                 ),
          column(7,
           plotOutput("features")
                 )
                )           
             ),
      tabPanel('Electric Model Features',
               fluidRow(
                 column(9,
                      h4('Choose the feature of the data set you would like to explore.')
                        ),
                 column(1),
                 column(2, 
                 varSelectInput("var", 
                                "Feature", 
                                ecars[,4:10], 
                                selected = "Price")
                  
                 )
               ),
               fluidRow(
                 column(6,
                        plotlyOutput("box")
                 ),
                 column(6,
                        plotlyOutput("box2")
                 )
               ),
               fluidRow(
                 column(12, '     ')
               ),
               fluidRow(
                 column(6, 
                        plotOutput("hist")
                        ),
                 column(6,
                        plotOutput("bar")
                 )
               )
              ),
      tabPanel("Compare the Features",
        fluidRow(
          column(2, 
            tags$label(h3('Select Variables')),
            varSelectInput("xvar", 
                           "X variable", 
                           ecars_vars, 
                           selected = "Battery"),
            varSelectInput("yvar", 
                           "Y variable", 
                           ecars_vars, 
                           selected = "Price")
            ),
          column(8,
                 tags$label(h4('The visual below allows comparison of 
                          the quantitative variables from the dataset. 
                          Only data from car makes that have 10+ models is 
                          displayed.')),
                 plotOutput("scatter")
                 ),
          column(2, 
            checkboxGroupInput("make", "Filter by Make",
                                choices = unique(ecars_make$Make), 
                                selected = unique(ecars_make$Make)),
            hr(), # Add a horizontal rule
            checkboxInput("by_make", "Show Make", TRUE),
            checkboxInput("smooth", "Add Smoother")
            )
          )
        )
      ),
    navbarMenu("Linear Model",
      tabPanel("About the Linear Model",
          fluidRow(
            tags$label(h3('The inputs of this multiple linear regression are all the quantititive varaibles from
                          the data set except Battery, which was eliminated using an AIC. The output is Price. Price was 
                          transformed using a BoxCox transformation. I used the linear model to predict the prices of 
                          the vehicles in the data set. I then plotted the predicted price against the actual
                          price to easily visualize which vehicles cost more vs. less than predicted.')),
            tags$label(h4('The blue line indicates the predicted price for all 
                          vehicles in the data set. The black dashed lines indicate  
                          the confidence interval and the the red dashed lines indicate 
                          the prediction interval.')),
            tags$label(h4('Hover over any point to see the make and model of the car.'))
          ),
          fluidRow(
          column(2,
                 sliderInput('xzoom', 'x zoom', 0, 300, 250, ticks = TRUE),
                 sliderInput('yzoom', 'y zoom', 0, 300, 250, ticks = TRUE)),
          column(10,
              plotlyOutput('MLR'))
                  )
               ),
      tabPanel('Price Predictor',
        fluidRow(
        column(3,
          tags$label(h3('Input parameters')),
            numericInput("eff", 
                          label = "Efficiency (Wh/km)", 
                          value = 200),
            numericInput("fc", 
                          label = "Fast Charge (minutes)", 
                          value = 500),
            numericInput("range", 
                          label = "Range (km)", 
                          value = 350),
            numericInput('ts', 
                          label = "Top Speed (km/hr)", 
                          value = 150),
            numericInput('acc', 
                         label = "Acceleration (s to 100 km/hr)", 
                         value = 6),
            numericInput('ap', 
                         label = "Price (euros)", 
                         value = 50000),
            actionButton("submitbutton",
                         "Submit", 
                          class = "btn btn-primary \n"),
            sliderInput('xlab', 'x zoom', 0, 500, 150, ticks = TRUE),
            sliderInput('ylab', 'y zoom', 0, 500, 150, ticks = TRUE)
        ),
        column(9,
            tags$label(h3('Predict what the price (euros) of an electric car should be!')),
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
      )
    )

