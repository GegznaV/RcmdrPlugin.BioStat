% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bs_widget_modify_names.R
\name{tk_widget_modify_names}
\alias{tk_widget_modify_names}
\title{TCL/TK helper widget for multiple variable names}
\usage{
tk_widget_modify_names(
  parent = top,
  init_val_radiobuttons = c("modify", "overwrite"),
  init_val_checkbox = "1",
  init_val_prefix = "",
  init_val_suffix = "",
  layout = "vvhv",
  width = 12,
  cmd_radiobuttons = do_nothing,
  cmd_checkbox = do_nothing,
  cmd_change_prefix = do_nothing,
  cmd_change_suffix = do_nothing
)
}
\description{
TCL/TK helper widget for multiple variable names
}
\examples{
\dontrun{\donttest{
paret_frame <- tktoplevel()
widget <- tk_widget_modify_names(paret_frame, layout = "vvhv")
tkgrid(widget$frame)
}}
}
\keyword{internal}
