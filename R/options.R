set_gpt_default_action = function(action=c("run","copy_prompt")[1]) {
  options("gpt_default_action"=action)
}
get_gpt_default_action = function() {
  getOption("gpt_default_action")
}
