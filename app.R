#App deploy
#rsconnect::deployApp('/home/plaque/workspace/ed/ED-project')
library(shiny)
library(ggplot2)
library(rgeos)
library(maptools)
source("zachorowania.R")
ui <- fluidPage(
  
  selectInput(inputId = "gender", label = "Gender", choices = c("All", "M", "F")),
  selectInput(inputId = "type_of_cancer", label = "Type of cancer", 
              choices = sort(unique(sickness$placement))),
  selectInput(inputId = "voivodeship", label = "County", choices = levels(sickness$voivodeship)),
  plotOutput("cancer_years"),
  selectInput(inputId = "year", label = "Year", choices = sort(unique(sickness$rok))),
  plotOutput("county_map"),
  plotOutput("bar_plot_sick")
)

server <- function(input, output) {
  output$cancer_years <- renderPlot({
    narrowed_data <- narrow_dataset(input$gender, input$type_of_cancer, input$voivodeship)
    narrowed_data <- aggregate(narrowed_data$SUM_of_liczba, by=list(rok=narrowed_data$rok, 
                                                                    plec=narrowed_data$plec), FUN=sum)
    ggplot(data = narrowed_data) + 
      geom_point(mapping = aes(x = narrowed_data$rok, y = narrowed_data$x, 
                               color = narrowed_data$plec)) + 
      scale_colour_discrete(name="Gender") +
      xlab("Year") +
      ylab("Number of diagnosed cases")
  })
  
  output$county_map <- renderPlot({
    narrowed_data <- narrow_dataset(input$gender, input$type_of_cancer, year=input$year)
    narrowed_data <- aggregate(narrowed_data$SUM_of_liczba, by=list(voivodeship=narrowed_data$voivodeship), FUN=sum)
    woj_map.gg <- merge(woj_map.gg, narrowed_data, by.x="id", by.y="voivodeship", sort=FALSE)
    map <- ggplot() +
      geom_polygon(data = woj_map.gg, 
                   aes(long, lat, group = group, 
                       fill = x), 
                   colour = "black", lwd=0.1) +
      labs(title = paste(input$year, input$type_of_cancer, ""), x = "E", y = "N", fill = "Number of diagnosed cases grouped by voivodeship") + 
      theme(plot.title = element_text(hjust = 0.5))
    map + scale_fill_gradient(low = "white", high = "red")
  })
  
  output$bar_plot_sick <- renderPlot({
    narrowed_data <- narrow_dataset(input$gender, input$type_of_cancer, year=input$year)
    narrowed_data <- aggregate(narrowed_data$SUM_of_liczba, by=list(voivodeship=narrowed_data$voivodeship), FUN=sum)
    ggplot(data = narrowed_data, aes(x = narrowed_data$voivodeship, y = narrowed_data$x, fill = narrowed_data$voivodeship)) + 
      scale_fill_discrete(name="Voivodeship", guide=FALSE) +
      geom_bar(stat = "identity") +
      geom_text(aes(label=narrowed_data$x), vjust=-0.3, size=3.5) +
      labs(title = paste(input$year, input$type_of_cancer, "")) +
      theme(plot.title = element_text(hjust = 0.5)) +
      xlab("Voivodeship") +
      ylab("Number of diagnosed cases")
  })
}

shinyApp(ui = ui, server = server)