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

colnames(base_par)[1] <- "parameter"


# confirm both base_par and test_par have 'parameter' as first column

msg <- "'Input parameters/base_parameter_values.csv' must begin with 'parameter' column."
if (colnames(base_par)[1] != 'parameter') stop(msg)

msg <- "'Input parameters/test_parameter_values.csv' must begin with 'parameter' column."
if (colnames(test_par)[1] != 'parameter') stop(msg)


# check for duplicate parameter names

msg <- "Duplicate parameters in 'Input parameters/base_parameter_values.csv'."
if (any(duplicated(base_par$parameter))) stop(msg)

msg <- "Duplicate parameters in 'Input parameters/test_parameter_values.csv'."
if (any(duplicated(test_par$parameter))) stop(msg)


# confirm that all test parameters are present in base_parameter_values.csv

msg <- "Not all parameters in 'Input parameters/test_parameter_values.csv' present in 'Input parameters/base_parameter_values.csv'."
if (!all(test_par$parameter %in% base_par$parameter)) stop(msg)



## GET SITE INPUT FILES AND IGNORE NON-XLSX FORMAT FILES

sifiles <- list.files('input sites')  # get file names from input folder

msg <- "Not all files in 'input sites' are xlsx format."
if (any(!grepl("xlsx$", sifiles, ignore.case=T))) stop(msg)








## GET ACTUAL DATA FOR SITES 

act_val <- read.csv('input actual/actual_data.csv')


# Check for duplicate sites

msg <- "Duplicate values in first column of 'input actual/actual_data.csv'."
if (any(duplicated(act_val[,1]))) stop(msg)


# Check that all sites in actual_data.csv are represented in 'input sites' subfolder and vice versa

msg <- "Not all sites in 'input actual/actual_data.csv' are represented in 'input sites'."
if (!all(paste0(act_val[,1], '.xlsx') %in% sifiles)) warning(msg)

msg <- "Not all files in 'input sites' subfolder are represented as sites in 'input actual/actual_data.csv'."
if (!all(sifiles %in% paste0(act_val[,1], '.xlsx'))) stop(msg)


# Check that selected output variables are all represented by numeric values in actual_data.csv

colnames(act_val) <- tolower(colnames(act_val))

msg <- "Not all r3PG outputs listed in 'RUN' script are present in 'input actual/actual_data.csv'."
if (!all(oput %in% colnames(act_val[,-1]))) stop(msg)

sel_data <- act_val[, match(oput, colnames(act_val))]

msg <- "Missing data in 'input actual/actual_data.csv' for r3PG output variables listed in 'RUN' script."
if (anyNA(sel_data)) stop(msg)

msg <- "Expected only numeric values in 'input actual/actual_data.csv' for r3PG output variables listed in 'RUN' script."
if (!all(is.numeric(unlist(sel_data)))) stop(msg)



## CREATE OUTPUT FOLDERS IF THEY DON'T ALREADY EXIST

if (!dir.exists('output psets')) dir.create('output psets')

if (!dir.exists('output sim')) dir.create('output sim')

if (!dir.exists('output compare')) dir.create('output compare')



