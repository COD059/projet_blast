library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(shinyjs)
library(httr)
library(rjson)
#library(jsonlite)

ui <- dashboardPage(
  
  
  dashboardHeader(title = "Biosearch"),
  dashboardSidebar(
    width = 0
  ),
  dashboardBody(
    tags$head(tags$script(src = 'app.js')),
    tags$head(tags$link(src="style.css")),
    box(title = "Search", status = "primary",height = "250" 
        ,solidHeader = T,
        uiOutput("search_plot")),
    box( title = "Result", status = "primary", height = "540px",solidHeader = T, 
         uiOutput("wep_page"))
    ))

server <- function(input, output) 
{ 
  output$search_plot <- renderUI({tagList(
    selectInput(inputId = "db", label = "DataBase",choices = list("Europe PMC" = 'europepmc', "UniProt KB" = 'uniprot'), selected = 1),
    textInput("keywords",label = "Keywords"),
    actionButton(inputId = "searchbtn", "Search",width = "100%")
  )
    
  })
  df<-eventReactive(input$searchbtn,{
    db<-input$db
    keys<-input$keywords
    if(db=="europepmc"){
      ebiSearchBaseURL <- "https://wwwdev.ebi.ac.uk/ebisearch/ws/rest/europepmc"
      res<-GET(ebiSearchBaseURL,query=list(size=20,
                                           query=toString(keys),
                                           fieldurl='true',
                                           fields="name",
                                           format="json"))
      txtcon<-content(res,as="text",encoding = "UTF-8")
      jsoncon<-fromJSON(txtcon)
      htmltxt<-"<ul class='list-group list-group-flush' style='height: 480px; overflow: auto'>"
      for(el in jsoncon$entries){
        title<-el$fields$name
        for(sousel in el$fieldURL){
          url<-sousel$value
        }
        
       
        a<-tags$a(href=url, title,target='_blank')
        htmltxt<-paste(htmltxt,"<li class='list-group-item'>",sep='')
        htmltxt<-paste(htmltxt,a,sep='')
        htmltxt<-paste(htmltxt,"</li>",sep='')
      }
      htmltxt<-paste(htmltxt,"</ul>",sep='')
      HTML(htmltxt)
    }
    else if (db=="uniprot") {
       ebiSearchBaseURL <- "https://wwwdev.ebi.ac.uk/ebisearch/ws/rest/uniprot"
      res<-GET(ebiSearchBaseURL,query=list(size=20,
                                           query=toString(keys),
                                           fieldurl='true',
                                           fields="descRecName,id",
                                           format="json"))
      txtcon<-content(res,as="text",encoding = "UTF-8")
      jsoncon<-fromJSON(txtcon)
      htmltxt<-"<ul class='list-group list-group-flush' style='height: 480px; overflow: auto'>"
      for(el in jsoncon$entries){
        title<-el$fields$descRecName
        title<-paste(title,el$fields$id,sep = " ")
        for(sousel in el$fieldURL){
          url<-sousel$value
        }
        a<-tags$a(href=url, title,target='_blank')
        htmltxt<-paste(htmltxt,"<li class='list-group-item'>",sep='')
        htmltxt<-paste(htmltxt,a,sep='')
        htmltxt<-paste(htmltxt,"</li>",sep='')
      }
      htmltxt<-paste(htmltxt,"</ul>",sep='')
      HTML(htmltxt)
    }
    
  })
  output$wep_page <- renderUI({
    df()
  })
}
shinyApp(ui, server)