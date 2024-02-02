# user interface ----
ui <- navbarPage( # where we'll establish important webpage components
  
  title = "LTER Animal Data Explorer",
  
  #(Page 1) intro tabPanel ----
  tabPanel(
    title = "About this Page",
    
    # intro text fluidRow 
    fluidRow(
      column(1), #adding blank columns for buffer room alongside text
      column(10, includeMarkdown("text/about.md")), #referencing the text from our markdown file
      column(1)
      
    ), # END intro text fluidRow 
    
    hr(), #adds a grey line
    
    includeMarkdown("text/footer.md")
    
  ), # END (Page 1) intro tabPanel
  
  #(Page 2) data viz tabPanel ----
  tabPanel(
    title = "Explore the Data",
    
    #tabsetPanel to contain tabs for data viz ----
    tabsetPanel(
      
      # trout tabPanel ----
      tabPanel(title = "Trout",
               # Trout sidebarLayout ----
               sidebarLayout(
                 # trout sidebarPanel ----
                 sidebarPanel(
                   
                   # channel type pickerinput ----
                   pickerInput(inputId = "channel_type_input",
                               label = "Select channel type(s):",
                               choices = unique(clean_trout$channel_type),
                               selected = c("cascade", "pool"),
                               options = pickerOptions(actionsBox = TRUE),
                               multiple = TRUE), #can select multiple options from the picker option
                   
                   # section checkboxGroupButtons ----
                   checkboxGroupButtons(inputId = "section_input",
                                             label = "Select a sampling section",
                                             choices = c("clear cut forest", "old growth forest"), #list of choices as options
                                             selected = c("clear cut forest", "old growth forest"), #default selected values
                                             individual = FALSE, 
                                             justified = TRUE, 
                                             size = "sm", #width of button r full width of sidebarpanel
                                            checkIcon = list( yes = icon("check"), #adding icons from fontawesome lib to buttons
                                                              no = icon("xmark")) #can search fontawesome for these icons
                                             )
                   
                 ), # END trout sidebar panel
                 # trout mainpanel ----
                 mainPanel(
                   # trout scatterplot output ----
                   
                   plotOutput(outputId = "trout_scatterplot_output") %>% 
                     withSpinner(color = "magenta", type = 1)
                   
                 ) # END trout mainPanel
               ) # END trout sidebarLayout
      ), # END trout tabPanel
      
      # penguin tabPanel ----
      tabPanel(title = "Penguins",
               
               # Penguin sidebarLayout ----
               sidebarLayout(
                 # penguin sidebarPanel ----
                 sidebarPanel(
                   
                   # channel type pickerinput ----
                   pickerInput(inputId = "island_type_input",
                               label = "Select an island:",
                               choices = unique(penguins$island),
                               selected = c("Torgersen", "Biscoe", "Dream"),
                               options = pickerOptions(actionsBox = TRUE),
                               multiple = TRUE), #can select multiple options from the picker option
                   
                   # bins slider input ----
                   sliderInput(inputId = "bin_input", 
                               label = "Select number of bins:",
                               min = 1, 
                               max = 100,
                               value = c(1,25))
                   
                 ), # END penguin sidebarPanel
                # penguin mainpanel ----
                mainPanel(
                  plotOutput(outputId = "penguin_hist_output") %>% 
                    withSpinner(color = "green", type = 5) #adding loading spinner
                ) # END penguin mainPanel
               ) # END penguin sidebarLayout
               ) # END penguin tabPanel
    ) # END tabsetPanel
    
  ) # END (Page 2) data viz tabPanel
  
  
) # END navbarpage
