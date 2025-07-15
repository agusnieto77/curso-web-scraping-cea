library(TweetScraperR)

tweets_milei <- readRDS("./Milei_2025_07_12_19_10_26/tweets_unificados_tweets_search_Milei_2025_07_12_19_12_32.rds")

tw_milei_url <- unique(tweets_milei$url)

tw_milei_df <- getTweetsData2(urls_tweets = tw_milei_url, save = FALSE)

str(tw_milei_df)

View(tw_milei_df)
