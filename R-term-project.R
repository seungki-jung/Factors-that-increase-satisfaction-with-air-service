#변수 설명(만족도에서 0은 결측값)
"Satisfaction:Airline satisfaction level(Satisfaction, neutral or dissatisfaction)"
#Age:The actual age of the passengers
#Gender:Gender of the passengers (Female, Male)
#"Type of Travel:Purpose of the flight of the passengers (Personal Travel, Business Travel)"
#"Class:Travel class in the plane of the passengers (Business, Eco, Eco Plus)"
#Customer Type:The customer type (Loyal customer, disloyal customer)
#Flight distance:The flight distance of this journey
#"Inflight wifi service:Satisfaction level of the inflight wifi service (0:Not Applicable;1-5)"
#Ease of Online booking:Satisfaction level of online booking
#Inflight service:Satisfaction level of inflight service
#Online boarding:Satisfaction level of online boarding
#Inflight entertainment:Satisfaction level of inflight entertainment
#Food and drink:Satisfaction level of Food and drink
#Seat comfort:Satisfaction level of Seat comfort
#On-board service:Satisfaction level of On-board service
#Leg room service:Satisfaction level of Leg room service
#Departure/Arrival time convenient:Satisfaction level of Departure/Arrival time convenient
#Baggage handling:Satisfaction level of baggage handling
#Gate location:Satisfaction level of Gate location
#Cleanliness:Satisfaction level of Cleanliness
#Check-in service:Satisfaction level of Check-in service
#Departure Delay in Minutes:Minutes delayed when departure
#Arrival Delay in Minutes:Minutes delayed when Arrival
#Flight cancelled:Whether the Flight cancelled or not (Yes, No)
#Flight time in minutes:Minutes of Flight takes

setwd("C:/Users/Jeong SeungJu/OneDrive/바탕 화면/범자")
library(tidyverse)
data<-as.tibble(read.csv("test.csv",header=TRUE))
head(data)
str(data)
dim(data)

#데이터 전처리
data<-data[,-c(1,2)]#x,id열 제외

for(i in 1:dim(data)[2]){
  print(table(is.na(data[i])))
  print(colnames(data)[i])
}
#Arrival.Delay.in.Minutes변수에서 83개의 결측값,결측값 개수가 적기 때문에 결측값 삭제
data<-na.omit(data)
table(is.na(data))

#데이터 unique 값
for(i in 1:dim(data)[2]){
  print(table(unique(data[i])))
  print(colnames(data)[i])
}


data2<-data %>% filter(Inflight.wifi.service==0|Departure.Arrival.time.convenient==0|Ease.of.Online.booking==0|Food.and.drink==0|Online.boarding==0|Inflight.entertainment==0|On.board.service==0|Leg.room.service==0|Inflight.service==0|Cleanliness==0)
#각 열에서 만족도가 0인 데이터를 검색해 본 결과 2104개 데이터 발견.
#리커트척도에서 만족도가 0이 나올 수 없기 때문에 각 문항에서 0이 아닌 데이터들만 추출 
data3<-data %>% filter(Inflight.wifi.service!=0&Departure.Arrival.time.convenient!=0&Ease.of.Online.booking!=0&Food.and.drink!=0&Online.boarding!=0&Inflight.entertainment!=0&On.board.service!=0&Leg.room.service!=0&Inflight.service!=0&Cleanliness!=0)
data3$satisfaction
data3$Gender<-factor(data3$Gender)
data3$Customer.Type<-factor(data3$Customer.Type)
data3$Type.of.Travel<-factor(data3$Type.of.Travel)
data3$Class<-factor(data3$Class)
data3$satisfaction<-ifelse(data3$satisfaction=="satisfied",1,0)
str(data3)

#출발 딜레이시간,도착 딜레이시간 이상값 제거
iqr<-fivenum(data3$Departure.Delay.in.Minutes)[4]-fivenum(data3$Departure.Delay.in.Minutes)[2]
a<-fivenum(data3$Departure.Delay.in.Minutes)[4]+1.5*iqr

iqr2<-fivenum(data3$Arrival.Delay.in.Minutes)[4]-fivenum(data3$Arrival.Delay.in.Minutes)[2]
a2<-fivenum(data3$Arrival.Delay.in.Minutes)[4]+1.5*iqr2

data3<-data3 %>% filter(data3$Departure.Delay.in.Minutes<=30&data3$Arrival.Delay.in.Minutes<=32.5)
unique(data3$Arrival.Delay.in.Minutes)
#도착 딜레이시간-출발 딜레이시간 해서 최대한 제시간에 도착했는지(0보다 크거나 같으면 최대한 제시간에 도착)
data3$ontime<-data3$Arrival.Delay.in.Minutes-data3$Departure.Delay.in.Minutes

