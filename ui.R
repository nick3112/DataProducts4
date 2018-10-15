library(shiny)
library(plotly)

#import crimes/fires data
myData<-read.csv("C:\\Nick\\07 R\\6JohnHopkins\\9 Developing Data Products\\Week4\\summaryKPIs.csv")
clusData<-myData[,c(8:26)]
ncol(myData)

pageWithSidebar(
  headerPanel('London (UK) Crime and Fire Rates k-means clustering'),
  sidebarPanel(
    selectInput('xcol', 'X Variable', names(clusData)),
    selectInput('ycol', 'Y Variable', names(clusData),
                selected=names(clusData)[[2]]),
    numericInput('clusters', 'Cluster count', 3,
                 min = 1, max = 50)
  ),
  mainPanel(
    em("Documentation for this web page can be found at:"),
    tags$a(href="https://nick3112.github.io/DataProducts4/Presentation.html", "https://nick3112.github.io/DataProducts4/Presentation.html"),
    br(),
    br(),
    em("Performance of the current cluster selection:"),
    textOutput("SS"),
    
    tabsetPanel(type = "tabs", 
                #create a tab to import/export the data for analysis
                tabPanel("1. Interactive Plot", plotlyOutput('plot1',height="600px")),
                tabPanel("2. Log-Interactive Plot", plotlyOutput('plot2',height="800px")),
                tabPanel("3. Cluster Plot", plotOutput('plot3')),
                tabPanel("4. Log-Cluster Plot", plotOutput('plot4')),
                tabPanel("5. Export Clusters",h3('export final clustesr'),
                         textInput('table_name', 'Save the final clusters down to a csv file:'),
                         p("Be sure to give your file a .csv file extension"),
                         downloadButton('downloadData', 'Save data table to .csv'),
                         br()
                         # textOutput("out3"),
                )
    )

  )
)
