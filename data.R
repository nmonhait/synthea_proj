#libraries
library(tidyverse)
library(readr)

#import data
patients <- read_csv("data/patients.csv")
careplans <- read_csv("data/careplans.csv")

#filter to patients in Boston and select variables
patients_boston <- patients %>% 
    filter(CITY == "Boston") %>% 
    select(c(Id, RACE, ETHNICITY, GENDER, 
             LAT, LON, HEALTHCARE_EXPENSES, 
             HEALTHCARE_COVERAGE))

View(patients_boston)
