# TODO:
#
# Renew template of:
#
#   - the main function:
#       + structure;
#       + widgets:
#           + ...
#           + ...
#           + ...
#
#   - okOK function:
#       + structure
#       + condition checking:
#           - for objects/datasets
#           - for variables in a dataset
#           - for files and folders
#
#
#


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' @rdname Menu-window-functions
#' @export
#' @keywords internal
window_xxx <- function() {
  # Functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # ...

  # Function onOK ----------------------------------------------------------
  onOK <- function() {
    # Cursor ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    cursor_set_busy(top)
    on.exit(cursor_set_idle(top))

    # Get values ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    new_name       <- tclvalue_chr(name_variable)
    which_position <- tclvalue_chr(positionVariable)

    # Reset widget properties before checking ~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    # tkconfigure(name_entry, foreground = "black")

    # Check values ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    if (is_empty_name(new_name, parent = top)) {
      return()
    }

    if (is_empty_name(file_name, which_name = "file name", parent = top)) {
      return()
    }

    if (is_not_valid_name(new_name, parent = top)) {
      return()
    }

    if (variable_is_not_selected(new_name, "variable", parent = top)) {
      return()
    }

    if (variable_is_not_selected(new_name, "group variable", parent = top)) {
      return()
    }


    if (forbid_to_replace_file(file_name, parent = top)) {
      return()
    }

    if (forbid_to_replace_object(new_name, parent = top)) {
      return()
    }

    if (forbid_to_replace_variables(new_name, parent = top)) {
      return()
    }



    # if (is_empty_name(new_name, parent = top))              {return()}
    # if (is_not_valid_name(new_name, parent = top))          {return()}
    # if (forbid_to_replace_variable(new_name, parent = top)) {return()}

    # if (object_is_not_selected(new_name, parent = top))     {return()}
    # if (forbid_to_replace_object(new_name, parent = top))   {return()}

    # if (??? == "") {
    # show_error_messages(
    #     "No ???  was selected.\nPlease select a ???.",
    #     title = "",
    #     parent = top)
    # return()
    # }

    #
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    # Save default values ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    putDialog("window_xxx", list(
      initial_position = which_position
    ))

    # Construct commands ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    y_var  <- safe_names(y_var)
    gr_var <- safe_names(gr_var)

    cmd_position <-
      switch(which_position,
        "first" = str_glue(
          "%>% \n dplyr::select({new_name}, everything())"),
        "last" = "")

    ds <- get(.ds, envir = globalenv())
    cmd_ungroup <- if (is_grouped_df(ds)) "ungroup() %>% \n" else ""

    command <- str_glue(
      '## Add column with row numbers \n',
      "{.ds} <- {.ds} %>% \n",
      "{cmd_ungroup}",
      "dplyr::mutate({new_name} = 1:n())",
      "{cmd_position}")

    # Apply commands ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Library("tidyverse")

    # doItAndPrint(command)
    result <- justDoIt(command)

    # result <- try_command(command)

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    if (class(result)[1] != "try-error") {
      logger(style_cmd(command))
      # doItAndPrint(style_cmd(command))

      active_dataset(ds, flushModel = FALSE, flushDialogMemory = FALSE)

      # Close dialog ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      closeDialog()


    } else {
      logger_error(command, error_msg = result)
      show_code_evaluation_error_message(parent = top)
      return()
    }

    # Close dialog ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # closeDialog()

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    command_dataset_refresh()
    tkfocus(CommanderWindow())
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Announce about the success to run the function `onOk()`
    TRUE
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  }

  # Initial values ---------------------------------------------------------

  # Set initial values ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  .ds    <- active_dataset() # active_dataset_0()
  # fg_col <- Rcmdr::getRcmdr("title.color")

  # Initialize dialog window and title ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  dialogue_title <- gettext_bs("xxx_title")
  initializeDialog(title = dialogue_title)
  tk_title(top, dialogue_title)

  # Get default values ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  defaults <- list(
    position = "first"
  )
  initial <- getDialog("window_xxx", defaults)


  # ... Widgets ============================================================
  # Widgets ----------------------------------------------------------------

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  upper_frame <- tkframe(top)

  # Text entry box
  name_entry <- bs_entry(
    parent = upper_frame,
    width = 28,
    value = unique_colnames("row_number"),
    label = "Column name:"
  )


  f1_buttons <- bs_radiobuttons(
    parent         = upper_frame,
    buttons = c(
      last_gg    = "Last ggplot2 plot",
      obj_gg     = "'ggplot2' object",
      code_gg    = "R Code of ggplot2 plot",
      code_base  = "R Code of R base plot",
      code_print = "R Code of plot (print)",
      code_plot  = "R Code of plot (plot)"
    ),
    value           = buttons[1],
    title           = NULL,
    variable        = NULL,
    labels          = NULL,
    commands        = list(),       # named list of functions
    default_command = do_nothing,
    tips            = list(),       # named list of strings
    default_tip     = "",
    border          = FALSE,
    layout          = c("vertical", "horizontal"),
    sticky_buttons  = "w",
    sticky_title    = "w"
  )
  tkgrid(f1_buttons$frame)

  # Radiobuttons horizontal

  # rb_frame <- tkframe(upper_frame)
  # radioButtons_horizontal(
  #     rb_frame,
  #     title = "Column position: ",
  #     title.color = fg_col,
  #
  #     # right.buttons = FALSE,
  #     name = "position",
  #     sticky_buttons = "w",
  #     buttons = c("first",  "last"),
  #     values =  c("first",  "last"),
  #     labels =  c("First  ","Last  "),
  #     initialValue = initial$position
  # )

  # Layout
  tkgrid(upper_frame, pady = c(0, 5))
  # tkgrid(name_frame, rb_frame, sticky = "w")
  tkgrid(name_entry$frame, rb_frame, sticky = "w")

  # tkgrid(
  #     tk_label(
  #         name_frame,
  #         text = gettext_bs("Column name:"),
  #         foreground = getRcmdr("title.color")),
  #     sticky = "w"
  # )
  # tkgrid(name_entry, sticky = "w")
  tkgrid(positionFrame, padx = c(15, 0))



  # TODO: [???] change this widget into bs_checkboxes()
  # Check box
  # bs_check_boxes(
  #     upper_frame,
  #     frame         = "check_locale_frame",
  #     boxes         = c("check_locale_", "hide_output_"),
  #     # commands      = list("check_locale_" = cmd_checkbox),
  #     initialValues = c("1", "0"),
  #     labels        = gettext_bs(c(
  #         "Check if the locale can be used on this computer",
  #         "Hide output"))
  # )

  #     bs_checkboxes(
  #         parent = upper_frame,
  #         boxes = c("check_locale_", "hide_output_"),
  # )


  # Radiobuttons vertical
  into_outter_frame <- tkframe(upper_frame)


  # TODO: [???] change this widget into bs_radiobuttons()
  Rcmdr::radioButtons(
    window  = into_outter_frame,
    name    = "into_",
    title   = gettext_bs("Convert into"),
    buttons = c("character", "nominal", "ordinal", "integer", "numeric", "logical"),
    values  = c("character", "nominal", "ordinal", "integer", "numeric", "logical"),
    # initialValue = initial$into,
    labels  = gettext_bs(
      c("Text (character)",
        "Nominal factors",
        "Ordinal factors",
        "Integers",
        "Real numbers",
        "Logical"
      )),
    command = function(){}
  )
  # Layout
  # tkgrid(upper_frame)
  # tkgrid(getFrame(var_y_box), into_outter_Frame, sticky = "nw")
  tkgrid(into_outter_frame, sticky = "nw")
  tkgrid(into_Frame, padx = c(15, 5))


  # * Y and Groups box =====================================================

  defaults <- list(
    var_y      = NULL,
    var_gr     = NULL,
    use_groups = "0"
  )

  widget_y_gr <- bs_listbox_y_gr(
    parent         = top,
    y_title        = title_var_1,
    y_var_type     = "num",
    y_initial      = initial$var_y,
    y_select_mode  = "single",

    gr_title       = title_gr_0_n,
    gr_var_type    = "fct_like",
    gr_initial     = initial$var_gr,
    gr_select_mode = "multiple",

    ch_initial     = initial$use_groups
  )

  use_groups <- tclvalue_lgl(widget_y_gr$checkbox)
  var_y      <- get_selection(widget_y_gr$y)
  var_gr     <- get_selection(widget_y_gr$gr)


  # Help menus -------------------------------------------------------------
  help_menu <- function() {

    menu_main <- tk2menu(tk2menu(top), tearoff = FALSE)

    menu_qq   <- tk2menu(menu_main, tearoff = FALSE)
    menu_test <- tk2menu(menu_main, tearoff = FALSE)

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    tkadd(menu_main, "cascade",
      label    = "Normality tests",
      menu     = menu_test)

    tkadd(menu_test, "command",
      label    = "xxx",
      command  = open_help("xxx", package = "xxx"))

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    tkadd(menu_main, "cascade",
      label    = "xxx-B",
      menu     = menu_qq)

    tkadd(menu_qq, "command",
      label    = "xxx",
      command  = open_help("xxx", package = "xxx"))

    tkadd(menu_qq, "separator")

    tkadd(menu_qq, "command",
      label    = "Package 'xxx'",
      command  = open_online_fun("https://   xxx"))


    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    tkpopup(menu_main,
      tkwinfo("pointerx", top),
      tkwinfo("pointery", top))
  }
  # Finalize ---------------------------------------------------------------

  # Buttons ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ok_cancel_help(
  #   close_on_ok = TRUE,
  #   on_help = help_menu,
  #   reset_location = TRUE,
  #   reset = "window_test_normality",
  #   apply = "window_test_normality"
  # )


  # Help topic
  # OKCancelHelp(helpSubject = "mutate", helpPackage = "dplyr")

  ok_cancel_help(
    # helpSubject = "xxx",
    # helpPackage = "xxx",
    close_on_ok = TRUE,
    on_help = help_menu,
    reset_location = TRUE,
    reset = "window_xxx()",
    apply = "window_xxx()"
  )

  tkgrid(buttonsFrame, sticky = "ew")
  dialogSuffix()
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Apply initial configuration functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  # Interactive bindings ---------------------------------------------------

  # Add interactivity for `fname_frame` and `fname_label`
  # tkbind(file_label,     "<ButtonPress-1>", on_click)
  # tkbind(fname_frame,    "<ButtonPress-1>", on_click)
  # tkbind(fname_label,    "<ButtonPress-1>", on_click)
  #
  # tkbind(fname_frame, "<Enter>",
  #        function() tkconfigure(fname_label, foreground = "blue"))
  # tkbind(fname_frame, "<Leave>",
  #        function() tkconfigure(fname_label, foreground = "black"))
  # # tkconfigure(file_label,     cursor = "hand2")
  # tkconfigure(fname_frame,    cursor = "hand2")
  # tkconfigure(button_ch_file, cursor = "hand2")
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


}
