# Kim Martin
# 15/07/2021
# R version 4.0.3 (2020-10-10)

# Aim: create combinations of key parameter values and test r3PG predictions against actual data for each parameter set

# This script to combine component code in pipeline



## DEFINE OUTPUTS TO EXTRACT

oput <- c('basal_area', 'dbh', 'height', 'volume')  # outputs must match names of r3PG outputs



## TIMESTAMP FOR OUTPUTS

tstamp <- format(Sys.time(), '%y%m%d%H%M')



## LIBRARIES AND FUNCTIONS

source('0 - libraries and functions.R')



## CHECK INPUT FILES

source('1 - check input files.R')



## ASSEMBLE R3PG PARAMETER COMBINATIONS

source('2 - r3PG parameter combinations.R')



## ASSEMBLE R3PG INPUTS AND RUN MODEL

source('3 - r3PG parameter testing.R')

