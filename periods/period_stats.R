library(dplyr)
library(tidyr)
library(tidyr)

p10bp <- read_delim("p10bp.csv", "\t", escape_double = FALSE, trim_ws = TRUE)
d<- p10bp

getmaxval<-function(v){return(max(v))}
getmaxindex<-function(v){ return(which.max(v) )}
getmaxperiod<-function(v,p){ return(p[getmaxindex(v)]) }


## get period of the max peak
dp<-d %>% group_by(condition,sample) %>% 
 do(data.frame( 
   pAA=getmaxperiod(.$AA,.$period),
    pTT=getmaxperiod(.$TT,.$period) ,
    pCC=getmaxperiod(.$CC,.$period) ,
pGG=getmaxperiod(.$GG,.$period) ,
pWW=getmaxperiod(.$WW,.$period) ,
pSS=getmaxperiod(.$SS,.$period) ,
pRR=getmaxperiod(.$RR,.$period) ,
pYY=getmaxperiod(.$YY,.$period) ) )

dpmcmp<-dp %>% select(-sample) %>%
  gather(value=period, key=dinucleotide, -condition) %>%
  filter(!grepl("sample",dinucleotide))

dpmcmpa<-dpmcmp %>% filter(grepl("apoptotic",condition))
ANOVAapo<-aov(period~dinucleotide, data=dpmcmpa)
TukeyHSD(ANOVAapo)

dpmcmps<-dpmcmp %>% filter(grepl("shones",condition))
ANOVAshones<-aov(period~dinucleotide, data=dpmcmps)
TukeyHSD(ANOVAshones)

dpmcmpm<-dpmcmp %>% filter(grepl("conmouse",condition))
ANOVAmouse<-aov(period~dinucleotide, data=dpmcmpm)
TukeyHSD(ANOVAmouse)

std <- function(x){ sd(x)/sqrt(length(x)) }

dpsum<-dp %>% group_by(condition) %>% select(-sample) %>%
  summarize_all(list(mean,sd,std) ) %>%
  gather(value=period, key=operation, -condition ) %>% 
  filter(!grepl("fn2",operation)) %>%
  arrange(operation,condition) %>%
  mutate(operation=gsub("fn1","mean",operation)) %>%
  mutate(operation=gsub("fn3","stderr",operation)) %>%
  mutate(operation=gsub("p","period_",operation))

write.table(dpsum,file="period_stats.csv", sep="\t", row.names = FALSE)

## compute the power 
dp1<-d %>% filter(period>9.9) %>% 
  group_by(condition,sample) %>% 
  summarize(AA=sum(AA),TT=sum(TT),CC=sum(CC), GG=sum(GG),
            WW=sum(WW), SS=sum(SS), RR=sum(RR), YY=sum(YY))

dp2<-gather(dp1,value=power,key=dinucleotide, -condition, -sample)

## apply anova and multiple comparisons
################################# Apoptotic 
a<-dp2 %>% filter(condition=="apoptotic") %>%
  select(power,dinucleotide)

ap<-a %>% group_by(dinucleotide) %>% 
  summarize(powerm=mean(power),sd=sd(power), stderr=sd/sqrt(31)) %>%
  arrange(desc(powerm))

write.csv(ap,file="apoptotic_10bp_power.csv", row.names = FALSE)

ANOVA1<-aov(powerm~dinucleotide, data=a)
summary(ANOVA1)

apodi<-TukeyHSD(ANOVA1)$dinucleotide
write.csv(apodi,file="tukey_cmp_apoptotic_10bp_power.csv", row.names = FALSE)

#plot(TukeyHSD(ANOVA1), las=1)

################################# Shones
s<-dp2 %>% filter(condition=="shones") %>%
  select(power,dinucleotide)

sp<-s %>% group_by(dinucleotide) %>% 
  summarize(powerm=mean(power),sd=sd(power), stderr=sd/sqrt(31)) %>%
  arrange(desc(powerm))

write.csv(sp,file="shones_10bp_power.csv", row.names = FALSE)

ANOVA2<-aov(powerm~dinucleotide, data=s)
summary(ANOVA2)

shonesdi<-TukeyHSD(ANOVA2)$dinucleotide
write.csv(shonesdi,file="tukey_cmp_shones_10bp_power.csv", row.names = FALSE)
#plot(TukeyHSD(ANOVA2), las=1)

################################# Mousecon
m<-dp2 %>% filter(condition=="conmouse") %>%
  select(power,dinucleotide)

mp<-m %>% group_by(dinucleotide) %>% 
  summarize(powerm=mean(power),sd=sd(power), stderr=sd/sqrt(31)) %>%
  arrange(desc(powerm))

write.csv(mp,file="mousecon_10bp_power.csv", row.names = FALSE)

ANOVA3<-aov(powerm~dinucleotide, data=m)
summary(ANOVA3)

mousedi<-TukeyHSD(ANOVA3)$dinucleotide
write.csv(mousedi,file="tukey_cmp_mousecon_10bp_power.csv", row.names = FALSE)
plot(TukeyHSD(ANOVA3), las=1)
