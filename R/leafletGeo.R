##' @title Create a sp object from a data.frame
##'
##' @description Function for creating a sp object from a data.frame and
##' mapType
##'
##' @usage
##' leafletGeo(mapName, dat = NULL, namevar = NULL, valuevar = NULL)
##'
##' @param mapName mapName for loading, eg. 'china', 'city', ...
##' @param dat a data.frame contain regions and values
##' @param namevar show which feature is chosen for name variable
##' @param valuevar show which featue is chosen for value variable
##'
##'
##' @examples
##' if(require(leaflet)){
##'   dat = data.frame(regionNames("china"),
##'                                 runif(34))
##'   map = leafletGeo("china", dat)
##'
##'    pal <- colorNumeric(
##'      palette = "Blues",
##'      domain = map$value)
##'
##'   leaflet(map) %>% addTiles() %>%
##'      addPolygons(stroke = TRUE,
##'      smoothFactor = 1,
##'      fillOpacity = 0.7,
##'      weight = 1,
##'      color = ~pal(value),
##'      popup = ~htmltools::htmlEscape(popup)
##'      ) %>%
##'    addLegend("bottomright", pal = pal, values = ~value,
##'                         title = "legendTitle",
##'                  labFormat = leaflet::labelFormat(prefix = ""),
##'                  opacity = 1)
##' }
##' @export
leafletGeo = function(mapName,
                      dat = NULL,
                      namevar = NULL,
                      valuevar = NULL){
  countries <- readGeoLocal(mapName)
  countries$popup = countries$name
  # if(.Platform$OS.type == "windows"){
  #   countries$popup = encodingSolution(countries$popup)
  # }

  if(is.null(dat)){
    return(
      countries
    )
  }else{
    if(class(dat) != 'data.frame'){
      stop("dat should be a data.frame")
    }
    if(is.null(namevar)){
      name = dat[, 1] %>% toLabel()
    }else{
      name = evalFormula(namevar,dat)
    }
    name = as.character(name) %>% toLabel()

    if(is.null(valuevar)){
      value = dat[, 2]
    }else{
      value = evalFormula(valuevar,dat)
    }
    countries <- readGeoLocal(mapName)
    countries$label = toLabel(countries$name)
    index = sapply(countries$label,function(x) which(name==x)[1])
    countries$value = value[index]
    countries$popup = countries$name
    return(
      countries
    )
  }
}

