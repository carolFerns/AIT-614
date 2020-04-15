#Import required packages
library(ggplot2) 
library(arules)
library(readr) 
install.packages("lubridate")
library(lubridate)
library(Rserve)
Rserve()


#Read the file into a dataframe
tv <- read_csv("C:\\Users\\Caroline\\Documents\\3rdSem\\AIT614\\Project\\AIT614_CarolineFernandes_System\\data\\Traffic_Violations.csv")

#Check the dimensionality of the dataframe
str(tv)
dim(tv)

head(tv)

#Reducing the number of attributes
tv<-subset(tv, select=c("Location","Latitude","Longitude","Accident","Fatal","Date Of Stop","Time Of Stop","Color","Race","Gender","Driver City","Driver State"))
dim(tv)


#Check for missing values
colSums(is.na(tv))
#Drop missing values
clean_data<-na.omit(tv)
#Check for missing values
colSums(is.na(clean_data))
dim(clean_data)

head(clean_data)


#Convert Categorical data to numeric format
clean_data$Accident<- ifelse(clean_data$Accident=="No", 0, 1)
clean_data$Fatal<- ifelse(clean_data$Fatal=="Yes", 1, 0)
clean_data$Alcohol<- ifelse(clean_data$Alcohol=="Yes", 1, 0)
head(clean_data)

write.csv(clean_data,"C:\\Users\\Caroline\\Documents\\3rdSem\\AIT614\\Project\\AIT614_CarolineFernandes_System\\data\\CleanData.csv",row.names=TRUE)

clean_data$`Date Of Stop`<-as.Date(clean_data$`Date Of Stop`,format="%m/%d/%Y")

clean_data$month<-format(clean_data$`Date Of Stop`,"%B")

clean_data$month_code<-as.numeric(format(clean_data$`Date Of Stop`,"%m"))

clean_data$year<-as.numeric(format(clean_data$`Date Of Stop`,"%Y"))

clean_data$hour<-hour(hms(as.character(clean_data$`Time Of Stop`)))+1

clean_data$weekday<-as.numeric(format(clean_data$`Date Of Stop`,"%u"))

clean_data$weekday_full<-format(clean_data$`Date Of Stop`,"%a")

tab_ptn<-data.frame(table(clean_data$month_code,clean_data$year))
names(tab_ptn)<-c("month","year","count")
time_ser=ts(tab_ptn[which(tab_ptn$count!=0),3],frequency=12,start=c(2014,7))
print(time_ser)

par(mfrow=c(3,1))
plot(time_ser,ylab="Total Traffic Incidents",type="b",,pch=5,lwd=2,col="#00AFBB")
abline(reg=lm(time_ser~time(time_ser)),col="red",lty=2, lwd=3)
#plot(aggregate(time_ser,FUN=mean),ylab="Traffic Incidents Trend ",lty=2,lwd=2,col="red")

boxplot(time_ser~cycle(time_ser),ylab="Traffic Incidents Seasonality",col="#00AFBB")

tab_weekday<-data.frame(table(clean_data$weekday,clean_data$year))
names(tab_weekday)<-c("weekday","year","count")

time_weekday=ts(tab_weekday[which(tab_weekday$count!=0),3],frequency=7,start=c(2014,7))
boxplot(time_weekday~cycle(time_weekday),xlab="weekdays",ylab="Traffic Violations on weekdays",names=c('MON','TUE',"WED","THU","FRI","SAT","SUN"),col="#FFFF00")

tab_hr<-data.frame(table(clean_data$year,clean_data$hour))

names(tab_hr)<-c("year","hour","count")

tab_hr<-tab_hr[order(tab_hr$year),]


time_hr=ts(tab_hr[which(tab_hr$count!=0),3],frequency=24,start=c(2014,1),end=c(2018,24))
boxplot(time_hr~cycle(time_hr),xlab="hours",ylab="Traffic Incidents hourly",col="#00AFBB")

