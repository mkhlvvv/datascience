library("RGA"


rga_auth <- authorize(client.id = "680348893674-74hji9v9jrls5oo1unap7kujg5jojb3q.apps.googleusercontent.com", client.secret = "jGsz-86u5sp2O54IChqV3bMo")

ga_data_ass1 <- get_mcf("ga:186429948",
                        start.date = last_date2,
                        end.date      = last_date2,
                        dimensions  = "mcf:sourceMedium, mcf:campaignName,mcf:adwordsCampaignID",
                        metrics     = "mcf:assistedConversions,mcf:lastInteractionConversions,mcf:firstInteractionConversions",
                        filters     = "mcf:conversionGoalNumber==006,mcf:conversionGoalNumber==005;mcf:pathLengthInInteractionsHistogram == 000001",
                        # fetch.by      = "day",
                        samplingLevel =  "HIGHER_PRECISION",
                        max.results   = 10000,
                        token = rga_auth)

ga_data_ass2 <- get_mcf("ga:186429948",
                        start.date = last_date2,
                        end.date      = last_date2,
                        dimensions  = "mcf:sourceMedium, mcf:campaignName,mcf:adwordsCampaignID",
                        metrics     = "mcf:assistedConversions,mcf:lastInteractionConversions,mcf:firstInteractionConversions",
                        filters     = "mcf:conversionGoalNumber==006,mcf:conversionGoalNumber==005;mcf:pathLengthInInteractionsHistogram != 000001",
                        # fetch.by      = "day",
                        samplingLevel =  "HIGHER_PRECISION",
                        max.results   = 10000,
                        token = rga_auth)
#ga_data_ass3 <- get_mcf("ga:192732068",
#                       start.date = last_date2,
#                      end.date      = last_date2,
#                     dimensions  = "mcf:sourceMedium, mcf:campaignName,mcf:adwordsCampaignID",
#                    metrics     = "mcf:assistedConversions,mcf:lastInteractionConversions,mcf:firstInteractionConversions",
#                   filters     = "mcf:conversionGoalNumber==009,mcf:conversionGoalNumber==012,mcf:conversionGoalNumber==013;mcf:pathLengthInInteractionsHistogram == 000001",
#                # fetch.by      = "day",
#                  samplingLevel =  "HIGHER_PRECISION",
#                max.results   = 10000,
#                token = rga_auth)
#ga_data_ass4 <- get_mcf("ga:192732068",
#                      start.date = last_date2,
#                      end.date      = last_date2,
#                     dimensions  = "mcf:sourceMedium, mcf:campaignName,mcf:adwordsCampaignID",
#                    metrics     = "mcf:assistedConversions,mcf:lastInteractionConversions,mcf:firstInteractionConversions",
#                   filters     = "mcf:conversionGoalNumber==009,mcf:conversionGoalNumber==012,mcf:conversionGoalNumber==013;mcf:pathLengthInInteractionsHistogram != 000001",
#                  # fetch.by      = "day",
#                 samplingLevel =  "HIGHER_PRECISION",
#        max.results   = 10000,
#               token = rga_auth)
ga_data_ass1$firstInteractionConversions<-"0"
ga_data_ass1$Conversion <- ga_data_ass1$lastInteractionConversions
ga_data_ass2$Conversion <- ga_data_ass2$lastInteractionConversions*0.4+ga_data_ass2$firstInteractionConversions*0.4+ga_data_ass2$assistedConversions*0.2
#ga_data_ass3$firstInteractionConversions<-"0"
#ga_data_ass3$Conversion <- ga_data_ass3$lastInteractionConversions
#ga_data_ass4$Conversion <- ga_data_ass4$lastInteractionConversions*0.4+ga_data_ass4$firstInteractionConversions*0.4+ga_data_ass4$assistedConversions*0.2
ga_data_ass<-rbind(ga_data_ass1,ga_data_ass2)#,ga_data_ass3,ga_data_ass4)
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


names(ga_data_ass)[3]<-"campaign_id"
ga_data_ass$Date<-last_date
ga_data_ass7<-merge(ga_data_ass,campaing, by.x="campaign_id", by.y ="id" )
ga_data_ass7<-ga_data_ass7[ ,-3]
names(ga_data_ass7)[8]<-"campaignName"
ga_data_ass<-ga_data_ass[ga_data_ass$sourceMedium !="mytarget / cpc", ]
ga_data_ass<- rbind(ga_data_ass,ga_data_ass7)


