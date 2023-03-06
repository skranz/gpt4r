log_gpt_call = function(tpl, input, output, present_text) {
  restore.point("log_gpt_call")
  if (!isTRUE(tpl$do_log)) {
    cat("\nGPT call not logged.")
    return(FALSE)
  }
  log = list(
    date = Sys.Date(),
    tpl = tpl,
    input = input,
    output = output,
    present_text = present_text
  )
  log_dir = tpl$log_dir
  if (!dir.exists(log_dir)){
    cat("\nGenerate log dir", log_dir)
    try(dir.create(log_dir))
  }
  if (!dir.exists(log_dir)) {
    cat("\nSorry could not generate the log dir.")
    return(FALSE)
  }
  existing.files = list.files(log_dir)
  log_num = str.between(existing.files, "gpt_call_",".Rds") %>% as.integer()
  max_log_num = suppressWarnings(max(log_num, na.rm=TRUE))
  if (!is.finite(max_log_num)) max_log_num = 0
  log_num = max_log_num+1
  log_file = file.path(log_dir,paste0("gpt_call_",log_num,".Rds"))
  saveRDS(log, log_file)
}
