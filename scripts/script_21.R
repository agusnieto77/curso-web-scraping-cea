# https://ollama.com/download

library(ollamar)
library(ellmer)

shell("start /b ollama serve")

test_connection()

# pull("gemma3n")

list_models()

instruccion <-  "
Hola, necesito identificar los selectores de una página web
con el objetivo de hacer web scraping con R. ¿Podés ayudarme?
"

chat_deepseek <- chat_ollama(model = "deepseek-r1:1.5b")
chat_llama <- chat_ollama(model = "llama3.2")
chat_gemma3n <- chat_ollama(model = "gemma3n")
chat_gemma3 <- chat_ollama(model = "gemma3")
chat_qwen <- chat_ollama(model = "qwen3:1.7b")

chat_deepseek$chat(instruccion)
chat_llama$chat(instruccion)
chat_gemma3n$chat(instruccion)
chat_gemma3$chat(instruccion)
chat_qwen$chat(instruccion)

shell("taskkill /IM ollama.exe /F")
