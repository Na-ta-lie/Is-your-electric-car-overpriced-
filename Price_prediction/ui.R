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
        mainPanel(fluidRow(plotOutput("scatter"))
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
            tags$label(h3('Expected Price in Euros')), # Status/Output Text Box
            verbatimTextOutput('contents'),
            tableOutput('tabledata'),
            plotOutput('predicted')
            )
          )
        
      )
    )

