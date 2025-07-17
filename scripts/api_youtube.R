library(vosonSML)

# youtube_auth <- Authenticate("youtube", apiKey = Sys.getenv("YOUTUBE_API"))

# saveRDS(youtube_auth, file = "~/.auth_yt")

youtube_auth <- readRDS("~/.auth_yt")


video_ids <- c("https://www.youtube.com/watch?v=nIuQQUNW3zY",
               "https://www.youtube.com/watch?v=MXSRiMrWFBA&t=19s",
               "https://www.youtube.com/watch?v=YRg6L2XnnUA")

youtubeData <- youtube_auth |> Collect(videoIDs = video_ids, writeToFile = TRUE, verbose = FALSE, maxComments = 200)
