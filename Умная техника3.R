load(file = "Last_date.RData")

t <- substr(as.character(Sys.time()), 1, 10)

today<-as.POSIXlt(t)

#last_date<-as.POSIXlt("2021-04-28")


#table_suffix<-"20210428"

m<-(as.numeric(today-last_date)-1)
last_date3<-last_date

if (last_date!=today & last_date!=as.POSIXlt(today-86400)) {

for (i in 1:m){last_date<-as.POSIXlt(last_date)+86400;i<-i+1;

table_suffix<-gsub("-", "", last_date, ignore.case = FALSE, perl = FALSE,
    fixed = FALSE, useBytes = FALSE);


library(ryandexdirect)
#aut <- yadirAuth(Login = "feldmann.elama", NewUser = TRUE, TokenPath = "C:/Users/?????????????/Documents/token_yandex")
#tok_fieldman_alama <- yadirGetToken()
login_getuniqu829361 <- "getuniq-u82936-1"
#my_client <- yadirGetClientList(AgencyAccount = "feldmann.elama")
getuniqu829361 <- yadirGetReport(ReportType = "CUSTOM_REPORT",
                                 DateRangeType = "CUSTOM_DATE",
                                 #DateRangeType = "YESTERDAY",
                                 DateFrom =last_date,
                                 DateTo =last_date,
                                 FieldNames = c("Date",
                                                "CampaignId",
                                                "CampaignName",
                                                "AdGroupId",
                                                "AdGroupName",
                                                "Criterion",
                                                "Cost",
                                                "Clicks",
                                                "Device",
                                                "Gender",
                                                "Age",
                                                "TargetingLocationName",
                                                "Conversions",
                                                "Revenue",
                                                "RlAdjustmentId"),
                                 Goals = c(132498535,134362828),
                                 AttributionModels = c("LYDC"),
                                 AgencyAccount = "feldmann.elama",
                                 Login = login_getuniqu829361,
                                 Token = "AgAAAABAFb6BAAMfZbZsaKvfa0Y6treWIeKzXB8")
getuniqu829361["account"]<- "getuniq-u82936-1"
getuniqu829361["Conversions_59226061_LYDC"]<-0
getuniqu829361["Conversions_52273132_LYDC"]<-0
login_getuniqu829371 <- "getuniq-u82937-1"
#my_client <- yadirGetClientList(AgencyAccount = "feldmann.elama")
getuniqu829371 <- yadirGetReport(ReportType = "CUSTOM_REPORT",
                                 DateRangeType = "CUSTOM_DATE",
                                 #DateRangeType = "YESTERDAY",
                                 DateFrom =last_date,
                                 DateTo =last_date,
                                 FieldNames = c("Date",
                                                "CampaignId",
                                                "CampaignName",
                                                "AdGroupId",
                                                "AdGroupName",
                                                "Criterion",
                                                "Cost",
                                                "Clicks",
                                                "Device",
                                                "Gender",
                                                "Age",
                                                "TargetingLocationName",
                                                "Conversions",
                                                "RlAdjustmentId"),
                                 Goals = c(59226061,52273132),
                                 AttributionModels = c("LYDC"),
                                 AgencyAccount = "feldmann.elama",
                                 Login = login_getuniqu829371,
                                 Token = "AgAAAAA-KwN-AAMfZQmkQKCms0t2oyB-AYf0I78")
getuniqu829371["Conversions_132498535_LYDC"]<-0
getuniqu829371["Conversions_134362828_LYDC"]<-0
getuniqu829371["account"]<- "getuniq-u82937-1"
getuniqu829371["Revenue_132498535_LYDC"]<-0
getuniqu829371["Revenue_134362828_LYDC"]<-0
direct <- rbind(getuniqu829361,getuniqu829371)



library(bigrquery)
bq_auth(path = "C:/Users/User/Documents/R/new2.json")
insert_upload_job("peaceful-parity-209212",
                  "Garlyn",
                  #gsub(" ", "", paste("direct_",yesterday2)),
                  gsub(" ", "", paste("direct_",table_suffix)),
                  direct,
                  "peaceful-parity-209212",
                  create_disposition = "CREATE_IF_NEEDED",
                  write_disposition = "WRITE_TRUNCATE")








library(RAdwords)

adwords_auth <- doAuth()



account_id   <- "140-579-3782"
body <- statement(select=c('AccountCurrencyCode',
                           'Date',
                           'CampaignId',
                           'CampaignName',
                           'Cost',
                           'Clicks'),
                  #'Conversions'),
                  report="CAMPAIGN_PERFORMANCE_REPORT",
                  start=last_date,
                  end=last_date)


c1405793782 <- getData(clientCustomerId = account_id,
                       google_auth = adwords_auth,
                       statement = body,
                       transformation = T)

c1405793782$Account_id<-account_id









adw<- rbind(c1405793782)




library(bigrquery)

bq_auth(path = "C:/Users/User/Documents/R/new2.json")


insert_upload_job("peaceful-parity-209212",  
                  "Garlyn", 
                  gsub(" ", "", paste("ADW_",table_suffix)),
                  adw, 
                  "peaceful-parity-209212", 
                  create_disposition = "CREATE_IF_NEEDED",     
                  write_disposition = "WRITE_TRUNCATE")





library(glue)
library(rmytarget)

#myTarAuth(login = "my_test_client",
#         token_path = "C:/Users/User/Documents/R/mytarget")

campaing <- myTarGetCampaignList(login = "my_test_client", token_path = "C:/Users/User/Documents/R/mytarget", request_speed = 1.2)

campaing <- data.frame(campaing$id,campaing$name)

names(campaing)[1]<-"id"
names(campaing)[2]<-"campaing"

camp_data    <- myTarGetStats(date_from   = last_date,
                              date_to     = last_date,
                              object_type = "campaigns",
                              
                              stat_type   = "day",
                              login       = "my_test_client", 
                              token_path  = "C:/Users/User/Documents/R/mytarget")

camp_data$Source<-"mytarget/cpc"


camp_data<-merge(camp_data,campaing, by.x="id", by.y ="id" )



library(bigrquery)


insert_upload_job("peaceful-parity-209212",  
                  "Garlyn", 
                  "mytarget_campaing",
                  #"Zakazy",
                  campaing, 
                  "peaceful-parity-209212", 
                  create_disposition = "CREATE_IF_NEEDED",     
                  write_disposition = "WRITE_TRUNCATE")

insert_upload_job("peaceful-parity-209212",  
                  "Garlyn", 
                  gsub(" ", "", paste("mytarget_",table_suffix)),
                  #"Lidi",
                  camp_data, 
                  "peaceful-parity-209212", 
                  create_disposition = "CREATE_IF_NEEDED",     
                  write_disposition = "WRITE_TRUNCATE")


library(yamarketr)

#yamarketrAuth(Login = "llc-ut@yandex.ru", NewUser = TRUE, TokenPath = "C:/Users/User/Documents/R/token_yandex")

campaigns <- yamarketrGetCampaigns(Login = NULL, TokenPath = "C:/Users/User/Documents/R/token_yandex")

yamarketCosts <- yamarketrGetCosts(campaigns,
                                   fromDate = format(last_date, "%d-%m-%Y"),
                                   toDate = format(last_date, "%d-%m-%Y"),
                                   Login = NULL,
                                   TokenPath = "C:/Users/User/Documents/R/token_yandex",
                                   places = 0,
                                   model = 0,
                                   fetchBy = "daily")

yamarketCosts$spending <- round(yamarketCosts$spending*30)




library(bigrquery)

bq_auth(path = "C:/Users/User/Documents/R/new2.json")
insert_upload_job("peaceful-parity-209212",  
                  "Garlyn", 
                  gsub(" ", "", paste("market_",table_suffix)),
                  #"Lidi",
                  yamarketCosts, 
                  "peaceful-parity-209212", 
                  create_disposition = "CREATE_IF_NEEDED",     
                  write_disposition = "WRITE_TRUNCATE")


library(rfacebookstat)

options(rfacebookstat.access_token = "EAACg7dbgLXMBAI1k8ZB3gPEBPFEXB9f6TBhM4TQbneTHevDZCcfcK2fcGJrsRn4xLgL1zWY3ROHUcLu3KCKo51rrEExKzj40fzE91qwS5bon664GwHGUk0z4FgQJaSFPYvnH6vQFO64tje7aeIdZAT1NKZCZAAImyo55HHzUEZBiruDZCv6Jd6W",
        rfacebookstat.accounts_id  = "act_185762959480302")
fb_data_bist <- fbGetMarketingStat(
  level              = "campaign",
  fields             = "account_id,
campaign_name,
campaign_id,
clicks,
spend",
  date_start         = (as.POSIXlt(last_date)),
  date_stop          = (as.POSIXlt(last_date)))
options(rfacebookstat.access_token = "EAACg7dbgLXMBAI1k8ZB3gPEBPFEXB9f6TBhM4TQbneTHevDZCcfcK2fcGJrsRn4xLgL1zWY3ROHUcLu3KCKo51rrEExKzj40fzE91qwS5bon664GwHGUk0z4FgQJaSFPYvnH6vQFO64tje7aeIdZAT1NKZCZAAImyo55HHzUEZBiruDZCv6Jd6W",
        rfacebookstat.accounts_id  = "act_249540576257448")
fb_data_garlyn <- fbGetMarketingStat(
  level              = "campaign",
  fields             = "account_id,
campaign_name,
campaign_id,
clicks,
spend",
  date_start         = (as.POSIXlt(last_date)),
  date_stop          = (as.POSIXlt(last_date)))

fb_data <- rbind(fb_data_bist,fb_data_garlyn)
fb_data<-fb_data[ ,-6]


library(bigrquery)
bq_auth(path = "C:/Users/User/Documents/R/new2.json")
insert_upload_job("peaceful-parity-209212",
                  "Garlyn",
                  #gsub(" ", "", paste("direct_",yesterday2)),
                  gsub(" ", "", paste("fb_data_",table_suffix)),
                  fb_data,
                  "peaceful-parity-209212",
                  create_disposition = "CREATE_IF_NEEDED",
                  write_disposition = "WRITE_TRUNCATE")












}}



