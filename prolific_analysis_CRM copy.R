##### COMPUTE THE SNR AS THE MEAN OVER BLOCKS OF THE LAST 4 REVERSALS
##### Roberta Bianco 2021 _ UCL , London
#### load
ls()
rm(list=ls())
dir = "/DATAprolific/"          # input dir
dirout = "/RESULTS/"            # output dir
s=10 ### font size for plots
setwd(dir) # set directory

codes <- c("9sri")  ## V8 had vabr for no bonus, but I manually changed the name of the csv file 
list_of_files <- list.files(recursive = TRUE, pattern = "\\.csv", full.names = TRUE)
list_of_files
tasks <- c()

for (i in 1:length(codes)){
  task <- grep(codes[i], list_of_files, value=TRUE, fixed=TRUE)
  tasks <- append(tasks, task, after=length(tasks))
}
alldat = ldply(tasks, read_csv)
dat = alldat

colnames(dat)[colnames(dat)=="Participant Public ID"] <- "subj"

#### select columns 
summary(dat)
table(dat$subj); dat$subj=as.factor(dat$subj)
length(unique(dat$subj))  
colnames(dat)
dat=dat[, which(colnames(dat) %in% c("subj",  "Event Index","Tree Node Key", "SNR (dB)", "Iteration" , "Correct", "Response",   "Masker" , "Target"))]
head(dat)
colnames(dat)[colnames(dat)=="Event Index"] <- "index"; dat$index=as.numeric(dat$index)
colnames(dat)[colnames(dat)=="SNR (dB)"] <- "SNR"
colnames(dat)[colnames(dat)=="Tree Node Key"] <- "group"

#### compute SNR based on last 4 reversals
nrev = 4 ### take last 4 reversal values
dat = dat[!is.na(dat$subj),]
summary(dat)
subjname=unique(dat$subj)
length(unique(dat$subj))
df=NULL
df2 <- data.frame(subj=factor(),
                 meanSNR=integer(), 
                 iteration=factor(), 
                 tNum=integer(),
                 n20db=integer(),
                 group=factor(),
                 stringsAsFactors=FALSE) 
for (s in 1:length(subjname)){
  df=NULL
  for (b in 1:4){
    t=dat[dat$subj==subjname[s] & dat$Iteration==b,]
    t$tNum=1:nrow(t)
    t$n20db=ifelse(t$SNR==20, 1, 0); n20db=sum(t$n20db) ###fix glitch of refresh page in Gorilla, that makes the block start over
    sum= sum(t$n20db) ### sum of occurrances of 20dB
    if (sum >1){
      last20db=tail(which(t$SNR==20), n=1) ###find the last 20db in the block
      t=t[last20db:nrow(t),]
      t$tNum=1:nrow(t)
      print('there was a glitch')
    }
    tNum=dim(t)[1]
    rev=diff(t$SNR); 
    subj = as.character(t$subj[1])
    idxrev=c(which(abs(diff(sign(rev)))==2)+1, dim(t)[1])  ### find idx of reversal and add the last one
    SNR= mean(t$SNR[tail(idxrev, n=nrev)])   ### take last 4 SNR associated with reversal indexes and do the mean
    SNR
    df=rbind(df, data.frame(subj, SNR, b, tNum, n20db))  ### store in dataframe
  }
  df2 = rbind(df2,df)
}
length(unique(df2$subj))
summary(df2)


df2$b=as.factor(df2$b)
cdat <- ddply(df2, "b", summarise, SNR.mean=mean(SNR))
cdat
ggplot(df2, aes(x=SNR, fill=b)) +
  geom_histogram(binwidth=1,aes(y = ..density..), alpha=.5, position="identity") +
  geom_vline(data=cdat, aes(xintercept=SNR.mean,  colour=b),
             linetype="dashed", size=1) #+scale_y_continuous(labels = percent_format()) 

agg<- with(table, aggregate(cbind(SNR) ~ subj, FUN="mean"))  #get mean of STEP condition per block per subject
write.table(table, file=paste0(dirout, "prolific_CRM_byblocks.csv"), row.names=F, col.names=T, sep=",") 
write.table(agg, file=paste0(dirout, "prolific_CRM.csv"), row.names=F, col.names=T, sep=",") 




