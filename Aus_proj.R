library("tidyverse") #For some preprocessing
library("dplyr") #For piping the data/some cleaning
library("ggplot2") #For static Visualisation
library("ggpubr") #For regression
library("broom") #For regression
library("tidyr") #For clean some dataset
library("plotly") #For interaction plot
library("sf") #Shapefile handling


#Set the workind directory to where the file is stall
getwd()
setwd("C:/Users/Gun_Sean/OneDrive/Desktop/R/Second semester/Fit 5147 project/Clean dataset")
options(scipen = 999)

#Read the clenead Australia Dataset
aus <- read.csv("aus_clean.csv",header = TRUE)

#Print all the column names for feature selection
print(colnames(aus))


#Create new column (Average salary by mutate())
aus <- aus %>% mutate(Average_salary = (min_salary + max_salary)/2)

#Select the column and using grepl with filter to match where the column rows got 
#a certain string. In this case, we choose the 2021 to only get the column of year 2021 job post only 
#(Lathiya ,2021). Then choose all the necessary column for the project
aus_data <- aus %>% select(job_simp,Average_salary,seniority,salary_per_year,first_seen,state,city)%>%
  filter(grepl("2021",first_seen))



#Trend of Data Job in Australia by each states is extracted by using the combination of group_by
#on state column and count each states within the dataframe with summarise(count=n()) from dplyr library 
#(Talat,2016)
aus_city <- aus_data %>% group_by(state)%>%summarise(count=n())
aus_city2<-aus_city[-3,]


#Choropleth map plot using the shape file 
#The method derieved from https://plotly-r.com/maps.html(n.d.) and (Jumble,2020)

#Getting Geojson data for Australia States:
aus_states <-  read_sf("https://raw.githubusercontent.com/rowanhogan/australian-states/master/states.geojson")

#Getting relevant Australia polygon to merge with our dataframe which contain number of job posts
aus_city2 <- aus_states %>% dplyr::left_join(aus_city2, by=c("STATE_NAME" = "state"))
aus_city2[is.na(aus_city2)] <- 0
aus_city2 <- aus_city2%>%mutate(hover=paste0(STATE_NAME,"\n",count, " jobs"))

#Using the merge dataset to create an interactive choropleth map with plotly 
aus_job_posts<-plot_ly(aus_city2,split=~count, color =~count,
        colors = 'RdYlBu',
        text = ~paste(STATE_NAME, "\nJob posts:", count),
        hoveron = "fills",
        hoverinfo = "text",
        showlegend = FALSE)%>%
  layout(title='Number of Data Science Job Posts in Australia')
  

#Run this to identify top three states
aus_city[order(aus_city$count,decreasing=TRUE),][1:3,]

aus_job <- aus_data %>% group_by(job_simp,state)%>%filter(state=="New South Wales"|
                                                            state=="Victoria"|
                                                            state=="Queensland")%>%
  summarise(count=n())

aus_job


#count all the requirement skill for Australia by each row
aus_skill <- aus %>% filter(grepl("2021",first_seen)) %>% 
  select(R,Scala,SAS,Matlab,Stata,Python,SPSS,Javascript,SQL,Spark,Tableau,C,Hadoop,Java,Ruby,D3,Julia,Golang,Knime,F.,Fortran,excel)%>% 
  mutate(Count_skill=R+Scala+SAS+Matlab+Stata+Python+SPSS+Javascript+SQL+Spark+Tableau+C+Hadoop+Java+Ruby+D3+Julia+Golang+Knime+F.+ Fortran + excel)

#Create a trend of skills for Australia as a data frame as preparation for visualisation 
Total_skills_aus<-aus %>% filter(grepl("2021",first_seen)) %>% 
  select(R,Scala,SAS,Matlab,Stata,Python,SPSS,Javascript,SQL,Spark,Tableau,C,Hadoop,Java,Ruby,D3,Julia,Golang,Knime,F.,Fortran,excel)
Total_aus<-data.frame(name=colnames(Total_skills_aus),value=colSums(Total_skills_aus,na.rm = TRUE))
Total_aus <-Total_aus[order(Total_aus$value,decreasing = TRUE),][1:10,]


#Count the number of post Australia (This part is for visualisation in Tableau)
aus_posts<-aus %>% filter(grepl("2021",first_seen))%>% group_by(nation,state)%>%summarise(count=n())
aus_posts2 <- aus_posts[1:7,] #Extract the total 7 states which post a data science job
write.csv(aus_posts2,"aus_pos.csv",row.names = FALSE) #export the data frame as a new file for tableau