library("RGA")


rga_auth <- authorize(client.id = "680348893674-74hji9v9jrls5oo1unap7kujg5jojb3q.apps.googleusercontent.com", client.secret = "jGsz-86u5sp2O54IChqV3bMo")


ga_data_ass1 <- get_ga("ga:186429948",
                       start.date = last_date-604800,
                       end.date      = last_date,
                       dimensions  = "ga:date,ga:sourceMedium,ga:campaign,ga:adwordsCampaignID",
                       metrics     = "ga:goal8Value,ga:goal8Completions",
                       filters     = "ga:medium=@cpc,ga:medium=@display",
                       fetch.by      = "day",
                       samplingLevel =  "HIGHER_PRECISION",
                       max.results   = 10000,
                       token = rga_auth)

#aggregate(cbind(goal8Completions)~sourceMedium,
#         data=ga_data_ass1,FUN=sum)


ga_data_ass2 <- get_mcf("ga:186429948",
                        start.date = last_date-604800,
                        end.date      = last_date,
                        dimensions  = "mcf:conversionDate,mcf:sourceMedium, mcf:campaignName,mcf:adwordsCampaignID",
                        metrics     = "mcf:assistedValue,mcf:firstInteractionValue,mcf:totalConversionValue,mcf:totalConversions,mcf:assistedConversions,mcf:firstInteractionConversions",
                        filters     = "mcf:conversionGoalNumber==008;mcf:Medium=@cpc,mcf:Medium=@display",
                        fetch.by      = "day",
                        samplingLevel =  "HIGHER_PRECISION",
                        max.results   = 10000,
                        token = rga_auth)