#시각화(막대그래프)
library(gridExtra)
data3 %>% ggplot(aes(x=Gender))+geom_bar()+geom_text(stat="count",aes(label=..count..),vjust=-0.3)#성별
data3 %>% ggplot(aes(x=satisfaction))+geom_bar()+geom_text(stat="count",aes(label=..count..),vjust=-0.3)#만족도
data3 %>% ggplot(aes(x=satisfaction,fill=Gender))+geom_bar()#성별에 따른 만족도 여부
data3 %>% ggplot(aes(x=Customer.Type))+geom_bar()+geom_text(stat="count",aes(label=..count..),vjust=-0.3)#소비자 타입
data3 %>% ggplot(aes(x=Type.of.Travel))+geom_bar()+geom_text(stat="count",aes(label=..count..),vjust=-0.3)#여행 유형
data3 %>% ggplot(aes(x=Class))+geom_bar()+geom_text(stat="count",aes(label=..count..),vjust=-0.3)#항공석 클래스

data3 %>% mutate(satisfaction=recode(satisfaction,'0'="neutral or dissatisfied",'1'="satisfied")) %>% ggplot(aes(x=Gender,fill=Gender))+geom_bar()+facet_wrap(~satisfaction)+geom_text(stat="count",aes(label=..count..),vjust=-0.3)+theme(text = element_text(size=20),
                                                                                                                                                                                                                                          axis.text.x = element_text(angle=0, hjust=0.5))#성별
data3 %>% mutate(satisfaction=recode(satisfaction,'0'="neutral or dissatisfied",'1'="satisfied")) %>% ggplot(aes(x=Customer.Type,fill=Customer.Type))+geom_bar()+facet_wrap(~satisfaction)+geom_text(stat="count",aes(label=..count..),vjust=-0.3)+theme(text = element_text(size=12),
                                                                                                                                                                                                                                                         axis.text.x = element_text(angle=0, hjust=0.5))#소비자 타입
data3 %>% mutate(satisfaction=recode(satisfaction,'0'="neutral or dissatisfied",'1'="satisfied")) %>% ggplot(aes(x=Type.of.Travel,fill=Type.of.Travel))+geom_bar()+facet_wrap(~satisfaction)+geom_text(stat="count",aes(label=..count..),vjust=-0.3)+theme(text = element_text(size=12),
                                                                                                                                                                                                                                                           axis.text.x = element_text(angle=0, hjust=0.5))#여행 유형
data3 %>% mutate(satisfaction=recode(satisfaction,'0'="neutral or dissatisfied",'1'="satisfied")) %>% ggplot(aes(x=Class,fill=Class))+geom_bar()+facet_wrap(~satisfaction)+geom_text(stat="count",aes(label=..count..),vjust=-0.3)+theme(text = element_text(size=12),
                                                                                                                                                                                                                                         axis.text.x = element_text(angle=0, hjust=0.5))#항공석 클래스

data3 %>% mutate(satisfaction=recode(satisfaction,'0'="neutral or dissatisfied",'1'="satisfied")) %>% ggplot(aes(x=Inflight.wifi.service,fill=factor(Inflight.wifi.service)))+geom_bar()+facet_wrap(~satisfaction)+geom_text(stat="count",aes(label=..count..),vjust=-0.3)+theme(text = element_text(size=12),
                                                                                                                                                                                                                                                                         axis.text.x = element_text(angle=0, hjust=0.5))#항공기 와이파이서비스 만족도
data3 %>% mutate(satisfaction=recode(satisfaction,'0'="neutral or dissatisfied",'1'="satisfied")) %>% ggplot(aes(x=Departure.Arrival.time.convenient,fill=factor(Departure.Arrival.time.convenient)))+geom_bar()+facet_wrap(~satisfaction)+geom_text(stat="count",aes(label=..count..),vjust=-0.3)#출발도착시간 만족도
data3 %>% mutate(satisfaction=recode(satisfaction,'0'="neutral or dissatisfied",'1'="satisfied")) %>% ggplot(aes(x=Ease.of.Online.booking,fill=factor(Ease.of.Online.booking)))+geom_bar()+facet_wrap(~satisfaction)+geom_text(stat="count",aes(label=..count..),vjust=-0.3)#온라인 예약 용이성 만족도
data3 %>% mutate(satisfaction=recode(satisfaction,'0'="neutral or dissatisfied",'1'="satisfied")) %>% ggplot(aes(x=Gate.location,fill=factor(Gate.location)))+geom_bar()+facet_wrap(~satisfaction)+geom_text(stat="count",aes(label=..count..),vjust=-0.3)+theme(text = element_text(size=12),
                                                                                                                                                                                                                                                                 axis.text.x = element_text(angle=0, hjust=0.5))#게이트 위치 편의성 만족도
data3 %>% mutate(satisfaction=recode(satisfaction,'0'="neutral or dissatisfied",'1'="satisfied")) %>% ggplot(aes(x=Food.and.drink,fill=factor(Food.and.drink)))+geom_bar()+facet_wrap(~satisfaction)+geom_text(stat="count",aes(label=..count..),vjust=-0.3)+theme(text = element_text(size=12),
                                                                                                                                                                                                                                                                   axis.text.x = element_text(angle=0, hjust=0.5))#음식,음료(기내식) 만족도
