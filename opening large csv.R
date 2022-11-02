# Kim Martin
# 17/02/2021
# R version 4.0.3 (2020-10-10)

# Aim: create combinations of key parameter values and test r3PG predictions against actual data for each parameter set

# This script to break large sim output file into pieces by site




library(tidyverse)

if (!dir.exists('output split sim')) dir.create('output split sim')

act_val <- read.csv('input actual/actual_data.csv')

colnames(act_val) <- tolower(colnames(act_val))

num_values <- 4


sifiles <- list.files('input sites')  # get file names from input folder

num_sites <- length(sifiles)


num_test_par <- 11
num_test_val <- 3

num_par_comb <- num_test_val ** num_test_par # number of different combinations of par values


large_csv <- list.files('output sim')[length(list.files('output sim'))]



ifilename <- paste0('output sim/', large_csv)



oheader <- read_csv(ifilename, col_names = F, n_max = 1)



skipped_rows <- 1

for (s in 1:num_sites) {
  
  
  site_id <- sub('.xlsx$', '', sifiles[s])
  
  
  num_measures <- dim(act_val[act_val[,1] == site_id & act_val$age > 3, ])[1]
  
  num_rows_per_pset <- num_values * num_measures
  
  num_rows <- num_rows_per_pset * num_par_comb
  
  
  ofilename <- paste0('output split sim/', site_id, '_', large_csv)
  
  
  input_sim <- read_csv(ifilename, col_names = F, skip = skipped_rows, n_max = num_rows)
  
  colnames(input_sim) <- oheader
  
  
  skipped_rows <- skipped_rows + num_rows
  
  write.csv(input_sim, file = ofilename, row.names=F)
  
}