ga_data_ass2$conversionDate<-as.Date(as.character(ga_data_ass2$conversionDate), format = "%Y%m%d")



ga_data_ass3 <- get_ga("ga:186429948",
                       start.date = last_date-604800,
                       end.date      = last_date,
                       dimensions  = "ga:date,ga:sourceMedium,ga:campaign,ga:adwordsCampaignID",
                       metrics     = "ga:goal7Value,ga:goal7Completions",
                       filters     = "ga:medium=@cpc,ga:medium=@display",
                       fetch.by      = "day",
                       samplingLevel =  "HIGHER_PRECISION",
                       max.results   = 10000,
                       token = rga_auth)



ga_data_ass4 <- get_mcf("ga:186429948",
                        start.date = last_date-604800,
                        end.date      = last_date,
                        dimensions  = "mcf:conversionDate,mcf:sourceMedium,mcf:campaignName,mcf:adwordsCampaignID",
                        metrics     = "mcf:assistedValue,mcf:firstInteractionValue,mcf:totalConversionValue,mcf:totalConversions,mcf:assistedConversions,mcf:firstInteractionConversions",
                        filters     = "mcf:conversionGoalNumber==007;mcf:Medium=@cpc,mcf:Medium=@display",
                        fetch.by      = "day",
                        samplingLevel =  "HIGHER_PRECISION",
                        max.results   = 10000,
                        token = rga_auth)

