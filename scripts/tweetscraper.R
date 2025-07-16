# package 'TweetScraperR' version '0.2.3.9000'
library(TweetScraperR)

openTwitter()

userTwitter()

passTwitter()

tweets_realtime <- getTweetsSearchStreaming2(search = "Milei", n_tweets = 30)

tweets_historic <- getTweetsHistoricalHashtag("#rstats", n_tweets = 30)

closeTwitter()

tweets_realtime

tweets_historic

tweets_realtime_enriquecidos <- extractTweetsData(tweets_realtime)

tweets_historic_enriquecidos <- extractTweetsData(tweets_historic)
