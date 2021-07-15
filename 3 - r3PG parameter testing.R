# Kim Martin
# 17/02/2021
# R version 4.0.3 (2020-10-10)

# Aim: create combinations of key parameter values and test r3PG predictions against actual data for each parameter set

# This script to run different combinations of key r3PG parameters in r3PG for multiple sites and output predictions



## CREATE FILE TO HOLD OUTPUTS ALONG WITH ACTUAL DATA

ofilename <- paste0('output sim/', tstamp, '_par_test_r3PG_output.csv')

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

  
  
  # EXTRACT PARAMETER SETS (WITH PSET ID) AND TRANSPOSE FOR INPUT INTO R3PG ONE AT A TIME
  
  for (pset in 1:dim(par_combination)[1]) {
    
    pset_id <- par_combination[pset, 1]   # ID of parameter set

    iparameters <- tibble(colnames(par_combination)[-1],
                          as.vector(t(par_combination[pset, -1])))
    
    colnames(iparameters) <- c('parameter', ispecies$species)
    
    
    r3PG_output <- check_and_run_r3PG_inputs(isite, ispecies, iclimate, iparameters)
    

    
    ## DISCARD ALL VALUES EXCEPT LAST IN TIME-SERIES
    
    last_day <- max(r3PG_output$date)
    
    r3PG_output <- r3PG_output[r3PG_output$date == last_day, ]
    
    
    
    ## DISCARD OUTPUT VARIABLES NOT OF INTEREST
    
    r3PG_output <- r3PG_output[r3PG_output$variable %in% oput, ]
    
    
    
    ## ADD PARAMETER SET AND SITE INFO TO MODEL OUTPUT

    r3PG_output <- cbind(pset_id, site_id, r3PG_output)
    
    
    
    
    
    
    
    
    
    ## OUTPUT CSV RESULTS WITH PSET AND SITE INFO (APPENDED TO OUTPUT FILE)
    
    write.table(r3PG_output, file = ofilename, row.names=F, col.names=F, append=T, sep=',')
  
    
    
  }
  
  
}



