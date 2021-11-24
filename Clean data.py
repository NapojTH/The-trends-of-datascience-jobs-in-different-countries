# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import pandas as pd
import re

#All the cleaning process derieved from 
#PlayingNumbers. (2020, April 13). Data Science Salary Estimator [only the data cleaning part] . 
#https://github.com/PlayingNumbers/ds_salary_proj/blob/master/data_cleaning.py

#Before the cleaning make sure the datset is on the same working directory of the python ide or 
#set the ide to where the dataset located
#Read the unclean dataset
uk = pd.read_csv("deduped-jobs.csv")
us = pd.read_csv("Cleaned_DS_Jobs.csv")
aus = pd.read_csv("listings2021.csv")

#create more skill column for us dataframe based on aus dataframe

#looking at aus column
print(list(aus.columns.values))

#Based on the aus column, these will be all the skills count for each country job list
#create more skill column from parsing the job description


#Create all skill column for us job list
us['R'] = us['Job Description'].apply(lambda x: 1 if 'r studio' in x.lower() or 'r-studio' in x.lower() else 0)
us['Scala'] = us['Job Description'].apply(lambda x: 1 if 'scala' in x.lower() else 0)
us ['SAS'] = us['Job Description'].apply(lambda x: 1 if 'sas' in x.lower() else 0)
us['Matlab'] = us['Job Description'].apply(lambda x: 1 if 'matlab' in x.lower() else 0)
us['Stata'] = us['Job Description'].apply(lambda x: 1 if 'stata' in x.lower() else 0)
us['SPSS'] = us['Job Description'].apply(lambda x: 1 if 'spss' in x.lower() else 0)
us['Javascript'] = us['Job Description'].apply(lambda x: 1 if 'javascript' in x.lower() else 0)
us['SQL'] =us['Job Description'].apply(lambda x: 1 if 'sql' in x.lower() else 0)
us['C'] = us['Job Description'].apply(lambda x: 1 if ' c ' in x.lower() else 0)
us['Java']=us['Job Description'].apply(lambda x: 1 if 'java' in x.lower() else 0)
us['Ruby']=us['Job Description'].apply(lambda x: 1 if 'ruby' in x.lower() else 0)
us['D3'] = us['Job Description'].apply(lambda x: 1 if 'd3' in x.lower() else 0)
us['Julia'] = us['Job Description'].apply(lambda x: 1 if 'julia' in x.lower() else 0)
us['Golang']=us['Job Description'].apply(lambda x: 1 if 'golang' in x.lower() else 0)
us['Knime']=us['Job Description'].apply(lambda x: 1 if 'knime' in x.lower() else 0)
us['F#'] = us['Job Description'].apply(lambda x: 1 if 'f#' in x.lower() else 0)
us['Fortran']=us['Job Description'].apply(lambda x: 1 if 'fortran' in x.lower() else 0)


#Create  all skill column for uk job list
uk['python'] = uk['description'].apply(lambda x: 1 if 'python' in x.lower() else 0)
uk['excel'] = uk['description'].apply(lambda x: 1 if 'excel' in x.lower() else 0)
uk['hadoop'] = uk['description'].apply(lambda x: 1 if 'hadoop' in x.lower() else 0)
uk['spark'] = uk['description'].apply(lambda x: 1 if 'spark' in x.lower() else 0)
uk['aws'] = uk['description'].apply(lambda x: 1 if 'aws' in x.lower() else 0)
uk['tableau'] = uk['description'].apply(lambda x: 1 if 'tableau' in x.lower() else 0)
uk['R'] = uk['description'].apply(lambda x: 1 if 'r studio' in x.lower() or 'r-studio' in x.lower() else 0)
uk['Scala'] = uk['description'].apply(lambda x: 1 if 'scala' in x.lower() else 0)
uk['SAS'] = uk['description'].apply(lambda x: 1 if 'sas' in x.lower() else 0)
uk['Matlab'] = uk['description'].apply(lambda x: 1 if 'matlab' in x.lower() else 0)
uk['Stata'] = uk['description'].apply(lambda x: 1 if 'stata' in x.lower() else 0)
uk['SPSS'] = uk['description'].apply(lambda x: 1 if 'spss' in x.lower() else 0)
uk['Javascript'] = uk['description'].apply(lambda x: 1 if 'javascript' in x.lower() else 0)
uk['SQL'] =uk['description'].apply(lambda x: 1 if 'sql' in x.lower() else 0)
uk['C'] = uk['description'].apply(lambda x: 1 if 'c' in x.lower() else 0)
uk['Java']=uk['description'].apply(lambda x: 1 if 'java' in x.lower() else 0)
uk['Ruby']=uk['description'].apply(lambda x: 1 if 'ruby' in x.lower() else 0)
uk['D3'] = uk['description'].apply(lambda x: 1 if 'd3' in x.lower() else 0)
uk['Julia'] = uk['description'].apply(lambda x: 1 if 'julia' in x.lower() else 0)
uk['Golang']=uk['description'].apply(lambda x: 1 if 'golang' in x.lower() else 0)
uk['Knime']=uk['description'].apply(lambda x: 1 if 'knime' in x.lower() else 0)
uk['F#'] = uk['description'].apply(lambda x: 1 if 'f#' in x.lower() else 0)
uk['Fortran']=uk['description'].apply(lambda x: 1 if 'fortran' in x.lower() else 0)

