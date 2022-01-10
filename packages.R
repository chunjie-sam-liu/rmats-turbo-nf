
pkgs <- c(
  "rtracklayer"
)

install.packages('BiocManager')

pkgs <- unique(pkgs)
ap.db <- available.packages(contrib.url(BiocManager::repositories()))
ap <- rownames(ap.db)
pkgs_to_install <- pkgs[pkgs %in% ap]
BiocManager::install(pkgs_to_install, update=FALSE, ask=FALSE)
suppressWarnings(BiocManager::install(update=TRUE, ask=FALSE))

warnings()

if (!is.null(warnings()))
{
  w <- capture.output(warnings())
  if (length(grep("is not available|had non-zero exit status", w))) quit(save="no", status=0L, runLast = FALSE)
}

unlink(x = '/tmp/*', recursive=T)