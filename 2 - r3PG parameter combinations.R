# Kim Martin
# 17/02/2021
# R version 4.0.3 (2020-10-10)

# Aim: create combinations of key parameter values and test r3PG predictions against actual data for each parameter set

# This script to generate different combinations of key r3PG parameters, given a csv of alternative values




## GET BASE AND TESTING PARAMETERS

base_par <- read.csv('Input parameters/base_parameter_values.csv')

test_par <- read.csv('Input parameters/test_parameter_values.csv')



## CREATE A LONG DATAFRAME FOR THE COMBINATION OF TEST PARAMETERS

num_test_par <- dim(test_par)[1]  # number of rows = number of parameters being varied
num_test_val <- (dim(test_par)[2]-1)  # number of cols = number of values for each test parameter

num_par_comb <- num_test_val ** num_test_par # number of different combinations of par values

test_par_comb <- data.frame(matrix(NA, ncol=(num_test_par+1), nrow=num_par_comb))

colnames(test_par_comb) <- c('Parameter_set', test_par$parameter)

test_par_comb$Parameter_set <- paste0('pset', 1:num_par_comb)



## CREATE SETS OF PARAMETER COMBINATIONS


# calculate number of consecutive duplicate values in each 'block' for the first parameter

block_size <- num_par_comb / num_test_val  


for (par in 1:num_test_par) {  # set up combinations by column (one parameter per column)

  
  # calculate number of repeated sets of 'blocks' in column (each set includes a block for each test value)
  
  block_rep <- num_par_comb / (block_size * num_test_val)

  
  # generate blocks of low, medium, and high values for parameter in column
  
  Low <- test_par[par, 2]
  Med <- test_par[par, 3]
  High <- test_par[par, 4]
  
  test_par_comb[,par+1] <- rep(c(rep(Low, block_size),
                                 rep(Med, block_size),
                                 rep(High, block_size)), block_rep)
  
  
  # calculate size of blocks in next column
  
  block_size <- block_size / num_test_val
  
}



## COMBINE COMBINATIONS OF TEST PARAMETERS AND BASE PARAMETERS

# duplicate base parameter values for each parameter set

par_combination <- data.frame(matrix(data = base_par[,2], ncol=dim(base_par)[1], nrow=num_par_comb, 
                                     byrow=T))

par_combination <- cbind(test_par_comb[,1], par_combination)

colnames(par_combination) <- c('Parameter_set', base_par[,1])


# identify parameters with varied test values, and over-write base values with appropriate test values

match_pars <- match(test_par[,1], base_par[,1])

par_combination[match_pars+1] <- test_par_comb[,-1]




## OUTPUT TIMESTAMPED CSV RESULTS

ofilename <- paste0('Input parameters/', tstamp, '_par_combination.csv')


write.csv(par_combination, file = ofilename, row.names=F)


