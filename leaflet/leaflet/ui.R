library("googlesheets")
library("leaflet")
library("shiny")
library(shinydashboard)
library("rgdal")
library("raster")
library("sp")

shinyUI(
  fluidPage(
    includeCSS("styles.css"),
    titlePanel("Map of Project Ethiopia Accomplishments"),
    fluidRow(
      column(8,
             tabsetPanel(
               tabPanel("Education",
                        fluidRow(leafletOutput("map"))
                          
               ),
               tabPanel("Healthy Villages",
                        fluidRow(leafletOutput("mapHV")),
                        "More controls"
               ),
               tabPanel("Economic Opportunity",
                        fluidRow(leafletOutput("mapEO"))
               )
             )
      ))
  )
)

