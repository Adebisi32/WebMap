library("googlesheets")
library("leaflet")
library("shiny")
library("rgdal")
library("raster")
library('githubinstall')


sheet<- gs_key('1hT9JHKGhKR1QcUDB8ylylURmgxoIkylLd4SF9zqdTVo')
kebele<-shapefile("inst/extdata/kebeles.shp")
#keb<-readOGR("inst/extdata/kebeles.shp")

#Creating School points
Schoolpoints<- sheet %>% gs_read(ws = 1, range = "A1:R18")

#ADDING DATA TO KEBELE SHAPEFILE
#University Transition
UniT<- sheet %>% gs_read(ws = 2, range = "A1:C34")
head(UniT)
UniT<- as.data.frame(UniT)
kebele<- merge(kebele, UniT, by="id")


#Healthy Villages
HV<- sheet %>% gs_read(ws = 3, range = "A1:L34")
HV<- as.data.frame(HV)
kebele<-merge(kebele,HV)


#Economic Opportunity
EconOpp<- sheet %>% gs_read(ws = 4, range = "A1:E34")
EconOpp<- as.data.frame(EconOpp)
kebele<- merge(kebele,EconOpp)
plot(kebele)
head(kebele)


m <- leaflet() %>%
  addTiles('https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png') %>%
  setView(36.776, 11.242, zoom = 10)

pal = colorNumeric(
  palette = "Greens",
  domain = kebele$UniT2012
)
m <- addPolygons(m, 
                data = kebele,
                stroke = TRUE, 
                smoothFactor = 0.1, 
                fillOpacity = 0.4,
                color = ~pal(kebele$UniT2012),
                popup = paste("Number of Awards: ", kebele$UniT2012, sep="")
)
m
class(kebele)
Schoolpoints

m %>% addCircles(data=Schoolpoints,lat= ~Lat, lng = ~Lng, radius = 50, color = '#ff0000', popup=paste("<img src = ", Schoolpoints$photos, ">"))
m


shinyServer(function (input, output) {
  output$map <- renderLeaflet({
  })
})
pal <- colorFactor(
  palette = "BuPu",
  domain = kebeles$UniT2012
)
shinyServer(function(input,output) {
  output$map<- renderLeaflet({
    m <- leaflet()
    m <- m %>%
      addTiles()%>%
      addProviderTiles("CartoDB.Positron")%>%
      setView(36.776, 11.242, zoom = 10)
    m <- addPolygons(m, 
                     data = kebeles,
                     stroke = TRUE, 
                     smoothFactor = 0.2, 
                     fillOpacity = 1,
                     color = ~pal(kebeles$UniT2012),
                     popup = paste("Number of Awards: ", kebeles$UniT2012, sep="")) %>%
      addCircles(data=Schoolpoints,lat= ~Lat, lng = ~Lng, radius = 50, color = '#191970', 
                 label = Schoolpoints$`School Name`, popup=popupImage(Schoolpoints$photos))
  })
})

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
                  popup = paste(popupImage(kebelef$HVphotos), "<br>", "Kebele:", kebelef$Kebele))