# Work space setup -------------------------------------------
rm(list = ls()) # clear console

# Load Libraries -------------------------------------------
library(plyr)

# download all data between start year and end year
end_year <- 2020
start_year <- 1989

# directory to store files
setwd("/home/dylan/Dropbox/Research/Crop Insurance/USDA_COL")

# loop through years to download each year of data
for(i in start_year:end_year){
  url <-paste0("https://www.rma.usda.gov/-/media/RMA/Cause-Of-Loss/Summary-of-Business-with-Month-of-Loss/colsom_",i,".ashx?la=en")
  download.file(url, destfile = basename(paste("COL_",i,".zip",sep="")), method="curl", extra="-k")
}

# get all the zip files in directory
zipF <- list.files(path = getwd(), pattern = "*.zip", full.names = TRUE)

# unzip all the identified zip files
ldply(.data = zipF, .fun = unzip, exdir = getwd())


# Get a List of all txt files in the director
txtF <- list.files(getwd(), pattern="*.txt", full.names=TRUE)
filenames <- filenames[which(substr(filenames,nchar(filenames)-3, nchar(filenames)) == ".csv")] 

# read and row bind all data sets
data <- rbindlist(lapply(txtF,fread))

# add column names
colnames(data) <- c("year_commodity","state_code","state","county_code","county",
                    "commodity_code","commodity","ins_plan_code","ins_plan",
                    "cov_cat","stage_code","col_code","col","month_loss_code","month_loss",
                    "year_loss","pol_ep","pol_indem","net_planted_acres","net_endorsed_acres",
                    "liability","total_prem","producer_paid_prem","subsidy","state_subsidy",
                    "additional_subsidy","efa_prem_discount","net_determined_acres","indemnity_amount",
                    "loss_ratio")

# write final data file to a csv
write.csv(data,paste0("USDA_COL_",start_year,"_",end_year,".csv"))

# clean up directory

# delete all zip files
ldply(.data = zipF, .fun = file.remove, exdir = getwd())

# delete all the txt files
ldply(.data = txtF, .fun = file.remove, exdir = getwd())



