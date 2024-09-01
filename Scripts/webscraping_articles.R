# Change this path to you your local folder
setwd("C:/Users/charl/Documents/Repositories/PNG-News-Database")

library(pngnewsR)
library(tidyverse)
library(dplyr)

# Check allowable number of pages to scrape
#page_validate(1,"https://www.postcourier.com.pg/national-news/")
#page_validate(1,"https://www.postcourier.com.pg/business/")

# Load Current business articles df on github
df_url <- "https://raw.githubusercontent.com/charlieikosi/PNG-News-Database/main/Postcourier/business_articles_pc.csv"
df1 <- read_csv(df_url) %>%
  dplyr::select(2:4)

# Scrape new business articles data
df2 <- scrape_news(6, "business", "postcourier")

# Filter out duplicate rows in scraped data
df2_filtered <- anti_join(df2, df1, by = c("Pub.Date", "Top.Stories", "URL"))

# merge tables
df1_merged <- rbind(df2_filtered, df1)

write.csv(df1_merged,"Postcourier/business_articles_pc.csv")
