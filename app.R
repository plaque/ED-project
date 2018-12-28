library(shiny)
source("zachorowania.R")
ui <- fluidPage(
  
  selectInput(inputId = "gender", label = "Gender", choices = c("All", "M", "F")),
  selectInput(inputId = "type_of_cancer", label = "Type of cancer", 
              choices = sort(unique(sickness$placement))),
  selectInput(inputId = "county", label = "County", choices = levels(sickness$countys)),
  plotOutput("cancer_years")
)

server <- function(input, output) {
  output$cancer_years <- renderPlot(
    plot(sick$year,sick$x, 'l')
  )
  
}

shinyApp(ui = ui, server = server)