## Large Functions

############################################
## function to arrange a vector into matrix 
## in which a second row is shifted by one 
## position to the right
##   1234
##   2345 ...
arrangev <- function(v,m){
  ## v -vector of numbers to arrange
  ## m - number of columns in a row
  ############################################
  if(m>length(v)){ 
    print("bad m")
    return(-1) }
  nr<-length(v)-m+1
  nc<-m
  vmat<-matrix(0, nrow=nr, ncol=nc)
  for(i in 1:nr){
    vrow<-v[i:(i+m-1)]
    vmat[i,]<-vrow
  }
  return(vmat)
}


## function to compute mappings
mappingfunc<-function(mp, trueposition){
  mappings<-mp %>% 
    select(X1, X2, X3, X7, location, accuracy) %>% 
    rowwise() %>% 
    do(data.frame(mappos(bs=.$X1, 
                         di=.$X2,
                         condition=.$X7,
                         seqname=.$X3, 
                         location=.$location, 
                         accuracyexp=.$accuracy,
                         truepos=trueposition)))
  
  
  
  mappings1<-onemaxcorrelation(mappings) %>% rowwise() %>%
    mutate( pattern=pattab[paste(pnames)])
  
  return(mappings1)
}

## Assign pattern groups
pattab<-c("SS2","SS1","SS1","SS2","WW2","WW1","WW1","WW2","YY2","YY1","YY1","YY2","RR2","RR1","RR1","RR2")

names(pattab)<-c("apo.SS","cd4.SS","con.SS","yeast.SS","apo.WW","cd4.WW","con.WW","yeast.WW",
                 "apo.YY","cd4.YY","con.YY","yeast.YY","apo.RR","cd4.RR","con.RR","yeast.RR")

###################################################
## for each sequence - one max correlation 
###################################################
onemaxcorrelation<-function(mappingdat){
  mappingdat1 <- mappingdat %>% 
    group_by(sname) %>% 
    summarize(mc=max(mmax), 
              mdi=dinuc[which.max(mmax)],
              mac=accuracy[which.max(mmax)],
              pnames=pnames[which.max(mmax)],
              condition=condition[which.max(mmax)],
              location=location[which.max(mmax)])
}



####################################
## function to match peak pattern
## to the dinucleotide 
mappos<-function(bs, di, condition, seqname, location, accuracyexp, truepos){
  ## bs - binary string
  ## di - dinucleotide
  ## seqname - nucleosome sequence name
  ## organism from seqname
  ###################################
  
  ## transform binary string into numeric vector
  t<-as.numeric(unlist(strsplit(unlist(bs),split="")) )
  
  ## arrange a numeri vector into a matrix
  ## in which number of ocolumns has a length
  ## and each subsequent row is shifted
  ## by one position, so that each row corresponds
  ## to a position in a nucleosomal sequence
  tmat<-arrangev(t,142)
  
  ## compute a dot product between the binary 
  ## dinucleotide representation in the matrix
  ## and peak distribution in the patterns
  ## each column in this matrix represents a pattern
  ## each row represents a position and
  ## in each cell there is a number of matches between 
  ## dinucleotide distribution in a nucleosomal sequece
  ## and the peak distribution in a pattern
  ##
  #  dotprod<-tmat  %*% peakmat
  
  ## or correlation matrix
  dotprod<-cor(t(tmat),peakmat)
  dim(tmat)
  dim(peakmat)
  dim(dotprod)
  
 # head(dotprod)
  
  ## find maximum matches in each column
  mmax<-apply(dotprod,2,max)
  ## find in which row/position was a maximum match
  mmaxpos<-apply(dotprod,2,which.max)
  
  ## in the occupancy sequences the start position is 
  ## about 20 bp from the sequence start
  
  ## which of the positions with max matches between
  ## dinucleotides in nucleosomal sequence
  ## and peak distribution in pattern
  accuracy<-(mmaxpos-truepos)
  condition<-rep(paste0(condition),length(accuracy))
  sname<-rep(paste0(seqname),length(accuracy))
  dinuc<-rep(paste0(di),length(accuracy))
  location<-rep(paste0(location),length(accuracy))
  ## for each pattern return the best mapping result
  ## for the particular sequence 
  mm<-data.frame(sname,dinuc,condition, accuracy,mmaxpos,mmax,pnames,location, accuracyexp) %>%
    filter(abs(accuracy)< accuracyexp+1)
  ##minp<-which.min(abs(mmaxpos-127))
  ##minv<-min(abs(mmaxpos-127))
  ##simv<-mmax[minp]
  ##patt<-pnames[minp]
  ##retv<-c(minp,minv,simv,patt)
  #return(retv)
  return(mm)
}

