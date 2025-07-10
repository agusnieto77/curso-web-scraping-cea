# Cargamos la librería
require(TweetScraperR)

# Con la función getTweetsSearchStreaming() recolectamos en tiempo real los  
# tweets que mencionan el término de búsqueda, en este ejemplo es un hashtag.
# Esta función guarda un rds con los tweets y algunos metadatos.

urls_hashtagRstats <- getTweetsSearchStreaming(search = "#RStats", n_tweets = 20)
