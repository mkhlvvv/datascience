load(file = "Last_date.RData")

t <- substr(as.character(Sys.time()), 1, 10)

today<-as.POSIXlt(t)

last_date<-as.POSIXlt("2021-01-31")
last_date2<-"2021-01-31"

# table_suffix<-"20210103"

m<-(as.numeric(today-last_date)-1)

rga_auth <- authorize(client.id = "680348893674-74hji9v9jrls5oo1unap7kujg5jojb3q.apps.googleusercontent.com", client.secret = "jGsz-86u5sp2O54IChqV3bMo")

if (last_date!=today & last_date!=as.POSIXlt(today-86400)) {
  
  for (i in 1:m){last_date<-as.POSIXlt(last_date)+86400;last_date2<-as.POSIXlt(last_date2)+86400;i<-i+1;
  
  table_suffix<-gsub("-", "", last_date, ignore.case = FALSE, perl = FALSE,
                     fixed = FALSE, useBytes = FALSE);
  


users_with_zakaz<- get_ga("ga:186429948",
                       start.date = "2021-01-01",
                       end.date      = "2021-02-23",
                       dimensions  = "ga:dimension3",
                       metrics     = "ga:goal8Completions,ga:goal8Value,ga:goal7Completions,ga:goal7Value",
                       #filters     = "ga:pagePath=@obzor-tovarov.pro",
                       #segment    = "sessions::condition::ga:PagePath=@obzor-tovarov.pro;ga:sessionCount==1",
                       segment    = "users::condition::ga:goal8Completions>0",
                       fetch.by      = "month",
                       samplingLevel =  "HIGHER_PRECISION",
                       #max.results   = 10000,
                       token = rga_auth)



library(bigrquery)

bq_auth(path = "C:/R/new2.json")
insert_upload_job("peaceful-parity-209212",  
                  "Garlyn", 
                  "users_with_zakaz",
                  #gsub(" ", "", paste("reytings",table_suffix)),
                  #"Lidi",
                  users_with_zakaz, 
                  "peaceful-parity-209212", 
                  create_disposition = "CREATE_IF_NEEDED",     
                  write_disposition = "WRITE_TRUNCATE")




}}
