# install.packages("devtools")
# devtools::install_github("agusnieto77/TweetScraperR")

library(TweetScraperR)

usuarixs_r <- c(
  "https://x.com/RosanaFerrero",
  "https://x.com/estacion_erre",
  "https://x.com/bastimapache",
  "https://x.com/curso_r",
  "https://x.com/rstudiotips",
  "https://x.com/SpatialLabA",
  "https://x.com/posit_pbc",
  "https://x.com/daily_r_sheets",
  "https://x.com/rupert_pupkin",
  "https://x.com/daniellequinn88",
  "https://x.com/ErreEspanol",
  "https://x.com/CodigoAbierto25",
  "https://x.com/NeaRenel",
  "https://x.com/R4DS_es",
  "https://x.com/renbaires",
  "https://x.com/renrosarioarg",
  "https://x.com/rstatstweet",
  "https://x.com/Diego_Koz",
  "https://x.com/LatinR_Conf",
  "https://x.com/RLadiesBA"
)

usuarixs_df <- getUsersData(urls_users = u, save = FALSE)

str(usuarixs_df)

View(usuarixs_df)
