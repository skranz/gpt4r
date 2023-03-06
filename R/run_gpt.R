
#' Run a GPT Template with the given input text
#'
#' @param tpl The template
#' @param values A list with input values used in the template. For mygpt templates, values has just the element 'text' containing the selected text in the RStudio.
#' @param openai_key OpenAI's API key.
#'
run_gpt_with_tpl <- function(tpl, values=list(), openai_key = get_openai_key()) {
  restore.point("run_gpt_with_tpl")
  if (is.null(openai_key)) {
    stop("`openai_key` not provided.")
  }

  # Set default fields in tpl
  tpl = set_gpt_tpl_defaults(tpl)

  params = tpl$parameter
  model = params$model

  if (!"text" %in% names(values)) {
    values$text = text
  }
  prompt = glue_text(tpl$prompt, values)

  if (isTRUE(tpl$action=="copy_prompt")) {
    cat(paste0("\ngpt_default_action is copy_prompt\n\n",prompt))
    clipr::write_clip(prompt)
    cat("\n\n---The prompt above was copied to the clipboard ---\n\n")
    return(invisible())
  }


  console = tpl$console
  if (isTRUE(tpl$verbose)) {
    show = glue_text(console$show_before, list(prompt=prompt, tpl=tpl, text=text, label=tpl$label))
    cat(show)
  }

  if (grepl("gpt-3.5-turbo", model)) {
    messages <- list(
      list(
        role = "system",
        content = tpl$system
      ),
      list(role = "user", content = prompt)
    )
    resp = content(POST(
      url = "https://api.openai.com/v1/chat/completions",
      add_headers("Authorization" = paste("Bearer", openai_key)),
      content_type_json(),
      body = toJSON(c(params, list(messages = messages)), auto_unbox = TRUE)
    ))
  } else {
    resp = content(POST(
      url = "https://api.openai.com/v1/completions",
      add_headers("Authorization" = paste("Bearer", openai_key)),
      content_type_json(),
      body = toJSON(c(params, list(prompt = prompt)), auto_unbox = TRUE)
    ))
  }
  restore.point("run_gpt_tpl2")
  output = parse_response(resp, tpl$parameter$model)
  if (isTRUE(tpl$verbose)) {
    show = glue_text(console$show_after, list(output = output, prompt=prompt, text=text, label=tpl$label))
    cat(show)
  }

  resp$output = output
  resp
}

#' Parse OpenAI API Response
#'
#' Takes the raw response from the OpenAI API and extracts the text content from it.
#' This function is currently designed to differentiate between gpt-3.5-turbo and others.
#'
#' @param raw_response The raw response object returned by the OpenAI API.
#'
#' @return Returns a character vector containing the text content of the response.
#'
parse_response <- function(raw_response, model="gpt-3.5-turbo") {
  # If the model is from the `gpt-3.5-turbo` family, it parses in a different way.
  if (grepl("gpt-3.5-turbo", model)) {
    trimws(sapply(raw_response$choices, function(x) x$message$content))
  } else {
    trimws(sapply(raw_response$choices, function(x) x$text))
  }
}