#sum(ga_data_ass4$assistedValue)

ga_data_ass4$conversionDate<-as.Date(as.character(ga_data_ass4$conversionDate), format = "%Y%m%d")


names(ga_data_ass1)[3]<-"campaignName"
names(ga_data_ass3)[3]<-"campaignName"
names(ga_data_ass2)[1]<-"date"
names(ga_data_ass4)[1]<-"date"
names(ga_data_ass4)[1]<-"date"
names(ga_data_ass3)[1]<-"date"

names(ga_data_ass2)[5]<-"AssistedValue8"
names(ga_data_ass2)[6]<-"firstInteractionValue8"
names(ga_data_ass2)[7]<-"totalConversionValue8"
names(ga_data_ass2)[8]<-"totalConversions8"
names(ga_data_ass2)[9]<-"assistedConversions8"
names(ga_data_ass2)[10]<-"firstInteractionConversions8"

names(ga_data_ass4)[5]<-"AssistedValue7"
names(ga_data_ass4)[6]<-"firstInteractionValue7"
names(ga_data_ass4)[7]<-"totalConversionValue7"
names(ga_data_ass4)[8]<-"totalConversions7"
names(ga_data_ass4)[9]<-"assistedConversions7"
names(ga_data_ass4)[10]<-"firstInteractionConversions7"

ga_data_ass1$AssistedValue8<-"0"
ga_data_ass1$firstInteractionValue8<-"0"
ga_data_ass1$totalConversionValue8<-"0"
ga_data_ass1$totalConversions8<-"0"
ga_data_ass1$assistedConversions8<-"0"
ga_data_ass1$firstInteractionConversions8<-"0"
ga_data_ass1$AssistedValue7<-"0"
ga_data_ass1$firstInteractionValue7<-"0"
ga_data_ass1$totalConversionValue7<-"0"
ga_data_ass1$totalConversions7<-"0"
ga_data_ass1$assistedConversions7<-"0"
ga_data_ass1$firstInteractionConversions7<-"0"
ga_data_ass1$goal7Value<-"0"
ga_data_ass1$goal7Completions<-"0"

