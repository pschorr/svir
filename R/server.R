library(shiny)
library(rgdal)
library(rpostgis)
library(RPostgreSQL)
library(sp)

# Define server logic
shinyServer(function(input, output) {

  # create a PostgreSQL instance and create one connection
  drv <- dbDriver("PostgreSQL")

  # open the connection with credentials
  con <- dbConnect(drv, user="postgres", password="gisde2018",
                   host="localhost", port=5432,dbname="svir")

  # create upload file function
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
      shpFile <- readOGR(shpPath)
      writeOGR(shpFile, dsn = c("PG:user = 'postgres' dbname = 'svir' host = 'localhost'"),  # write shp to PG table & create sp index
               layer_options = "geometry_name = geom", layer = "userext", overwrite_layer = TRUE, driver = "PostgreSQL")
      pgGetGeom(con, name = c("public", "svi2014_us"), geom = "geom", gid = "gid", clauses = "SELECT *
                FROM svi2014_us AS svi, userext AS poly
                WHERE ST_Intersects(svi.geom, poly.wkb_geometry)")  # find intersections of user input and states and return geom
      return(shpFile)
    } else {
      return()
    }
  })

  # plot output$map
  output$map <- renderPlot({
    if (!is.null(uploadShpfile())){
      plot(uploadShpfile())
    }
  })
})