data3 %>% mutate(satisfaction=recode(satisfaction,'0'="neutral or dissatisfied",'1'="satisfied")) %>% ggplot(aes(x=Online.boarding,fill=factor(Online.boarding)))+geom_bar()+facet_wrap(~satisfaction)+geom_text(stat="count",aes(label=..count..),vjust=-0.3)+theme(text = element_text(size=12),
                                                                                                                                                                                                                       axis.text.x = element_text(angle=0, hjust=0.5))#온라인 탑승 만족도
data3 %>% mutate(satisfaction=recode(satisfaction,'0'="neutral or dissatisfied",'1'="satisfied")) %>% ggplot(aes(x=Seat.comfort,fill=factor(Seat.comfort)))+geom_bar()+facet_wrap(~satisfaction)+geom_text(stat="count",aes(label=..count..),vjust=-0.3)+theme(text = element_text(size=12),
                                                                                                                                                                                                                                                               axis.text.x = element_text(angle=0, hjust=0.5))#좌석 만족도
data3 %>% mutate(satisfaction=recode(satisfaction,'0'="neutral or dissatisfied",'1'="satisfied")) %>% ggplot(aes(x=Inflight.entertainment,fill=factor(Inflight.entertainment)))+geom_bar()+facet_wrap(~satisfaction)+geom_text(stat="count",aes(label=..count..),vjust=-0.3)+theme(text = element_text(size=12),
                                                                                                                                                                                                                                                                                   axis.text.x = element_text(angle=0, hjust=0.5))#기내 오락거리 만족도
data3 %>% mutate(satisfaction=recode(satisfaction,'0'="neutral or dissatisfied",'1'="satisfied")) %>% ggplot(aes(x=On.board.service,fill=factor(On.board.service)))+geom_bar()+facet_wrap(~satisfaction)+geom_text(stat="count",aes(label=..count..),vjust=-0.3)+theme(text = element_text(size=12),
                                                                                                                                                                                                                                                                       axis.text.x = element_text(angle=0, hjust=0.5))#탑승 서비스 만족도
data3 %>% mutate(satisfaction=recode(satisfaction,'0'="neutral or dissatisfied",'1'="satisfied")) %>% ggplot(aes(x=Leg.room.service,fill=factor(Leg.room.service)))+geom_bar()+facet_wrap(~satisfaction)+geom_text(stat="count",aes(label=..count..),vjust=-0.3)+theme(text = element_text(size=12),
                                                                                                                                                                                                                                                                       axis.text.x = element_text(angle=0, hjust=0.5))#다리 뻗을 수 있는 공간이 잘 마련되어 있는지
data3 %>% mutate(satisfaction=recode(satisfaction,'0'="neutral or dissatisfied",'1'="satisfied")) %>% ggplot(aes(x=Baggage.handling,fill=factor(Baggage.handling)))+geom_bar()+facet_wrap(~satisfaction)+geom_text(stat="count",aes(label=..count..),vjust=-0.3)+theme(text = element_text(size=12),
                                                                                                                                                                                                                                                                       axis.text.x = element_text(angle=0, hjust=0.5))#수하물 처리시스템 만족도
data3 %>% mutate(satisfaction=recode(satisfaction,'0'="neutral or dissatisfied",'1'="satisfied")) %>% ggplot(aes(x=Checkin.service,fill=factor(Checkin.service)))+geom_bar()+facet_wrap(~satisfaction)+geom_text(stat="count",aes(label=..count..),vjust=-0.3)+theme(text = element_text(size=12),
                                                                                                                                                                                                                                                                     axis.text.x = element_text(angle=0, hjust=0.5))#check in service 만족도
data3 %>% mutate(satisfaction=recode(satisfaction,'0'="neutral or dissatisfied",'1'="satisfied")) %>% ggplot(aes(x=Inflight.service,fill=factor(Inflight.service)))+geom_bar()+facet_wrap(~satisfaction)+geom_text(stat="count",aes(label=..count..),vjust=-0.3)+theme(text = element_text(size=12),
                                                                                                                                                                                                                                                                       axis.text.x = element_text(angle=0, hjust=0.5))#기내 서비스 만족도
data3 %>% mutate(satisfaction=recode(satisfaction,'0'="neutral or dissatisfied",'1'="satisfied")) %>% ggplot(aes(x=Cleanliness,fill=factor(Cleanliness)))+geom_bar()+facet_wrap(~satisfaction)+geom_text(stat="count",aes(label=..count..),vjust=-0.3)+theme(text = element_text(size=12),
                                                                                                                                                                                                                                                             axis.text.x = element_text(angle=0, hjust=0.5))#기내가 청결한가?
data3 %>% group_by(satisfaction) %>% select(-c(1:6),-c(21:24)) %>% summarise(Inflight.wifi.service=mean(Inflight.wifi.service),
                                                                             Departure.Arrival.time.convenient=mean(Departure.Arrival.time.convenient),
                                                                             Ease.of.Online.booking=mean(Ease.of.Online.booking),
                                                                             Gate.location=mean(Gate.location),
                                                                             Food.and.drink=mean(Food.and.drink),
                                                                             Online.boarding=mean(Online.boarding),
                                                                             Seat.comfort=mean(Seat.comfort))


