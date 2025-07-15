library(TweetScraperR)

tweets_milei <- readRDS("./Milei_2025_07_12_19_10_26/tweets_unificados_tweets_search_Milei_2025_07_12_19_12_32.rds")

tw_milei_df2 <- extractTweetsData(tweets_milei)

str(tw_milei_df2)

View(tw_milei_df2)
