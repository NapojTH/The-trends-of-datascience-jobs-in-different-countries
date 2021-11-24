library("tidyverse") #For some preprocessing
library("dplyr") #For piping the data/some cleaning
library("ggplot2") #For static Visualisation
library("ggpubr") #For regression
library("broom") #For regression
library("tidyr") #For clean some dataset
library("plotly") #For interaction plot
library("maps") #Extract the city polygon of UK

#Set the working directory to where the dataset for UK.
getwd()
setwd("C:/Users/Gun_Sean/OneDrive/Desktop/R/Second semester/Fit 5147 project/Clean dataset")
options(scipen = 999)

#Store the file as dataframe
uk <- read.csv("uk_clean.csv",header=TRUE)



#extract uk necessary data based on the column name
uk_data <- uk %>% select(job_simp,average_salary,seniority,location,city)


#Trend of Data Job in UK by each city is extracted by using the combination of group_by
#on state column and count each states within the dataframe with summarise(count=n()) from dplyr library 
#(Talat,2016)
uk_city <- uk_data %>% group_by(city)%>%summarise(count=n())
uk_city

uk_city[order(uk_city$count,decreasing = TRUE),][1:3,]

#Extract this to identify/extract top three cities
uk_job <- uk_data %>% group_by(job_simp,city)%>%summarise(count=n())%>%
  filter(city=="London"|city=="Manchester"|city=="Bristol")

#count all the top skill for UK job by the rows
uk_skill <- uk %>% select(python,excel,hadoop,spark,aws,tableau,R,Scala,SAS,Matlab,Stata,SPSS,
                          Javascript,SQL,C,Java,Ruby,D3,Julia,Golang,Knime,F.,Fortran)%>%
  mutate(Count_skill=python+excel+hadoop+spark+aws+tableau+R+Scala+SAS+Matlab+Stata+SPSS
         +Javascript+SQL+C+Java+Ruby+D3+Julia+Golang+Knime+F.+Fortran)

Total_uk_skill<-uk %>% select(python,excel,hadoop,spark,aws,tableau,R,Scala,SAS,Matlab,Stata,SPSS,
                            Javascript,SQL,C,Java,Ruby,D3,Julia,Golang,Knime,F.,Fortran)

#Make a dataframe of all the skill to get the top 10 skills requiring for the job
Total_uk <-data.frame(name=colnames(Total_uk_skill),value=colSums(Total_uk_skill,na.rm = TRUE))
Total_uk <-Total_uk[order(Total_uk$value,decreasing = TRUE),][1:10,]

#Bubble map uk method derived from (Bubble map with ggplot2,n.d.)
#https://www.r-graph-gallery.com/330-bubble-map-with-ggplot2.html

#count all post by uk for tableau
uk_posts <- uk %>% group_by(city)%>%summarise(count=n())%>%mutate(C="United Kingdom")
uk_posts

#Get map lat/lon info for bubble plot
uk_c <- map_data("world") %>% filter(region=="UK")

uk_r <- world.cities %>% filter(country.etc=="UK")
uk_r <- uk_r %>% dplyr::left_join(uk_posts, by=c("name" = "city"))
uk_r <- uk_r[,-8]
uk_r[is.na(uk_r)]<-0

#Arrange the count of the job post and make the name column become factor and the text column is created
#for intereactive ext appearance when the mouse cursor move through the visualisation
uk_r <- uk_r %>%
  arrange(count)%>%
  mutate(name=factor(name,unique(name)))%>%
  mutate(text = paste(name,"\n","Job Posts:",count,sep=""))

#Plot UK bubble map with ggplot
uk_posts_plot <- uk_r %>%
  ggplot() +
  geom_polygon(data = uk_c, aes(x=long, y = lat, group = group), fill="grey", alpha=0.3) +
  geom_point(aes(x=long, y=lat, size=count, color=count, text=text, alpha=count) ) +
  scale_size_continuous(range=c(1,15)) +
  scale_alpha_continuous(trans="log") +
  theme_void() +
  ylim(50,59) +
  coord_map() +
  theme(legend.position = "right",plot.title = element_text(hjust = 0.5))+
  ggtitle("Number of Data Science Job Posts in UK by Cities ")