data3 %>% group_by(satisfaction) %>% select(-c(1:6),-c(21:24)) %>% summarise(
                                                                             Inflight.entertainment=mean(Inflight.entertainment),
                                                                             On.board.service=mean(On.board.service),
                                                                             Leg.room.service=mean(Leg.room.service),
                                                                             Baggage.handling=mean(Baggage.handling),
                                                                             Checkin.service=mean(Checkin.service),
                                                                             Inflight.service=mean(Inflight.service),
                                                                             Cleanliness=mean(Cleanliness))
data3 %>% ggplot(aes(x=satisfaction))+geom_bar()+facet_wrap(~Gender)+geom_text(stat="count",aes(label=..count..),vjust=-0.3)#성별
data3 %>% ggplot(aes(x=satisfaction))+geom_bar()+facet_wrap(~Customer.Type)+geom_text(stat="count",aes(label=..count..),vjust=-0.3)
data3 %>% ggplot(aes(x=satisfaction))+geom_bar()+facet_wrap(~Type.of.Travel)+geom_text(stat="count",aes(label=..count..),vjust=-0.3)
data3 %>% ggplot(aes(x=satisfaction))+geom_bar()+facet_wrap(~Class)+geom_text(stat="count",aes(label=..count..),vjust=-0.3)#성별


data3 %>% ggplot(aes(x=satisfaction))+geom_bar()+facet_wrap(~Inflight.wifi.service)+geom_text(stat="count",aes(label=..count..),vjust=-0.3)#성별
data3 %>% ggplot(aes(x=satisfaction))+geom_bar()+facet_wrap(~Departure.Arrival.time.convenient)+geom_text(stat="count",aes(label=..count..),vjust=-0.3)#성별
data3 %>% ggplot(aes(x=satisfaction))+geom_bar()+facet_wrap(~Ease.of.Online.booking)+geom_text(stat="count",aes(label=..count..),vjust=-0.3)#성별
data3 %>% ggplot(aes(x=satisfaction))+geom_bar()+facet_wrap(~Gate.location)+geom_text(stat="count",aes(label=..count..),vjust=-0.3)#성별
data3 %>% ggplot(aes(x=satisfaction))+geom_bar()+facet_wrap(~Food.and.drink)+geom_text(stat="count",aes(label=..count..),vjust=-0.3)#성별
data3 %>% ggplot(aes(x=satisfaction))+geom_bar()+facet_wrap(~Online.boarding)+geom_text(stat="count",aes(label=..count..),vjust=-0.3)#성별
data3 %>% ggplot(aes(x=satisfaction))+geom_bar()+facet_wrap(~Seat.comfort)+geom_text(stat="count",aes(label=..count..),vjust=-0.3)#성별
data3 %>% ggplot(aes(x=satisfaction))+geom_bar()+facet_wrap(~Inflight.entertainment)+geom_text(stat="count",aes(label=..count..),vjust=-0.3)#성별
data3 %>% ggplot(aes(x=satisfaction))+geom_bar()+facet_wrap(~On.board.service)+geom_text(stat="count",aes(label=..count..),vjust=-0.3)#성별
data3 %>% ggplot(aes(x=satisfaction))+geom_bar()+facet_wrap(~Leg.room.service)+geom_text(stat="count",aes(label=..count..),vjust=-0.3)#성별
data3 %>% ggplot(aes(x=satisfaction))+geom_bar()+facet_wrap(~Inflight.service)+geom_text(stat="count",aes(label=..count..),vjust=-0.3)#성별
data3 %>% ggplot(aes(x=satisfaction))+geom_bar()+facet_wrap(~Baggage.handling)+geom_text(stat="count",aes(label=..count..),vjust=-0.3)#성별
data3 %>% ggplot(aes(x=satisfaction))+geom_bar()+facet_wrap(~Checkin.service)+geom_text(stat="count",aes(label=..count..),vjust=-0.3)#성별
data3 %>% ggplot(aes(x=satisfaction))+geom_bar()+facet_wrap(~Cleanliness)+geom_text(stat="count",aes(label=..count..),vjust=-0.3)#성별


par(mfrow=c(1,2))
#시각화(히스토그램)
data3 %>% ggplot(aes(x=Age,colour="blue"))+geom_histogram(bins=10)#나이
data3 %>% ggplot(aes(x=Flight.Distance,colour="blue"))+geom_histogram(bins=10)#비행거리
data3 %>% ggplot(aes(x=Departure.Delay.in.Minutes,colour="blue"))+geom_histogram(bins=5)#출발 딜레이 시간
data3 %>% ggplot(aes(x=Arrival.Delay.in.Minutes,colour="blue"))+geom_histogram(bins=5)
data3 %>% ggplot(aes(x=ontime,colour="blue"))+geom_histogram(bins=5)

#연속형 독립변수간 상관관계 시각화(히트맵)
library(corrplot)
x11();corrplot(cor(data3 %>% select(-c(Gender,Customer.Type,Type.of.Travel,Class,satisfaction))),type="lower",tl.col="black", tl.srt=30)

