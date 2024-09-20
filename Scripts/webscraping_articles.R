# Change this path to you your local folder
setwd("C:/Users/charl/Documents/Repositories/PNG-News-Database")

library(pngnewsR)
library(tidyverse)
library(dplyr)

# Check allowable number of pages to scrape
#page_validate(1,"https://www.postcourier.com.pg/sports/")
#page_validate(1,"https://www.postcourier.com.pg/business/")

# Load Current business articles df on github
df_url <- "https://raw.githubusercontent.com/charlieikosi/PNG-News-Database/main/Postcourier/business_articles_pc.csv"
df1 <- read_csv(df_url) %>%
  na.omit()


# Scrape national news articles
#df1 <- scrape_news(2092, "national", "postcourier")

# Scrape new business articles data
df2 <- scrape_news(10, "business", "postcourier")

# Filter out duplicate rows in scraped data
df2_filtered <- anti_join(df2, df1, by = c("Pub.Date", "Top.Stories", "URL"))

# Format date
df2_filtered$Pub.Date <- as.POSIXct(strptime(df2_filtered$Pub.Date, format = "%B %d, %Y"))
df1$Pub.Date <- as.POSIXct(strptime(df1$Pub.Date, format = "%d/%m/%Y"))

# merge tables
df1_merged <- rbind(df2_filtered, df1)

# Set date column to date format
#df1_merged$Pub.Date <- as.POSIXct(df1_merged$Pub.Date, format = "%B %d, %Y")

write.csv(df1_merged,"Postcourier/business_articles_pc.csv", row.names = FALSE)
