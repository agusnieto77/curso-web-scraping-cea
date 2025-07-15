library(TweetScraperR)

tweets_milei <- readRDS("./Milei_2025_07_12_19_10_26/tweets_unificados_tweets_search_Milei_2025_07_12_19_12_32.rds")

usuarixs_milei <- unique(gsub("@", "https://x.com/", tweets_milei$user))

usuarixs_milei_df <- getUsersData(urls_users = u, save = FALSE)

str(usuarixs_milei_df)

View(usuarixs_milei_df)
