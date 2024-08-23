setwd("C:/Users/charl/Documents/Repositories/PNG-News-Database")

library(pngnewsR)
library(tidyverse)
library(dplyr)

# Check allowable number of pages to scrape
page_validate(1,"https://www.postcourier.com.pg/national-news/")

national_df <- scrape_news(2082,'national;','postcourier')
write.csv(national_df,"national_articles_pc.csv")

page_validate(1,"https://www.postcourier.com.pg/business/")


