# Kim Martin
# 15/07/2021
# R version 4.0.3 (2020-10-10)

# Aim: create combinations of key parameter values and test r3PG predictions against actual data for each parameter set

# This script to check input files exist and match requirements



## WARNING

warning("All input files must be closed, or this process will fail.")



## GET BASE AND TESTING PARAMETERS

base_par <- read.csv('Input parameters/base_parameter_values.csv')

test_par <- read.csv('Input parameters/test_parameter_values.csv')


# confirm both base_par and test_par have 'parameter' as first column


if (colnames(base_par)[1] != 'parameter') stop("'Input parameters/base_parameter_values.csv' must begin with 'parameter' column.")

if (colnames(test_par)[1] != 'parameter') stop("'Input parameters/test_parameter_values.csv' must begin with 'parameter' column.")


# check for duplicate parameter names

if (any(duplicated(base_par$parameter))) stop("Duplicate parameters in 'Input parameters/base_parameter_values.csv'.")

if (any(duplicated(test_par$parameter))) stop("Duplicate parameters in 'Input parameters/test_parameter_values.csv'.")


# confirm that all test parameters are present in base_parameter_values.csv

if (!all(test_par$parameter %in% base_par$parameter)) stop("Not all parameters in 'Input parameters/test_parameter_values.csv' present in 'Input parameters/base_parameter_values.csv'.")






## CREATE OUTPUT FOLDERS IF THEY DON'T ALREADY EXIST

if (!dir.exists('output psets')) dir.create('output psets')




