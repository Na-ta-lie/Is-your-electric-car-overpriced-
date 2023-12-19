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


fluidPage(
    navbarPage("Is Your Electric Car Overpriced?",
               tabPanel("Variable Relationships",
                    sidebarLayout(
                      sidebarPanel(
                        varSelectInput("xvar", "X variable", ecars_vars, selected = "Battery"),
                        varSelectInput("yvar", "Y variable", ecars_vars, selected = "Price"),
                        checkboxGroupInput(
                          "make", "Filter by Make",
                          choices = unique(ecars_make$Make), 
                          selected = unique(ecars_make$Make)
                        ),
                        hr(), # Add a horizontal rule
                        checkboxInput("by_make", "Show Make", TRUE),
                        checkboxInput("smooth", "Add smoother"),
                      ),
                      mainPanel(fluidRow(plotOutput("scatter"))
                      )
                    )
                  ),
               tabPanel('Linear Model',
                        sidebarLayout(
                          sidebarPanel(
                            sliderInput('xlab', 'x zoom', 0, 300, 300, ticks = TRUE),
                            sliderInput('ylab', 'y zoom', 0, 300, 300, ticks = TRUE),
                            checkboxInput('by_make2, "Add Make', TRUE),
                          ),
                          mainPanel(fluidRow(plotOutput("regression"))
                        )),
               tabPanel("blah")
    )
  )
)

