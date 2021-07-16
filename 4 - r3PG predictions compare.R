# Kim Martin
# 15/07/2021
# R version 4.0.3 (2020-10-10)

# Aim: create combinations of key parameter values and test r3PG predictions against actual data for each parameter set

# This script to compare actual values to predictions from r3PG for each parameter set



## IMPORT COMPLETE SET OF PREDICTIONS AND ACTUAL DATA

r3PG_output <- read.csv(ofilename)



## CREATE DATAFRAMES TO HOLD CALCULATED MAE AND RMSE VALUES

MAE_df <- RMSE_df <- data.frame(cbind(paste0('pset', 1:num_par_comb)), 
                                matrix(NA, ncol = length(oput) + 1, nrow = num_par_comb))

colnames(MAE_df) <-  c('parameter set', paste(oput, 'MAE'), 'combined MAE')

colnames(RMSE_df) <-  c('parameter set', paste(oput, 'RMSE'), 'combined RMSE')



# CALCULATE MAE AND RMSE FOR EACH OUTPUT VARIABLE FOR EACH PARAMETER SET

for (pset in 1:num_par_comb) {
  
  
  
  
}


ofilename <- paste0('output compare/', tstamp, '_par_test_r3PG_MAE.csv')
