
# install.packages("RcmdrPlugin.KMggplot2")
#
# if (!"devtools" %in% installed.packages())  install.packages("devtools")
#
# devtools::install_github("GegznaV/RcmdrPlugin.EZR@unmodified_Rcmdr_menu")
# devtools::install_github("GegznaV/biostat")
# devtools::install_github("GegznaV/RcmdrPlugin.biostat")

# packages <- c("devtools",
#               "rlang",
#               "tidyverse",
#               "tidyselect",
#               "checkmate",
#               "RcmdrPlugin.KMggplot2",
#               "RcmdrPlugin.EZR",
#               "biostat",
#               "RcmdrPlugin.biostat"
#               )
#
# missing_packages <- packages[!packages %in% utils::installed.packages()]
#
# # Jei bent vieno paketo nėra, tada įdiegiam, ko trūksta
# if (length(missing_packages) > 0) {
#     utils::install.packages(missing_packages,
#                             dependencies = c("Depends", "Imports", "Suggests"))
# }




    # devtools::install_github("GegznaV/RcmdrPlugin.EZR@unmodified_Rcmdr_menu",
    #                          dependencies = c("Depends", "Imports", "Suggests"))
    #
    # devtools::install_github("GegznaV/biostat",
    #                          dependencies = c("Depends", "Imports", "Suggests"))
    #
    # devtools::install_github("GegznaV/RcmdrPlugin.biostat",
    #                          dependencies = c("Depends", "Imports", "Suggests"))



# if (!"RcmdrPlugin.biostat" %in% utils::installed.packages()) {
#     utils::install.packages("biostat")
#     utils::install.packages("RcmdrPlugin.biostat")
# }


rmd_template_filenamename <- paste0(
    dir(.libPaths(), pattern = "RcmdrPlugin.biostat", full.names = TRUE),
    "/etc/biostat-RMarkdown-Template.Rmd"
)

###! Rcmdr Options Begin !###
options(Rcmdr = list(plugins = c("RcmdrPlugin.KMggplot2",
                                 "RcmdrPlugin.EZR.2",
                                 "RcmdrPlugin.biostat",
                                 NULL),
                     console.output = FALSE,
                     use.rgl = FALSE,
                     rmd.template = rmd_template_filenamename)
        )

if (.Platform$OS.type == "windows") {
    Sys.setlocale(locale = "Lithuanian")
} else {
    # Turėtumėte patikslinti pagal operacinę sistemą
    # Sys.setlocale(locale = "lt_LT")
}


# library(biostat)

# library(magrittr)
# library(pander)
# library(ggplot2)
# library(spMisc)



# Uncomment the following 4 lines (remove the #s)
#  to start the R Commander automatically when R starts:

# local({
#    old <- getOption('defaultPackages')
#    options(defaultPackages = c(old, 'Rcmdr'))
# })

###! Rcmdr Options End !###


message("--- Papildinys uzkrautas: RcmdrPlugin.biostat ---")
