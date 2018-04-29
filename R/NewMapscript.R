library("googlesheets")
library("leaflet")
library("shiny")
library("rgdal")
library("raster")
library("sp")
library("mapview")
#getwd()
#setwd("F:/Spring2018/Web Mapping/Project/WebMap1/")
sheet<- gs_key('1hT9JHKGhKR1QcUDB8ylylURmgxoIkylLd4SF9zqdTVo')
kebele<-shapefile("inst/extdata/kebeles.shp")

#Creating School points
Schoolpoints<- sheet %>% gs_read(ws = 1, range = "A1:R18")

#Adding data to shapefile
UniT<- sheet %>% gs_read(ws = 2, range = "A1:C34")
UniT<- as.data.frame(UniT)
head(UniT)
#merge to kebeles
oo <- merge(kebele,UniT, by="id")

HV<- sheet %>% gs_read(ws = 3, range = "A1:L34")
HV<- as.data.frame(HV)
kb1 <- merge(oo,HV)

#Adding economic opportunities data
EconOpp<- sheet %>% gs_read(ws = 4, range = "A1:E34")
EconOpp<- as.data.frame(EconOpp)
head(EconOpp)
head(HV)
kebelef <- merge(kb1,EconOpp)
head(kebelef)
# Create the map
m <- leaflet()
m <- m %>%
  addTiles()%>%
  addProviderTiles("CartoDB.Positron")%>%
  setView(36.776, 11.242, zoom = 10)
#create color palette for UniT2012
bins1 <- c(0, 1, 2, 3, 5, Inf)
palUniT <- colorBin(
  palette = "YlOrRd",
  domain = kebelef$UniT2012,
  bins=bins1
)
# add UniT data to the map
m <- addPolygons(m, 
                 data = kebelef,
                 color = "#444444",
                 weight = 1,
                 smoothFactor = 0.5,
                 opacity = 1.0,
                 fillOpacity = 0.7,
                 highlightOptions = highlightOptions(color = "white", weight = 2,
                                                     bringToFront = FALSE),
                 fillColor = ~palUniT(kebelef$UniT2012),
                 popup = paste("Number of University Transition Awards: ", kebelef$UniT2012, sep="")
)
m
m<- m %>% addCircles(data=Schoolpoints,
                     lat = ~Lat, lng = ~Lng, 
                     radius = 60, 
                     color = '#191970',
                     label = Schoolpoints$`School Name`,
                     labelOptions = labelOptions(
                          style = list(
                            "color"= "black",
                            "font-size" = "12px",
                            "border-color" = "rgba(0,0,0,0.5)")),
                     popup =  paste('<h7 style="color:white;">', "Name:", "<b>", Schoolpoints$`School Name`, "</b>", '</h7>', "<br>",
                                    '<h8 style="color:white;">',"New Buildings:", Schoolpoints$`New Buildings`,'</h8>', "<br>",
                                    '<h8 style="color:white;">', "New Classrooms:", Schoolpoints$`New Classrooms`, '</h8>', "<br>",
                                    '<h8 style="color:white;">', "Wells:", Schoolpoints$Wells, '</h8>', "<br>",
                                    '<h8 style="color:white;">', "Piped Water:", Schoolpoints$`piped water system`, '</h8>', "<br>",
                                    '<h8 style="color:white;">', "Latrines:", Schoolpoints$` Latrines `, '</h8>', "<br>",
                                    popupImage(Schoolpoints$photos)))
#paste(paste(popupImage(Schoolpoints$photos), "<br>", "Name:", Schoolpoints$`School Name`)))
m

bins2<- c(0, 300, 450, 600, 750, Inf)
palHV <- colorBin(
  palette = "BuPu",
  domain = kebelef$Homes,
  bins = bins2
)
HV<- leaflet()
HV <- HV %>%
  addTiles()%>%
  addProviderTiles("CartoDB.Positron")%>%
  setView(36.776, 11.242, zoom = 10)
HV <- addPolygons(HV, 
                 data = kebelef,
                 color = "#444444",
                 weight = 1,
                 smoothFactor = 0.5,
                 opacity = 1.0,
                 fillOpacity = 0.7,
                 label = kebelef$Kebele,
                 labelOptions = labelOptions(
                   style = list(
                     "color"= "black",
                     "font-size" = "12px",
                     "border-color" = "rgba(0,0,0,0.5)")),
                 highlightOptions = highlightOptions(color = "white", weight = 2,
                                                     bringToFront = TRUE),
                 fillColor = ~palHV(kebelef$Homes),
                 popup = paste('<h7 style="color:white;">',  "Name:", "<b>", kebelef$Kebele, "</b>", '</h7>', "<br>",
                               '<h8 style="color:white;">',"Total Homes Improved:", kebelef$Homes,'</h8>', "<br>",
                               '<h8 style="color:white;">', "Wells:", kebelef$Wells, '</h8>', "<br>",
                               '<h8 style="color:white;">', "Piped Water:", kebelef$Wells, '</h8>', "<br>",
                               '<h8 style="color:white;">', "Cement Floors:", kebelef$`Piped water`, '</h8>', "<br>",
                               '<h8 style="color:white;">', "Solar Lanterns:", kebelef$`Cement Floors`, '</h8>', "<br>",
                               '<h8 style="color:white;">', "Latrines:", kebelef$`Latrines`, '</h8>', "<br>",
                               popupImage(kebelef$HVphotos)))#paste("Kebele:", kebelef$Kebele, "<br>", popupImage(kebelef$HVphotos)))
HV

bins3<- c(0, 6, 30, 60, Inf)
palEO <- colorBin(
  palette = "YlGn",
  domain = kebelef$`Farmer's Association members assisted`,
  bins = bins3
)
EO<- leaflet()
EO <- EO %>%
  addTiles()%>%
  addProviderTiles("CartoDB.Positron")%>%
  setView(36.776, 11.242, zoom = 10)
EO <- addPolygons(EO, 
                  data = kebelef,
                  color = "#444444",
                  weight = 1,
                  smoothFactor = 0.5,
                  opacity = 1.0,
                  fillOpacity = 0.7,
                  label = kebelef$Kebele,
                  labelOptions = labelOptions(
                    style = list(
                      "color"= "black",
                      "font-size" = "12px",
                      "border-color" = "rgba(0,0,0,0.5)")),
                  highlightOptions = highlightOptions(color = "white", weight = 2,
                                                      bringToFront = TRUE),
                  fillColor = ~palEO(kebelef$`Farmer's Association members assisted`),
                  popup = paste('<h7 style="color:white;">',  "Name:", "<b>", kebelef$Kebele, "</b>", '</h7>', "<br>",
                                '<h8 style="color:white;">',"Microloans Distributed:", kebelef$Microloans,'</h8>', "<br>",
                                '<h8 style="color:white;">', "Wells:", kebelef$`Farmer's Association members assisted`, '</h8>', "<br>",
                                popupImage(kebelef$HVphotos)))
EO

install.packages('rsconnect')
library(rsconnect)
rsconnect::setAccountInfo(name='naramccray',
                          token='23F9B0E5213EA9806412DC9AE18F1E69',
                          secret='IKZFch+n8U2OwVfhHheuOyc7UzcA6A9lYXJ0fSdw')
rsconnect::deployApp('C:/Users/NMcCray/Documents/R/WEbMapping/WebMap/leaflet/leaflet')
shiny::runApp('C:/Users/NMcCray/Documents/R/WEbMapping/WebMap/leaflet/leaflet')
