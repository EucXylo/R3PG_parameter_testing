# Kim Martin
# 17/02/2021
# R version 4.0.3 (2020-10-10)

# Aim: create combinations of key parameter values and test r3PG predictions against actual data for each parameter set

# This script to run different combinations of key r3PG parameters in r3PG for multiple sites and output predictions



## CREATE FILE TO HOLD OUTPUTS ALONG WITH ACTUAL DATA

ofilename <- paste0('output sim/', tstamp, '_par_test_r3PG_output.csv')

oheaders <- c('parameter set', 'site', 'date', 'species', 'group', 'variable', 'predicted', 'actual')

write.table(t(oheaders), file = ofilename, row.names=F, col.names=F, sep=',')



## LOOP THROUGH EACH INPUT FILE TO GENERATE R3PG OUTPUT

for (sifile in sifiles) {
  
  site_id <- sub('.xlsx$', '', sifile)
  
  
  ## GET INPUT DATA FROM FILE
  
  sifilepath <- paste0('input sites/', sifile)
  
  isite <- read_xlsx(sifilepath, 'site')
  ispecies <- read_xlsx(sifilepath, 'species')
  iclimate <- read_xlsx(sifilepath, 'climate')  
  
  
  ## OVERWRITE CLIMATE DATA IN 'SITE' FILES WITH ANY SUBSTITUTE WEATHER DATA FROM 'INPUT WEATHER' FOLDER
  
  if (length(all_weather_vars) > 0) {
    
    weather_data <- merge(iclimate[, c('year', 'month')], 
                          subst_weather[subst_weather$site == site_id, ], 
                          by = c('year', 'month'), sort = FALSE, all.x = TRUE)
    
    msg <- paste0(paste0("Period covered by 'input weather' doesn't include start date from 'site' sheet in 'input sites/", sifile, "'."))
    if (!check_dates(isite$from, '>=', subst_weather$year[1], subst_weather$month[1])) stop(msg)
    
    msg <- paste0(paste0("Period covered by 'input weather' doesn't include end date from 'site' sheet in 'input sites/", sifile, "'."))
    if (!check_dates(isite$to, '<=', tail(subst_weather$year, 1), tail(subst_weather$month, 1))) stop(msg)
    
    
    # replace old weather data with substitute data
    
    for (v in all_weather_vars) {

      old_var <- match(v, colnames(iclimate))
      
      msg <- paste0("File 'input weather/", v, ".csv' doesn't have corresponding variable in the 'climate' sheet of 'input sites/", sifile, "'.")
      if (anyNA(old_var)) stop(msg)
      
      subst_var <- match(v, colnames(weather_data))
      
      iclimate[, old_var] <- NA # make sure old values are removed
      
      iclimate[, old_var] <- weather_data[, subst_var]
      
    }
    
    # discard rows with missing data
    
    iclimate <- iclimate[!is.na(rowSums(iclimate[, all_weather_vars])), ]
    
  }
  
  
  ## OUTPUT CLIMATE DATA USED IN SITE SIMULATION FOR RECORD
  
  ofilename <- paste0('output trace/', tstamp, '_', site_id, '_climate.csv')
  
  write.csv(iclimate, file = ofilename, row.names=F)
  
  
  
  # EXTRACT PARAMETER SETS (WITH PSET ID) AND TRANSPOSE FOR INPUT INTO R3PG ONE AT A TIME
  
  for (pset in 1:num_par_comb) {
    
    pset_id <- par_combination[pset, 1]   # ID of parameter set

    iparameters <- tibble(colnames(par_combination)[-1],
                          as.vector(t(par_combination[pset, -1])))
    
    colnames(iparameters) <- c('parameter', ispecies$species)
    
    
    r3PG_output <- check_and_run_r3PG_inputs(isite, ispecies, iclimate, iparameters)
    


    ## DISCARD OUTPUT VARIABLES NOT OF INTEREST
    
    r3PG_output <- r3PG_output[r3PG_output$variable %in% oput, ]
    
    
    
    ## DISCARD ALL VALUES EXCEPT THOSE WITH MATCHING ACTUAL DATA (IN TREES OVER 3YO)
    
    site_act_val <- act_val[act_val[,1] == site_id, ]
    
    site_act_val <- site_act_val[site_act_val$age > 3, ]
    
    site_act_val$end_month <- as.Date(paste(site_act_val$year, site_act_val$month + 1, '01', sep = '-'), format = '%Y-%m-%d') - 1
    
    r3PG_output <- r3PG_output[r3PG_output$date %in% site_act_val$end_month, ]
    
    
    
    ## ADD PARAMETER SET AND SITE INFO TO MODEL OUTPUT

    r3PG_output <- cbind(pset_id, site_id, r3PG_output)
    
    
    
    ## MATCH PREDICTED AND ACTUAL VALUES FOR SITE
    
    r3PG_output <- r3PG_output[order(r3PG_output$variable, r3PG_output$date), ]
    
    site_act_val <- site_act_val[order(site_act_val$end_month), ]
    
    site_act_val <- unlist(site_act_val[, sort(oput)])
                      
    r3PG_output <- cbind(r3PG_output, site_act_val)
    
    
    colnames(r3PG_output) <- oheaders
    
    
    
    ## OUTPUT CSV RESULTS WITH PSET AND SITE INFO (APPENDED TO OUTPUT FILE)
    
    ofilename <- paste0('output sim/', tstamp, '_par_test_r3PG_output.csv')
    
    write.table(r3PG_output, file = ofilename, row.names=F, col.names=F, append=T, sep=',')
  
    
    print(paste(site_id, pset_id))
    
    
  }
  
  print(paste(rep('-', nchar(site_id) + 10), collapse = ''))
  print(paste('Completed', site_id))
  print(paste(rep('-', nchar(site_id) + 10), collapse = ''))
  
}



