

library(GWmodel)
# ��ȡ
data = read.csv("F:\\��ҵ���ĳ���\\��������\\������\\�վ�\\�ܵ���toR.csv")

coordinates(data)<-~X+Y

# �����Ŵ���   UNINTS: KM
BW = bw.gwr(�վ�PM2.5 ~ AODֵ + cloudCover + dewPoint + humidity + precipAccumulation + precipIntensity + pressure + temperature + visibility + windSpeed,
              data=data, approach="CV",kernel="bisquare", adaptive=FALSE, p=2, theta=0, longlat=F)
# ������Ȩģ��

res = gwr.predict(�վ�PM2.5 ~ AODֵ + cloudCover + dewPoint + humidity + precipAccumulation + precipIntensity + uvIndex + pressure + temperature + visibility + windSpeed,
                   data=data[1:2555,], predictdata=data[2556:3011,], bw=6333, kernel="bisquare",adaptive=TRUE, p=2,
                theta=0, longlat=F)
cha = res$SDF$prediction - data[2556:3011,]$�վ�PM2.5
AME = mean(abs(cha))




# ����ʮ�۽�����֤
library("caret")
folds<-createFolds(data,k=10) #����training��laber-Species�����ݼ��зֳ�10�ȷ�
re1<-{}
re2<-{}
for(i in 1:10){
  traindata<-data[-folds[[i]],]
  testdata<-data[folds[[i]],]
  coordinates(traindata) <-~X+Y
  coordinates(testdata) <-~X+Y
  # �����Ŵ���   UNINTS: KM
  #BW = bw.gwr(�վ�PM2.5 ~ AODֵ + cloudCover + dewPoint + humidity + precipAccumulation + precipIntensity + pressure + temperature + visibility + windSpeed,
  #              data=traindata, approach="CV",kernel="bisquare", adaptive=FALSE, p=2, theta=0, longlat=F)
  BW = 6353.376
  # ���
  res = gwr.predict(�վ�PM2.5 ~ AODֵ + cloudCover + dewPoint + humidity + precipAccumulation + precipIntensity + pressure + temperature + visibility + windSpeed,
                      data=traindata, predictdata=testdata, bw=BW, kernel="bisquare",adaptive=TRUE, p=2,
                      theta=0, longlat=F)
  cha = res$SDF$prediction - testdata$�վ�PM2.5
  cha_2 = cha*cha
  AME = mean(abs(cha))
  MSE = mean(cha_2)
  re1 = c(re1,AME)
  re2 = c(re2,MSE)
}

OUTCOME = mean(re1)
outcome = mean(re2)
sdre1 = sd(re1)
sdre2 = sd(re2)

BW = 0.6353376
