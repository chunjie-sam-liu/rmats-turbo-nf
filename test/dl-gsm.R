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

GSE112037 %>%
  purrr::map(.f = function(.x) {
    .x %>%
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
      tidyr::unnest()
  }) %>%
  dplyr::bind_rows() ->
  GSE112037_meta


GSE112037_meta %>%
  readr::write_tsv(file = "test/GSE112037_metadata.tsv")

# Aspera ------------------------------------------------------------------


GSE112037_meta %>%
  dplyr::select(srr) %>%
  dplyr::mutate(dir = stringr::str_sub(srr, start = 1, end = 6)) %>%
  dplyr::mutate(path = glue::glue("/sra/sra-instant/reads/ByRun/sra/SRR/{dir}/{srr}")) %>%
  dplyr::mutate(last = stringr::str_sub(srr, start = -1, end = -1)) %>%
  dplyr::mutate(ebi = glue::glue("/vol1/fastq/{dir}/00{last}/{srr}")) ->
  GSE112037_meta_sra_path

GSE112037_meta_sra_path %>%
  dplyr::select(path) %>%
  readr::write_tsv(file = "~/scratch/aspera/GSE112037_sra_aspera.txt", col_names = FALSE)

# ascp -v -QT -l 400m -m 300m -P33001 -k1 -i ${HOME}/.aspera/connect/etc/asperaweb_id_dsa.openssh --mode recv --host fasp.sra.ebi.ac.uk --user era-fasp --file-list GSE112037_sra_aspera.txt ./

GSE112037_meta_sra_path %>%
  dplyr::select(ebi) %>%
  readr::write_tsv(file = "~/scratch/aspera/GSE112037_sra_ebi_aspera.txt", col_names = FALSE)

#ascp -v -QT -l 2g -m 500m -P33001 -k1 -i ${HOME}/.aspera/connect/etc/asperaweb_id_dsa.openssh --mode recv --host fasp.sra.ebi.ac.uk --user era-fasp --file-list GSE112037_sra_ebi_aspera.txt ./ebi

# No longer use aspera to donwload data from sra, use prefetch.
# prefetch sra in parallel

GSE112037_meta_sra_path %>%
  dplyr::select(srr) %>%
  readr::write_tsv(file = "~/scratch/aspera/GSE112037_sra.txt",col_names = FALSE)
# prefetch --option-file GSE112037_sra.txt --output-directory ./

GSE112037_meta_sra_path %>%
  dplyr::select(srr) %>%
  dplyr::mutate(pf = "prefetch {srr} --output-directory /home/liuc9//home/liuc9/aspera/test" %>% glue::glue()) %>%
  dplyr::select(pf) %>%
  readr::write_tsv(file = "~/scratch/aspera/GSE112037_sra_parallel.sh", col_names = FALSE)
# generalParallelSlurm GSE112037_sra_parallel.sh

# Save image --------------------------------------------------------------


