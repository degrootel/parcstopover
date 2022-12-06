
library(data.table)
setwd("C:/Users/degrootel/Downloads/")

#from download
dt = fread("CTT-CB9A196520E9-raw-data.2022-08-18_192643.csv.gz")
nh = fread("CTT-CB9A196520E9-node-health.2022-08-18_192644.csv.gz")

names(nh)


#view(dt)
view(nh)

dt %>%
  group_by(NodeId) %>%
  summarize(count = n())


Node1<-subset(nh,NodeId=="365747")

view(Node1)
#from api

dt2 = fread("C:/Users/degrootel/Documents/Parc Stopover/data/PARC Stopover/CB9A196520E9/raw/CTT-CB9A196520E9-raw-data.2021-10-01_105316.csv.gz")

nh=fread("C:/Users/degrootel/Documents/Parc Stopover/data/New England C-SWG Motus/0F47E1B82263/node_health/CTT-0F47E1B82263-node-health.2022-02-24_043049.csv.gz")

view(nh)



