library(dplyr)
library(tidyr)
library(zoo)
library(ggpubr)
library(ggplot2)

## Load data computed in Galaxy for visualization
library(readr)

## Apoptotic data
apo_cor <- read_delim("apo-cor.csv", "\t",escape_double = FALSE, trim_ws = TRUE)
apo_ft <- read_delim("apo-ft.csv", "\t",escape_double = FALSE, trim_ws = TRUE)
apo_orig <- read_delim("apo-orig.csv", "\t",escape_double = FALSE, trim_ws = TRUE)
apo_pat <- read_delim("apo-pat.csv", "\t",escape_double = FALSE, trim_ws = TRUE)

### CD4+ data
cd4_cor <- read_delim("cd4-cor.csv", "\t",escape_double = FALSE, trim_ws = TRUE)
cd4_ft <- read_delim("cd4-ft.csv", "\t",escape_double = FALSE, trim_ws = TRUE)
cd4_pat <- read_delim("cd4-pat.csv", "\t",escape_double = FALSE, trim_ws = TRUE)
cd4_orig <- read_delim("cd4-orig.csv", "\t",escape_double = FALSE, trim_ws = TRUE)

### Mouse data
mouse_corr <- read_delim("mouse-corr.csv","\t", escape_double = FALSE, trim_ws = TRUE)
mouse_ft <- read_delim("mouse-ft.csv", "\t",escape_double = FALSE, trim_ws = TRUE)
mouse_orig <- read_delim("mouse-orig.csv","\t", escape_double = FALSE, trim_ws = TRUE)
mouse_pat <- read_delim("mouse-pat.csv","\t", escape_double = FALSE, trim_ws = TRUE)

#################################### Plot original dinucleotide profiles 
## Aggregate original profiles
## Select dinucleotides

di=c("AA","TT","AT","CC","GG","GC")
f<-paste0(di,".f")
r<-paste0(di,".r")

apo_orig1 <- apo_orig %>% 
  select(c(f,r)) %>%
  mutate(pos=1:n()) %>%
  mutate(Cells="Apoptotic")

mouse_orig1 <- mouse_orig %>% 
  select(c(f,r)) %>%
  mutate(pos=1:n()) %>%
  mutate(Cells="Mouse")

cd4_orig1 <- cd4_orig %>% 
  select(c(f,r)) %>%
  mutate(pos=1:n()) %>%
  mutate(Cells="CD4+")

original<-bind_rows(apo_orig1,mouse_orig1,cd4_orig1)  %>%
  gather(value="relfreq", key="Pattern", -Cells, -pos)

poriginal<-ggplot(original,aes(x=pos, y=relfreq, colour=Pattern))+
  facet_wrap(~Cells, nrow=1,ncol=3, scales = "free") +
  geom_line()+
  xlab("Position in sequence")+ 
  ylab("Relative frequency") + 
  labs(title="Dinucleotide frequency profiles", 
       subtitle="from a batch of nucleosome sequences")

########################################################################
## Plot correlation profiles in different plots and combine these two plots
########################################################################

## Select dinucleotides
di=c("AA","TT","AT","CC","GG","GC")

apo_cor1 <- apo_cor %>% 
  select(di)  %>% 
  mutate(pos=1:n()) %>%
  mutate(Cells="Apoptotic")

mouse_cor1 <- mouse_corr %>% 
  select(di) %>%
  mutate(pos=1:n()) %>%
  mutate(Cells="Mouse")

cd4_cor1 <- cd4_cor %>% 
  select(di) %>%
  mutate(pos=1:n()) %>%
  mutate(Cells="CD4+")

correlations<-bind_rows(apo_cor1,mouse_cor1,cd4_cor1)  %>%
  gather(value="pearsoncc", key="Dinucleotide", -Cells, -pos)


dataPos <- correlations %>%
  group_by(Cells) %>%
  summarize(MaxPos = which.max(pearsoncc) ) %>% 
  mutate(MaxPos=ifelse(Cells=="Apoptotic",109,ifelse(Cells=="Mouse",24,105)))

# Add position information to the plot
pcorrelations<-ggplot(correlations, aes(x=pos, y=pearsoncc, colour=Dinucleotide))+
  facet_wrap(~Cells, nrow=1,ncol=3,scales="free") +
  geom_line(size=0.9)+ theme_bw()+
  geom_vline(data=filter(correlations, Cells=="Mouse"), 
             aes(xintercept=24), colour="red",size=1.7) + 
  geom_vline(data=filter(correlations, Cells=="Apoptotic"), 
             aes(xintercept=109), colour="red",size=1.7) + 
  geom_vline(data=filter(correlations, Cells=="CD4+"), 
             aes(xintercept=105), colour="red",size=1.7) + 
  xlab("Position in sequence")+ 
  ylab("Pearson correlation coeff") + 
  labs(title="Correlations of fw and rc frequency profiles", 
       subtitle="Within 146 bp sliding window")

## Stack the plots
ocplot<-ggarrange(poriginal, pcorrelations, 
labels = c("A", "B"),
ncol = 1, nrow = 2)

################################################################
## Pattern and Periodogram Plots
################################################################

pattern_table<-function(data,dinuc,patternname){
  a<-data %>% select(pos,dinuc) %>% 
    gather(value=relfreq, key=Di, -pos) %>%
    mutate(Pattern=patternname)
  return(a)
}

## Make table for all, but plot only portions 
di=c("AA","TT","CC","GG","WW","SS","RR","YY")
##
a<-pattern_table(apo_pat,di,"Apoptotic")
m<-pattern_table(mouse_pat,di,"Mouse")
cd<-pattern_table(cd4_pat,di,"CD4+")

pattern_data<-bind_rows(a,m,cd)


