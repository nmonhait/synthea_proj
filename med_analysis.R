#analysis of medication df

#libraries
library(lubridate)

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
medication_by_length <- medications %>% 
    separate(care_time, into = c("care_time_days", NA), sep = " ") %>% 
    select(code, description, base_cost, payer_coverage, reason_code,
           reason, care_time_days)
View(medication_by_length
     )