ga_data_ass3$AssistedValue8<-"0"
ga_data_ass3$firstInteractionValue8<-"0"
ga_data_ass3$totalConversionValue8<-"0"
ga_data_ass3$totalConversions8<-"0"
ga_data_ass3$assistedConversions8<-"0"
ga_data_ass3$firstInteractionConversions8<-"0"
ga_data_ass3$AssistedValue7<-"0"
ga_data_ass3$firstInteractionValue7<-"0"
ga_data_ass3$totalConversionValue7<-"0"
ga_data_ass3$totalConversions7<-"0"
ga_data_ass3$assistedConversions7<-"0"
ga_data_ass3$firstInteractionConversions7<-"0"
ga_data_ass3$goal8Value<-"0"
ga_data_ass3$goal8Completions<-"0"

ga_data_ass2$AssistedValue7<-"0"
ga_data_ass2$firstInteractionValue7<-"0"
ga_data_ass2$totalConversionValue7<-"0"
ga_data_ass2$totalConversions7<-"0"
ga_data_ass2$assistedConversions7<-"0"
ga_data_ass2$firstInteractionConversions7<-"0"
ga_data_ass2$goal8Value<-"0"
ga_data_ass2$goal8Completions<-"0"
ga_data_ass2$goal7Value<-"0"
ga_data_ass2$goal7Completions<-"0"

ga_data_ass4$AssistedValue8<-"0"
ga_data_ass4$firstInteractionValue8<-"0"
ga_data_ass4$totalConversionValue8<-"0"
ga_data_ass4$totalConversions8<-"0"
ga_data_ass4$assistedConversions8<-"0"
ga_data_ass4$firstInteractionConversions8<-"0"
ga_data_ass4$goal8Value<-"0"
ga_data_ass4$goal8Completions<-"0"
ga_data_ass4$goal7Value<-"0"
ga_data_ass4$goal7Completions<-"0"


ga_data_ass<-rbind(ga_data_ass1,ga_data_ass2,ga_data_ass3,ga_data_ass4)


for (i in 1:nrow(ga_data_ass)) {
  if (ga_data_ass$adwordsCampaignID[i] == "(not set)" &  
      ga_data_ass$sourceMedium[i] == "mytarget / cpc")   {
    ga_data_ass$adwordsCampaignID[i]<-sapply(regmatches(ga_data_ass$campaignName[i], gregexpr("[0-9]\\s*", ga_data_ass$campaignName[i])), paste, collapse = "")
  }}

for (i in 1:nrow(ga_data_ass)) {
  if (ga_data_ass$adwordsCampaignID[i] == "(not set)")   {
    ga_data_ass$adwordsCampaignID[i]<-strsplit(ga_data_ass$campaignName[i],"|",fixed = TRUE)[[1]][2]
  }}

for (i in 1:nrow(ga_data_ass)) {
  if (is.na(ga_data_ass$adwordsCampaignID[i]))   {
    ga_data_ass$adwordsCampaignID[i]<-"(not set)"
  }}


names(ga_data_ass)[4]<-"campaign_id"

ga_data_ass7<-merge(ga_data_ass,campaing, by.x="campaign_id", by.y ="id" )
ga_data_ass7<-ga_data_ass7[ ,-4]
names(ga_data_ass7)[20]<-"campaignName"
ga_data_ass<-ga_data_ass[ga_data_ass$sourceMedium !="mytarget / cpc", ]
ga_data_ass<- rbind(ga_data_ass,ga_data_ass7)

for (i in 1:nrow(ga_data_ass)) {
  if (ga_data_ass$sourceMedium [i] == "google / display" )   {
    ga_data_ass$sourceMedium[i]<-"google / cpc"
  }}

library(dplyr)

