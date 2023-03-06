example_set_list_defaults = function() {
  li = list(a="hi", su = list(x="Hello"))
  def = list(a="a",b="b",c="c", su = list(x="x",y="y"))
  set_list_defaults(li, def, "su")
}

glue_text = function(pattern, values,make.line.breaks=FALSE,.open="{{", .close = "}}",...) {
  restore.point("glue_text")
  env = as.environment(values)
  parent.env(env) = globalenv()
  res_text= glue(pattern, .envir=env, .trim=FALSE, .open=.open, .close=.close)
  if (make.line.breaks) {
    restore.point("glue_text2")
    res_text = gsub("\\n","\n",res_text, fixed=TRUE)
  }
  res_text
}

set_list_defaults = function(li, def, sublists = NULL) {
  # Set default for sublists
  fields = intersect(sublists, names(li))
  for (field in fields) {
    li[[field]] = set_list_defaults(li[[field]], def[[field]])
  }

  def[names(li)] = li
  def
}

first.non.null = function(...) {
  args = list(...)
  for (val in args) {
    if (!is.null(val)) return(val)
  }
  return(NULL)

}
