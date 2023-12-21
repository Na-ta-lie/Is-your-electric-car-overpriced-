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
      scale_color_manual(values = make_colors) +
      list(theme(legend.position = "bottom"),
      if (input$by_make) aes(color = Make),
      geom_point(), 
      if (input$smooth) geom_smooth()
    )
    p
  }, res = 100)
  

  
  datasetInput <- reactive({  
    
    df <- data.frame(Efficiency = input$eff,
                      Fast_charge = input$fc, 
                      Range = input$range, 
                      Top_speed = input$ts, 
                      Acceleration = input$acc,
                      stringsAsFactors = FALSE)
   
    input <- df
    
    Output <- (((predict(model, df)) *lambda) + 1)^(1/lambda)
    
    print(Output)
    
  })
  
  # Status/Output Text Box
  output$contents <- renderPrint({
    if (input$submitbutton>0) { 
      isolate("Calculation complete.") 
    } else {
      return("Server is ready for calculation.")
    }
  })
  
  # Prediction results table
  output$tabledata <- renderTable({
    if (input$submitbutton>0) { 
      isolate(datasetInput()) 
    } 
  })
  
  output$predicted <- renderPlot({
    df <- data.frame(Efficiency = input$eff,
                     Fast_charge = input$fc, 
                     Range = input$range, 
                     Top_speed = input$ts, 
                     Acceleration = input$acc,
                     stringsAsFactors = FALSE)
    ap = input$ap 
    ymax = input$ylab
    xmax = input$xlab
    
    input <- df
    
    pp = as.numeric(((predict(model, df)) *lambda) + 1)^(1/lambda)   
    
    df2 = data.frame(x1 = pp,
                     y1 = ap)
    
    ggplot(NULL, aes(Predicted_price, Price)) +
      geom_smooth(data = predicted_price, aes(x = Predicted, y = Predicted), col = 'blue', size = .5, alpha = .8) +
      geom_smooth(data = predicted_price, aes(x = Predicted, y = Predict_lwr), col = 'red', linetype = 'dashed', alpha = .8) +
      geom_smooth(data = predicted_price, aes(x = Predicted, y = Predict_upr), col = 'red', linetype = 'dashed', alpha = .8) +
      geom_smooth(data = predicted_price, aes(x = Predicted, y = Confidence_lwr), col = 'black', linetype = 'dashed', alpha = .8) +
      geom_smooth(data = predicted_price, aes(x = Predicted, y = Confidence_upr), col = 'black', linetype = 'dashed', alpha = .8) +
      geom_point(data = predicted_price, aes(x = Predicted, y = Price), alpha = .5) +
      geom_point(data = df2, aes(x = x1/1000, y = y1/1000), size = 7, pch= 18, col = 'black') +
      geom_point(data = df2, aes(x = x1/1000, y = y1/1000), size = 6, pch= 18, col = 'yellow') +
      geom_point(data = df2, aes(x = x1/1000, y = y1/1000), size = 3, pch= 18, col = 'black') +
      theme(legend.position = "bottom", legend.text = element_text(size = 10))+
      ylim(25, ymax) + xlim(25, xmax) +
      xlab("Predicted Price in 1000s of Euros") + ylab("Price in 1000s of Euros") +
      ggtitle('Predicted Price vs. Price for all EV Models')  
    
    
      
  })
  
  output$predicted_mean <- renderPlot({
    df <- data.frame(Efficiency = input$eff,
                     Fast_charge = input$fc, 
                     Range = input$range, 
                     Top_speed = input$ts, 
                     Acceleration = input$acc,
                     stringsAsFactors = FALSE)
    ap = input$ap 
    ymax = input$ylab
    xmax = input$xlab
    
    input <- df
    
    pp = as.numeric(((predict(model, df)) *lambda) + 1)^(1/lambda)   
    
    df2 = data.frame(x1 = pp,
                     y1 = ap)
    
    ggplot(NULL, aes(Predicted_price, Price)) +
      geom_smooth(data = predicted_price, aes(x = Predicted, y = Predicted), col = 'blue', size = .5, alpha = .8) +
      geom_smooth(data = predicted_price, aes(x = Predicted, y = Predict_lwr), col = 'red', linetype = 'dashed', alpha = .8) +
      geom_smooth(data = predicted_price, aes(x = Predicted, y = Predict_upr), col = 'red', linetype = 'dashed', alpha = .8) +
      geom_smooth(data = predicted_price, aes(x = Predicted, y = Confidence_lwr), col = 'black', linetype = 'dashed', alpha = .8) +
      geom_smooth(data = predicted_price, aes(x = Predicted, y = Confidence_upr), col = 'black', linetype = 'dashed', alpha = .8) +
      geom_point(data = most_makes, aes(x = mean_predicted, y = mean_price), size = 4) +
      geom_point(data = most_makes, aes(x = mean_predicted, y = mean_price, col = Make), size = 3) +
      geom_point(data = most_makes, aes(x = mean_predicted, y = mean_price), size = 1) +
      geom_point(data = df2, aes(x = x1/1000, y = y1/1000), size = 7, pch= 18, col = 'black') +
      geom_point(data = df2, aes(x = x1/1000, y = y1/1000), size = 6, pch= 18, col = 'yellow') +
      geom_point(data = df2, aes(x = x1/1000, y = y1/1000), size = 3, pch= 18, col = 'black') +
      theme(legend.position = "bottom", legend.text = element_text(size = 10))+
      labs(col = 'Car Make') +
      ylim(25, ymax) + xlim(25, xmax) +
      scale_color_manual(values = make_colors) +
      xlab("Predicted Price in 1000s of Euros") + ylab("Price in 1000s of Euros") +
      ggtitle('Predicted Price vs. Price for each Make with 10+ Models (mean of price of all models)')  
    
    
    
  })
}



