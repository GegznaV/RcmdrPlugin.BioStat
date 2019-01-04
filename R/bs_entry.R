#' @rdname Helper-functions
#' @export
#' @keywords internal
bs_entry <- function(

    parent = top,
    width = "28",
    value = "",
    label = "",
    label_position = c("left", "above", "right", "none"),
    label_color = getRcmdr("title.color"),
    padx = 0,
    pady = 0,     # pady = 5,
    sticky = "w",
    sticky_label = sticky,
    sticky_text  = sticky,
    main_frame  = tk2frame(parent),
    text_frame  = tk2frame(main_frame),
    label_frame = tk2frame(main_frame),
    tip       = "",
    label_tip = "",
    on_click           = function() {},
    on_double_click    = function() {},
    on_triple_click    = function() {},
    on_release         = function() {},
    on_click_3         = function() {},
    on_double_click_3  = function() {},
    on_triple_click_3  = function() {},
    on_release_3       = function() {},
    on_key_release     = function() {},
    ...

) {
    label_position <- match.arg(label_position)

    var_text <- tclVar(value)

    obj_text <- tk2entry(
        parent       = text_frame,
        tip          = tip,
        width        = width,
        textvariable = var_text,
        ...
    )

    obj_label <- tk2label(
        parent     = label_frame,
        text       = gettext_bs(label),
        foreground = label_color,
        tip        = label_tip
    )

    if (nchar(label) > 0) {

        switch(label_position,
               "above" = {
                   if (length(pady) == 1) {
                       pady <- c(pady, pady)
                   }
                   tkgrid(label_frame, sticky = sticky, padx = padx, pady = c(pady[1], 0))
                   tkgrid(text_frame,  sticky = sticky, padx = padx, pady = c(0, pady[2]))
                   tkgrid(obj_text,    sticky = sticky_text)
               },

               "left" = {
                   tkgrid(label_frame, text_frame, sticky = sticky,
                          padx = padx, pady = pady)
                   tkgrid(obj_text, sticky = sticky_text, padx = c(5, 0))
               },

               "right" = {
                   tkgrid(text_frame, label_frame, sticky = sticky,
                          padx = padx, pady = pady)
                   tkgrid(obj_text, sticky = sticky_text, padx = c(0, 5))
               }
        )
        tkgrid(obj_label, sticky = sticky_label)

    } else {
        tkgrid(text_frame, sticky = sticky, padx = padx, pady = pady)
        tkgrid(obj_text,  sticky = sticky_text)
    }

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    bind_mouse_keys(obj_text)
    tkbind(obj_text, "<KeyRelease>", on_key_release)
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    structure(list(
        frame       = main_frame,
        frame_text  = text_frame,
        frame_label = label_frame,

        var_text  = var_text,
        obj_text  = obj_text,
        obj_label = obj_label
    ),
    class = c("bs_entry", "bs_tk_widget", "list"))
}


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#' @rdname Helper-functions
#' @export
#' @keywords internal
set_values.bs_entry <- function(obj, values, ...) {
    if (is.null(values)) {
        values <- ""
    }
    tclvalue(obj$var_text) <- values
}

#' @rdname Helper-functions
#' @export
#' @keywords internal
`values<-.bs_entry` <- function(x, value) {
    set_values(x, value)
}

#' @rdname Helper-functions
#' @export
#' @keywords internal
`tclvalue<-.bs_entry` <- function(x, value) {
    set_values(x, value)
}

#' @rdname Helper-functions
#' @export
#' @keywords internal
get_values.bs_entry <- function(obj, ...) {
    tclvalue_chr(obj$var_text)
}

#' @rdname Helper-functions
#' @export
#' @keywords internal
tk_disable.bs_entry <- function(obj, ..., foreground = "grey") {
    tk_disable(obj$obj_text, ...)
    tk_disable(obj$obj_label, foreground = foreground)
}

#' @rdname Helper-functions
#' @export
#' @keywords internal
tk_normalize.bs_entry <- function(obj, ..., foreground = getRcmdr("title.color")) {
    tk_normalize(obj$obj_text, ...)
    tk_normalize(obj$obj_label, foreground = foreground)
}

#' @rdname Helper-functions
#' @export
#' @keywords internal
tk_activate.bs_entry <- function(obj, ..., foreground = getRcmdr("title.color")) {
    tk_activate(obj$obj_text)
    tk_activate(obj$obj_label, foreground = foreground)
}

#' @rdname Helper-functions
#' @export
#' @keywords internal
tk_get_state.bs_entry <- function(obj, ...) {
    tk_get_state(obj$obj_text, ...)
}