# Kim Martin
# 17/02/2021
# R version 4.0.3 (2020-10-10)

# Aim: create combinations of key parameter values and test r3PG predictions against actual data for each parameter set

# This script to run different combinations of key r3PG parameters in r3PG for multiple sites and output predictions



## CREATE FILE TO HOLD OUTPUTS ALONG WITH ACTUAL DATA

ofilename <- paste0('Output sim/', 
                    sub('combination.csv$', 'test_r3PG_output.csv', pfiles[is_par_comb]))

oheaders <- c('parameter set', 'site', 'date', 'species', 'group', 'variable', 'value')

write.table(t(oheaders), file = ofilename, row.names=F, col.names=F, sep=',')



## LOOP THROUGH EACH INPUT FILE TO GENERATE R3PG OUTPUT

for (sifile in sifiles) {
  
  site_id <- sub('.xlsx$', '', sifile)
  
  
  ## GET INPUT DATA FROM FILE
  
  sifilepath <- paste0('Input sites/', sifile) # add relative file path
  
  isite <- read_xlsx(sifilepath, 'site')
  ispecies <- read_xlsx(sifilepath, 'species')
  iclimate <- read_xlsx(sifilepath, 'climate')
  
  
  #iparameters_old <- read_xlsx(sifilepath, 'parameters')

  
  
  ## GET SPECIES AND TIME RANGE INFORMATION FROM DATA
  
  ispeciesname <- ispecies$species[1]  # NB: this assumes one species per input dataset!
  
  iclimatestart <- isite$from[1]
    
  iclimateend <- isite$to[1]
  
  
  
  # EXTRACT PARAMETER SETS (WITH PSET ID) AND TRANSPOSE FOR INPUT INTO R3PG ONE AT A TIME
  
  for (pset in 1:dim(par_combinations)[1]) {
    
    pset_id <- par_combinations[pset, 1]   # ID of parameter set
    
    iparameters_new <- tibble('parameter' = colnames(par_combinations)[-1],
                          'Eucalyptus grandis x urophylla' = as.vector(t(par_combinations[pset, -1])))
    
    iparameters <- iparameters_new
    
    
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
    
    
    
    ## DISCARD OUTPUT VARIABLES NOT OF INTEREST
    
    keepv <- rep(F, dim(r3PG_output)[1])
    
    for (ov in oput) {
      
      keepv <- keepv + c(r3PG_output$variable == ov)
      
    }
    
    r3PG_output <- r3PG_output[keepv > 0, ]
    
    
    
    ## ADD PARAMETER SET AND SITE INFO TO MODEL OUTPUT
    
    r3PG_output <- cbind(rep(pset_id, dim(r3PG_output)[1]),
                         rep(site_id, dim(r3PG_output)[1]),
                         r3PG_output)

    
    
    ## OUTPUT CSV RESULTS WITH PSET AND SITE INFO (APPENDED TO OUTPUT FILE)
    
    write.table(r3PG_output, file = ofilename, row.names=F, col.names=F, append=T, sep=',')
  
    
    
  }
  
  
}



