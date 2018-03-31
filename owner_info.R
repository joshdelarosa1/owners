library(dplyr)

#read in NYC DOB Job data
job_file= read.csv("https://data.cityofnewyork.us/api/views/ic3t-wcy2/rows.csv?accessType=DOWNLOAD")  
head(job_file)

#convert pre-file date to from char to date format
job_file$dates <- as.Date(job_file$Pre..Filing.Date, "%m/%d/%Y")

str(job_file)

attach(job_file)
#sort by BIN and date
job_file2 <- job_file[order(GIS_BIN, dates),]

detach(job_file)
#keep permits in 2015 or beyond
job_file2015 <- subset(job_file, dates > as.Date("2014-12-31") )


# keep the most recent permit for the BIN
newest_owner<-tbl_df(job_file2015) %>% group_by(GIS_BIN) %>% top_n(1, dates)
#drop ties
newest_owner2<-distinct(newest_owner,GIS_BIN,.keep_all = TRUE)


# keep only var we need to reduce file size
myvars <- c("GIS_BIN", "Borough", "Block","Lot","Job..","Pre..Filing.Date","Owner.s.First.Name","Owner.s.Last.Name","Owner.s.Business.Name","Owner.s.House.Number","Owner.sHouse.Street.Name","City", "State","Zip","Owner.sPhone.." )
NYC_Owners_Job_subset <- newest_owner2[myvars]

write.csv(NYC_Owners_Job_subset, file=gzfile("/Users/josuedelarosa/dev/owner/owners_per_permit.csv.gz"))