### ACCURACY LOCATION FOR OCCUPANCY DATA  
accuracylocationocc<-function(binstr){
  binstr1<- binstr %>%
    mutate(sname=X3) %>%
    mutate(accuracy=20 ) %>%
    mutate(location=case_when(grepl("Promot", sname) ~ "Promoter",
                              grepl("Genebody",sname) ~ "Genebody",
                              grepl("desert",sname) ~ "Genedesert",
                              grepl("genic",sname) ~ "Otherintergenic" ) )
  return(binstr1)
}

### ACCURACY LOCATION FOR RANDOM DATA  
accuracylocationrand<-function(binstr, truepos, condition){
  binstr1<- binstr %>%
    mutate(sname=X3) %>%
    mutate(accuracy=truepos ) %>%
    mutate(location="Random" ) %>%
    mutate(X7=condition)
  return(binstr1)
}


## function assigns class name to the pattern
pclass<-function(pname){
  switch ( pname,
           "apo.SS"=return(4),
           "cd4.SS"=return(1),
           "con.SS"=return(1),
           "sus.SS"=return(1),
           "res.SS"=return(1),
           "apo.WW"=return(1),
           "cd4.WW"=return(4),
           "con.WW"=return(4),
           "sus.WW"=return(4),
           "res.WW"=return(4),
           "apo.RR"=return(3),
           "cd4.RR"=return(2),  
           "con.RR"=return(2),
           "sus.RR"=return(2),
           "res.RR"=return(2),
           "apo.YY"=return(2),
           "cd4.YY"=return(3),
           "con.YY"=return(3),
           "sus.YY"=return(3),
           "res.YY"=return(3),
           "apo.AA"=return(1),
           "cd4.AA"=return(4),
           "con.AA"=return(4),
           "sus.AA"=return(4),  
           "res.AA"=return(4),
           "apo.TT"=return(1),
           "cd4.TT"=return(4),
           "con.TT"=return(4),
           "sus.TT"=return(4),
           "res.TT"=return(4),
           "apo.CC"=return(2),
           "cd4.CC"=return(3),
           "con.CC"=return(1),
           "sus.CC"=return(1),
           "res.CC"=return(1),
           "apo.GG"=return(3),  
           "cd4.GG"=return(2),
           "con.GG"=return(1),
           "sus.GG"=return(1),
           "res.GG"=return(1),
           "yeast.RR"=return(2),
           "yeast.YY"=return(3),
           "yeast.WW"=return(1),
           "yeast.SS"=return(4)
  )
}

## function assigns class name to the pattern
pladder<-function(pname){
  switch ( pname,
           "apo.SS"=return("SS2"),
           "cd4.SS"=return("SS1"),
           "con.SS"=return("SS1"),
           "sus.SS"=return("SS1"),
           "res.SS"=return("SS1"),
           "apo.WW"=return("WW2"),
           "cd4.WW"=return("WW1"),
           "con.WW"=return("WW1"),
           "sus.WW"=return("WW1"),
           "res.WW"=return("WW1"),
           "apo.RR"=return("RR2"),
           "cd4.RR"=return("RR1"),  
           "con.RR"=return("RR1"),
           "sus.RR"=return("RR1"),
           "res.RR"=return("RR1"),
           "apo.YY"=return("YY2"),
           "cd4.YY"=return("YY1"),
           "con.YY"=return("YY1"),
           "sus.YY"=return("YY1"),
           "res.YY"=return("YY1"),
           "yeast.RR"=return("RR1"),
           "yeast.YY"=return("YY1"),
           "yeast.WW"=return("WW2"),
           "yeast.SS"=return("SS2"),
           return("NA")
  )
}