#Using plotly to make the ggplot graph interactive
uk_job_posts<-ggplotly(uk_posts_plot, tooltip="text")
uk_job_posts

#For tableau
write.csv(uk_posts,"uk_pos.csv",row.names = FALSE)

#Include count skill in uk_data
uk_data$count_skill<-uk_skill$Count_skill
uk_data

#Check Correlation and build model using method from Bevans (Bevans, 2020)
uk_c<-cor.test(uk_data$count_skill,uk_data$average_salary,method = "pearson")
uk_c2<-cor.test(uk_data$seniority,uk_data$average_salary,method = "pearson")
uk_c3 <- cor.test(uk_data$count_skill,uk_data$seniority,method="pearson")

uk_c
uk_c2
uk_c3

#Multiple regression model created from the feature selected from the uk dataset
avg.salary.uk.lm <- lm(average_salary ~ count_skill + seniority,data=uk_data)
summary(avg.salary.uk.lm)

#plot Multiple regression by making the same process in the Australia's dataset (Bevans, 2020)
plot_uk <- expand.grid(
  count_skill = seq(min(uk_data$count_skill),max(uk_data$count_skill),length.out=30),
  seniority=c(min(uk_data$seniority),mean(uk_data$seniority),max(uk_data$seniority))
)

plot_uk$predicted.y <- predict.lm(avg.salary.uk.lm,newdata = plot_uk)

plot_uk$seniority <- round(plot_uk$seniority,digits=2)

plot_uk$seniority <- as.factor(plot_uk$seniority)

salary_plot_uk <- ggplot(uk_data,aes(x=count_skill,y=average_salary))+
  geom_point()

salary_plot_uk<- salary_plot_uk + geom_line(data = plot_uk,aes(x=count_skill, y=predicted.y,color=seniority)
                                      ,size=1.25)+
                                      labs(title="Prediction of Estimate Salary in UK")

#Make the regression plot of UK become interactive with ggplotly
salary_plot_uk<-ggplotly(salary_plot_uk)

#Plot graph
# Top 10 skill required for data science job in UK plot with reorder of top ten skill (Jaap, 2014)
top_10_uk<-ggplot(Total_uk,aes(fill=name,x=reorder(name,-value),y=value))+
  geom_bar(stat = "identity")+
  scale_x_discrete(guide = guide_axis(check.overlap = TRUE))+
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))+
  labs(title = "Top 10 programming skills for data science in United Kingdom",fill="Skills")+
  xlab("Skills")

#Make the plot become interactive using ggplotly()  
top_10_uk <- ggplotly(top_10_uk)
top_10_uk

#Plot graph of the job type by top three city in UK  
top_city_uk<-ggplot(uk_job,aes(fill=city,y=count,x=job_simp))+
  geom_bar(position="dodge",stat="identity")+
  scale_x_discrete(guide = guide_axis(check.overlap = TRUE))+
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))+
  labs(title = " Data science job trend in Top 3 United Kingdom Cities")+
  xlab("Job Lists")

#Make the graph interactive
top_city_uk <- ggplotly(top_city_uk)
top_city_uk

#References:
#Bevans, R. (2020, February 20). An introduction to multiple linear regression. 
#https://www.scribbr.com/statistics/multiple-linear-regression/
#Bevans, R. (2020, February 25). A step-by-step guide to linear regression in R. 
#https://www.scribbr.com/statistics/linear-regression-in-r/
#Bubble map with ggplot2. (n.d.). 
#https://www.r-graph-gallery.com/330-bubble-map-with-ggplot2.html
#Choropleth Maps in R (n.d.). https://plotly.com/r/choropleth-maps/
#Jaap (2014, September 4). Reorder bars in geom_bar ggplot2 by value.
#https://stackoverflow.com/questions/25664007/reorder-bars-in-geom-bar-ggplot2-by-value
#Talat.(2016,January 18). Count number of rows by group using dplyr. 
#https://stackoverflow.com/questions/22767893/count-number-of-rows-by-group-using-dplyr