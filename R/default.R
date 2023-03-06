
default_gpt_tpl = function() {
  def = list(
    action = first.non.null(get_gpt_default_action(),"run"),
    system = "You are a helpful assisstant.",
    verbose = TRUE,
    parameter = list(
      model="gpt-3.5-turbo",
      temperature = 0.7
    ),
    # none, prompt or output
    to_clipboard = "none",
    do_log = TRUE,
    log_dir = "gpt_logs",
    present = list(
      where = "inline",
      ext = "Rmd",
      input_header = "",
      output_header = "",
      input_footer = "",
      output_footer = "",
      input_line_prefix = "",
      output_line_prefix = ""
    ),
    console = list(
      show_before = "
Task for ChatGPT: {{tpl$prompt}}

Wait until ChatGPT is creating the answer...",
      show_after = " ...done.\n"
    )
  )


}

set_gpt_tpl_defaults = function(tpl, def_tpl = default_gpt_tpl()) {
  restore.point("set_gpt_tpl_defaults")
  tpl = set_list_defaults(tpl, def_tpl, c("parameter","present"))
  tpl$verbose = as.logical(tpl$verbose)
  tpl$do_log = as.logical(tpl$do_log)
  tpl
}

