# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Rcmdr window for z transformation
#'
#' @export
#' @keywords internal
#' @family transformations
#'
window_num_transform_z <- function() {
    initializeDialog(title = gettext_bs("Z transformation (standardization)"))
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Title ------------------------------------------------------------------
    fg_col <- Rcmdr::getRcmdr("title.color")
    tkgrid(label_rcmdr(
        top,
        text = gettext_bs("Standardize variables"),
        font = tkfont.create(weight = "bold", size = 9),
        fg = fg_col),
        pady = c(5, 9), columnspan = 2)
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    variableBox <-
        variableListBox2(top,
                        Numeric(),
                        selectmode = "multiple",
                        title = gettext_bs("Variables (pick one or more)"),
                        listHeight = 6
        )
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    prefix_var  <- tclVar("z_")
    prefixField <- ttkentry(top,
                            width = "25",
                            textvariable = prefix_var)
    suffix_var  <- tclVar("")
    suffixField <- ttkentry(top,
                            width = "25",
                            textvariable = suffix_var)
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    onOK <- function() {
        variables <- getSelection(variableBox)
        prefix    <- trim.blanks(tclvalue(prefix_var))
        suffix    <- trim.blanks(tclvalue(suffix_var))
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        closeDialog()
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        # Check conditions
        if (length(variables) == 0) {
            errorCondition(recall = window_num_transform_z,
                           message = gettext_bs("You must select a variable."))
            return()
        }

       # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        new_names <- paste0(prefix, variables, suffix) %>% make.names()

        # Chech for errors ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        for (i in seq_along(variables)) {

            if (!is.valid.name(new_names[i])) {
                errorCondition(
                    recall = window_num_transform_z,
                    message = paste(new_names[i], gettext_bs("is not a valid name."))
                )
                return()
            }
            if (is.element(new_names[i], Variables())) {
                if ("no" == tclvalue(checkReplace(new_names[i]))) {
                    window_num_transform_z()
                    return()
                }
            }
        }
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        .activeDataSet <- ActiveDataSet()

        # # Base way
        # command <- paste0(c("\n",
        #                     glue("{.activeDataSet} <- within({.activeDataSet}, {{ "),
        #                     glue("   {new_names} <- biostat::scale_vector({variables}) "),
        #                     "})\n"
        # ),
        # collapse = "\n")

        # Tidyverse way
        Library("tidyverse")
        Library("biostat")
        command <- paste0(
            c("\n",
              glue("{.activeDataSet} <- {.activeDataSet} %>% \n",
                   "dplyr::mutate(\n"),
              paste(
                  glue("   {new_names} = biostat::scale_vector({variables}) "),
                  collapse = ",\n"),
              ")\n"
            ),
            collapse = "\n") %>%
            style_cmd()

        result <- justDoIt(command)

        if (class(result)[1] !=  "try-error")
            activeDataSet(.activeDataSet, flushModel = FALSE)

        # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        msg <- glue("#---  ", gettext_bs("Z transformation"), "  ---#\n\n",
                    "# ", gettext_bs("New variable(s):"), " \n",
                    paste("#   ", new_names, collapse = "\n"))

        logger(paste0(msg, command, collapse = "\n"))
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        tkfocus(CommanderWindow())
    } # [end: onOK]
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    OKCancelHelp(helpSubject = "scale_vector", helpPackage = "biostat")
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    tkgrid(getFrame(variableBox), sticky = "n", columnspan = 2)
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    tkgrid(labelRcmdr(top,
                      text = gettext_bs("Prefix for variable names (optional):"),
                      fg = getRcmdr("title.color")),
           sticky = "w",
           pady = c(10, 0), columnspan = 2)

    tkgrid(prefixField, sticky = "ew", columnspan = 2)
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    tkgrid(labelRcmdr(top,
                      text = gettext_bs("Suffix for variable names (optional):"),
                      fg = getRcmdr("title.color")),
           sticky = "w",
           pady = c(10, 0), columnspan = 2)

    tkgrid(suffixField, sticky = "ew", columnspan = 2)
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    tkgrid(buttonsFrame, sticky = "w", columnspan = 2)

    dialogSuffix(rows = 4,
                 columns = 2,
                 preventGrabFocus = TRUE)
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~