ga_data_ass<-ga_data_ass%>%group_by(date,sourceMedium,campaignName,campaign_id)%>%
  summarise(
    AssistedValue8=sum(as.numeric(AssistedValue8)),
    firstInteractionValue8=sum(as.numeric(firstInteractionValue8)),
    totalConversionValue8=sum(as.numeric(totalConversionValue8)),
    totalConversions8=sum(as.numeric(totalConversions8)),
    assistedConversions8=sum(as.numeric(assistedConversions8)),
    firstInteractionConversions8=sum(as.numeric(firstInteractionConversions8)),
    AssistedValue7=sum(as.numeric(AssistedValue7)),
    firstInteractionValue7=sum(as.numeric(firstInteractionValue7)),
    totalConversionValue7=sum(as.numeric(totalConversionValue7)),
    totalConversions7=sum(as.numeric(totalConversions7)),
    assistedConversions7=sum(as.numeric(assistedConversions7)),
    firstInteractionConversions7=sum(as.numeric(firstInteractionConversions7)),
    goal7Value=sum(as.numeric(goal7Value)),
    goal7Completions=sum(as.numeric(goal7Completions)),
    goal8Value=sum(as.numeric(goal8Value)),
    goal8Completions=sum(as.numeric(goal8Completions)))

#ga_data_ass$Date<-last_date

library(bigrquery)

bq_auth(path = "C:/Users/User/Documents/R/new2.json")
insert_upload_job("peaceful-parity-209212",  
                  "Garlyn", 
                  "analytics_day",
                  #gsub(" ", "", paste("analytics_day",table_suffix)),
                  #"Lidi",
                  ga_data_ass, 
                  "peaceful-parity-209212", 
                  create_disposition = "CREATE_IF_NEEDED",     
                  write_disposition = "WRITE_TRUNCATE")


library(timeperiodsR)

m<-as.numeric(format(this_week(today-86400)$start, "%W"))-as.numeric(format(this_week(last_date)$start, "%W"))+1


