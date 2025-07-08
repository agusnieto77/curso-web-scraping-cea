require(rvest)
require(dplyr)

url <- "https://www.instagram.com/ceandaluces/p/DGf0Fz-IGGO/"

html <- read_html_live(url)

html$view()

html$click("body > div.x1n2onr6.xzkaem6 > div.x9f619.x1n2onr6.x1ja2u2z > div > div.x1uvtmcs.x4k7w5x.x1h91t0o.x1beo9mf.xaigb6o.x12ejxvf.x3igimt.xarpa2k.xedcshv.x1lytzrv.x1t2pt76.x7ja8zs.x1n2onr6.x1qrby5j.x1jfb8zj > div > div > div > div > div.x7r02ix.x1bphaa0.x18nydb4.xcm95gh.x1vsb9q8.xb88tzc.xw2csxc.x1odjw0f.x5fp0pe.x5yr21d.x19onx9a > div > button._a9--._ap36._a9_0")

html$click("body > div.x1n2onr6.xzkaem6 > div:nth-child(2) > div > div > div.x9f619.x1n2onr6.x1ja2u2z > div > div.x1uvtmcs > div > div > div > div > div.x7r02ix > div > div._ab8w")

imagen <- html_attr(html$html_elements("img.x5yr21d.xu96u03.x10l6tqk.x13vifvy.x87ps6o.xh8yej3"), "src")[1]

fecha <- html_attr(html$html_elements("time.xsgj6o6, time.x1p4m5qa"), "datetime")

texto <- html_text(html$html_elements("div > div > div.x9f619.x1n2onr6.x1ja2u2z > div > div > div.x78zum5.xdt5ytf.x1t2pt76.x1n2onr6.x1ja2u2z.x10cihs4 > div.x9f619.xvbhtw8.x78zum5.x15mokao.x1ga7v0g.x16uus16.xbiv7yw.xvkph5b.x1uhb9sk.x1plvlek.xryxfnj.x1c4vz4f.x2lah0s.x1q0g3np.xqjyukv.x1qjc9v5.x1oa3qoh.x1qughib > div.x10o80wk.x14k21rp.xh8yej3.x8vgawa > section > main > div > div.x6s0dn4.x78zum5.xdt5ytf.xdj266r.x11t971q.xat24cr.xvc5jky.x1n2onr6.xh8yej3 > div > div.x4h1yfo > div > div.x5yr21d.xw2csxc.x1odjw0f.x1n2onr6 > div > div:nth-child(1) > div > div.x9f619.xjbqb8w.x78zum5.x15mokao.x1ga7v0g.x16uus16.xbiv7yw.x1uhb9sk.x1plvlek.xryxfnj.x1iyjqo2.x2lwn1j.xeuugli.x1q0g3np.xqjyukv.x1qjc9v5.x1oa3qoh.x1nhvcw1 > div > span > div > span"))

comentario <- html_text(html$html_elements("div > div > div.x9f619.x1n2onr6.x1ja2u2z > div > div > div.x78zum5.xdt5ytf.x1t2pt76.x1n2onr6.x1ja2u2z.x10cihs4 > div.x9f619.xvbhtw8.x78zum5.x15mokao.x1ga7v0g.x16uus16.xbiv7yw.xvkph5b.x1uhb9sk.x1plvlek.xryxfnj.x1c4vz4f.x2lah0s.x1q0g3np.xqjyukv.x1qjc9v5.x1oa3qoh.x1qughib > div.x10o80wk.x14k21rp.xh8yej3.x8vgawa > section > main > div > div.x6s0dn4.x78zum5.xdt5ytf.xdj266r.x11t971q.xat24cr.xvc5jky.x1n2onr6.xh8yej3 > div > div.x4h1yfo > div > div.x5yr21d.xw2csxc.x1odjw0f.x1n2onr6 > div > div.x78zum5.xdt5ytf.x1iyjqo2 > div > div:nth-child(1) > div > div.x9f619.xjbqb8w.x78zum5.x15mokao.x1ga7v0g.x16uus16.xbiv7yw.x1uhb9sk.x1plvlek.xryxfnj.x1iyjqo2.x2lwn1j.xeuugli.x1q0g3np.xqjyukv.x1qjc9v5.x1oa3qoh.x1nhvcw1 > div > div:nth-child(1) > div > div.x9f619.xjbqb8w.x78zum5.x15mokao.x1ga7v0g.x16uus16.xbiv7yw.x1uhb9sk.x1plvlek.xryxfnj.x1c4vz4f.x2lah0s.xdt5ytf.xqjyukv.x1cy8zhl.x1oa3qoh.x1nhvcw1 > span"))

me_gustas <- html_text(html$html_elements("div > div > div.x9f619.x1n2onr6.x1ja2u2z > div > div > div.x78zum5.xdt5ytf.x1t2pt76.x1n2onr6.x1ja2u2z.x10cihs4 > div.x9f619.xvbhtw8.x78zum5.x15mokao.x1ga7v0g.x16uus16.xbiv7yw.xvkph5b.x1uhb9sk.x1plvlek.xryxfnj.x1c4vz4f.x2lah0s.x1q0g3np.xqjyukv.x1qjc9v5.x1oa3qoh.x1qughib > div.x10o80wk.x14k21rp.xh8yej3.x8vgawa > section > main > div > div.x6s0dn4.x78zum5.xdt5ytf.xdj266r.x11t971q.xat24cr.xvc5jky.x1n2onr6.xh8yej3 > div > div.x4h1yfo > div > div.x1xp8e9x.x13fuv20.x178xt8z.x9f619.x1yrsyyn.xv54qhq.x10b6aqq.xf7dkkf.xh8yej3 > section.x12nagc > div > div > span > a > span"))

n_comentarios <- html_text(html_elements(html, "div > div > div.x9f619.x1n2onr6.x1ja2u2z > div > div > div.x78zum5.xdt5ytf.x1t2pt76.x1n2onr6.x1ja2u2z.x10cihs4 > div.x9f619.xvbhtw8.x78zum5.x15mokao.x1ga7v0g.x16uus16.xbiv7yw.xvkph5b.x1uhb9sk.x1plvlek.xryxfnj.x1c4vz4f.x2lah0s.x1q0g3np.xqjyukv.x1qjc9v5.x1oa3qoh.x1qughib > div.x10o80wk.x14k21rp.xh8yej3.x8vgawa > section > main > div > div.x6s0dn4.x78zum5.xdt5ytf.xdj266r.x11t971q.xat24cr.xvc5jky.x1n2onr6.xh8yej3 > div > div.x4h1yfo > div > div.x5yr21d.xw2csxc.x1odjw0f.x1n2onr6 > div > div.x78zum5.xdt5ytf.x1iyjqo2 > div > div.x9f619.xjbqb8w.x78zum5.x15mokao.x1ga7v0g.x16uus16.xbiv7yw.x1uhb9sk.x1plvlek.xryxfnj.x1c4vz4f.x2lah0s.xdt5ytf.xqjyukv.x1qjc9v5.x1oa3qoh.x1nhvcw1.x11hdunq > div > div > span"))

post_cea <- tibble(fecha = fecha, text_post = texto, img_post = imagen, me_gustas = me_gustas, n_comentarios = n_comentarios, primer_com = comentario, url = url)

glimpse(post_cea)

html$session$close()
