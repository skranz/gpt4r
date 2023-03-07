example_embedding = function() {
  #key = readLines("C:/libraries/gpt4r/openai.key")
  set_openai_key(path="C:/libraries/gpt4r/openai.key")

  input = "Hi, I am a text that wants to get an embedding."

  resp = gpt_embedding(input)
  emb = resp$embedding

}

gpt_embedding = function(input){
  openai_key = get_openai_key()
  model = 'text-embedding-ada-002'
  parameter_list = list(model = model ,input = input)
  restore.point("gpt_embedding")

  resp = httr::POST(url = "https://api.openai.com/v1/embeddings", body = parameter_list, httr::add_headers(Authorization = paste("Bearer", openai_key)), encode = "json")

  restore.point("gpt_embedding2")
  output_base = httr::content(resp)

  #resp$embedding = to_numeric(unlist(output_base$data[[1]]$embedding))
  resp$embedding = unlist(output_base$data[[1]]$embedding)
  return(resp)
}