#csv파일 저장
write.csv(data3,file='air.csv',row.names=FALSE)


data<-read.csv("air.csv",header=T)
data3<-data
str(data)



#?????????????????? ???????????? ?????????????????? ?????????????????? ????????

#hist(data$Age)    5~80 10????????????
data <- transform(data, Age = ifelse(Age < 10, "0", 
                                     ifelse(Age >= 10 & Age < 20, "1", 
                                            ifelse(Age >= 20 & Age < 30, "2", 
                                                   ifelse(Age >= 30 & Age < 40, "3", 
                                                          ifelse(Age >= 40 & Age < 50, "4", 
                                                                 ifelse(Age >= 50 & Age < 60, "5",
                                                                        ifelse(Age >= 60 & Age < 70, "6",
                                                                               ifelse(Age >= 70 & Age < 80, "7", "8")))))))))

#hist(data$Flight.Distance)   0~4000 500????????????
data <- transform(data, Flight.Distance = ifelse(Flight.Distance < 500, "1", 
                                                 ifelse(Flight.Distance >= 500 & Flight.Distance < 1000, "2", 
                                                        ifelse(Flight.Distance >= 1000 & Flight.Distance < 1500, "3", 
                                                               ifelse(Flight.Distance >= 1500 & Flight.Distance < 2000, "4", 
                                                                      ifelse(Flight.Distance >= 2000 & Flight.Distance < 3000, "5", 
                                                                             ifelse(Flight.Distance >= 3000 & Flight.Distance < 3500, "6",
                                                                                    ifelse(Flight.Distance >= 3500 & Flight.Distance < 4000, "7","8"))))))))

#hist(data$Departure.Delay.in.Minutes)    0~30 5????????????
data <- transform(data, Departure.Delay.in.Minutes = ifelse(Departure.Delay.in.Minutes < 5, "1", 
                                                            ifelse(Departure.Delay.in.Minutes >= 5 & Departure.Delay.in.Minutes < 10, "2", 
                                                                   ifelse(Departure.Delay.in.Minutes >= 10 & Departure.Delay.in.Minutes < 15, "3", 
                                                                          ifelse(Departure.Delay.in.Minutes >= 15 & Departure.Delay.in.Minutes < 20, "4", 
                                                                                 ifelse(Departure.Delay.in.Minutes >= 20 & Departure.Delay.in.Minutes < 30, "5", "6"))))))

#hist(data$Arrival.Delay.in.Minutes)   0~30 5????????????
data <- transform(data, Arrival.Delay.in.Minutes = ifelse(Arrival.Delay.in.Minutes < 5, "1", 
                                                          ifelse(Arrival.Delay.in.Minutes >= 5 & Arrival.Delay.in.Minutes < 10, "2", 
                                                                 ifelse(Arrival.Delay.in.Minutes >= 10 & Arrival.Delay.in.Minutes < 15, "3", 
                                                                        ifelse(Arrival.Delay.in.Minutes >= 15 & Arrival.Delay.in.Minutes < 20, "4", 
                                                                               ifelse(Arrival.Delay.in.Minutes >= 20 & Arrival.Delay.in.Minutes < 30, "5", "6"))))))

#hist(data$ontime)   -30~30 10????????????
data <- transform(data, ontime = ifelse(ontime < -20, "1", 
                                        ifelse(ontime >= -20 & ontime < -10, "2", 
                                               ifelse(ontime >= -10 & ontime < 0, "3", 
                                                      ifelse(ontime >= 0 & ontime < 10, "4", 
                                                             ifelse(ontime >= 10 & ontime < 20, "5", 
                                                                    ifelse(ontime >= 20 & ontime < 30, "6", "7")))))))



#char?????? factor?????????????????? ????????
data$Age<-as.factor(data$Age)
data$Flight.Distance<-as.factor(data$Flight.Distance)
data$Departure.Delay.in.Minutes<-as.factor(data$Departure.Delay.in.Minutes)
data$Arrival.Delay.in.Minutes<-as.factor(data$Arrival.Delay.in.Minutes)
data$ontime<-as.factor(data$ontime)



#int?????? factor?????????????????? ????????
data$Inflight.wifi.service<-as.factor(data$Inflight.wifi.service)
data$Departure.Arrival.time.convenient<-as.factor(data$Departure.Arrival.time.convenient)
data$Ease.of.Online.booking<-as.factor(data$Ease.of.Online.booking)
data$Gate.location<-as.factor(data$Gate.location)
data$Food.and.drink<-as.factor(data$Food.and.drink)
data$Online.boarding<-as.factor(data$Online.boarding)
data$Seat.comfort<-as.factor(data$Seat.comfort)
data$Inflight.entertainment<-as.factor(data$Inflight.entertainment)
data$On.board.service<-as.factor(data$On.board.service)
data$Leg.room.service<-as.factor(data$Leg.room.service)
data$Baggage.handling<-as.factor(data$Baggage.handling)
data$Checkin.service<-as.factor(data$Checkin.service)
data$Inflight.service<-as.factor(data$Inflight.service)
data$Cleanliness<-as.factor(data$Cleanliness)
data$satisfaction<-as.factor(data$satisfaction)



