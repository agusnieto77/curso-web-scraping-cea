library(rvest)

url_rooms <- "https://www.airbnb.com.ar/rooms/551177743350811683/"

html_rooms <- read_html_live(url_rooms)

html_rooms |> html_element("h1") |> html_text2()

html_rooms |> html_elements("img") |> html_attr("src")

html_rooms |> html_element("h2") |> html_text2()

html_rooms |> html_element("ol") |> html_text2()

html_rooms |> html_element("div.lbjrbi0") |> html_text2()

html_rooms |> html_element("div.a8jhwcl") |> html_text2()

html_rooms |> html_element("div.rn4plgm") |> html_text2()

html_rooms |> html_element("div.t1lpv951") |> html_text2()

html_rooms |> html_element("div.s121tj5m") |> html_text2()

html_rooms |> html_element("div.i1jq8c6w") |> html_text2()

html_rooms |> html_element("div.d1isfkwk") |> html_text2()

html_rooms |> html_element("div.c16f2viy") |> html_text2()

html_rooms |> html_element("div.c14whb16") |> html_text2() |> cat()

html_rooms |> html_element("div.rjiv01r") |> html_text2() |> cat()

boton <- "div.d17m63sc > div.c1lbtiq8 > button.l1ovpqvx"

if (length(html_rooms$html_elements(boton)) > 0) { html_rooms$click(boton) }
Sys.sleep(2)

html_rooms$scroll_by(2500)
Sys.sleep(3)
html_rooms$scroll_by(2500)
Sys.sleep(3)

html_rooms |> html_element("div.gm-style > div a") |> html_attr("href")

html_rooms |> html_element("div._vd6w38n") |> html_text2()

html_rooms |> html_element("div.cmuek5n") |> html_text2() |> cat()

html_rooms |> html_element("div._88xxct") |> html_text2() |> cat()

html_rooms$session$close()
