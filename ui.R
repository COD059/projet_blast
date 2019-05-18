
library(ggplot2)
library(shiny)
fluidPage(
  titlePanel("Basic Local Alignement Search Tool"),
  hr(),
  fluidRow(
    column(4,
           fileInput("file", label = h4("Import sequence"),multiple = FALSE,accept = c(".fasta"))
    )
  ),
  fluidRow(
    column(4,sliderInput("slider2", label = h3("Pourcentage de similarite"), min = 0, max = 100, value = c(0, 100))),
    column(8,
           actionButton("btn_blast", "Blast",style="color: #fff; background-color: #337ab7;width: 180px;margin-left: 80%;margin-top:95px")
    )
  ),
  fluidRow(
    column(12,
           actionButton("btn_expo", "Export csv",style="color: #fff; background-color: #555555;width: 180px;margin-left:87%;")
    )
  ),
  
  # Create a new row for the table.
  DT::dataTableOutput("table"),
  fluidRow(
    column(6,plotOutput(outputId = "graphique1")),column(6,plotOutput(outputId = "graphique2")))
)
