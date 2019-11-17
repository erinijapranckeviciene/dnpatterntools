library(dplyr)
library(ggplot2)
library(tidyr)
library(readr)

######################################
## load the source data - patterns
######################################
patterns <- read_delim("patterns.csv", "\t",escape_double = FALSE, trim_ws = TRUE)
######################################
## initialize functions
######################################
source("largefunctionsforoccupancy.R")

#######################################
## start computation with pattern peaks
## select only peaks in the patterns
peaks1<-all_profiles %>%
  select(-contains("peaks")) %>%
  select(contains("WW"), contains("SS"),contains("YY"),contains("RR")) %>%
  select(-contains("sus"), -contains("res"))
peaks<-peaks1
#peaks[peaks1==-1]<-0


nrp<-dim(peaks)[1]
ncp<-dim(peaks)[2]
## Transform peak table into z-score matrix
peakmat=matrix(0, nrow=nrp, ncol=ncp )
for(i in 1:ncp ){
  pcol<-as.numeric(unlist(peaks[,i]))
  ## normalize into [0-1] interval
  ## 
  minpcol<-min(pcol)
  maxpcol<-max(pcol)
  zpcol<-(pcol-minpcol)/(maxpcol-minpcol)
#  print(i)
#  print(length(zpcol))
  peakmat[1:nrp,i] = zpcol[1:nrp]
#  print(pcol)
#  print(peakmat[1:nrp,i])
}

## originnal pattern names
pnames<- gsub("peaks.","", colnames(peaks),fixed=TRUE)
## pattern class names

## LOAD BINARY STRING SOURCE FILE into binstrings
## unzip first if from github
## occupancy binstr is a large file merged from source
## res-con.occ.binstr.csv and sus-con.occ.binstr.csv
## these two files can be imorted sepqrqtely
occupancy_binstr <- read_delim("fastabinstrings/occupancy.binstr.csv","\t", escape_double = FALSE, col_names = FALSE,trim_ws = TRUE)

## Random binstrings
resrandom <- read_delim("fastabinstrings/resrandom.binstr.csv","\t", escape_double = FALSE, col_names = FALSE,trim_ws = TRUE)
susrandom <- read_delim("fastabinstrings/susrandom.binstr.csv","\t", escape_double = FALSE, col_names = FALSE,trim_ws = TRUE)

## Filter conditions and location=Promoters
## correlation will break if there is 0 or 1 
## filter for more than 12 dinucleotide occurrence
rescon <- occupancy_binstr %>% 
  filter(X7=="res-con") %>% 
  filter(X5>12) 
suscon <- occupancy_binstr %>% 
  filter(X7=="sus-con") %>% 
  filter(X5>12)

############### compute mappings
############### Res-con
mprescon<-rescon %>% filter(location=="Promoter") 
## mapping func takes long time
resconpromot<-mappingfunc(mprescon)

mprescon<-rescon %>% filter(location=="Genebody") 
rescongenebody<-mappingfunc(mprescon)

################ Sus-con

mpsuscon<-suscon %>% filter(location=="Promoter") 
susconpromot<-mappingfunc(mpsuscon)

mpsuscon<-suscon %>% filter(location=="Genebody") 
suscongenebody<-mappingfunc(mpsuscon)

#### Process random binstrings if needed
## create accuracy and organism or location column
#resrand<-accuracylocationrand(resrandom,25,"res") %>% 
#  filter(X5>12) %>%
#  sample_n(size=20000)

## Map the patterns
#resrandmap<-mappingfunc(resrand,25)
## Takes long time

#susrand<-accuracylocationrand(susrandom,25,"sus") %>% 
#  filter(X5>12) 

## Map the patterns
## susrandmap<-mappingfunc(susrand,25)
## Takes long time

#sus3<-susrandmap %>%
# mutate(mclass="Random +1") %>%
#  select(mc,pattern,mclass)

sus1<-susconpromot %>% select(mc,pattern,mclass=location)
sus2<-suscongenebody %>% select(mc,pattern,mclass=location)
suspat13<-bind_rows(sus1,sus2) %>% 
  mutate(condition="sus")

## Sus tables
##100*(table(sus3$pattern)/sum(table(sus3$pattern)))
100*(table(sus1$pattern)/sum(table(sus1$pattern)))
100*(table(sus2$pattern)/sum(table(sus2$pattern)))

#####################################################
#res3<-resrandmap %>%
#  mutate(mclass="Random +1") %>%
#  select(mc,pattern,mclass)

res1<-resconpromot %>% select(mc,pattern,mclass=location)
res2<-rescongenebody %>% select(mc,pattern,mclass=location)
respat13<-bind_rows(res1,res2) %>% 
  mutate(condition="res")

## Res tables
## 100*(table(res3$pattern)/sum(table(res3$pattern)))
100*(table(res1$pattern)/sum(table(res1$pattern)))
100*(table(res2$pattern)/sum(table(res2$pattern)))

############ Graphics
g<-bind_rows(respat13,suspat13)


######## Plot correlations for each pattern 
## for(p in c("YY1", "YY2","RR1","RR2","WW1","WW2","SS1","SS2") )
for(p in c("SS2") )
{  
pt<-g %>% filter(grepl(p, pattern)) 
gp<-ggplot(pt, aes(mc,color=mclass))+
  stat_ecdf(geom="step")+
  facet_wrap(~condition+pattern) + xlab("PearsonCC")
#ggsave(filename=paste0(p,".png"),plot=gp,device="png",width=510,height=267, units="mm")
gp
}

