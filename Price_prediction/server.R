#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram


server <- function(input, output, session) {
  subsetted <- reactive({
    req(input$make)
    ecars |> filter(Make %in% input$make)
  })
  
  output$scatter <- renderPlot({
    p <- ggplot(subsetted(), aes(!!input$xvar, !!input$yvar)) + 
      list(theme(legend.position = "bottom"),
      if (input$by_make) aes(color = Make),
      geom_point(),
      if (input$smooth) geom_smooth()
    )
    p
  }, res = 100)
}