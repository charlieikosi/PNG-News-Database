library(tidyverse)
library(dplyr)
library(pngnewsR)
library(articlesentimentR)

# Load Current business articles df on github
df_pc.national_url <- "https://raw.githubusercontent.com/charlieikosi/PNG-News-Database/refs/heads/main/Postcourier/national_articles_pc.csv"
df1_pc.national <- read_csv(df_pc.national_url) %>%
  na.omit()

#df1.Central <- df1_pc.national %>%
#  dplyr::filter(grepl("Central Province", Top.Stories, ignore.case =TRUE))

url_list <- df1_pc.national$URL

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
df1.Central$Article.Sentiment <- Article.Sentiment
url_list[93]
                        