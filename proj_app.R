#------Please read this line before the app execution------
#Before running this shiny dashboard web app, please run the previous 3 files Aus_proj,Uk_proj,and Usa_proj
#r script with all the necessary dataset(csv.file) on the work directory
#The plot may take a few seconds to appear.

library('shiny') #For running the web app
library('shinydashboard') #For creat a dashboard environment


#The template for create the UI and Server for dashboard derived from https://rstudio.github.io/shinydashboard/
#Design the UI for the sidebar and the main body of the dash
ui<- dashboardPage(#Put the header,sidebar and body of the ui
  dashboardHeader(title='Data Science Job Trends',titleWidth = 300),
  dashboardSidebar(width=300,
    sidebarMenu(#Create a sidebar tab for the visualisation
      menuItem("Project Description",tabName = "Description"),
      menuItem("Job Trends", tabName = "jobtrends"),
      menuItem("Salary Prediction", tabName = "salaryprediction"),
      menuItem("Skill Trends", tabName = "skilltrends")
    )
  ),
  dashboardBody(
    tabItems(#Create the item which appear once the tab is clicked.this will show different header with text and some paragraph
      tabItem(tabName = "Description",#Title page
              h2("The Trend of Data Science Job Posts in Australia and Other countries on 2021 by
                 Napoj Thanomkul"),br(),
              h3("Introduction and Motivation:"),br(),
              p("As an individual who start a journey in a data science field, I am interest in finding out about the trend of 
data science job posting in many different countries. Also, I would like to explore what are the relevant skills require 
for a certain data science job in different countries, and I want to identify the factors that predict the salary for data 
science career. By doing this topic, it will be beneficial for my preparation for data science job application in the 
future and I think it will help me in choosing what kind of skill I need to improve for this field. As mentioned above, 
I decide to identify differences in job posting trends between Australia and other countries.
"),br(),h3("Question:"),br(),p("1. What is the different in the trend of data science jobs posting in each country?"),br(),
p("2. What are the factors predicting the estimated salary of the data science jobs in each country?"),br(),
p("3. What is the trend of relevant skills require for a specific data science job in each country?"),br(),
p("Which will be answered separatly by each tabs on the sidebar"),br(),
h3("Data Sources and references"),br(),p("Nomilk. (2021, July 24). Data Science Job Listings - Australia - 2019-2021. 
https://www.kaggle.com/nomilk/datascience-job-listings-australia-20192020?select=listings2019_2021.csv,Tabular Data (csv file): 1458 rows x 52 columns, the dataset is provided with geospatial/location data and 
                                        textual format data."),br(),
p("Rahman, R. (2021, March 9). Data Science Job Posting on Glassdoor. 
https://www.kaggle.com/rashikrahmanpritom/data-science-job-posting-onglassdoor?select=Cleaned_DS_Jobs.cs, Tabular Data (csv file): 661 rows x 27 columns, the dataset is provided with geospatial/location data and 
                                        textual format data."),br(),
p("Clarke, M. (2021, February 8). UK Data Science Jobs dataset. https://www.kaggle.com/devario/uk-data-sciencejobs-dataset?select=deduped-jobs.csv
,Tabular Data (csv file): 596 rows x 14 columns, the dataset is provided with geospatial/location data and 
                                        textual format data. "),br(),
p("Shape File of Australia'States(https://raw.githubusercontent.com/rowanhogan/australian-states/master/states.geojson)")
      ),

              
      tabItem(tabName = "jobtrends",#Second tab which including the drop down bar using selectInput()
              h2("Data Science Job Trends by each countries' states/cities"),
              br(),selectInput("title", "Country:", choices = c("Please Select Country","Australia", "United States","United Kingdom")),
              textOutput("info"),
              tags$head(tags$style("#info{color: black;#Change the font style of the text (Jdharrison,2014)
                                 font-size: 16px;
                                 }")),
              br(),#Plot two graph in the main body side-by-side (MLavoie,2015)
              splitLayout(cellWidths = c("50%", "50%"), plotlyOutput("plot"), plotlyOutput("plot2")),
              textOutput("info1")),
      tabItem(tabName = "salaryprediction",
              h2("Salary Prediction"),
              br(),textOutput("info2"),
              br(),#Plot two graph in the main body side-by-side (MLavoie,2015)
              splitLayout(cellWidths = c("50%", "50%"), plotlyOutput("plot3"), plotlyOutput("plot4")),
              br(),
              textOutput("info3"),
              br(),
              textOutput("info4"),br(),
              textOutput("info5"),br(),
              textOutput("info6"),
              tags$head(tags$style("#info{color: black;#(Jdharrison,2014)
                                 font-size: 18px;
                                 }"))),
      tabItem(tabName = "skilltrends",
              h2("Trends of Data Science Skills by each countries"), #Same procedure as the first tab
              br(),selectInput("title2", "Country:", choices = c("Please Select Country","Australia", "United States","United Kingdom")),
              textOutput("info7"),
              tags$head(tags$style("#info{color: black;#(Jdharrison,2014)
                                 font-size: 16px;
                                 }")),
              br(),
              plotlyOutput("plot5"),
              textOutput("info8"),br(),
              textOutput("info9"))
)))

#Create a server function to make the output appear
server <- function(input,output){
  #For making the plot change according to the drop-down selection the observeEvent is used along with ifelse funtion
  #(Amrrs,2018). Doing the same process for the tab 1 and tab3
  #Tab 1 chunks. For example in the first chunk if the drop down is a ountry name it will show the plot based on the
  #Selected country. If the selected option is Please select country it will show nothing.
  observeEvent(input$title,{
    if(input$title == 'Australia') output$plot <- renderPlotly(aus_job_posts)
    else if (input$title == 'Please Select Country') output$plot <- NULL
    else if (input$title == 'United Kingdom') output$plot <- renderPlotly(uk_job_posts)
    else output$plot <- renderPlotly(usa_job_num)
    
  })
  observeEvent(input$title,{
    if(input$title == 'Australia') output$plot2 <- renderPlotly(Top_aus_states)
    else if (input$title == 'Please Select Country') output$plot2 <- NULL
    else if (input$title == 'United Kingdom') output$plot2 <- renderPlotly(top_city_uk)
    else output$plot2 <- renderPlotly(usa_top3)
    
  })
  
  observeEvent(input$title,{
    if(input$title == 'Australia') output$info <- renderText({ "These visualisation are
      Cholopleth Map of Australia with number of job posts by each states and a bar chart of job posts number by 
      the top three states and the job types:"})
    
    else if (input$title == 'Please Select Country') output$info <- renderText({"Instruction:
      Please select the country you want to see the number of job posts by the states/cities.
      After selection, two visualisations will appear. The first one on the left is an interactive 
      Cholopleth/Bubble map of the selected country which show the number of job posts by each states/cities, 
      while another one is a barchart showing the type of jobs with number of posts by the top three states
      or cities which posts the most jobs. 'Note: The graph is interactive so you can use a mouse to move on
      them, they will show numbers of job posts and name of states/cities on the map, and number of job posts
      and job name on the bar graph. In addition, you can zoom in/out of the plot with the tool bar on
      the upper-right side of these two plots(it's may take a few seconds to show up)'."})
    
    else if (input$title == 'United Kingdom') output$info <- renderText({ "These visualisation are
      Bubble Map of United Kingdom with number of job posts by each cities and a bar chart of job posts number by 
      the top three cities and the job types:"})
    
    else output$info <- renderText({ "These visualisation are
      Cholopleth Map of United States with number of job posts by each cities and a bar chart of job posts number by 
      the top three cities and the job types:"})
    
  })
  
  observeEvent(input$title,{
    if(input$title == 'Australia') output$info1 <- renderText({"Interesting Finding: The top three states 
    which have a highest demand in this job field are the following: 
    1. New South Wales 293 posts, 2. Victoria 221 posts, and 3. Queensland 77 posts. Based on the chart, 
    the most demand position is data scientist position. This result is followed by other 
    related data science job and data analyst position. However, this result is not the case for Queensland, because the 
      third on demand job for Queensland is data engineer."})
    
    else if (input$title == 'Please Select Country') output$info1 <- NULL
    
    else if (input$title == 'United Kingdom') output$info1 <- renderText({"Interesting Finding: The city which have highest on demand job is London followed by Manchester 
and Bristol. The highest on demand job in London is other data science related job, following by data scientist and 
data engineer. For Manchester, the highest and the second highest on demand are the same as London, but the third 
job on demand is data science manager position. For Bristol, the highest on demand position is the same as other 
two cities following by lead and manager position, and data scientist position."})
    
    else output$info1 <- renderText({ "Interesting Finding: USA’s states which have the top three highest 
    number of job post are CA (165 posts), MA(85 posts) and VA(62 posts). For CA and VA, the highest on demand job is data scientist 
    which is followed by data engineer and data analyst. On the contrary, MA highest demand position is data scientist, 
    other data science related job , and machine learning related job."})
    
  })
  #Tab 2
  #the output without observeEvent will be the static interactive plot without any change from the conditions
  #This is chunk is for tab2
  output$info2 <- renderText({ "These visualisation are
      the scatter plot of multiple regression of Australia and United Kingdom Regarding 
    the salary prediction based on number of skills and seniority level:"})
  
  output$plot3 <-renderPlotly(salary_plot_aus)
  output$plot4 <-renderPlotly(salary_plot_uk)
  
  output$info3 <- renderText({ "According to these two following graphs, here is the result:"})
  output$info4 <- renderText({"Australia: The significant relationship between level of seniority and average salary of Australia data science job was found (p<0.05). 
    This can be implied that 36.2% average salary will increase for every 1% 
    increase in seniority level."})
  output$info5<-renderText({"UK:The significant relationship between level of seniority and average salary were found (p<0.05). 
    This can be implied that5% average salary will increase for every 5% increase in seniority level."})
  output$info6<-renderText({"Therefore, the skill number is not a factor that predict the salary, and both skill numbers and
    seniority is not the factor that predict salary for United States.
    In addition, this is just a prediction with a pretty small r-square so the result may not entirely
    true due to the error in prediction."})
  
  #Tab3,Same procedure describe above for tab1 
  observeEvent(input$title2,{
    if(input$title2 == 'Australia') output$plot5 <- renderPlotly(Top_10_aus)
    else if (input$title2 == 'Please Select Country') output$plot5 <- NULL
    else if (input$title2 == 'United Kingdom') output$plot5 <- renderPlotly(top_10_uk)
    else output$plot5 <- renderPlotly(usa_skill10)
    
  })
  
  observeEvent(input$title2,{
    if(input$title2 == 'Australia') output$info7 <- renderText({ "This visualisation is
      a bar chart of top 10 data science skills for data science job in Australia:"})
    
    else if (input$title2 == 'Please Select Country') output$info7 <- renderText({"Instruction:
      Please select the country you want to see the top 10 skills required for data science job by
      the selected country"})
    
    else if (input$title2 == 'United Kingdom') output$info7 <- renderText({ "This visualisation is
      a bar chart of top 10 data science skills for data science job in United Kingdom:"})
    
    else output$info7 <- renderText({ "This visualisation is
      a bar chart of top 10 data science skills for data science job in United States"})
    
  })
  
  observeEvent(input$title2,{
    if (input$title2 == 'Please Select Country') output$info8 <- NULL
    else output$info8 <- renderText({ "Summarise:"})
    
  })
  
  observeEvent(input$title2,{
    if (input$title2 == 'Please Select Country') output$info9 <- NULL
    else  output$info9 <- renderText({ "the most on demand skill in data science job for Australia and 
USA is Python, while the highest on demand skill in UK is C. The second on demand skill is SQL for 
Australia and USA but this is not the case in UK which demand python as the second highest on demand skill.
For the third highest on demand skill, they varied differently in these three countries. For instance, 
Australia require SAS as the third highest on demand skill, whereas USA demand excel skill and UK demand SQL. 
For the rest of the skills, it seems that Tableau,Java, Excel and Spark are on demand for 
these three countries. At the same time, there is some unique skills require differently 
in each country. For example, AWS and Scala did not appear as top ten on demand skill for 
Australia, while R and Matlab did not appear in USA and UK. Also, Hadoop and SAS only on demand in Australia 
and USA but not UK, and javascript is on demand only in UK.
"})
    
  })
  
  
  
}
#Run the app after the UI and Server is created
shinyApp(ui,server)

#Refrences:
#Amrrs. (2018,February 15). RShiny Generating Dropdown Menu for Plotly Charts - using subelements.
#https://stackoverflow.com/questions/48805897/rshiny-generating-dropdown-menu-for-plotly-charts-using-subelements
#Jdharrison. (2014,June 5). Change the color and font of text in Shiny App.
#https://stackoverflow.com/questions/24049159/change-the-color-and-font-of-text-in-shiny-app
#MLavoie (2015,December 21). How can put multiple plots side-by-side in shiny r?
#https://stackoverflow.com/questions/34384907/how-can-put-multiple-plots-side-by-side-in-shiny-r/34392254
#Shinydashboard (n.d.). https://rstudio.github.io/shinydashboard/