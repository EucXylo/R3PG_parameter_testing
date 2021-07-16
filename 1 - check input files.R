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



## GET SITE INPUT FILES AND IGNORE NON-XLSX FORMAT FILES

sifiles <- list.files('input sites')  # get file names from input folder


ixlsx <- grepl("xlsx$", sifiles, ignore.case=T)  # check if input files end with xlsx

if (any(!ixlsx)) warning("Not all files in 'input sites' were xlsx format - some files ignored.")

sifiles <- sifiles[ixlsx]  # discard any non-xlsx files



## GET ACTUAL DATA FOR SITES 

act_val <- read.csv('input actual/actual_data.csv')


# Check for duplicate sites

if (any(duplicated(act_val[,1]))) stop("Duplicate values in first column of 'input actual/actual_data.csv'.")


# Check that all sites in actual_data.csv are represented in 'input sites' subfolder and vice versa

if (!all(paste0(act_val[,1], '.xlsx') %in% sifiles)) warning("Not all sites in 'input actual/actual_data.csv' are represented in 'input sites'.")

if (!all(sifiles %in% paste0(act_val[,1], '.xlsx'))) stop("Not all files in 'input sites' subfolder are represented as sites in 'input actual/actual_data.csv'.")


# Check that selected output variables are all represented by numeric values in actual_data.csv

colnames(act_val) <- tolower(colnames(act_val))

if (!all(oput %in% colnames(act_val[,-1]))) stop("Not all r3PG outputs listed in 'RUN' script are present in 'input actual/actual_data.csv'.")

sel_data <- act_val[, match(oput, colnames(act_val))]

if (anyNA(sel_data)) stop("Missing data in 'input actual/actual_data.csv' for r3PG output variables listed in 'RUN' script.")

if (!all(is.numeric(unlist(sel_data)))) stop("Expected only numeric values in 'input actual/actual_data.csv' for r3PG output variables listed in 'RUN' script.")



## CREATE OUTPUT FOLDERS IF THEY DON'T ALREADY EXIST

if (!dir.exists('output psets')) dir.create('output psets')

if (!dir.exists('output compare')) dir.create('output compare')



