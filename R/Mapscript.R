library("googlesheets")
library("leaflet")
library("shiny")
library("rgdal")
library("raster")

sheet<- gs_key('1hT9JHKGhKR1QcUDB8ylylURmgxoIkylLd4SF9zqdTVo')
kebele<-shapefile("inst/extdata/kebeles.shp")
#adding columns
cnames<- c("UniT","HV_Homes", "HV_Wells", "HV_Pipedw", "HV_Floors", "HV_Roofs", "HV_Solar", "HV_Latrines", "HV_p", "HV_p1", "HV_p2")

#Creating School points
Schoolpoints<- sheet %>% gs_read(ws = 1, range = "A1:D8")

#Adding data to shapefile
UniT<- sheet %>% gs_read(ws = 2, range = "A1:B34")
UniT<- as.data.frame(UniT)
kebele$UniT<-UniT
plot(kebele)

HV<- sheet %>% gs_read(ws = 3, range = "A1:I34")
HV<- as.data.frame(HV)
kebele<-merge(kebele@data,HV)
head(kebele)
class(kebele)
EconOpp<- sheet %>% gs_read(ws = 4, range = "A1:D8")



m <- leaflet() %>%
  addTiles('https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png') %>%
  setView(36.776, 11.242, zoom = 8)
 
m
