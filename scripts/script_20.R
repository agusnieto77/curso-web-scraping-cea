library(TweetScraperR)

milei_rds   <- readRDS("milei.rds")

arrow::write_parquet(milei_rds, "milei.parquet")

milei_arrow <- arrow::read_parquet("milei.parquet")

milei_arrow |> class()

milei_arrow |> head()

milei_db <- extractTweetsData(milei_arrow[1:1000, ])

img <- unlist(milei_db$links_img_post)

img <- grep("/media/", img, value = TRUE)

img <- sub("\\?.*$", ".jpg", img)

img <- unique(img)

getTweetsImages(img)

imagenes <- list.files("./img_x", pattern = "\\.jpg$", full.names = TRUE)

tamanos <- file.info(imagenes)$size

imagenes_a_eliminar <- imagenes[tamanos < 100]

file.remove(imagenes_a_eliminar)

imagenes <- list.files("./img_x", pattern = "\\.jpg$", full.names = TRUE)

img_20 <- sample(imagenes, 20)

analisis_img <- getTweetsImagesAnalysis(img_20)

View(getTweetsImagesAnalysis)

HTMLImgReport(analisis_img)

plotWords(milei_arrow, min_freq = 5, max_words = 200, sw = c('javier', 'milei', 'argentina', 'presidente', 'gobierno', 'si', 'va', 'q', 'the'))

plotEmojis(milei_db, top_n = 15)

plotEmojisPNG(milei_db, top_n = 15)

