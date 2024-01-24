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
  
  kaggle_url = a("Electric Vehicle Specifications and Prices", 
                 href="https://www.kaggle.com/datasets/fatihilhan/electric-vehicle-specifications-and-prices/")
  
  output$tab1 <- renderUI({
    tagList("Kaggle:", kaggle_url)
  })
  
  output$features <- renderPlot({
    plot(ecars[,4:10], 
         main = 'Comparison of all Continuous Variables', 
         cex.lab=1.5, cex.axis=1.5, cex =1.5)  
  })
  
  
  output$box <- renderPlotly({
  
    plot_ly(
      data = ecars,
      x = ~get(input$var),
      type = "box",
      text = ~Car_name,
      name = ' ',
      tooltip = c("x", "text")) %>% 
      layout(title = "Box Plot of Selected Feature",
             yaxis = list(title = ''),
             xaxis = list(title = ''))
      
    
    #ggplot(ecars, aes(!!input$var, y = factor(0))) +
    #  geom_boxplot()+
    #  theme(axis.title.y=element_blank(),
    #        axis.text.y=element_blank(),
    #        axis.ticks.y=element_blank()) +
    #  ggtitle('Box Plot of Selected Feature')  
    #
    #ggplotly(p2, x = !!input$var)
  })
  
  output$box2 <- renderPlotly({
    
    plot_ly(
      data = ecars_make,
      x = ~get(input$var),
      y = ~Make,
      type = "box",
      color = ~Make,
      colors = make_colors,
      text = ~Car_name,
      tooltip = c("x", "text"),
      showlegend = FALSE
    )%>% 
      layout(title = "Box Plots of Selected Feature by Makes with 10 or More Models",
             yaxis = list(title = ''),
             xaxis = list(title = ''))
    
    #ggplot(ecars_make, aes(!!input$var, Make, fill = Make)) +
    #  scale_fill_manual(values = make_colors) +
    #  geom_boxplot(outlier.colour="black", 
    #               outlier.shape=16, 
    #               outlier.size=2, 
    #               notch=FALSE) +
    #  theme(legend.position = "none") +
    #  ggtitle('Box Plots of Selected Feature by Makes with 10 or More Models') 
    
    
  })
  
  output$hist <- renderPlot({
    ggplot(ecars, aes(x=!!input$var)) + 
      geom_histogram(color="black", fill="white", bins = 10)+
      ggtitle('Distribution of Selected Feature')  
    
  })
  
  output$bar <- renderPlot({
  ecars %>% group_by(Make) %>%
    filter(n() >= 10) %>%
    summarise(feature = (mean(!!input$var))) %>%
    ggplot(., aes(x = Make, y = feature, fill = Make, label = Make)) +
    geom_bar(stat = 'identity') +
    scale_fill_manual(values = make_colors) +
    ylab('Mean')+
    theme(axis.title.x=element_blank(),
          axis.text.x=element_blank(),
          axis.ticks.x=element_blank()) +
    geom_text(angle = 90, position = position_stack(vjust = 0.5)) + 
    theme(legend.position = "none")+
    ggtitle('Mean of Selected Feature for each Make with 10 or More Models')  
  })
  
  subsetted <- reactive({
    req(input$var)
    ecars |> filter(Make %in% input$make)
  })
  
  output$scatter <- renderPlot({
    p <- ggplot(subsetted(), aes(!!input$xvar, !!input$yvar)) + 
      scale_color_manual(values = make_colors) +
      list(theme(legend.position = "bottom"),
      if (input$by_make) aes(color = Make),
      geom_point(size = 2), 
      if (input$smooth) geom_smooth()
    )
    
    p
    
  }, res = 100)
  

  
  output$MLR <- renderPlotly({
    mlr = ggplot(NULL, aes(Predicted_price, Price)) +
      geom_smooth(data = predicted_price, aes(x = Predicted, y = Predicted), 
                  col = 'blue', size = .8, alpha = .5) +
      geom_smooth(data = predicted_price, aes(x = Predicted, y = Predict_lwr), 
                  col = 'red', linetype = 'dashed', size = .8, alpha = .8) +
      geom_smooth(data = predicted_price, aes(x = Predicted, y = Predict_upr), 
                  col = 'red', linetype = 'dashed',size = .8, alpha = .8) +
      geom_smooth(data = predicted_price, aes(x = Predicted, y = Confidence_lwr), 
                  col = 'black', linetype = 'dashed', size = .8, alpha = .8) +
      geom_smooth(data = predicted_price, aes(x = Predicted, y = Confidence_upr), 
                  col = 'black', linetype = 'dashed', size = .8, alpha = .8) +
      geom_point(data = predicted_price, aes(x = Predicted, y = Price, text = Name), alpha = .5) +
      theme(legend.position = "right", legend.text = element_text(size = 8))+
      ylim(25, input$yzoom) + xlim(25, input$xzoom) +
      labs(title = "Predicted Price vs. Price for all EV Models",
           caption = "Data source: ToothGrowth",
           x = "Predicted Price (euros in thousands)", y = "German Price (euros in thousands)",
           tag = "A")
    
    ggplotly(mlr, tooltip = c("x", 'y', "text")) 
  })
  
  
  
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
      xlab("Predicted Price (euros in thousands)") + ylab("Price (euros in thousands)") +
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
      geom_point(data = df2, aes(x = x1/1000, y = y1/1000), size = 7, pch= 18, col = 'black') +
      geom_point(data = df2, aes(x = x1/1000, y = y1/1000), size = 6, pch= 18, col = 'yellow') +
      geom_point(data = df2, aes(x = x1/1000, y = y1/1000), size = 3, pch= 18, col = 'black') +
      theme(legend.position = "bottom", legend.text = element_text(size = 10))+
      labs(col = 'Car Make') +
      ylim(25, ymax) + xlim(25, xmax) +
      scale_color_manual(values = make_colors) +
      xlab("Predicted Price (euros in thousands)") + ylab("Price (euros in thousands)") +
      ggtitle('Predicted Price vs. Price for each Make with 10+ Models (mean of price of all models)')  
    

    
  })
}



