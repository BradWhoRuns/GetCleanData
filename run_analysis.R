## This is my run_analysis.R file for the Getting & Cleaning Data course.

## First, let's load dplyr and tidyr (just in case it isn't already)
## As 'require' was designed to work within other functions
## I'll use it instead of 'library'.


    if({require(dplyr)==FALSE}){ require(dplyr, quietly = TRUE)} ## If dplyr and/or tidyr 
    if({require(tidyr)==FALSE}){ require(tidyr, quietly = TRUE)} ## aren't installed, these
                                                                 ## will kick an error message
                                                                 ## prompting the user to install them.
    
## The variable names given by the original researchers
## are in the text file called features.  I'll use those
## 

ActivityVector<-c("Walking", "Walking Up Stairs", "Walking Down Stairs",
                  "Sitting", "Standing", "Laying")    
        
VarNames<-read.table("UCI HAR Dataset/features.txt")
    
    
## Let's start compiling the data

## The following lines read in the datasets
## and attach the subject Id numbers then attach the activity type
## to each row
    

TestFile<-tbl_df(read.table("UCI HAR Dataset/test/X_test.txt"))
  colnames(TestFile)<-make.names(VarNames$V2, unique=TRUE)
  sub_num<-tbl_df(read.table("UCI HAR Dataset/test/subject_test.txt"))
  TestFile["Subj_ID_number"]<-sub_num$V1
    activity_num<-tbl_df(read.table("UCI HAR Dataset/test/y_test.txt"))
    TestFile["Activity"]<-activity_num$V1
      TestFile<-mutate(TestFile, Activity = ActivityVector[Activity])

TrainFile<-tbl_df(read.table("UCI HAR Dataset/train/X_train.txt"))   
  colnames(TrainFile)<-make.names(VarNames$V2, unique=TRUE)
  sub_num<-tbl_df(read.table("UCI HAR Dataset/train/subject_train.txt"))
  TrainFile["Subj_ID_number"]<-sub_num$V1
    activity_num<-tbl_df(read.table("UCI HAR Dataset/train/y_train.txt"))
    TrainFile["Activity"]<-activity_num$V1
      TrainFile<-mutate(TrainFile, Activity = ActivityVector[Activity])

## Next, we collect ONLY the columns we want, putting subject Id first and activity second

TestFile <-select( TestFile, Subj_ID_number, Activity, contains("mean"), contains("std"), -contains("Freq"))
TrainFile<-select(TrainFile, Subj_ID_number, Activity, contains("mean"), contains("std"), -contains("Freq"))


## Merge the two files now

CombinedFile<-merge(TestFile, TrainFile, all=TRUE)

rm(TestFile, TrainFile, sub_num, activity_num)  ## We don't need these variables anymore

## This next bit of code builds the second, independent tidy data set we
## were told to build.


PenultimateFile<-as.data.frame(c())  ## Start with an empty dataframe
newrow<-c()                          ## and an empty row

## For each of the 30 id numbers and each of the 6 activities
## form the corresponding subset and find the average of each
## of the 86 variables that have mean or std as part of their
## names.  Save this as a vector, and use rbind to attach this
## new row to the previous stage of the file.
    

for(i in 1:30){ 
  for(j in ActivityVector){ 
    for(k in 1:73) {
        workingsubset<-subset(CombinedFile, Subj_ID_number==i & Activity == j)
        newrow[k]<-mean(workingsubset[, k+2], na.rm=TRUE)  
    }
    PenultimateFile<-rbind(PenultimateFile,newrow)
    
      }
}

## PenultimateFile lacks the column names, the subject id and the activity
## names.  We form UltimateFile by adding those columns to the beginning of
## PenultimateFile and attaching the column names from CombinedFile.

UltimateFile<-cbind(rep(1:30, each = 6), ActivityVector, PenultimateFile)
colnames(UltimateFile)<-colnames(CombinedFile)

## This is the file we want, we use write.table to save it to our working directory

write.table(UltimateFile, file="GetCleanDataProjectFile.txt", row.names=FALSE)

## Note to per evaluators: I'm well aware that this code is inefficient.  I'm not 
## a particularly talented programmer.  If you have suggestions for optimizing this
## code, I'd love to hear them.  Thanks.  
