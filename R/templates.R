example = function() {
  tpl.file = "C:/libraries/RTutorChatGPT/as_poem.yml"

  prompt = "Below you find a task for a student, a sample solution and the answer by the student. Please evaluate the student's answer based on the sample solution.

TASK FOR STUDENT:

{{task}}

SAMPLE SOLUTION:

{{solution}}

STUDENT'S ANSWER:

{{answer}}
"
  task = "Describe all information given about Germany in the tex we read in our lecture."

  solution = "It is a founding member of the EU since 1958. Its population is roughly 80 million. Longest chancellor after the 2nd world war was Helmut Kohl (16 years), longest chancellor overall was Bismarck (22 years)"

  answer = "Germany is the biggest country in Europe and member of the EU. Chancellor for the longest time was Helmut Kohl."

  tpl = new_gtp_tpl(prompt=prompt, temperature = 0.9)
  key = get_openai_key(dir="C:/libraries/gpt4rstudio")
  values = list(task=task, solution=solution, answer=answer)
  res = run_gpt_with_tpl(tpl, values)

  # Just generate prompt and copy to clipboard
  # Can be used in web interface of ChatGPT or BingGPT
    res_prompt = get_gpt_prompt(tpl, values)
}


get_gpt_prompt = function(tpl, values, to.clipboard=TRUE) {
  restore.point("get_gpt_prompt")
  prompt = glue_text(tpl$prompt, values)
  if (to.clipboard) {
    clipr::write_clip(prompt)
    cat("\n",prompt,"\n")
    cat("\n\n---The prompt above was copied to the clipboard ---\n\n")
    return(invisible(prompt))
  }
  return(prompt)
}

#' Manually create a simple template
#'
#' Not all template settings can be specified by this function but only
#' those you may want to  naturally modify for non-interactive use.
#' Missing settings will be set to default.
new_gtp_tpl = function(prompt, temperature=0.8, do_log=TRUE, log_dir="gpt_logs", verbose=TRUE, action = NULL) {
  tpl = list(prompt=prompt,parameter=list(temperature=temperature), do_log=do_log, log_dir = "gpt_logs", verbose=verbose)
  if (!is.null(action)) {
    tpl$action = action
  }
  tpl
}

parse_gpt_tpl = function(tpl.file=paste0(dir,"/",tpl_name,".yml"), dir=getwd(), tpl_name) {
  restore.point("parse_gpt_tpl")
  dir = dirname(tpl.file)
  get_openai_key(dir)
  tpl = yaml::read_yaml(tpl.file)
}

default_gpt_tpl = function() {
  def = list(
    action = first.non.null(get_gpt_default_action(),"run"),
    system = "You are a helpful assisstant.",
    verbose = TRUE,
    parameter = list(
      model="gpt-3.5-turbo",
      temperature = 0.7
    ),
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



find_tpl_file = function(tpl_name, dir=getwd(), default.dir=system.file("templates", package="mygpr")) {
  restore.point("find_tpl_file")
  base = paste0(tpl_name,".yml")

  #file = file.path(dir, base)
  #if (file.exists(file)) return(file)

  file = file.path(default.dir, base)
  if (file.exists(file) & !identical(file,"")) return(file)
  return(NULL)
}



