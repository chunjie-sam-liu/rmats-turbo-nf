# Metainfo ----------------------------------------------------------------

# @AUTHOR: Chun-Jie Liu
# @CONTACT: chunjie.sam.liu.at.gmail.com
# @DATE: Tue Dec 28 21:28:40 2021
# @DESCRIPTION: dl-gsm.R

# Library -----------------------------------------------------------------

library(magrittr)
library(ggplot2)
library(GEOquery)

# GEO ---------------------------------------------------------------------

GSE112037 <- GEOquery::getGEO(GEO = "GSE112037", destdir = "test/data", GSEMatrix = TRUE)

GSE112037[[1]] %>%
  phenoData() %>%
  pData() %>%
  tibble::as_tibble() %>%
  dplyr::mutate(
    srr = purrr::map(
      .x = relation.1,
      .f = function(.x) {
        .srx <- gsub(pattern = "SRA: ", replacement = "", x = .x)
        .srx_html <- xml2::read_html(x = .srx)
        .srx_html %>%
          rvest::html_nodes('td a') %>%
          rvest::html_text()
      }
    )
  ) %>%
  tidyr::unnest() ->
  GSE112037_1_data

GSE112037[[2]] %>%
  phenoData() %>%
  pData() %>%
  tibble::as_tibble() %>%
  dplyr::mutate(
    srr = purrr::map(
      .x = relation.1,
      .f = function(.x) {
        .srx <- gsub(pattern = "SRA: ", replacement = "", x = .x)
        .srx_html <- xml2::read_html(x = .srx)
        .srx_html %>%
          rvest::html_nodes('td a') %>%
          rvest::html_text()
      }
    )
  ) %>%
  tidyr::unnest() ->
  GSE112037_2_data

dplyr::bind_rows(GSE112037_1_data, GSE112037_2_data) %>%
  readr::write_tsv(file = "test/GSE112037_metadata.tsv")


# Save image --------------------------------------------------------------

library(SRAdb)
sra_dbname <- file.path(system.file('extdata', package = "SRAdb"), 'SRAmetadb_demo.sqlite')
sra_con <- dbConnect(dbDriver("SQLite"), sra_dbname)
in_acc <- GSE112037_2_data$srr[[1]]
sraFiles <- ascpSRA( in_acc, sra_con, "ascp -QT -l 300m", fileType = 'sra', destDir=getwd() )
