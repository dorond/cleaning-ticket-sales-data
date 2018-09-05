library(tidyverse)
library(lubridate)

# import sales file
sales <- read_csv("sales.csv")

# clean data - this script is derived from the iterative cleaning exploration we went through.
# see notebook for details

sales_final <- sales %>%
  select(event_name:fin_mkt_nm) %>%
  separate(event_date_time, c("event_dt", "event_time"), sep = " ") %>%
  separate(sales_ord_create_dttm, c("ord_create_dt", "ord_create_time"), sep = " ") 

date_cols <- str_detect(names(sales_final), "dt")
time_cols <- c("event_time", "ord_create_time")

sales_final[, date_cols] <- lapply(sales_final[, date_cols], ymd)
sales_final[, time_cols] <- lapply(sales_final[, time_cols], hms)

sales_final$secondary_act_name <- str_replace(sales_final$secondary_act_name, "NULL", "None")
sales_final$sales_platform_cd <- str_replace(sales_final$sales_platform_cd, "NULL", "None")

write.csv(sales_final, "sales_final.csv")


