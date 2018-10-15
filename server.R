###################################################################
##  start of the server calculations

library(shiny)
library(plotly)

# Define server logic required to draw a histogram
function(input, output, session) {

  #import crimes/fires data
  myData<-read.csv("C:\\Nick\\07 R\\6JohnHopkins\\9 Developing Data Products\\Week4\\summaryKPIs.csv")
  clusData<-myData[,c(8:26)]  
  
  # Combine the selected variables into a new data frame (plotting)
  plottedData <- reactive({
    myData[, c("COM_SECT","HH",input$xcol, input$ycol)]
  })
  # Combine the selected variables into a new data frame (clust)
  selectedData <- reactive({
    clusData[, c(input$xcol, input$ycol)]
  })
  clusters <- reactive({
    kmeans(selectedData(), input$clusters)
  })
  #cluster performance statistic (cluster error/total error)
  output$SS<-reactive({
      test<-kmeans(selectedData(), input$clusters)  
      paste(round(100*(test$betweenss/test$totss), 2), "%", sep="")
    })
  
  datasetInput<-reactive({
    temp_table<-cbind(as.vector(myData$COM_SECT),as.vector(clusters()$cluster))
    names(temp_table)<-c("COM_SECT","Cluster")
    return(temp_table)
  })
  
  # Downloadable csv of selected dataset ----
  output$downloadData <- downloadHandler(
    filename = "output.csv",
    content = function(file) {
      write.csv(datasetInput(), file, row.names = FALSE)
    }
  )
  
  output$plot1 <- renderPlotly({
    plot_ly(plottedData(),x=plottedData()[,3],y=plottedData()[,4],type="scatter"
            ,text = ~paste("KPIs: (Crimes,Fires)","<br>Sector: ", plottedData()$COM_SECT, '$ Exposure=', plottedData()$HH)
            , marker=list(size=log(plottedData()$HH))
    )
    })
  
  output$plot2 <- renderPlotly({
    plot_ly(plottedData(),x=log(plottedData()[,3]),y=log(plottedData()[,4]),type="scatter"
            ,text = ~paste("KPIs: (Crimes,Fires)","<br>Sector: ", plottedData()$COM_SECT, '$ Exposure=', plottedData()$HH)
            , marker=list(size=log(plottedData()$HH))
    )
  })
  
  #cluster
  output$plot3 <- renderPlot({
    palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
              "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))
    
    par(mar = c(5.1, 4.1, 0, 1))
    plot(selectedData(),
         col = clusters()$cluster,
         pch = 20, cex = 3)
    points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
  })
  
  #log space cluster
  output$plot4 <- renderPlot({
    palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
              "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))
    
    par(mar = c(5.1, 4.1, 0, 1))
    plot(log(selectedData()),
         col = clusters()$cluster,
         pch = 20, cex = 3)
    points(log(clusters()$centers), pch = 4, cex = 4, lwd = 4)
  })


  
}


