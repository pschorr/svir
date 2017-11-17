library(shiny)
library(maptools)

# Define server logic
shinyServer(function(input, output) {

  uploadShpfile <- reactive({
    if (!is.null(input$shp)){
      shpDF <- input$shp
      prevWD <- getwd()
      updir <- dirname(shpDF$datapath[1])
      setwd(updir)
      for (i in 1:nrow(shpDF)){
        file.rename(shpDF$datapath[i], shpDF$name[i])
      }
      shpName <- shpDF$name[grep(x = shpDF$name, pattern = "*.shp")]
      shpPath <- paste(updir, shpName, sep = "/")
      setwd(prevWD)
      shpFile <- readShapePoly(shpPath)
      return(shpFile)
    } else {
      return()
    }
  })

  output$map <- renderPlot({
    if (!is.null(uploadShpfile())){
      plot(uploadShpfile())
    }
  })
})
