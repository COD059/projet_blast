library(ggplot2)
library(gdata)
library(dplyr)
library(rBLAST)
library(stringr)
function(input, output) {
  test <- data.frame(QueryID="",	SubjectID=""	,Perc.Ident=""	,Alignment.Length="",Mismatches=""	,Gap.Openings="",Q.start=""	,Q.end=""	,S.start="",S.end="",EBits="")
  output$table <- DT::renderDataTable(DT::datatable({
    data <- test
    data}))
  observeEvent(input$btn_blast, {
    if (!is.null(input$file)) {
      seq <- readAAStringSet(input$file$datapath )
      names(seq) <-  sapply(strsplit(names(seq), " "), "[", 1)
      bl <- blast(db="./refseq_protein.00/refseq_protein.00",type = "blastp")
      cl <- predict(bl, seq[1,])
      cl <- dplyr::filter(cl,  Perc.Ident > input$slider2[1] && Perc.Ident < input$slider2[2])
      output$table <- NULL
      output$table <- DT::renderDataTable(DT::datatable({
        data <- cl
        data
      }))
      if (!is.null(length(cl))) {
        output$graphique1 <- renderPlot({hist(cl$Perc.Ident,col = "black",xlab = "Pourcentage de similarite ",main = "Repartition des pourcentages de similarites",border = "white")})
        output$graphique2 <- renderPlot({hist(cl$Alignment.Length,col = "black",xlab = "Alignement Lenght",main = "Repartition des longueurs d'alignements",border = "white")}) 
      }
    }
  })
  observeEvent(input$btn_expo, {
    if (!is.null(input$file)) {
    showNotification("Resultat exporter avec succes",type = "message",duration = 7)
    write.csv2(cl,str_c(input$file$name,".csv"))
    }else{
      showNotification("Aucune donnees a exporter !",type = "error",duration = 7) 
    }
  })
}
