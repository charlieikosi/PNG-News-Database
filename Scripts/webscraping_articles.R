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

# Scrape new business articles data
df2 <- scrape_news(40, "business", "postcourier")
df2$Pub.Date <- as.POSIXct(strptime(df2$Pub.Date, format = "%B %d, %Y"))
df2$Pub.Date <- df2$Pub.Date %>% as.Date(tryFormats = "%Y-%m-%d", tz = "NZ")

# Filter out duplicate rows in scraped data
df2_filtered <- anti_join(df2, df1, by = c("Pub.Date", "Top.Stories", "URL"))

# merge tables
df1_merged <- rbind(df2_filtered, df1)

write.csv(df1_merged,"Postcourier/business_articles_pc.csv", row.names = FALSE)

#------- Scrape National News Articles -----------------------------------------

# Load Current business articles df on github
df_pc.national_url <- "https://raw.githubusercontent.com/charlieikosi/PNG-News-Database/refs/heads/main/Postcourier/national_articles_pc.csv"
df1_pc.national <- read_csv(df_pc.national_url) %>%
  na.omit()

# Scrape new national news articles data
df2_pc.national <- scrape_news(40, "national", "postcourier")
df2_pc.national$Pub.Date <- as.POSIXct(strptime(df2_pc.national$Pub.Date, format = "%B %d, %Y"))
df2_pc.national$Pub.Date <- df2_pc.national$Pub.Date %>% as.Date(tryFormats = "%Y-%m-%d", tz = "NZ")

# Filter out duplicate rows in scraped data
df_pc.national.filtered <- anti_join(df2_pc.national,df1_pc.national, by = c("Pub.Date", "Top.Stories", "URL"))

# merge tables
df_pc.national.merged <- rbind(df_pc.national.filtered,df1_pc.national)

write.csv(df_pc.national.merged,"Postcourier/national_articles_pc.csv", row.names = FALSE)


# Run Sentiment analysis

url_list <- df_pc.national.filtered$URL

Article.Sentiment <- c()
count <- 1

for (i in url_list) {
  count <- count
  sentiment.result <- tryCatch({
    article_sentiment(i)}, error = function(e) {
      # Print the error message
      message("An error occurred: ", e$message)
      # Return a tibble with default values
      tibble(sentiment = "NA", n = "NA", proportion = "NA")
    })
  
  result <- sentiment.result$sentiment[1]
  Article.Sentiment <- c(Article.Sentiment,result)
  message("Accessing article ", count, " of ", length(url_list), "\n")
  count <- count + 1
}

df_pc.national.filtered$Article.Sentiment <- Article.Sentiment

# merge tables
df_pc.national.merged <- rbind(df_pc.national.filtered,df1_pc.national)

write.csv(df_pc.national.merged,"Postcourier/national_articles_pc.csv", row.names = FALSE)
