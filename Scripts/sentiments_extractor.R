library(tidyverse)
library(dplyr)
library(pngnewsR)
library(articlesentimentR)

# Load Current business articles df on github
df_pc.national_url <- "https://raw.githubusercontent.com/charlieikosi/PNG-News-Database/refs/heads/main/Postcourier/national_articles_pc.csv"
df1_pc.national <- read_csv(df_pc.national_url) %>%
  na.omit()

df2 <- df1_pc.national

#df1.Central <- df1_pc.national %>%
#  dplyr::filter(grepl("Central Province", Top.Stories, ignore.case =TRUE))

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
write.csv(df3,"Postcourier/national_articles_pc_sentiment.csv", row.names = FALSE)

         
library(lubridate)

df3 <- df3 %>%
  mutate(Pub.Date = as.Date(Pub.Date),
         Year = year(Pub.Date))
df3 <- df3 %>%
  mutate(Month = month(Pub.Date, label = TRUE, abbr = FALSE))  # Full names

df3 <- df3 %>%
  mutate(Weekday = wday(Pub.Date, label = TRUE, abbr = FALSE))  # Full name

write.csv(df3,"Postcourier/national_articles_pc_sentiment.csv", row.names = FALSE)



# Working script

# Load sentiment df on github
df_pc.national_sentiment_url <- "https://raw.githubusercontent.com/charlieikosi/PNG-News-Database/refs/heads/main/Postcourier/national_articles_pc_sentiment.csv"
df_pc.national_sentiment <- read_csv(df_pc.national_sentiment_url) %>%
  na.omit()

# Load Current business articles df on github
df_pc.national_url <- "https://raw.githubusercontent.com/charlieikosi/PNG-News-Database/refs/heads/main/Postcourier/national_articles_pc.csv"
df1_pc.national <- read_csv(df_pc.national_url) %>%
  na.omit()



# Filter out duplicate rows in data
filtered_df <- anti_join(df1_pc.national, df_pc.national_sentiment, by = c("Pub.Date", "Top.Stories", "URL"))

filtered_df2 <- df1_pc.national %>%
  anti_join(df_pc.national_sentiment, by = c("Pub.Date", "Top.Stories", "URL"))



df2 <- filtered_df2

#df1.Central <- df1_pc.national %>%
#  dplyr::filter(grepl("Central Province", Top.Stories, ignore.case =TRUE))

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

library(lubridate)

df3 <- df3 %>%
  mutate(Pub.Date = as.Date(Pub.Date),
         Year = year(Pub.Date))
df3 <- df3 %>%
  mutate(Month = month(Pub.Date, label = TRUE, abbr = FALSE))  # Full names

df3 <- df3 %>%
  mutate(Weekday = wday(Pub.Date, label = TRUE, abbr = FALSE))  # Full name


#write.csv(df3,"Postcourier/national_articles_pc_sentiment.csv", row.names = FALSE)

