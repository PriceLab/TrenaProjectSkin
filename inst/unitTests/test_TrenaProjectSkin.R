library(TrenaProjectSkin)
library(RUnit)
#------------------------------------------------------------------------------------------------------------------------
if(!exists("skin.project")) {
   message(sprintf("--- createing instance of TrenaProjectSkin"))
   skin.project <- TrenaProjectSkin();
   }
#------------------------------------------------------------------------------------------------------------------------
runTests <- function()
{
   test_constructor()
   test_supportedGenes()
   test_footprintDatabases()
   test_expressionMatrices()
   test_setTargetGene()

} # runTests
#------------------------------------------------------------------------------------------------------------------------
test_constructor <- function()
{
   message(sprintf("--- test_constructor"))

   checkTrue(all(c("TrenaProjectSkin", "TrenaProject") %in% is(skin.project)))

} # test_constructor
#------------------------------------------------------------------------------------------------------------------------
test_supportedGenes <- function()
{
   message(sprintf("--- test_supportedGenes"))

   expected <-  c("COL1A1", "COL3A1", "COL4A1", "COL4A2", "COL5A1", "COL5A2", "COL6A1",
                  "COL6A2", "COL6A3", "COL7A1", "COL8A1", "COL9A1", "CREB3L1", "GLI2")

   checkTrue(all(expected %in% getSupportedGenes(skin.project)))

} # test_supportedGenes
#------------------------------------------------------------------------------------------------------------------------
test_footprintDatabases <- function()
{
   message(sprintf("--- test_footprintDatabases"))

   expected <- c("skin_wellington_16", "skin_wellington_20",
                 "skin_hint_16", "skin_hint_20")
   checkTrue(all(expected %in% getFootprintDatabaseNames(skin.project)))

   checkEquals(getFootprintDatabaseHost(skin.project), "khaleesi.systemsbiology.net")

} # test_footprintDatabases
#------------------------------------------------------------------------------------------------------------------------
test_expressionMatrices <- function()
{
   expected <- c("gtex.fibroblast", "gtex.primary", "mtx.protectedAndExposed",
                 "mtx.protectedAndExposedLowVarianceGenesEliminated")

   checkTrue(all(expected %in% getExpressionMatrixNames(skin.project)))

   mtx <- getExpressionMatrix(skin.project, expected[1])
   checkEquals(dim(mtx), c(18067, 284))
      # make sure geneSymbols are used in the rownames
   checkTrue(length(grep("COL1", rownames(mtx))) > 5)
   checkTrue("GTEX.111VG.0008.SM.5Q5BG" %in% colnames(mtx))
   checkTrue(min(mtx) == 0)
   checkTrue(max(mtx) < 11)

} # test_expressionMatrices
#------------------------------------------------------------------------------------------------------------------------
test_setTargetGene <- function()
{
   message(sprintf("--- test_setTargetGene"))

   setTargetGene(skin.project, "COL1A1")
   checkEquals(getTargetGene(skin.project), "COL1A1")

   message(sprintf("    transcripts"))
   tbl.transcripts <- getTranscriptsTable(skin.project)
   checkTrue(nrow(tbl.transcripts) >= 9)

   message(sprintf("    enhancers"))
   tbl.enhancers <- getEnhancers(skin.project)
   checkEquals(colnames(tbl.enhancers), c("chrom", "start", "end", "type", "combinedScore", "geneSymbol"))
   checkTrue(nrow(tbl.enhancers) >= 28)

   message(sprintf("    encode DHS"))
   tbl.dhs <- getEncodeDHS(skin.project)
   checkTrue(nrow(tbl.dhs) > 1000)
   checkEquals(colnames(tbl.dhs), c("chrom", "chromStart", "chromEnd", "count", "score"))

   chromosome <- unique(c(tbl.dhs$chrom, tbl.enhancers$chrom))
   checkEquals(length(chromosome), 1)
   start <- min(tbl.dhs$chromStart)
   end   <- max(tbl.dhs$chromEnd)

   message(sprintf("    ChIP-seq"))
   tbl.chipSeq <- getChipSeq(skin.project, chrom=chromosome, start=start, end=end, tfs=NA)
   checkTrue(nrow(tbl.chipSeq) > 20000)
   checkEquals(colnames(tbl.chipSeq), c("chrom", "start", "endpos", "tf", "name", "strand", "peakStart", "peakEnd"))

   tbl.chipSeq.tf <- getChipSeq(skin.project, chrom=chromosome, start=start, end=end, tfs="CREB3L1")
   checkTrue(nrow(tbl.chipSeq.tf) > 30)
   checkTrue(nrow(tbl.chipSeq.tf) < 50)

} # test_setTargetGene
#------------------------------------------------------------------------------------------------------------------------


