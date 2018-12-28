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
  output$cancer_years <- renderPlot({
    narrowed_data <- narrow_dataset(input$gender, input$type_of_cancer)
    ggplot(data = narrowed_data) +
      geom_point(mapping = aes(x = narrowed_data$rok, y = narrowed_data$x, 
                               color = narrowed_data$plec))
  })
  
}

shinyApp(ui = ui, server = server)