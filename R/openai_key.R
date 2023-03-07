clear_openai_key = function() {
  Sys.setenv(OPENAI_API_KEY = "")
}

set_openai_key = function(key=NULL, path=NULL) {
  if (!is.null(key)) {
    Sys.setenv(OPENAI_API_KEY = key)
    return(TRUE)
  }
  if (file.exists(file.path(path,"openai.key"))) {
    key = readLines(file.path(path,"openai.key"))
    Sys.setenv(OPENAI_API_KEY = key)
    return(TRUE)
  }
  if (file.exists(path) & !dir.exists(path)) {
    try({
      key = readLines(path)
      Sys.setenv(OPENAI_API_KEY = key)
      return(TRUE)
    })
  }
  return(FALSE)
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
