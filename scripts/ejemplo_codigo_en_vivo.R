library(rvest)
library(tidyverse)

url1 <- "https://opendata.aemet.es/centrodedescargas/inicio"
url2 <- "https://bocm.es/"

"h6 form"
"action"
html1 <- read_html_live(url1)

html1$view()

link1 <- html1$html_elements("#form2")[2] |> html_attr("action") |> url_absolute("https://opendata.aemet.es/")

read_html_live(link1) |> html_table()

html1$click("#form2")

html_elements(html1, "h1, h2, h3, h4, a, p") |> html_text2()

link <- html_element(html1, xpath = "//*[@id='form2']") |> html_attr("action") |> url_absolute("https://opendata.aemet.es/")

html2 <- read_html(url2)

html_elements(html2, "h1, h2, h3, h4, a, p") |> html_text2()

bolcomp <- ".field-item.even .file a"
bolhtml <- ".field-item.even > a"
bolsum  <- ".field-item.even .file a"
bolxml <-  ".field-item.even .file a"

bolcomp <- "//*[@id='node-931322']/div[2]/div[1]/div/div/div/span/a"
bolhtml <- "//*[@id='node-931322']/div[2]/div[2]/div[1]/div/div/a"
bolsum  <- "//*[@id='node-931322']/div[2]/div[2]/div[2]/div/div/span/a"
bolxml <-  "//*[@id='node-931322']/div[2]/div[2]/div[3]/div/div/div/a"

html_element(html2, css = bolhtml) |> html_attr("href") |> url_absolute("https://bocm.es/")

read_html("https://bocm.es/boletin/bocm-20250703-157") |> html_element("body") |> html_text()

urls <- read_html("https://bocm.es/boletin/bocm-20250703-157") |> html_elements(".view-content a") |> html_attr("href") |> url_absolute("https://bocm.es/")

body <- c()

for (u in urls) {
  body <- append(body, read_html(u) |> html_element("body") |> html_text())
}

body |> cat()
