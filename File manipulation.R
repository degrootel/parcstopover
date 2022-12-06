remove(list=ls())		### remove all objects
detach()			### detach all objects

library(lubridate)
library(tidyverse)
library(tidyr)
library(dplyr)

Sys.setenv(TZ='US/Eastern')

PARC_SensorNodeLocations_0 <- read_csv("PARC_SensorNodeLocations_0.csv")


############## 1. Creating test.info datatable ###########################

test.prep<- PARC_SensorNodeLocations_0%>%
  filter(Type=="test") %>%
  select(c(Name,DateTime,`Battery Swap Date`,x, y))

test.prep<-as.data.frame(test.prep)

test.prep$DateTime2<-as.POSIXct(test.prep$DateTime,format= "%m/%d/%Y %I:%M:%OS %p", tz="EST")

test.prep$Bat.swap.date<-as.POSIXct(test.prep$'Battery Swap Date',"%m/%d/%Y %I:%M:%OS %p", tz="EST")

summary(test.prep)

##                -- TestId: unique identifier given to each of the unique locations where a test was conducted
test.prep$TestId<-test.prep$Name

##                -- Date: date when the specified test was conducted
test.prep$Date <- date(test.prep$DateTime2)

##                -- Start.Time: time when the specified test was started
test.prep$Start.Time <-strftime(test.prep$DateTime2, format="%H:%M:%S")

##                -- End.Time: time when the specified test was ended
test.prep$End.Time <-strftime(test.prep$Bat.swap.date, format="%H:%M:%S")

##                -- Min: 1-minute time period of the specified test

timeint<-ceiling(difftime(test.prep$Bat.swap.date,test.prep$DateTime2,units="mins"))  ##number of minute test was conducted

test.prep2<-data.frame(lapply(test.prep, rep, timeint)) ### repeat data by number of minutes test conducted

test.prep2$Min<-sequence(timeint)  ### Add sequence for number of mintutes test conducted

##                -- Hour: hour of the the specified minute of the test
test.prep2$Hour<-hour(test.prep2$DateTime2)

##                -- TestUTMx: Easting location of the specified test 
test.prep2$TestUTMx<-test.prep2$x

##                -- TestUTMy: Northing location of the specified test 
test.prep2$TestUTMy<-test.prep2$y

##                -- TagId: unique identifier of the transmitter used during the specified test
#### 1 transmitter pointing left 662D1E61
#### 2 transmitter pointing away 2A1E1907
#### 3 transmitter pointing right 55290719

test.prep2$TagId<-rep("662D1E61",nrow(test.prep2))  ### only using one transmitter for now

########### Create test.info dataset
test.info<-select(test.prep2,c(TagId,TestId,Date,Start.Time,End.Time,Min,Hour,TestUTMx,TestUTMy))

write.csv(test.info,file="TestInfo.csv")

################## 3 Creating "nodes" datatable ######################################################
nodes<- PARC_SensorNodeLocations_0%>%
  filter(Descript=="Deployed"|Descript=="fall") %>%
  select(c(Name,x, y)) %>%
  rename("NodeId" = "Name", "NodeUTMx" = "x", "NodeUTMy" = "y")

write.csv(nodes, file="Nodes.csv")

