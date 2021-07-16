# Kim Martin
# 15/07/2021
# R version 4.0.3 (2020-10-10)

# Aim: create combinations of key parameter values and test r3PG predictions against actual data for each parameter set

# This script to compare actual values to predictions from r3PG for each parameter set



## IMPORT COMPLETE SET OF PREDICTIONS AND ACTUAL DATA

r3PG_output <- read.csv(ofilename)



## CREATE DATAFRAMES TO HOLD CALCULATED MAE AND RMSE VALUES

all_psets <- paste0('pset', 1:num_par_comb)

MAE_df <- RMSE_df <- data.frame(cbind(all_psets, 
                                matrix(NA, ncol = length(oput) + 1, nrow = num_par_comb)))

colnames(MAE_df) <-  c('parameter set', paste(oput, 'MAE'), 'combined MAE')

colnames(RMSE_df) <-  c('parameter set', paste(oput, 'RMSE'), 'combined RMSE')



# CALCULATE MAE AND RMSE FOR EACH OUTPUT VARIABLE FOR EACH PARAMETER SET

for (o in oput) {
  
  
  o_MAE <- o_RMSE <- numeric(length = num_par_comb)
  
  
  for (pset in 1:num_par_comb) {
    
    sub_output <- r3PG_output[(r3PG_output[,1] == paste0('pset', pset)), ]
    
    
    actual <- sub_output[(sub_output$variable == o), ]$actual
    
    predicted <- sub_output[(sub_output$variable == o), ]$predicted
    
    
    o_MAE[pset] <- calc_MAE(actual, predicted)
    
    o_RMSE[pset] <- calc_RMSE(actual, predicted)
    
  }
  
  
  MAE_df[, match(paste(o, 'MAE'), colnames(MAE_df))] <- o_MAE
  
  RMSE_df[, match(paste(o, 'RMSE'), colnames(RMSE_df))] <- o_RMSE
  
}



for (pset in 1:num_par_comb) {
  
  sub_output <- r3PG_output[(r3PG_output[,1] == paste0('pset', pset)), ]
  
  
  actual <- sub_output$actual
  
  predicted <- sub_output$predicted
  
  
  o_MAE[pset] <- calc_MAE(actual, predicted)
  
  o_RMSE[pset] <- calc_RMSE(actual, predicted)
  
}

MAE_df[, match('combined MAE', colnames(MAE_df))] <- o_MAE

RMSE_df[, match('combined RMSE', colnames(RMSE_df))] <- o_RMSE




write.csv(MAE_df, file = paste0('output compare/', tstamp, '_par_test_r3PG_MAE.csv'), row.names=F)

write.csv(RMSE_df, file = paste0('output compare/', tstamp, '_par_test_r3PG_RMSE.csv'), row.names=F)
          
          
                    