#Add count_skill to aus_data and filter for job which post salary per year/ remove some 0 and outliers
aus_data$count_skill <- aus_skill$Count_skill
aus_data<-aus_data%>%filter(salary_per_year==1)%>%filter(Average_salary!=0.00)%>%filter(Average_salary<940.00)

#Check Correlation and select statistic model (Bevans,2020)
res_aus <- cor.test(aus_data$count_skill,aus_data$Average_salary,method="pearson")
res_aus2 <- cor.test(aus_data$seniority,aus_data$Average_salary,method="pearson")
res_aus3 <-cor.test(aus_data$count_skill,aus_data$seniority,method="pearson")

res_aus
res_aus2
res_aus3

#Multiple regression (Bevans,2020) fit the data to the linear model using lm()
avg.salary.aus.lm <- lm(Average_salary ~ count_skill + seniority,data=aus_data)
summary(avg.salary.aus.lm) #Lookin at the model result

#plot regression follow the method of Bevans (Bevans,2020)
plot_data_aus <- expand.grid(
  count_skill = seq(min(aus_data$count_skill),max(aus_data$count_skill),length.out=30),
  seniority=c(min(aus_data$seniority),mean(aus_data$seniority),max(aus_data$seniority))
)

#Make a prediction of salary before plotting
plot_data_aus$predicted.y <- predict.lm(avg.salary.aus.lm,newdata = plot_data_aus)

plot_data_aus$seniority <- round(plot_data_aus$seniority,digits=2)

plot_data_aus$seniority <- as.factor(plot_data_aus$seniority)

#Combination of scatter plot with a line pass through the plot
salary_plot_aus <- ggplot(aus_data,aes(x=count_skill,y=Average_salary))+
  geom_point()

salary_plot_aus<- salary_plot_aus + geom_line(data = plot_data_aus,aes(x=count_skill, y=predicted.y,color=seniority)
                                      ,size=1.25)+
                                      labs(title="Prediction of Estimate Salary in Australia")

#Make the regression become interactive by using ggplotly() which make ggplot interactive
salary_plot_aus<-ggplotly(salary_plot_aus)



#Plot all the data exploration
#Plot the top ten skill using the dataframe of the top ten skill prepared earlier with ggplot and plotly.
#The value of graph is order by using reorder() to make an descending order of plot (Jaap,2014)
Top_10_aus<-ggplot(Total_aus,aes(fill=name,x=reorder(name,-value),y=value))+geom_bar(stat = "identity")+
  scale_x_discrete(guide = guide_axis(check.overlap = TRUE))+
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))+
  labs(title = "Top 10 programming skills for data science in Australia",fill="Skills")+
  xlab("Skills")

Top_10_aus <- ggplotly(Top_10_aus)


#Plot the top three states using the same method as the previous plot
Top_aus_states<-ggplot(aus_job,aes(fill=state,y=count,x=job_simp))+
  geom_bar(position="dodge",stat="identity")+
  scale_x_discrete(guide = guide_axis(check.overlap = TRUE))+
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))+
  labs(title = " Data science job trend in Top 3 Australia States")+
  xlab("Job Lists")
  
Top_aus_states <- ggplotly(Top_aus_states)

#References:
#Bevans, R. (2020, February 20). An introduction to multiple linear regression. 
#https://www.scribbr.com/statistics/multiple-linear-regression/
#Bevans, R. (2020, February 25). A step-by-step guide to linear regression in R. 
#https://www.scribbr.com/statistics/linear-regression-in-r/
#Choropleth Maps in R (n.d.). https://plotly.com/r/choropleth-maps/
#Interactive web-based data visualization with R, plotly, and shiny. (n.d.)
#https://plotly-r.com/maps.html
#Jaap (2014, September 4). Reorder bars in geom_bar ggplot2 by value.
#https://stackoverflow.com/questions/25664007/reorder-bars-in-geom-bar-ggplot2-by-value
#Jumble. (2020, September 27). Plotting a chloropleth map of Australian states
#https://stackoverflow.com/questions/64087391/plotting-a-chloropleth-map-of-australian-states
#Lathiya, K. (2021, September 8). grepl in R: How to Use grepl() Function in R
#https://r-lang.com/grepl-in-r/
#Talat.(2016,January 18). Count number of rows by group using dplyr. 
#https://stackoverflow.com/questions/22767893/count-number-of-rows-by-group-using-dplyr
