# load packages ----
library(shiny)
library(palmerpenguins)
library(tidyverse)
library(DT)

# user interface ----
ui <- fluidPage( #establishing the webpage of our UI
  # app title ----
  tags$h1("My App Title"), #h1 indicates a level 1 header
  
  # app subtitle,
  h4(strong("Exploring Antarctic Penguin Data")), #h4 indicates a level 4 header and strong means bold
  
  # body mass slider input ---- #creating a slider widget
  sliderInput(inputId = "body_mass_input", 
              label = "Select a range of body masses (g):",
              min = 2700, #could use min/max functions to grab the values too
              max = 6300,
              value = c(3000,4000)), #initial starting values slider defaults to when opening app
  plotOutput(outputId = "bodyMass_scatterplot_output"), #creating placeholder where plot will live with a plot names "bodyMass_scatterplot_output"
  
  # create checkbox year input ----
  checkboxGroupInput(
    inputId = "year_input" ,
    label = "Select Year(s)" ,
    choices = c("2007", "2008", "2009"),
    selected = c("2007", "2008")
  ),
  
  # creating DT output ----
  DT::dataTableOutput(outputId = "year_table_output")
) 

# create server ----
server <- function(input, output) {
  
  # filter body masses ----
  body_mass_df <- reactive({ #creating a reactive input using reactive()
    penguins %>% 
      filter(body_mass_g %in% c(input$body_mass_input[1]:input$body_mass_input[2])) #1 indicates the value applied by the lower slider and 2 indicates the value applied by the upper slider
  })
  # render penguin scatterplot ----
  output$bodyMass_scatterplot_output <- renderPlot({ #generating plot to be displayed
    
    #add ggplot code here
    ggplot(na.omit(body_mass_df()), #need to add () at the end of df for a reactive plot
           aes(x = flipper_length_mm, y = bill_length_mm, color = species, shape = species)) +
      geom_point() +
      scale_color_manual(values = c("Adelie" = "darkorange", "Chinstrap" = "purple", "Gentoo" = "cyan4")) + #assigning the species to colors so they don't change with sliders changing
      scale_shape_manual(values = c("Adelie" = 19,"Chinstrap" = 17, "Gentoo" = 15)) +
      labs(x = "Flipper Length (mm)", y = "Bill Length (mm)", color = "Penguin Species", shape = "Penguin Species") +
      theme_minimal() +
      theme(legend.position = c(0.85, 0.2),
            legend.background = element_rect(color = "white"))
    
  })
  
  #filter for years ----
  year_table <- reactive({
    penguins %>% 
      filter(year %in% c(input$year_input))
  }) 
   
  # render datatable ----
  output$year_table_output <- renderDataTable({ 

    #add code here
    DT::datatable(year_table())
})
  
}

# combine UI & server into app ----
shinyApp(ui = ui, server = server)