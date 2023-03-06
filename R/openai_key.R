clear_openai_key = function() {
  Sys.setenv(OPENAI_API_KEY = "")
}


get_openai_key = function(dir=getwd(), keyfile = NULL) {
  key = Sys.getenv("OPENAI_API_KEY")
  if (key=="") {
    if (!is.null(keyfile)) {
      if (file.exists(keyfile)) {
        key = readLines(file.path(dir,"openai.key"))
        Sys.setenv(OPENAI_API_KEY = key)
        return(invisible(key))
      }
    }
    if (file.exists(file.path(dir,"openai.key"))) {
      key = readLines(file.path(dir,"openai.key"))
      Sys.setenv(OPENAI_API_KEY = key)
      return(invisible(key))
    }
    cat('\nI cannot find OPENAI_API_KEY. To specify the key in R either call:

Sys.setenv(OPENAI_API_KEY = "XX-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")

or create a text file `openai.key` containing just the key as string in the directory of the documents that you modify.
')
    return(NULL)
  }
  return(invisible(key))
}
