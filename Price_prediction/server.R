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
  

  output$regression <- renderPlot({
    p2 <- ggplot(NULL, aes(Predicted_price, Price)) +
      geom_smooth(data = predicted_price, aes(x = Predicted, y = Predicted), col = 'black') +
      geom_smooth(data = predicted_price, aes(x = Predicted, y = Predict_lwr), col = 'red') +
      geom_smooth(data = predicted_price, aes(x = Predicted, y = Predict_upr), col = 'red') +
      geom_smooth(data = predicted_price, aes(x = Predicted, y = Confidence_lwr), col = 'blue') +
      geom_smooth(data = predicted_price, aes(x = Predicted, y = Confidence_upr), col = 'blue') +
      geom_point(data = predicted_price, aes(x = Predicted, y = Price), alpha = .5) + 
      ylim(25, input$ylab) + xlim(25, input$xlab)
  })
}