str(data)



#분할표/독립성검정

Gender_table<-xtabs(~Gender + satisfaction, data=data)
chisq.test(Gender_table)

CustomerType_table<-xtabs(~Customer.Type + satisfaction, data=data)
CustomerType_table
chisq.test(CustomerType_table)

Age_table<-xtabs(~Age + satisfaction, data=data)
Age_table
chisq.test(Age_table)

TypeTravel_table<-xtabs(~Type.of.Travel + satisfaction, data=data)
TypeTravel_table
chisq.test(TypeTravel_table)

Class_table<-xtabs(~Class + satisfaction, data=data)
Class_table
chisq.test(Class_table)

FlightDist_table<-xtabs(~Flight.Distance + satisfaction, data=data)
FlightDist_table
chisq.test(FlightDist_table)

InflightWifi_table<-xtabs(~Inflight.wifi.service + satisfaction, data=data)
InflightWifi_table
chisq.test(InflightWifi_table)

DATimeConvenient_table<-xtabs(~Departure.Arrival.time.convenient + satisfaction, data=data)
DATimeConvenient_table
chisq.test(DATimeConvenient_table)

EaseOnlineBook_table<-xtabs(~Ease.of.Online.booking + satisfaction, data=data)
EaseOnlineBook_table
chisq.test(EaseOnlineBook_table)

GateLocation_table<-xtabs(~Gate.location + satisfaction, data=data)
GateLocation_table
chisq.test(GateLocation_table)

FoodDrink_table<-xtabs(~Food.and.drink + satisfaction, data=data)
FoodDrink_table
chisq.test(FoodDrink_table)

OnlineBoard_table<-xtabs(~Online.boarding + satisfaction, data=data)
OnlineBoard_table
chisq.test(OnlineBoard_table)

SeatComfort_table<-xtabs(~Seat.comfort + satisfaction, data=data)
SeatComfort_table
chisq.test(SeatComfort_table)

InflightEntertain_table<-xtabs(~Inflight.entertainment + satisfaction, data=data)
InflightEntertain_table
chisq.test(InflightEntertain_table)

OnBoardService_table<-xtabs(~On.board.service + satisfaction, data=data)
OnBoardService_table
chisq.test(OnBoardService_table)

LegRoomService_table<-xtabs(~Leg.room.service + satisfaction, data=data)
LegRoomService_table
chisq.test(LegRoomService_table)

BaggageHandling_table<-xtabs(~Baggage.handling + satisfaction, data=data)
BaggageHandling_table
chisq.test(BaggageHandling_table)

CheckinService_table<-xtabs(~Checkin.service + satisfaction, data=data)
CheckinService_table
chisq.test(CheckinService_table)

InflightService_table<-xtabs(~Inflight.service + satisfaction, data=data)
InflightService_table
chisq.test(InflightService_table)

Cleanliness_table<-xtabs(~Cleanliness + satisfaction, data=data)
Cleanliness_table
chisq.test(Cleanliness_table)

DepartDelay_table<-xtabs(~Departure.Delay.in.Minutes + satisfaction, data=data)
DepartDelay_table
chisq.test(DepartDelay_table)

ArrivDelay_table<-xtabs(~Arrival.Delay.in.Minutes + satisfaction, data=data)
ArrivDelay_table
chisq.test(ArrivDelay_table)

ontime_table<-xtabs(~ontime + satisfaction, data=data)
ontime_table
chisq.test(ontime_table)



#GLM
data3<-data
str(data3)
#"Satisfaction:Airline satisfaction level
#(Satisfaction, neutral or dissatisfaction)"
#반응변수인 항공기 승객 만족도는 binary이다. 
#설명변수: Age - 연속형,양적 
fit<-glm(satisfaction~.,family=binomial,data=data3)
summary(fit) #몇몇 변수들은 유의하지 않다.
fit0<-glm(satisfaction~1,family=binomial,data=data3)
library(lmtest)
lrtest(fit,fit0) #최대우도검정으로 모형이 유의하므로 다중공선성이 존재함을 알 수 있다.
summary(fit)
summary(fit0)
#stepwise variable selection
fitg<-glm(satisfaction~Gender,family=binomial,data=data3)
summary(fitg)
anova(fitg,test="LR") #유의하지 않다.
fita<-glm(satisfaction~Age,family=binomial,data=data3)
summary(fita)
anova(fita,test="LR") #유의하다.
fittot<-glm(satisfaction~Type.of.Travel,family=binomial,data=data3)
summary(fittot)
anova(fittot,test="LR") #유의하다.
fitc<-glm(satisfaction~Class,family=binomial,data=data3)
summary(fitc)
anova(fitc,test="LR") #유의하다.
fitct<-glm(satisfaction~Customer.Type,family=binomial,data=data3)
summary(fitct)
anova(fitct,test="LR") #유의하다.
fitfd<-glm(satisfaction~Flight.Distance,family=binomial,data=data3)
summary(fitfd)
anova(fitfd,test="LR") #유의하다.
fitiws<-glm(satisfaction~Inflight.wifi.service,family=binomial,data=data3)
summary(fitiws)
anova(fitiws,test="LR") #유의하다.
fiteoob<-glm(satisfaction~Ease.of.Online.booking,family=binomial,data=data3)
summary(fiteoob)
anova(fiteoob,test="LR") #유의하다.
fitis<-glm(satisfaction~Inflight.service,family=binomial,data=data3)
summary(fitis)
anova(fitis,test="LR") #유의하다.
fitob<-glm(satisfaction~Online.boarding,family=binomial,data=data3)
summary(fitob)
anova(fitob,test="LR") #유의하다.
fitie<-glm(satisfaction~Inflight.entertainment,family=binomial,data=data3)
summary(fitie)
anova(fitie,test="LR") #유의하다.
fitfad<-glm(satisfaction~Food.and.drink,family=binomial,data=data3)
summary(fitfad)
anova(fitfad,test="LR") #유의하다.
fitsc<-glm(satisfaction~Seat.comfort,family=binomial,data=data3)
summary(fitsc)
anova(fitsc,test="LR") #유의하다.
fitobs<-glm(satisfaction~On.board.service,family=binomial,data=data3)
summary(fitobs)
anova(fitobs,test="LR") #유의하다.
fitlrs<-glm(satisfaction~Leg.room.service,family=binomial,data=data3)
summary(fitlrs)
anova(fitlrs,test="LR") #유의하다.
fitdatc<-glm(satisfaction~Departure.Arrival.time.convenient,family=binomial,
             data=data3)