for (i in 1:m){table_suffix<-gsub("-", "", this_week(last_date)$start);i<-i+1;



reytings_path<- get_ga("ga:186429948",
                       start.date = this_week(last_date)$start,
                       end.date      = this_week(last_date)$end,
                       dimensions  = "ga:pagePath",
                       metrics     = "ga:users",
                       #filters     = "ga:pagePath=@obzor-tovarov.pro",
                       #segment    = "sessions::condition::ga:PagePath=@obzor-tovarov.pro;ga:sessionCount==1",
                       #segment    = "sessions::condition::ga:PagePath=@obzor-tovarov.pro",
                       fetch.by      = "month",
                       samplingLevel =  "HIGHER_PRECISION",
                       #max.results   = 10000,
                       token = rga_auth);


promo_path<- get_ga("ga:186429948",
                    start.date = this_week(last_date)$start,
                    end.date      = this_week(last_date)$end,
                    dimensions  = "ga:pagePath",
                    metrics     = "ga:users",
                    #filters     = "ga:pagePath=@obzor-tovarov.pro",
                    #segment    = "users::condition::ga:dimension3 == reytings_path$dimension3[1]",
                    segment    = "sessions::sequence::ga:pagePath=@obzor-tovarov.pro;->>ga:pagePath=@garlyn.ru,ga:pagePath=@bist.ru,ga:pagePath=@mirandi.ru,ga:pagePath=@sendo-air-90-akcija,ga:pagePath=@product/air-pro-4",
                    fetch.by      = "month",
                    samplingLevel =  "HIGHER_PRECISION",
                    #max.results   = 10000,
                    token = rga_auth)


users_path_sks<- get_ga("ga:186429948",
                        start.date = this_week(last_date)$start,
                        end.date      = this_week(last_date)$end,
                        dimensions  = "ga:pagePath",
                        metrics     = "ga:users",
                        #filters     = "ga:pagePath=@obzor-tovarov.pro",
                        segment    = "users::condition::ga:sessions>0;sessions::sequence::ga:pagePath=@obzor-tovarov.pro;->>ga:pagePath=@sendo-air.ru,ga:pagePath=@orverk.com;->>ga:goal5Completions>0,ga:goal6Completions>0",
                        fetch.by      = "month",
                        samplingLevel =  "HIGHER_PRECISION",
                        #max.results   = 10000,
                        token = rga_auth)

users_path<- get_ga("ga:186429948",
                    start.date = this_week(last_date)$start,
                    end.date      = this_week(last_date)$end,
                    dimensions  = "ga:pagePath",
                    metrics     = "ga:users",
                    #filters     = "ga:pagePath=@obzor-tovarov.pro",
                    segment    = "users::condition::ga:sessions>0;sessions::sequence::ga:pagePath=@obzor-tovarov.pro;->>ga:pagePath=@garlyn.ru,ga:pagePath=@bist.ru,ga:pagePath=@mirandi.ru;->>ga:goal8Completions>0",
                    fetch.by      = "month",
                    samplingLevel =  "HIGHER_PRECISION",
                    #max.results   = 10000,
                    token = rga_auth)


for (i in 1:nrow(reytings_path))  {
  reytings_path$pagePath1[i]<-strsplit(reytings_path$pagePath[i],"?",fixed = TRUE)}


for (i in 1:nrow(reytings_path))  {
  reytings_path$pagePath2[i]<-c(reytings_path$pagePath1[[i]][1])}



library(dplyr)

reytings_path<-reytings_path%>%group_by(pagePath2)%>%
  summarise(
    users=sum(as.numeric(users)))


for (i in 1:nrow(promo_path))  {
  promo_path$pagePath1[i]<-strsplit(promo_path$pagePath[i],"?",fixed = TRUE)}


for (i in 1:nrow(promo_path))  {
  promo_path$pagePath2[i]<-c(promo_path$pagePath1[[i]][1])}



library(dplyr)

promo_path<-promo_path%>%group_by(pagePath2)%>%
  summarise(
    users=sum(as.numeric(users)))

users_path<-rbind(users_path,users_path_sks)


for (i in 1:nrow(users_path))  {
  users_path$pagePath1[i]<-strsplit(users_path$pagePath[i],"?",fixed = TRUE)}


for (i in 1:nrow(users_path))  {
  users_path$pagePath2[i]<-c(users_path$pagePath1[[i]][1])}



library(dplyr)

users_path<-users_path%>%group_by(pagePath2)%>%
  summarise(
    users=sum(as.numeric(users)))

reytings_path$week<-format(this_week(last_date)$start, "%W")
promo_path$week<-format(this_week(last_date)$start, "%W")
users_path$week<-format(this_week(last_date)$start, "%W")




library(bigrquery)

bq_auth(path = "C:/Users/User/Documents/R/new2.json")
insert_upload_job("peaceful-parity-209212",  
                  "Garlyn", 
                  #"reytings_path",
                  gsub(" ", "",paste("reytings_path_",table_suffix)),
                  #"Lidi",
                  reytings_path, 
                  "peaceful-parity-209212", 
                  create_disposition = "CREATE_IF_NEEDED",     
                  write_disposition = "WRITE_TRUNCATE")



insert_upload_job("peaceful-parity-209212",  
                  "Garlyn", 
                  #"promo_path",
                  gsub(" ", "",paste("promo_path_",table_suffix)),
                  #"Lidi",
                  promo_path, 
                  "peaceful-parity-209212", 
                  create_disposition = "CREATE_IF_NEEDED",     
                  write_disposition = "WRITE_TRUNCATE")


insert_upload_job("peaceful-parity-209212",  
                  "Garlyn", 
                  #"users_path",
                  gsub(" ", "",paste("users_path_",table_suffix)),
                  #"Lidi",
                  users_path, 
                  "peaceful-parity-209212", 
                  create_disposition = "CREATE_IF_NEEDED",     
                  write_disposition = "WRITE_TRUNCATE")
}
last_date<-today - 86400  
save(last_date, file = "Last_date.RData") 

