# The-trends-of-datascience-jobs-in-different-countries (This project is my own project created as a part of FIT5147 Data Visualisation and Exploration unit)

### Here is a link to an interactive visualisation dashboard of the project:



## Introduction and Motivation:
As an individual who start a journey in a data science field, I am interest in finding out about the trend of data 
science job posting in many different countries. Also, I would like to explore what are the relevant skills require for 
a certain data science job in different countries, and I want to identify the factors that predict the salary for data 
science. By doing this topic, it will be beneficial for my preparation for data science job application in the future and 
I think it will help me in choosing what kind of skill I need to improve for this field. As mentioned above, I decide 
to identify differences in job posting trends between Australia (base country) and other countries.

## Questions:
1. What is the different in the trend of data science jobs posting in each country?
2. What are the factors predicting the estimated salary of the data science jobs in each country?
3. What is the trend of relevant skills require for a specific data science job in each country?

### Data sources:
A. Data Science Job Listings - Australia - 2019-2021 from Seek.com.au
B. Data Science Job Posting on Glassdoor 
C. UK Data Science Jobs dataset
All of the dataset will be used for answering all of the questions above by combining each dataset together.

### Description of Data Sources:
• Tabular Data (csv file): 1458 rows x 52 columns, the dataset is provided with geospatial/location data and 
textual format data. 
(https://www.kaggle.com/nomilk/data-science-job-listings-australia20192020?select=listings2021.csv).
• Tabular Data (csv file): 661 rows x 27 columns, the dataset is provided with geospatial/location data and 
textual format data. 
(https://www.kaggle.com/rashikrahmanpritom/data-science-job-posting-onglassdoor?select=Cleaned_DS_Jobs.csv)
• Tabular Data (csv file): 596 rows x 14 columns, the dataset is provided with geospatial/location data and 
textual format data. 
(https://www.kaggle.com/devario/uk-data-science-jobs-dataset

This project's questions will be answered by the combination of data exploration, data visualization and data analysis on the 
job list dataset via Python, R, Microsoft Excel, and Tableau

Here are the sections describing the procedure of making this project:

## Data Wrangling/ Data Cleaning and Pre-processing
This project is involved with these following datasets:
A.	Data Science Job Listings - Australia - 2019-2021 from Seek.com.au; 
Tabular Data (csv file): 1458 rows x 52 columns, the dataset is provided with geospatial/location data and textual format data. (https://www.kaggle.com/nomilk/data-science-job-listings-australia20192020?select=listings2021.csv).
B.	Data Science Job Posting on Glassdoor;
Tabular Data (csv file): 661 rows x 27 columns, the dataset is provided with geospatial/location data and textual format data. (https://www.kaggle.com/rashikrahmanpritom/data-science-job-posting-on-glassdoor?select=Cleaned_DS_Jobs.csv)
C.	UK Data Science Jobs dataset;
Tabular Data (csv file): 596 rows x 14 columns, the dataset is provided with geospatial/location data and textual format data. (https://www.kaggle.com/devario/uk-data-science-jobs-dataset)
Tools for Data Wrangling:
1.	Python
2.	Microsoft Excel

### Data Wrangling Step:
Step 1: Select all the relevant data column within each dataset for answering the above question.
This process can be done by explore each data set on the Microsoft excel as shown below:
After looking through all the dataset, these are all the selected columns which will be used in the data exploration and answering the questions: All skills columns (Python, R, and etc.), Job description, salary (avg, min and max), job title, location, city, seniority, and job_simp (job_type)
Step 2: Pre-process the dataset.
For this step, the data cleaning process in python derived from the internet source (PlayingNumbers, 2020) will be used for pre-process the dataset because some of the dataset does not include all of the column similar to one and another. To make all the dataset ready for use, python is used for extracting the skills, average_salary , seniority  and job_simp  information from job_description, salary_per_year(only in Australia dataset) and salary column. These are the steps use for pre-process each information (see appendix for the all data cleaning code):
1.	Skills: All the skill columns such as python and the others in this stage can be extracted by applied lambda function on job_description or description column by input the following command: df[‘python’] = df[‘job_description’].apply(lambda x: 1 if ‘python in x.lower() else 0). Based on the command if the skills name was found in the description, number one will be added to the skill column row.
2.	Average Salary : To get the average salary for each job, the regex will be applied to extract the salary range, or salary from description or salary column. After extract all salary, if the salary is in the form of range, it will be extract again to create a min and max salary column by apply split on a hyphen between each salary range, and the alphabet that come along with salary number will be replace by applying the same approach on those salary-related columns. Also, the salary which has more than a range of 0-999 will be divided by a thousand. Lastly, some of the average_salary column will be form by using R for adding both min and max_salary column together and dividing by 2.
3.	Salary_Per_year: This column is created for checking whether the salary rate is calculated per/year or per annum. It was created from exploring the salary column or job_description columns. For instance, if there is a word “per year” it will return “1” as a Salary_Per_year column.
4.	Seniority and Job_simp:  For these two columns, the functions for exploring the word which represent seniority level or data science job in the job_title are created. These two functions applied a condition if a certain word is met in the job_title, it will represent other text. For example, if ‘data scientist’ in title.lower() return ‘data scientist, and the others condition

## Data Checking 
Once the data is ready for used, it is time to check whether there are nulls or any outliers as the following:
Step 1. Handling Null:
	For this step, the null in the salary-related columns will be replace with zero by using python fillna(0) command on the columns. Also, during the data analysis coding part, the “na.rm = TRUE” was used for sum between columns in R (see the code in appendix). The picture below is the result after handling null process:

![Data Exploration - Word 24_11_2021 19_37_39 (2)](https://user-images.githubusercontent.com/67892412/143240176-7beb6158-ba44-4c10-a2a2-9ec2417afac3.png)

Step2. Handling outliers:
	The salary-related column which divided by thousand value, but return a value with more than a range of 0-999 will be removed or changed based on the salary or job_description column. This process is done in both R and Microsoft Excel as the picture below:  
                                              
![Data Exploration - Word 24_11_2021 19_37_48](https://user-images.githubusercontent.com/67892412/143240506-2b2bdf40-5974-440e-9e48-2159463b5530.png)
![Data Exploration - Word 24_11_2021 19_45_43](https://user-images.githubusercontent.com/67892412/143243707-c683cfd3-c4cb-4fd9-bdc4-369d6dd132fd.png)

 
## Data Exploration
For the data exploration part, the tool used for identify the answer for this project are R and Tableau.
After applying statistical analysis and create some visualization, these are the results of the exploration:

### What is the different in the trend of data science jobs posting in each country?
In this part, a Bar chart of top three states/city created by ggplot in R and a map of each countries are created by R and Tableau respectively. The purpose for creating map and the bar chart together is for comparing the level of data science job demand in each part of the country, and creating a chart for identifying differences in the data science job type demand in the top three states which have a highest data science job post. On the map, the colour step is divided into five steps. This is done as a way to identify which three states are high in demand of data science position. The tone of the colour represents the differences in the number of the job demand. For example, the darker the colour the number of job demand will be higher accordingly. However, the map representation is different for UK because UK dataset did not provide states.
These are the result for each country after the visualisation:
The first two visualisations are choropleth map of Australia and a bar chart of three Australia’s states consisted of New South Wales, Victoria and Queensland:     

![Data Exploration - Word 24_11_2021 19_37_56](https://user-images.githubusercontent.com/67892412/143240675-37e097a6-457a-4fe6-8e18-f37579d1d025.png)

  
After identify the different in data science job demand by each state, the top three states which have a highest demand in this job field are the following:1. New South Wales 293 posts, 2. Victoria 221 posts, and 3. Queensland 77 posts. Based on the chart, the most demand position is data scientist position. This result is followed by other related data science job and data analyst position. However, this result is not the case for Queensland, because the third on demand job for Queensland is data engineer.

The second set of two visualisations are choropleth map of USA and a bar chart of three USA’s states consisted of 
California (CA), Massachusetts (MA), and Virginia (VA):

![Data Exploration - Word 24_11_2021 19_38_01](https://user-images.githubusercontent.com/67892412/143241218-ed45fed6-8f22-4c5a-8570-97e73ca1c0af.png)

 
Based on, the map visualisation and bar chart, the USA’s states which have the top three highest number of job post are CA (165 posts), MA(85 posts) and VA(62 posts). For CA and VA, the highest on demand job is data scientist which is followed by data engineer and data analyst. On the contrary, MA highest demand position is data scientist, other data science related job , and machine learning related job.


Lastly for the first question, these two visualisations are map of UK consisted of point representing cities and a bar chart of three UK’s cities consisted of London, Manchester, and Bristol. 

![Data Exploration - Word 24_11_2021 19_38_06](https://user-images.githubusercontent.com/67892412/143241152-dcf8da11-941f-4ce5-9091-aed11dd06912.png)

  
According to these visualisations, the city which have highest on demand job is London followed by Manchester and Bristol. The highest on demand job in London is other data science related job, following by data scientist and data engineer. For Manchester, the highest and the second highest on demand are the same as London, but the third job on demand is data science manager position. For Bristol, the highest on demand position is the same as other two cities following by lead and manager position, and data scientist position.

### What are the factors predicting the estimated salary of the data science jobs in each country?
In this part, the correlation function and multiple regression is applied on the selected variables (seniority and count of skill require for a position in each country dataset) to identify whether these factors predicted the average salary of the job. In this part, the count skill column for each dataset is derived from the sum of all skill columns (see the R code for acquiring count skill column in appendix section).
Firstly, the correlation function is applied on both pairwise independent variables (count of skill and seniority) and dependent variable (average salary) as the following: 1. Correlation between count of skill and average salary, 2. Correlation between seniority and average salary 3. Correlation between count of skill and seniority. If the third pairwise is insignificant while one out of the first two pairwise is significant, it can determine whether to apply the dataset with a regression model (Bevans, 2020a; Bevans, 2020b).
These are the correlation result for each country dataset pairwise (see the full correlation result in appendix):
Australia: The correlation for 1. And 2. pairwise is significant (p-value = 0.03687, coefficient = 0.1531; p-value = 0.0167, coefficient = 0.1752) but the 3. Pairwise is insignificant (this dataset is suitable for running a linear regression)
USA: All the correlation for each pairwise are insignificant so the USA variables cannot be used in the regression model. Since the correlation is insignificant, it can be concluded that the seniority and count of skill cannot be used for predict the estimated salary in the USA.
UK: The 1. And 3. pairwise correlation is insignificant but the 2. is significant (p-value = 0.03808, coefficient = 0.085) (this dataset is suitable for running a linear regression).


The following visualisations are the result of multiple regression on Australia and UK dataset:

![Data Exploration - Word 24_11_2021 19_38_13](https://user-images.githubusercontent.com/67892412/143241683-fc465808-c1d8-406a-a913-dd6888f2d036.png)

     
According to these two visualisations, here are the interpretation of the result: 
Australia regression result:  The significant relationship between the count of skill and average salary and level of seniority and average salary were found (at p<0.1 and p<0.05 respectively). This can be implied that 6.3% average salary will increase for every 1% increase in skill numbers, and 36.2% average salary will increase for every 1% increase in seniority level (see the full result in appendix).
Uk regression result: The significant relationship between the count of skill and average salary and level of seniority and average salary were found (at p<0.1 and p<0.05 respectively). This can be implied that 1% average salary will increase for every 1% increase in skill numbers, and 5% average salary will increase for every 5% increase in seniority level (see the full result in appendix).

### What is the trend of relevant skills require for a specific data science job in each country?
For the last part, the bar chart of the skill set will be created by using ggplot in R to compare the top ten skills on demand for a data science job.
These are the visualisations of the skill set required for data science job in each country: 

![Data Exploration - Word 24_11_2021 19_38_32](https://user-images.githubusercontent.com/67892412/143241833-3d2766c6-f8f7-493e-950e-3fea37f71f42.png)
![Data Exploration - Word 24_11_2021 19_38_38](https://user-images.githubusercontent.com/67892412/143241929-3750124e-a1b6-43d8-bb63-7a514bcfb8b0.png)

 
Based on these visualisations, it seems that Python is the most in demand skill in data science job for Australia and USA, while C is the highest on demand skill in UK. For Australia and USA, the second on demand skill is SQL but this is not the case in UK which demand python as the second highest on demand skill. For the third highest on demand skill, they varied differently in these three countries; for example, Australia require SAS as the third highest on demand skill, whereas USA demand excel skill and UK demand SQL. For the rest of the skills, it seem that Tableau,Java, Excel and Spark are on demand for these three countries. At the same time, there is some unique skills require differently in each country. For example, AWS and Scala did not appear as top ten on demand skill for Australia, while R and Matlab did not appear in USA and UK. Also, Hadoop and SAS only on demand in Australia and USA but not UK, and javascript is on demand only in UK.



## Conclusion
From the result of data visualisation and analysis, it seems that data scientist is the most popular career in demand for Australia and USA in 2021. In contrast, the other data science related jobs are the most demand job in UK. Regarding the first question answer, it may have an effect on the trend of skill as well. For example, C is the most in demand skill in UK, while python is the most wanted skill for data science job. Also, the result of the regression model can be improve if I have apply 
suitaible statistical method (outlier detection) the result may be more significant.Lastly, it was found that the number of skills and level of seniority could be a predictor for average salary for data science job in Australia and UK, whereas they are not a predictor for data science average salary in USA.

## Appendix

![Data Exploration - Word 24_11_2021 20_02_58](https://user-images.githubusercontent.com/67892412/143243789-91f1454d-89d3-4b6b-a729-68c622c6033e.png)
![Data Exploration - Word 24_11_2021 20_03_07 (1)](https://user-images.githubusercontent.com/67892412/143243854-1f2554c0-c1a7-4919-a2eb-1cde6475db6f.png)
![Data Exploration - Word 24_11_2021 20_03_14](https://user-images.githubusercontent.com/67892412/143243968-a4044f4d-9c72-4a67-8d29-a96133ae6241.png)
![Data Exploration - Word 24_11_2021 20_03_30](https://user-images.githubusercontent.com/67892412/143244106-b7131bff-ea16-4f63-9850-fc8d9377aeea.png)
![Data Exploration - Word 24_11_2021 20_03_36](https://user-images.githubusercontent.com/67892412/143244172-0d577e32-7a33-4de8-a2ff-4393a69c1867.png)
![Data Exploration - Word 24_11_2021 20_03_41](https://user-images.githubusercontent.com/67892412/143244287-784b1594-e756-4612-8172-53d90a52b620.png)
![Data Exploration - Word 24_11_2021 20_03_45](https://user-images.githubusercontent.com/67892412/143244480-449f902e-4343-4c66-b90a-9fb1320aaa60.png)




## References
1. Amrrs. (2018, February 15). RShiny Generating Dropdown Menu for Plotly Charts - using subelements. https://stackoverflow.com/questions/48805897/rshiny-generating-dropdown-menu-for-plotlycharts-using-subelements
2. Bevans, R. (2020, February 20). An introduction to multiple linear regression. https://www.scribbr.com/statistics/multiple-linear-regression/
3. Bevans, R. (2020, February 25). A step-by-step guide to linear regression in R. https://www.scribbr.com/statistics/linear-regression-in-r/
4. Bubble map with ggplot2. (n.d.). https://www.r-graph-gallery.com/330-bubble-map-with-ggplot2.html
5. Choropleth Maps in R (n.d.). https://plotly.com/r/choropleth-maps/
6. Clarke, M. (2021, February 8). UK Data Science Jobs dataset. https://www.kaggle.com/devario/uk-datasciencejobs-dataset?select=deduped-jobs.csv
7. Divibisan (2018, August 7). How to remove all whitespace from a string? https://stackoverflow.com/questions/5992082/how-to-remove-all-whitespace-from-a-string
8. Interactive web-based data visualization with R, plotly, and shiny. (n.d.) https://plotly-r.com/maps.html
9. Jaap (2014, September 4). Reorder bars in geom_bar ggplot2 by value. https://stackoverflow.com/questions/25664007/reorder-bars-in-geom-bar-ggplot2-by-value
10. Jdharrison. (2014, June 5). Change the color and font of text in Shiny App. https://stackoverflow.com/questions/24049159/change-the-color-and-font-of-text-in-shiny-app
11. Jumble. (2020, September 27). Plotting a chloropleth map of Australian states https://stackoverflow.com/questions/64087391/plotting-a-chloropleth-map-of-australian-states
12. Lathiya, K. (2021, September 8). grepl in R: How to Use grepl() Function in R https://r-lang.com/grepl-in-r/
13. MLavoie (2015, December 21). How can put multiple plots side-by-side in shiny r? https://stackoverflow.com/questions/34384907/how-can-put-multiple-plots-side-by-side-in-shinyr/34392254
14. Nomilk. (2021, July 24). Data Science Job Listings - Australia - 2019-2021. https://www.kaggle.com/nomilk/datascience-job-listings-australia20192020?select=listings2019_2021.csv
15. PlayingNumbers. (2020, April 13). Data Science Salary Estimator [only the data cleaning part] . https://github.com/PlayingNumbers/ds_salary_proj/blob/master/data_cleaning.py
16. Rahman, R. (2021, March 9). Data Science Job Posting on Glassdoor. https://www.kaggle.com/rashikrahmanpritom/data-science-job-postingonglassdoor?select=Cleaned_DS_Jobs.csv
17. R Maps: Beautiful Interactive Choropleth & Scatter Maps with Plotly. (2020, October 1). [Video]. YouTube. https://www.youtube.com/watch?v=RrtqBYLf404
18. Satriadi,K. (2021a, April 27). The human visual system. https://lms.monash.edu/mod/book/view.php?id=8900106&chapterid=959465
19. Satriadi,K. (2021b, April 27). Visual Communication. https://lms.monash.edu/mod/book/view.php?id=8900106&chapterid=959465
20. Shinydashboard (n.d.). https://rstudio.github.io/shinydashboard/
21. Talat.(2016,January 18). Count number of rows by group using dplyr.https://stackoverflow.com/questions/22767893/count-number-of-rows-by-group-using-dplyr
