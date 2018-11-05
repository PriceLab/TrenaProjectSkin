#----------------------------------------------------------------------------------------------------
#' @import methods
#' @import TrenaProject
#' @importFrom AnnotationDbi select
#' @import org.Hs.eg.db
#'
#' @title TrenaProjectSkin-class
#'
#' @name TrenaProjectSkin-class
#' @rdname TrenaProjectSkin-class
#' @aliases TrenaProjectSkin
#' @exportClass TrenaProjectSkin
#'

.TrenaProjectSkin <- setClass("TrenaProjectSkin",
                              contains="TrenaProject")

#----------------------------------------------------------------------------------------------------
#' Define an object of class TrenaProjectSkin
#'
#' @description
#' Expression, variant and covariate data for the genes of interest (perhaps unbounded) for pre-term birth studies
#'
#' @rdname TrenaProjectSkin-class
#'
#' @export
#'
#' @return An object of the TrenaProjectSkin class
#'

TrenaProjectSkin <- function(quiet=TRUE)

{
   genomeName <- "hg38"

   nominated.genes <- c("COL1A1", "COL3A1", "COL4A1", "COL4A2", "COL5A1", "COL5A2", "COL6A1",
                        "COL6A2", "COL6A3", "COL7A1", "COL8A1", "COL9A1", "CREB3L1", "GLI2")

   footprintDatabaseHost <- "khaleesi.systemsbiology.net"
   footprintDatabaseNames <- c("skin_hint_20",
                               "skin_wellington_20",
                               "skin_hint_16",
                               "skin_wellington_16")

   expressionDirectory <- system.file(package="TrenaProjectSkin", "extdata", "expression")
   variantsDirectory <- "/dev/null"

   covariatesFile <- system.file(package="TrenaProjectSkin", "extdata", "covariates", "covariates.RData")

   stopifnot(file.exists(expressionDirectory))
   stopifnot(file.exists(covariatesFile))

   .TrenaProjectSkin(TrenaProject(supportedGenes=nominated.genes,
                                  genomeName=genomeName,
                                  footprintDatabaseHost=footprintDatabaseHost,
                                  footprintDatabaseNames=footprintDatabaseNames,
                                  expressionDirectory=expressionDirectory,
                                  variantsDirectory=variantsDirectory,
                                  covariatesFile=covariatesFile,
                                  quiet=quiet
                                  ))

} # TrenaProjectSkin, the constructor
#----------------------------------------------------------------------------------------------------
