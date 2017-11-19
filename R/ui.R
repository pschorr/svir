library(shiny)

# Define UI for file upload
navbarPage(
  "CDC's Social Vulnerability Index Map",
  tabPanel(
    "Overall SVI",
    fluidPage(sidebarLayout(

      # sidebar panel with file upload
      sidebarPanel(
        fileInput(inputId="shp", label="Upload Shapefile", multiple=TRUE)),  # must upload all 6 shapefile extensions

      # plot shapefile
      mainPanel(
        plotOutput("map")  # take this out later; this is only to show that upload file works
      )
    ))
  ),
  tabPanel(
    "Socioeconomic Status"
  ),
  tabPanel(
    "Househould Composition & Disability"
  ),
  tabPanel(
    "Minority Status & Language"
  ),
  tabPanel(
    "Housing & Transportation"
  )
)