#Add excel skill in aus dataframe
aus['mobileAdTemplate']=aus['mobileAdTemplate'].astype('str')
aus['excel'] = aus['mobileAdTemplate'].apply(lambda x: 1 if 'excel' in x.lower() else 0)

# Create salary column for aus
aus['salary_string'] = aus['salary_string'].fillna(0)
aus_salary = aus['salary_string']
aus_salary = aus_salary.astype('str')
No_sign = aus_salary.apply(lambda x:x.replace('$','').replace('k','').replace('K',''))
Salary_per_year= aus_salary.apply(lambda x: 0 if ' day ' in x.lower() or '/' in x.lower() or 'hr' in x.lower()
                                  or 'p.h.' in x.lower() or 'pd' in x.lower()
                                  or 'p.d.' in x.lower() or 'hour' in x.lower() else 1)
aus['salary_per_year']= Salary_per_year
No_sign=No_sign.apply(lambda x: x.replace('to','-'))
No_sign1=No_sign.str.replace(r'[^\d.-]+', '')
aus['real_salary'] = No_sign1
aus['real_salary'] = aus.real_salary.str.replace(r"\.\d.","")
aus['real_salary'] = aus['real_salary'].apply(lambda x: x.replace("-15.4.","").replace(".4","")
                                              .replace(".5","").replace("..","").replace(".",""))
aus['real_salary'] = aus['real_salary'].fillna(0)
aus['min_salary'] = aus['real_salary'].apply(lambda x: x.split("-")[0] if '-' in x else x)
aus['max_salary'] = aus['real_salary'].apply(lambda x: x.split("-")[1] if '-' in x else x)

aus['min_salary'] = aus['min_salary'].apply(lambda x:x.strip())
aus['max_salary'] = aus['max_salary'].apply(lambda x:x.strip())
aus['min_salary'] = aus['min_salary'].replace(r'',0)
aus['max_salary'] = aus['max_salary'].replace(r'',0)
aus['min_salary'] = aus['min_salary'].astype('int64')
aus['max_salary'] = aus['max_salary'].astype('int64')

aus['min_salary'] = aus['min_salary'].apply(lambda x: x/1000 if x > 1000 else x)
aus['max_salary'] = aus['max_salary'].apply(lambda x: x/1000 if x > 1000 else x)

# Change uk salary to thousand or k form
uk['min'] = uk['salary_min'].apply(lambda x: x/1000)
uk['max'] = uk['salary_max'].apply(lambda x: x/1000)
uk['average_salary'] = (uk['min']+uk['max'])/2

#Find a job type and seniority of each job in aus and uk 
#Functions for making a simplified job title
def title_simp(title):
    if 'data scientist' in title.lower():
        return 'data scientist'
    elif 'data engineer' in title.lower():
        return 'data engineer'
    elif 'data analyst' in title.lower():
        return 'data analyst'
    elif 'ml' in title.lower():
        return "machine learning"
    elif 'machine learning' in title.lower():
        return 'machine learning'
    elif 'manager' in title.lower():
        return 'manager'
    elif 'lead' in title.lower():
        return 'lead'
    elif 'head' in title.lower():
        return'lead'
    elif 'director' in title.lower():
        return 'director'
    else:
        return 'other'
#Find a seniority level of the job
def seniority(title):
    if 'senior' in title.lower():
        return 3
    elif 'sr' in title.lower():
        return 3
    elif 'junior' in title.lower():
        return 1
    elif 'jr' in title.lower():
        return 1
    else:
        return 2
        
#apply function to the data frame
aus['job_simp'] = aus['jobTitle'].apply(title_simp)
aus['seniority'] = aus['jobTitle'].apply(seniority)
uk['job_simp'] = uk['title'].apply(title_simp)
uk['seniority'] = uk['title'].apply(seniority)

#Export to as a clean csv csv.
aus.to_csv('aus_clean.csv',index=False)
uk.to_csv('uk_clean.csv',index=False)
us.to_csv('us_clean.csv',index=False)

#Reference:
#PlayingNumbers. (2020, April 13). Data Science Salary Estimator [only the data cleaning part] . 
#https://github.com/PlayingNumbers/ds_salary_proj/blob/master/data_cleaning.py