summary(fitdatc)
anova(fitdatc,test="LR") #유의하다.
fitbh<-glm(satisfaction~Baggage.handling,family=binomial,data=data3)
summary(fitbh)
anova(fitbh,test="LR") #유의하다.
fitgl<-glm(satisfaction~Gate.location,family=binomial,data=data3)
summary(fitgl)
anova(fitgl,test="LR") #유의하지 않다.
fitcl<-glm(satisfaction~Cleanliness,family=binomial,data=data3)
summary(fitcl)
anova(fitcl,test="LR") #유의하다.
fitcs<-glm(satisfaction~Checkin.service,family=binomial,data=data3)
summary(fitcs)
anova(fitcs,test="LR") #유의하다.
fitddim<-glm(satisfaction~Departure.Delay.in.Minutes,family=binomial,data=data3)
summary(fitddim)
anova(fitddim,test="LR") #유의하다.
fitadim<-glm(satisfaction~Arrival.Delay.in.Minutes,family=binomial,data=data3)
summary(fitadim)
anova(fitadim,test="LR") #유의하다.
fito<-glm(satisfaction~ontime,family=binomial,data=data3)
summary(fito)
anova(fito,test="LR") #유의하다.

#유의하지 않은 gender와 Gate.location를 제외한다.
fit.except.ggl<-glm(satisfaction~.-Gender-Gate.location,family=binomial,data=data3)
summary(fit.except.ggl)

