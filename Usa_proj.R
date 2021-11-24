library("tidyverse") #For some preprocessing
library("dplyr") #For piping the data/some cleaning
library("ggplot2") #For static Visualisation
library("ggpubr") #For regression
library("broom") #For regression
library("tidyr") #For clean some dataset
library("plotly") #For interaction plot
library('stringr') #For data manipulation

#Set the working directory where usa cleaned dataset is located.
setwd("C:/Users/Gun_Sean/OneDrive/Desktop/R/Second semester/Fit 5147 project/Clean dataset")
options(scipen = 999)

#Import the usa clean csv,
usa <- read.csv("us_clean.csv",header = TRUE)



#extract usa necessary data by select the necessary column
usa_data <- usa %>% select(job_simp,avg_salary,seniority,job_state,Location)
usa_data

#Extract a job trend of USA using the summarise similar to the previous two files
#and remove all the white space as preparation from map creation (Talat,2016)
usa_city<-usa_data%>%group_by(job_state)%>%summarise(count=n())

#Remove the white space in job_state column (Divibisan,2018)
usa_city<-usa_city %>% mutate(job_state =str_squish(job_state))%>%mutate(hover=paste0(job_state,"\n",count, " jobs"))

#Cholopleth map plot derieved method from R Maps: Beautiful Interactive Choropleth & Scatter Maps with Plotly
#(2020)

usa_job_num <- plot_geo(usa_city,
                        locationmode='USA-states')%>%
  add_trace(locations=~job_state,z=~count,zmin=min(usa_city$count),
            zmax=max(usa_city$count),color=~count,text=~hover,
            hoverinfo='text',colorscale='Jet')%>%
  layout(geo=list(scope='usa'),title='Number of Data Science Job Posts in United States')
  

usa_job_num


#Identify top three states
usa_city[order(usa_city$count,decreasing = TRUE),][1:3,]

#Create the data frame with a count of job posts for top three states
usa_job<-usa_data%>%
  group_by(job_simp,job_state)%>%filter(job_state==" CA"|job_state==" VA"|job_state==" MA")%>%
  summarise(count=n())

usa_job

#count all the number of posts and import the file for the tableau visualisation
usa_posts <- usa%>%group_by(job_state,Location)%>%summarise(count=n())%>%mutate(Country="United States")
usa_posts
write.csv(usa_posts,"us_pos.csv",row.names = FALSE)

#count all the necessary skill for usa job
usa_skill <- usa %>% select(python,excel,hadoop,spark,aws,tableau,R,Scala,
                            SAS,Matlab,Stata,SPSS,Javascript,SQL,C,Java,Ruby,D3,Julia
                            ,Golang,Knime,F.,Fortran)%>%
  mutate(Count_skill=python+excel+hadoop+spark+aws+tableau+R+Scala+
           SAS+Matlab+Stata+SPSS+Javascript+SQL+C+Java+Ruby+D3+Julia
         +Golang+Knime+F.+Fortran)

Top_usa_skill<-usa %>% select(python,excel,hadoop,spark,aws,tableau,R,Scala,
                              SAS,Matlab,Stata,SPSS,Javascript,SQL,C,Java,Ruby,D3,Julia
                              ,Golang,Knime,F.,Fortran)

#Make the dataframe of the top 10 skill required for data science job in USA
Total_usa<-data.frame(name=colnames(Top_usa_skill),value=colSums(Top_usa_skill,na.rm = TRUE))
Total_usa<-Total_usa[order(Total_usa$value,decreasing = TRUE),][1:10,]


#Add column count skill and change seniority value so that the dataset can fit in the regression model
usa_data$count_skill <- usa_skill$Count_skill 
usa_data$seniority[usa_data$seniority=='senior']<-3
usa_data$seniority[usa_data$seniority=='junior']<-1
usa_data$seniority[usa_data$seniority=='na']<-2

usa_data$seniority<-as.numeric(usa_data$seniority)

#Check correlation #Insignificant correlation between IVs and Dv plot scatter plot instead (Bevans,2020)
us <- cor.test(usa_data$count_skill,usa_data$avg_salary,method="pearson")
us2 <- cor.test(usa_data$seniority,usa_data$avg_salary,method = "pearson")
us3 <- cor.test(usa_data$count_skill,usa_data$seniority,method="pearson")

us
us2
us3

#No multiple regression plot because there is not any significance relationship between predictors and 
#dependent variable

#plot graph


#Bar for skill trend in USA using reorder() (Jaap, 2014):
usa_skill10<-ggplot(Total_usa,aes(fill=name,x=reorder(name,-value),y=value))+geom_bar(stat = "identity")+
  scale_x_discrete(guide = guide_axis(check.overlap = TRUE))+
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))+
  labs(title = "Top 10 programming skills for data science in USA",fill="Skills")+
  xlab("Skills")

#Make the graph interactive with ggplotly():
usa_skill10 <- ggplotly(usa_skill10)


#Visualisation for USA top three states data science job posts
usa_top3<-ggplot(usa_job,aes(fill=job_state,y=count,x=job_simp))+
  geom_bar(position="dodge",stat="identity")+
  scale_x_discrete(guide = guide_axis(check.overlap = TRUE))+
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))+
  labs(title = " Data science job trend in Top 3 USA States")+
  xlab("Job Lists")

#Make the graph interactive
usa_top3<-ggplotly(usa_top3)

#Reference:
#Bevans, R. (2020, February 20). An introduction to multiple linear regression. 
#https://www.scribbr.com/statistics/multiple-linear-regression/
#Bevans, R. (2020, February 25). A step-by-step guide to linear regression in R. 
#https://www.scribbr.com/statistics/linear-regression-in-r/
#Choropleth Maps in R (n.d.). https://plotly.com/r/choropleth-maps/
#Divibisan (2018, August 7). How to remove all whitespace from a string?
#https://stackoverflow.com/questions/5992082/how-to-remove-all-whitespace-from-a-string
#Jaap (2014, September 4). Reorder bars in geom_bar ggplot2 by value.
#https://stackoverflow.com/questions/25664007/reorder-bars-in-geom-bar-ggplot2-by-value
#R Maps: Beautiful Interactive Choropleth & Scatter Maps with Plotly. (2020, October 1). [Video]. 
#YouTube. https://www.youtube.com/watch?v=RrtqBYLf404
#Talat.(2016,January 18). Count number of rows by group using dplyr. 
#https://stackoverflow.com/questions/22767893/count-number-of-rows-by-group-using-dplyr

