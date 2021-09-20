#analysis of medication df

#libraries
library(tidyverse)
library(readr)
library(lubridate)

#import data
medications <- read_csv("data/medications.csv")

#clean data
medications <- medications %>% 
    rename(
        start = START,
        stop = STOP,
        code = CODE,
        description = DESCRIPTION,
        base_cost = BASE_COST,
        payer_coverage = PAYER_COVERAGE,
        reason_code = REASONCODE,
        reason = REASONDESCRIPTION
    )

medications <- medications %>% 
    select(start, stop, code, description, base_cost,
           payer_coverage, reason_code, reason)

#format date
medications <- medications %>% 
    mutate(start = ymd_hms(start),
           stop = ymd_hms(stop),
           start = floor_date(start, unit = "day"),
           stop = floor_date(stop, unit = "day"),
           start = date(start),
           stop = date(stop),
           care_time = difftime(stop, start, units = "days")
           )

#reformat care_time variable 
medications <- medications %>% 
    separate(care_time, into = c("care_time_days", NA), sep = " ") %>% 
    select(code, description, base_cost, payer_coverage, reason_code,
           reason, care_time_days) %>% 
    mutate(care_time_days = as.numeric(care_time_days)) %>% 
    mutate(out_of_pocket_cost = (base_cost - payer_coverage))


#most diagnosed reason
top_reasons_for_med <- medications %>% 
    group_by(reason) %>%
    summarize(reason_count = n()) %>% 
    arrange(desc(reason_count)) %>% 
    ungroup()

#most diagnosed drug
top_med <- medications %>% 
    group_by(description) %>%
    summarize(prescription_count = n()) %>% 
    arrange(desc(prescription_count)) %>% 
    ungroup()


#avg care time for diagnosis
care_time_by_reason <- medications %>% 
    group_by(reason) %>% 
    summarize(avg_care_time = mean(care_time_days)) %>% 
    arrange(desc(avg_care_time)) %>% 
    ungroup() 

#cost by reason
cost_by_reason <- medications %>% 
    group_by(reason) %>% 
    summarize(avg_cost_reason = mean(out_of_pocket_cost, na.rm = TRUE)) %>% 
    arrange(desc(avg_cost_reason)) %>% 
    ungroup()
              
#cost by drug  
cost_by_drug <- medications %>% 
    group_by(description) %>% 
    summarize(avg_cost_reason = mean(out_of_pocket_cost, na.rm = TRUE)) %>% 
    arrange(desc(avg_cost_reason)) %>% 
    ungroup()

#plot cost by reason
cost_by_reason %>% 
    ggplot() +
    geom_col(aes(x = reason, y = avg_cost_reason))
          
    