
library(tidyverse)
library(dplyr)
library(pngnewsR)
library(articlesentimentR)
library(lubridate)

# Load current sentiment df
df_sentiment_url <- "https://raw.githubusercontent.com/charlieikosi/PNG-News-Database/refs/heads/main/Postcourier/national_articles_pc_sentiment.csv"
df_sentiment <- read_csv(df_sentiment_url) %>%
  na.omit() %>%
  dplyr::select(1:3)

df_sentiment_original <- read_csv(df_sentiment_url) %>%
  na.omit

# Load Current national df
df_pc.national_url <- "https://raw.githubusercontent.com/charlieikosi/PNG-News-Database/refs/heads/main/Postcourier/national_articles_pc.csv"
df1_pc.national <- read_csv(df_pc.national_url) %>%
  na.omit()

# Filter non duplicate in both df
df_filtered <- anti_join(df1_pc.national, df_sentiment, by = c("Pub.Date", "Top.Stories", "URL"))

# Do sentiment analysis
df2 <- df_filtered

url_list <- df2$URL

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

df3 <- df2
df3$Article.Sentiment <- Article.Sentiment

df3 <- df3 %>%
  mutate(Pub.Date = as.Date(Pub.Date),
         Year = year(Pub.Date))
df3 <- df3 %>%
  mutate(Month = month(Pub.Date, label = TRUE, abbr = FALSE))  # Full names

df3 <- df3 %>%
  mutate(Weekday = wday(Pub.Date, label = TRUE, abbr = FALSE))  # Full name

# merge tables
merged_df <- rbind(df3, df_sentiment_original) %>%
  arrange(desc(Pub.Date))

write.csv(merged_df,"Postcourier/national_articles_pc_sentiment.csv", row.names = FALSE)
