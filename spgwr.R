# 3.13
# ��������
setwd("C:\\Users\\Administrator.SC-201902221855\\Desktop")
# ��ؿ�
library(spgwr)
# ��ȡ����
data1 = read.csv("F:\\��ҵ���ĳ���\\��������\\������\\�վ�\\�ܵ���.csv")



# ������Ȩ�ع�ģ��
#res = gwr(PM2.5Ũ�� ~ AODֵ + cloudCover + dewPoint + humidity + precipAccumulation +  pressure + temperature + visibility + windSpeed, 
#          data = data1, bandwidth=BW, hatmatrix = TRUE)

# ����ʮ�۽�����֤
library("caret")
folds<-createFolds(data1,k=10) #����training��laber-Species�����ݼ��зֳ�10�ȷ�
re<-{}
for(i in 1:10){
  traindata<-data1[-folds[[i]],]
  testdata<-data1[folds[[i]],]
  coordinates(traindata) <-~X+Y
  coordinates(testdata) <-~X+Y
  # �����Ŵ���   UNINTS: KM
  BW = gwr.sel(�վ�PM2.5 ~ AODֵ + cloudCover + dewPoint + humidity + precipAccumulation + precipIntensity + pressure + temperatureMax + visibility + windSpeed,
                 , data=traindata, adapt=FALSE, method = "cv", verbose = TRUE, longlat=NULL, RMSE=TRUE)
  # ���
  res = gwr(�վ�PM2.5 ~ AODֵ + cloudCover + dewPoint + humidity +  pressure + precipAccumulation + precipIntensity  + temperature + visibility + windSpeed, 
            data = traindata, bandwidth=BW, hatmatrix = TRUE)
  re = c(re,res$results$rss/res$gTSS)
  print(re)
}

mean(re)


# ��ѩ�����0
res = gwr(�վ�PM2.5 ~ AODֵ + cloudCover + dewPoint + humidity +  pressure + precipAccumulation + precipIntensity + temperature + visibility + windSpeed, 
            data = data1, bandwidth=BW, hatmatrix = TRUE)
# summary(res$results)
sdf = res$SDF
localR2 = sdf$localR2
r2 = 1 - (res$results$rss/res$gTSS)
r2 = mean(r2)
MAE=mean(abs(res$lm$residuals))
mse = res$results$rss/res$results$n

# t ����
t = sdf$humidity/sdf$humidity_se
t = sdf$AODֵ/sdf$AODֵ_se
t = sdf$cloudCover/sdf$cloudCover_se_EDF
t = sdf$dewPoint/sdf$dewPoint_se
t = sdf$precipAccumulation/sdf$precipAccumulation_se # 0.383
t = sdf$pressure/sdf$pressure_se
t = sdf$temperature/sdf$temperature_se
t = sdf$visibility/sdf$visibility_se
t = sdf$windSpeed/sdf$windSpeed_se