install.packages("leaflet")
install.packages("odbc")
install.packages("DBI")
install.packages("taskscheduleR")


library(taskscheduleR)
library(odbc)
library(leaflet)
library(DBI)

getwd()

con <- DBI::dbConnect(drv = odbc::odbc(),
                      Driver = "SQL Server",
                      Server = "DESKTOP-26BSLL4",
                      Database = "Mapas")

a <- DBI::Id(
  table   = "LatLong3"
)
ds <- DBI::dbReadTable(con, a)
DBI::dbDisconnect(con)

attach(ds)

OtterIcon <- makeIcon(
  iconUrl = "OtterPointer.png",
  iconWidth = 35, iconHeight = 35,
  iconAnchorX = 17, iconAnchorY = 34)

content <- paste(sep = "",
                 "<i><center><b>","   ", Cidades, "</b></center></i>",
                 "<br/>",
                 "<b>Habitantes: </b>", Habitantes,
                 "<br/>",
                 "<b>Área Total: </b>", Área.total, " km²",
                 "<br/>",                 
                 "<b>PIB: </b> R$ ", PIB, " mil",
                 "<br/>",
                 "<b>PIB per capita: </b>R$ ", PIB.per.capita,
                 "<br/>"#,
                 #"<b>Latitude: </b>", LatitudeGraus,
                 #"<br/>",
                 #"<b>Longitude: </b>", LongitudeGraus
)

leaflet() %>%
  addProviderTiles(providers$CartoDB.Voyager) %>%
  #addTiles()%>%
  addMarkers(lng = Longitude ,lat = Latitude,
             popup = content ,
             label = Cidades,
             icon = OtterIcon)  %>% 
  groupOptions("detail", zoomLevels = 7:18)