mappingsreduced<- function(mappings, accuracyval){
  mr<-mappings %>% filter(abs(accuracy) < accuracyval ) %>% 
    arrange(sname, organism, desc(mmax) , accuracy ) %>% 
#    filter(mmax>4) %>% 
    mutate(pnames=gsub("peaks.","",pnames, fixed=TRUE)) %>%
    rowwise() %>%
    mutate(class=pclass(pnames), ladder=pladder(pnames)) %>% 
    group_by(sname) %>% 
    summarise( di=paste(dinuc, sep=",", collapse=","), 
               mmaxmatch=paste(mmax, sep=",",collapse=","), 
               accuracy=paste(accuracy, sep=",",collapse=","),
               class=paste(class, sep=",",collapse=","),
               ladder=paste(ladder, sep=",",collapse=","),
               patterns=paste(pnames, sep=",", collapse=","), 
               organism=paste(unique(organism)), n=n() )
  return(mr)
}

mpsummary<-function(mp){
  mpreturn<-mp %>%
    group_by(organism) %>%
    summarise( nseq=n(),
               inseqmatches=paste(n, sep=",",collapse=","),
               mmaxmatch=paste(mmaxmatch, sep=",",collapse=","),
               class=paste(class, sep=",",collapse=","),
               ladder=paste(ladder, sep=",",collapse=","),
               di=paste(di, sep=",", collapse=",")
    )
  return(mpreturn)
}


## create tables to summarize prevalences
prevalence<-function(valvect,field){
  t<-table(strsplit(unlist(valvect),split=","))
  return(t[field])
}

mpprevalence<-function(mpsummary){
  mpp<-mpsummary %>%
    rowwise() %>%
    mutate(Class1=prevalence(class,1)) %>%
    mutate(Class2=prevalence(class,2)) %>%
    mutate(Class3=prevalence(class,3)) %>%
    mutate(Class4=prevalence(class,4)) %>%
    mutate(WW1=prevalence(ladder,"WW1")) %>%
    mutate(WW2=prevalence(ladder,"WW2")) %>%
    mutate(SS1=prevalence(ladder,"SS1")) %>%
    mutate(SS2=prevalence(ladder,"SS2")) %>%
    mutate(RR1=prevalence(ladder,"RR1")) %>%
    mutate(RR2=prevalence(ladder,"RR2")) %>%
    mutate(YY1=prevalence(ladder,"YY1")) %>%
    mutate(YY2=prevalence(ladder,"YY2"))
  return(mpp)
}


## clean
cleanmp<-function(mpprev,accur){
  mpc<-mpprev %>% 
    select(organism,nseq,di,WW1,WW2,SS1,SS2,RR1,RR2,YY1,YY2) %>%
    mutate(matchinseq=sum(WW1,WW2,SS1,SS2,RR1,RR2,YY1,YY2, na.rm=TRUE)) %>%
    mutate(WW1p=ifelse(is.na(WW1),0,round(100*(WW1/matchinseq), digits=2) ) ) %>%
    mutate(WW2p=ifelse(is.na(WW2),0,round(100*(WW2/matchinseq), digits=2) ) ) %>%
    mutate(SS1p=ifelse(is.na(SS1),0,round(100*(SS1/matchinseq), digits=2) ) ) %>%
    mutate(SS2p=ifelse(is.na(SS2),0,round(100*(SS2/matchinseq), digits=2) ) ) %>%
    mutate(RR1p=ifelse(is.na(RR1),0,round(100*(RR1/matchinseq), digits=2) ) ) %>%
    mutate(RR2p=ifelse(is.na(RR2),0,round(100*(RR2/matchinseq), digits=2) ) ) %>%
    mutate(YY1p=ifelse(is.na(YY1),0,round(100*(YY1/matchinseq), digits=2) ) ) %>%
    mutate(YY2p=ifelse(is.na(YY2),0,round(100*(YY2/matchinseq), digits=2) ) ) %>%
    mutate(accuracy=accur)
}
