
# calculate monthly percentage changes in debitcard data
Swiss_Exp_MonAgg <- summarise(
  group_by(Expenditure_CH_Cat, Cat, Code, YearMon),
  Exp = sum(Exp, na.rm=T)
)
Swiss_Exp_MonAgg <- Swiss_Exp_MonAgg[with(Swiss_Exp_MonAgg, order(Cat, YearMon)), ]
Swiss_Exp_MonAgg$PctChange <- c(rep(NA,1), diff(log(Swiss_Exp_MonAgg$Exp), lag = 1))*100
Swiss_Exp_MonAgg$PctChange[Swiss_Exp_MonAgg$YearMon == "2019-01-01"] <- NA
Swiss_Exp_MonAgg <- Swiss_Exp_MonAgg[!(Swiss_Exp_MonAgg$YearMon == "2020-06-01"),]

# COVID weights by IP ----
# mapping MCC - IP
Mapping_MCC_IP <- read.xlsx(xlsxFile = paste0(data.path, "Mapping_MCC_IP.xlsx"),
                            startRow = 4)
CPI_IP <- left_join(x = CPI_IP,
                    y = subset(Mapping_MCC_IP) %>%
                      select(c("PosNo", "MCC_Code")),
                    by = c("IP" = "PosNo"))

# add PctChange to corresponding IP
CPI_IP <- left_join(x = CPI_IP,
                    y = Swiss_Exp_MonAgg[,c("YearMon", "Code", "PctChange")],
                    by = c("MCC_Code" = "Code",
                           "Date" = "YearMon"))

# get CPI weights "normal"
CPI_Weights <- read.xlsx(xlsxFile = paste0(data.path, "CPI_Weights.xlsx"),
                         startRow = 4,
                         sheet = "DE_FR_IT_EN")

CPI_IP_Weights <- subset(CPI_Weights) %>%
  filter(PosType == 4)
CPI_IP_Weights <- CPI_IP_Weights[,c(2,14:ncol(CPI_IP_Weights))]
names(CPI_IP_Weights)[1] <- c("IP")
CPI_IP_Weights %>%
  pivot_longer(-IP, names_to = "Year", values_to = "Weight",
               values_transform = list(Weight = as.numeric),
               names_transform = list(Year = as.numeric)) -> CPI_IP_Weights

# add weights to CPI index
CPI_IP <- left_join(x = CPI_IP, y = CPI_IP_Weights, by = c("IP", "Year"))

# COVID weight calculation
CPI_IP <- subset(CPI_IP) %>%
  filter(Year >= 2000)
names(CPI_IP)[ncol(CPI_IP)-1] <- "CovidWeightAdd"
CPI_IP$CovidWeightAdd[is.na(CPI_IP$CovidWeightAdd)] <- 0
CPI_IP$CovidWeightAdd[CPI_IP$CovidWeightAdd==100] <- 0
CPI_IP <- CPI_IP[with(CPI_IP, order(IP, Date)), ]
CPI_IP$CovidWeight <- CPI_IP$Weight

# CPI_IP$CovidWeightAdd[CPI_IP$CovidWeightAdd < -100] <- -95

for (indIP in unique(CPI_IP$IP)){
  data <- CPI_IP[(CPI_IP$IP == indIP &
                    CPI_IP$Year == 2020),]
  for (ind in 2:nrow(data)){
    data$CovidWeight[ind] <- data$CovidWeight[ind-1]*(data$CovidWeightAdd[ind]/100+1)
  }
  CPI_IP[(CPI_IP$IP == indIP &
            CPI_IP$Year == 2020),] <- data
}


# COVID weights by HG ----
CovidWeightsAdd <- read.xlsx(paste0(data.path, "HGWeights_CovidAddOns.xlsx"))
CovidWeightsAdd$YearMon <- as.Date(CovidWeightsAdd$YearMon)

# get CPI weights "normal"
CPI_HG_Weights <- CPI_Weights[400:411,]
CPI_HG_Weights <- CPI_HG_Weights[,c(2,14:ncol(CPI_HG_Weights))]
names(CPI_HG_Weights)[1] <- c("HG")
CPI_HG_Weights %>%
  pivot_longer(-HG, names_to = "Year", values_to = "Weight",
               values_transform = list(Weight = as.numeric),
               names_transform = list(Year = as.numeric)) -> CPI_HG_Weights

# add weights to CPI index
CPI_HG <- left_join(x = CPI_HG, y = CPI_HG_Weights, by = c("HG", "Year"))
# add COVID add ons
CPI_HG <- left_join(x = CPI_HG, y = CovidWeightsAdd, by = c("HG" = "HG", "Date" = "YearMon"))

# COVID weight calculation
CPI_HG$CovidWeightAdd[is.na(CPI_HG$CovidWeightAdd)] <- 0
CPI_HG$CovidWeightAdd[CPI_HG$CovidWeightAdd==100] <- 0
CPI_HG <- CPI_HG[with(CPI_HG, order(HG, Date)), ]
CPI_HG$CovidWeight <- CPI_HG$Weight2020
for (indHG in 1:12){
  data <- CPI_HG[CPI_HG$HG == indHG,]
  for (ind in 2:nrow(data)){
    data$CovidWeight[ind] <- data$CovidWeight[ind-1]*(data$CovidWeightAdd[ind]/100+1)
  }
  CPI_HG[CPI_HG$HG == indHG,] <- data
}
