present_addin_results = function(doc_context, tpl, text, out) {
  restore.point("present_addin_results")

  out = sep.lines(out)
  text = sep.lines(text)

  present = tpl$present
  show = present$show
  if (show=="none") {
    cat("\nNo output presented since present.show = none\n")
    return(invsible())
  }

  vals = list(label=tpl$label, date=as.character(Sys.Date()), time=as.character(Sys.time()))

  present_input = paste0(
    glue_text(present$input_header, vals, make.line.breaks=TRUE),
    paste0(present$input_line_prefix, text, collapse="\n"),
    glue_text(present$input_footer,vals, make.line.breaks=TRUE)
  )
  present_output = paste0(
    glue_text(present$output_header,vals, make.line.breaks=TRUE),
    paste0(present$output_line_prefix, out, collapse="\n"),
    glue_text(present$output_footer,vals, make.line.breaks=TRUE)
  )


  show = present$show
  if (show == "input-output") {
    present_text = paste0(present_input, present_output)
  } else if (show == "output-input") {
    present_text = paste0(present_output, present_input)
  } else if (show == "output") {
    present_text = present_output
  } else if (show == "input") {
    present_text = present_input
  } else {
    warning(paste0("Unknown specification in present.show: ", show,".\nUse \"input-output\" instead."))
  }


  if (present$where == "open_doc") {
    present_open_doc(doc_context, tpl, present_text)
  } else if (present$where == "new_file") {
    present_open_doc(doc_context, tpl, present_text)
  } else if (present$where == "inline") {
    present_inline(doc_context, tpl, present_text)
  } else {
    warning(paste0('\npresent.where = "', present$where, '" is unknown. By default present in new document.'))
    present_open_doc(doc_context, tpl, present_text)
  }

  return(present_text)
}

present_inline = function(doc_context,tpl, present_text) {
  doc_range <- doc_context$selection[[1]]$range
  modifyRange(doc_range, present_text, doc_context$id)
}

present_open_doc = function(doc_context,tpl, present_text) {

  ext = tpl$present$ext

  if (tolower(ext)=="r") {
    type = "r"
  }  else {
    type = "rmarkdown"
  }
  context = documentNew(
    text = present_text,
    type = type,
    position = document_position(0, 0),
    execute = FALSE
  )
}


present_new_file = function(doc_context,tpl, present_text) {
  ext = tpl$present$ext

  if (tolower(ext)=="r") {
    type = "r"
  }  else {
    type = "rmarkdown"
  }
  context = documentNew(
    text = present_text,
    type = c("r", "rmarkdown", "sql"),
    position = document_position(0, 0),
    execute = FALSE
  )
}
