# R3PG_parameter_testing

## Overview

To parameterize the 3PG model for Eucalyptus grandis x urophylla in South Africa, `test parameters` were selected from the list of 3PG standard parameters (`base parameter`). These test parameters could not be calibrated from the data available in this study and 3PG outputs have shown sensitivity to them. Published parameter values for this species were set as biologically plausible bounds(low, medium, high). This repository contains scripts used for generating all the possible combinations of the test parameter values with the base parameters, and testing R3PG model predictions from each parameter set against observed data.

Four output folders are automatically created during the run, to contain the following timestamped outputs:

* 'output psets' - contains parameter sets generated from all combinations of parameters in 'input parameters/test_parameters.csv', along with 'input parameters/base_parameters.csv'

* 'output trace' - contains climate data used for each site in 'input sites', combining climate data from each site's 'climate' tab along with substituted values from files in the 'input weather' subfolder (the latter over-writes the former)

* 'output sim' - contains r3PG simulation outputs matched with actual data taken from 'input actual/actual_data.csv'

* 'output compare' - contains MAE and RMSE outputs for all parameter sets
