library(shiny)

# Define UI for file upload
shinyUI(pageWithSidebar(

  # add application title
  headerPanel(""),

  # sidebar panel with file upload
  sidebarPanel(
    fileInput(inputId="shp", label="Upload Shapefile", multiple=TRUE)),

   # plot shapefile
   mainPanel(
    plotOutput("map")
  )
))

