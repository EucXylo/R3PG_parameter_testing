# R3PG_parameter_testing

Testing combinations of key parameters for best R3PG predictions of selected output variables

Four output folders are automatically created during the run, to contain the following timestamped outputs:

* 'output psets' - contains parameter sets generated from all combinations of parameters in 'input parameters/test_parameters.csv', along with 'input parameters/base_parameters.csv'

* 'output trace' - contains climate data used for each site in 'input sites', combining climate data from each site's 'climate' tab along with substituted values from files in the 'input weather' subfolder (the latter over-writes the former)

* 'output sim' - contains a single output file with r3PG simulation outputs matched with actual data taken from 'input actual/actual_data.csv'

* 'output compare' - contains MAE and RMSE outputs for all parameter sets