ft_table<-function(data,dinuc,patternname){
a<-data %>% filter(period<=20) %>% filter(period>=3) %>% 
  select(period,dinuc) %>% gather(value=relfreq, key=di, -period) %>%
  mutate(Pattern=paste(patternname,di,sep="."))
return(a)
}

## Make table for all, but plot only portions 
##
di=c("AA","TT","CC","GG","WW","SS","RR","YY")
##
a<-ft_table(apo_ft,di,"Apoptotic")
m<-ft_table(mouse_ft,di,"Mouse")
cd<-ft_table(cd4_ft,di,"CD4+")

ft_data<-bind_rows(a,m,cd)


## Here function to generate combined plots 
pattern_and_ft_plot<-function(ft_data_selected, pattern_data_selected, pat_plot_title){

  ft_plot<-ggplot(data=ft_data_selected, aes(x=period,y=relfreq, colour=Pattern))+
  geom_line(size=1)+theme_bw()+facet_wrap(~Pattern,ncol=2,nrow=3)+
  labs(title="Pattern periodograms", 
       subtitle="Human and mouse cells")+
  ylab("Spectral power") +
  xlab("Period bp")

pat_plot <- ggplot(data=pattern_data_selected, 
                   aes(x=pos,y=relfreq, colour=Di))+
  facet_wrap(~Pattern,ncol=1,nrow = 3, scales="free")+
  geom_line(size=1.2)+theme_bw()+
  labs(title=pat_plot_title, 
       subtitle="Dinucleotide frequency distribution in human and mouse cells")+
  ylab("Relative frequency of dinucleotides") +
  xlab("Nucleosome position relative to the dyad center")

## combine plots
cp<-ggarrange(pat_plot, ft_plot, ncol = 2, nrow = 1, widths=c(1,1.5))
return(cp)
}

#### Summary on peaks around 10bp

psum<-function(ft_data_selected){
  p<- ft_data_selected %>%
    filter( (period >=9.5) & (period<=10.5) ) %>%
    group_by(Pattern) %>% summarize(pi=which.max(relfreq), 
                                    per=period[pi],
                                    val=relfreq[pi])
  return(p)
}

psumft<-psum(ft_data) %>% data.frame()
write.table(as.data.frame(psumft),file="psumft.csv", 
            sep="\tab",quote=FALSE, 
            row.names = FALSE,
            col.names = TRUE)

### end of summary

################# This section to generate the plots for selected dinuc
## ggplot only selected
## AA TT
ft_data_selected <- ft_data %>% filter((di=="AA") |(di=="TT"))
pattern_data_selected <-pattern_data %>%  filter((Di=="AA") | (Di=="TT"))
cplot_aatt<-pattern_and_ft_plot(ft_data_selected, pattern_data_selected,"AA/TT Patterns")


## CC GG
ft_data_selected <- ft_data %>% filter((di=="CC") |(di=="GG"))
pattern_data_selected <-pattern_data %>%  filter((Di=="CC") | (Di=="GG"))
cplot_ccgg<-pattern_and_ft_plot(ft_data_selected, pattern_data_selected,"CC/GG Patterns")


## WW
ft_data_selected <- ft_data %>% filter((di=="WW") )
pattern_data_selected <-pattern_data %>%  filter((Di=="WW") )
cplot_ww<-pattern_and_ft_plot(ft_data_selected, pattern_data_selected,"WW Patterns")

## SS
ft_data_selected <- ft_data %>% filter( (di=="SS"))
pattern_data_selected <-pattern_data %>%  filter(  (Di=="SS"))
cplot_ss<-pattern_and_ft_plot(ft_data_selected, pattern_data_selected,"SS Patterns")


## WW SS
ft_data_selected <- ft_data %>% filter((di=="WW") |(di=="SS"))
pattern_data_selected <-pattern_data %>%  filter((Di=="WW") | (Di=="SS"))
cplot_wwss<-pattern_and_ft_plot(ft_data_selected, pattern_data_selected,"WW/SS Patterns")



## RR YY
ft_data_selected <- ft_data %>% filter((di=="RR") |(di=="YY"))
pattern_data_selected <-pattern_data %>%  filter((Di=="RR") | (Di=="YY"))
cplot_rryy<-pattern_and_ft_plot(ft_data_selected, pattern_data_selected,"RR/YY Patterns")


################################################################
## ggsave all Figures
###############################################################
swidth=12
sheight=8
sunits="in"
## Save the plot / export from environment
ggsave("OCcombined.png", plot = ocplot, device = "png",
       scale = 1, width = swidth, height = sheight, units=sunits, dpi = 300, limitsize = FALSE)

ggsave("pftAATT.png", plot = cplot_aatt, device = "png",
       scale = 1, width = swidth, height = sheight, units=sunits, dpi = 300, limitsize = FALSE)

ggsave("pftCCGG.png", plot = cplot_ccgg, device = "png",
       scale = 1, width = swidth, height = sheight, units=sunits, dpi = 300, limitsize = FALSE)

ggsave("pftWW.png", plot = cplot_ww, device = "png",
       scale = 1,width = swidth, height = sheight, units=sunits, dpi = 300, limitsize = FALSE)

ggsave("pftSS.png", plot = cplot_ss, device = "png",
       scale = 1, width = swidth, height = sheight, units=sunits, dpi = 300, limitsize = FALSE)

ggsave("pftWWSS.png", plot = cplot_wwss, device = "png",
       scale = 1, width = swidth, height = sheight, units=sunits, dpi = 300, limitsize = FALSE)

ggsave("pftRRYY.png", plot = cplot_rryy, device = "png",
       scale = 1, width = swidth, height = sheight, units=sunits, dpi = 300, limitsize = FALSE)
