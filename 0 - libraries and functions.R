# Kim Martin
# 15/07/2021
# R version 4.0.3 (2020-10-10)

# Aim: create combinations of key parameter values and test r3PG predictions against actual data for each parameter set

# This script to install necessary libraries and contain function definitions



## LIBRARIES

# install if not already installed

if (!require('r3PG')) install.packages('r3PG', dependencies = TRUE)  
library(r3PG)

if (!require('tidyverse')) install.packages('tidyverse', dependencies = TRUE)  
library(tidyverse)

if (!require('readxl')) install.packages('readxl', dependencies = TRUE)  
library(readxl)




## FUNCTIONS


# check r3PG inputs and run model

check_and_run_r3PG_inputs <- function(isite, ispecies, iclimate, iparameters) {
  
  ## GET SPECIES AND TIME RANGE INFORMATION FROM DATA
  
  ispeciesname <- ispecies$species[1]  # NB: this assumes one species per input dataset!
  
  iclimatestart <- isite$from[1]
  
  iclimateend <- isite$to[1]
  
  
  ## PREPARE INPUT DATA
  
  # NNB: must assign results of 'prepare...' function(s) to use prepared input in model!?
  
  
  # is 'prepare_climate' redundant ('prepare_input' does the same job?)?
  iclimate <- prepare_climate( climate = iclimate, from = iclimatestart, to = iclimateend)
  
  # is 'prepare_parameters' redundant ('prepare_input' does the same job?)?
  iparameters <- prepare_parameters( parameters = iparameters, sp_names = ispeciesname)
  
  inputlist <- prepare_input(site = isite,
                             species = ispecies,
                             climate = iclimate,
                             parameters = iparameters,
                             thinning = NULL,
                             size_dist = NULL)
  
  
  ## RUN MODEL
  
  r3PG_output <- run_3PG(
    site        = inputlist$site,
    species     = inputlist$species,
    climate     = inputlist$climate,
    thinning    = NULL,
    parameters  = inputlist$parameters,
    size_dist   = NULL,
    settings    = list(light_model = 1, transp_model = 1, phys_model = 1,
                       height_model = 1, correct_bias = 0, calculate_d13c = 0),
    check_input = TRUE, df_out = TRUE)
  
  
  return(r3PG_output)
  
}