#backward elimination을 사용하여 각 변수들간의 유의성을 본다.
fit.except.ggla<-glm(satisfaction~.-Gender-Gate.location-Age,family=binomial,data=data3)
summary(fit.except.ggla)
lrtest(fit.except.ggl,fit.except.ggla) #p-value는 유의하다.
fit.except.ggltot<-glm(satisfaction~.-Gender-Gate.location-Type.of.Travel,family=binomial,data=data3)
summary(fit.except.ggltot)
lrtest(fit.except.ggl,fit.except.ggltot) #p-value는 유의하다.
fit.except.gglc<-glm(satisfaction~.-Gender-Gate.location-Class,family=binomial,data=data3)
summary(fit.except.gglc)
lrtest(fit.except.ggl,fit.except.gglc) #p-value는 유의하다.
fit.except.gglct<-glm(satisfaction~.-Gender-Gate.location-Customer.Type,family=binomial,data=data3)
summary(fit.except.gglct)
lrtest(fit.except.ggl,fit.except.gglct) #p-value는 유의하다.
fit.except.gglfd<-glm(satisfaction~.-Gender-Gate.location-Flight.Distance,family=binomial,data=data3)
summary(fit.except.gglfd)
lrtest(fit.except.ggl,fit.except.gglfd) #p-value=0.2844로 유의하지 않다.
fit.except.ggliws<-glm(satisfaction~.-Gender-Gate.location-Inflight.wifi.service,family=binomial,data=data3)
summary(fit.except.ggliws)
lrtest(fit.except.ggl,fit.except.ggliws) #p-value는 유의하다.
fit.except.ggleoob<-glm(satisfaction~.-Gender-Gate.location-Ease.of.Online.booking,family=binomial,data=data3)
summary(fit.except.ggleoob)
lrtest(fit.except.ggl,fit.except.ggleoob) #p-value는 유의하다.
fit.except.gglis<-glm(satisfaction~.-Gender-Gate.location-Inflight.service,family=binomial,data=data3)
summary(fit.except.gglis)
lrtest(fit.except.ggl,fit.except.gglis) #p-value는 유의하다.
fit.except.gglob<-glm(satisfaction~.-Gender-Gate.location-Online.boarding,family=binomial,data=data3)
summary(fit.except.gglob)
lrtest(fit.except.ggl,fit.except.gglob) #p-value는 유의하다.
fit.except.gglie<-glm(satisfaction~.-Gender-Gate.location-Inflight.entertainment,family=binomial,data=data3)
summary(fit.except.gglie)
lrtest(fit.except.ggl,fit.except.gglie) #p-value=0.626로 유의하지 않다.
fit.except.gglfad<-glm(satisfaction~.-Gender-Gate.location-Food.and.drink,family=binomial,data=data3)
summary(fit.except.gglfad)
lrtest(fit.except.ggl,fit.except.gglfad) #p-value는 유의하다.
fit.except.gglsc<-glm(satisfaction~.-Gender-Gate.location-Seat.comfort,family=binomial,data=data3)
summary(fit.except.gglsc)
lrtest(fit.except.ggl,fit.except.gglsc) #p-value=0.8124로 유의하지 않다.
fit.except.gglobs<-glm(satisfaction~.-Gender-Gate.location-On.board.service,family=binomial,data=data3)
summary(fit.except.gglobs)
lrtest(fit.except.ggl,fit.except.gglobs) #p-value는 유의하다.
fit.except.ggllrs<-glm(satisfaction~.-Gender-Gate.location-Leg.room.service,family=binomial,data=data3)
summary(fit.except.ggllrs)
lrtest(fit.except.ggl,fit.except.ggllrs) #p-value는 유의하다.
fit.except.gglbh<-glm(satisfaction~.-Gender-Gate.location-Baggage.handling,family=binomial,data=data3)
summary(fit.except.gglbh)
lrtest(fit.except.ggl,fit.except.gglbh) #p-value는 유의하다.
fit.except.gglcl<-glm(satisfaction~.-Gender-Checkin.service-Cleanliness,family=binomial,data=data3)
summary(fit.except.gglcl)
lrtest(fit.except.gclgl,fit.except.gglcl) #p-value는 유의하다.
fit.except.gglcs<-glm(satisfaction~.-Gender-Gate.location-Checkin.service,family=binomial,data=data3)
summary(fit.except.gglcs)
lrtest(fit.except.ggl,fit.except.gglcs) #p-value는 유의하다.
fit.except.gglddim<-glm(satisfaction~.-Gender-Gate.location-Departure.Delay.in.Minutes,family=binomial,data=data3)
summary(fit.except.gglddim)
lrtest(fit.except.ggl,fit.except.gglddim) #p-value는 유의하지 않다.
fit.except.ggladim<-glm(satisfaction~.-Gender-Gate.location-Arrival.Delay.in.Minutes,family=binomial,data=data3)
summary(fit.except.ggladim)
lrtest(fit.except.ggl,fit.except.ggladim) #p-value는 유의하지 않다.
fit.except.gglo<-glm(satisfaction~.-Gender-Gate.location-ontime,family=binomial,data=data3)
summary(fit.except.gglo)
lrtest(fit.except.ggl,fit.except.gglo) #p-value는 유의하지 않다.

#여기서 유의하지 않은 변수는 Flight.Distance,Inflight.entertainment,Seat.comfort,
#Departure Delay in Minutes,Arrival Delay in Minutes,ontime 6개임을 알 수 있었다.

#이제 맨 처음 제외했었던 gender와 Gate.location변수를 다시 넣어서 유의한지 판단한다.
#gender변수 추가
fit.step3<-glm(satisfaction~.-Gender-Gate.location-Flight.Distance-Inflight.entertainment-
                 Seat.comfort-Departure.Delay.in.Minutes-Arrival.Delay.in.Minutes-ontime,family=binomial,data=data3)
summary(fit.step3)
fit.step3.g<-glm(satisfaction~.-Gate.location-Flight.Distance-Inflight.entertainment-
                   Seat.comfort-Departure.Delay.in.Minutes-Arrival.Delay.in.Minutes-ontime,family=binomial,data=data3)
summary(fit.step3.g)
lrtest(fit.step3,fit.step3.g) #p-value=0.01514로 유의하다.

library(lmtest)
#Gate.location변수 추가
fit.step3.gl<-glm(satisfaction~.-Gender-Flight.Distance-Inflight.entertainment-
                    Seat.comfort-Departure.Delay.in.Minutes-Arrival.Delay.in.Minutes-ontime,family=binomial,data=data3)
summary(fit.step3.gl)
lrtest(fit.step3,fit.step3.gl) #p-value는 유의하다.

#맨 처음 제외시켰던 Gender와 Gate.location은 유의하니 다시 추가할 수 있다.
#즉 제외시켜야 하는 변수는 Flight.Distance,Inflight.entertainment,Seat.comfort,
#Departure Delay in Minutes,Arrival Delay in Minutes,ontime 6개이다.

fit.final<-glm(satisfaction~.-Flight.Distance-Inflight.entertainment-
                 Seat.comfort-Departure.Delay.in.Minutes-Arrival.Delay.in.Minutes-ontime,family=binomial,data=data3)
summary(fit.final)
