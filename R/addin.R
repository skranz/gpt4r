
#' Run a ChatGPT RStudio Addin
#'
#' @param tpl_name Name of the tpl to execute.
run_tpl_addin <- function(tpl_name, pkg = "mygpt", default_tpl_dir = system.file("templates", package=pkg)) {
  library(gpt4r)
  require(pkg, character.only=TRUE)

  doc_context <- getActiveDocumentContext()
  restore.point("run_tpl_addin")

  # Get path of current document and set openai key
  path = doc_context$path
  if (path == "") {
    cat("\nSorry could not detect the active document. Please, try again.\n")
    return(invisible())
  }

  dir = dirname(doc_context$path)
  api.key = get_openai_key(dir)

  # If a template with same name exists in
  # directory of document use that template
  # otherwise take from package.
  tpl_file = find_tpl_file(tpl_name, dir, default_tpl_dir)

  if (is.null(tpl_file)) {
    cat(paste0("\nCould not find template file ", tpl_name,".yml"))
    return(invisible())
  }

  setwd(dir)

  tpl = parse_gpt_tpl(tpl_file)
  tpl = set_gpt_tpl_defaults(tpl)

  ext = tools::file_ext(doc_context$path)
  if (length(tpl$only_files)>0) {
    if (!tolower(ext) %in% tolower(tpl$only_files)) {
      cat(paste0("To reduce unintended, effects you have to select some text in a file with one of the following extensions: ", paste0(tpl$only_files, collapse=", "),". But the current active file is ", doc_context$path,"."))
      return(invisible())
    }
  }


  # Get the selected text.
  text <- doc_context$selection[[1]]$text
  no_sel <- all(nchar(text) == 0)
  # If no text is selected, use the whole file.
  if (no_sel) {
    cat("\nPlease select some text in an open document in RStudio! (Try again if the selected text was not detected.)")
    return()
  }
  text <- paste0(text, collapse = "\n")


  if (isTRUE(tpl$action=="copy_prompt")) {
    just.prompt = TRUE
    cat("\nThe default action was set to 'copy_prompt'.")
  } else if (is.null(api.key)) {
    just.prompt = TRUE
    cat("\nSince no OpenAI API key was set, I will just copy the prompt in the clipboard. You can manually paste it on the ChatGPT or Bing Chat Webinterface.")
  }
  if (just.prompt) {
    prompt = glue_text(tpl$prompt, list(text=text))
    cat(paste0("\n The prompt is:\n\n",prompt))
    try({
      clipr::write_clip(prompt)
      cat("\n\n---The prompt above was copied to the clipboard ---\n\n")
      log_gpt_call(tpl, text, out="copy_prompt",present_text=NA)
    })
    return(invisible())
  }


  # Apply the addin function.
  resp <- run_gpt_with_tpl(tpl,values=list(text=text))

  out = resp$output
  present_text = present_addin_results(doc_context,tpl,text,out)

  # Create a log so that later students can easily show
  # how they used chat-gpt
  log_gpt_call(tpl, , out,present_text)

  invisible(NULL)
}
