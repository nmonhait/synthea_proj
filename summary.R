#Demographic information for patients_boston df

#Summary variables
patients_boston_race <- patients_boston %>% 
    group_by(RACE) %>% 
    summarize(by_race = n()) %>% 
    ungroup()


patients_boston_ethnicity <- patients_boston %>% 
    group_by(ETHNICITY) %>% 
    summarize(by_ethnicity = n()) %>% 
    ungroup()

patients_boston_sex <- patients_boston %>% 
    group_by(GENDER) %>% 
    summarize(by_sex = n()) %>% 
    ungroup()

patients_boston_expense <- patients_boston %>% 
    summarize(mean_cost = mean(HEALTHCARE_EXPENSES)) 

patients_boston_coverage <- patients_boston %>% 
    summarize(mean_coverage = mean(HEALTHCARE_COVERAGE))


