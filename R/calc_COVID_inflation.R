
# inflation calculation IP ----
# for any month, calculate two indices based on two different weighting schemes
# such that, when calculating inflation, you can leave the 'basket' constant
CPI_CovidBasket <- CPI_IP

CPI_CovidBasket$CovidWeight_Lead1 <- lead(CPI_CovidBasket$CovidWeight, n = 1)
CPI_CovidBasket$CovidWeight_Lead1[CPI_CovidBasket$Date == max(CPI_CovidBasket$Date)] <- NA
# create indices with the two weighting schemes
# lead 1 (mom)
CPI_CovidBasket_IP_agg_1 <- summarise(
  group_by(CPI_CovidBasket, Date),
  CPI_CovidBasket_t = wtd.mean(CPI, weights = CovidWeight, normwt = T),
  CPI_CovidBasket_tlead1 = wtd.mean(CPI, weights = CovidWeight_Lead1, normwt = T)
)
CPI_CovidBasket_IP_agg_1$CPI_CovidBasket_tlead1 <- lag(CPI_CovidBasket_IP_agg_1$CPI_CovidBasket_tlead1)
CPI_CovidBasket_IP_agg_1$CPI_CovidBasket_MoM <- c(CPI_CovidBasket_IP_agg_1$CPI_CovidBasket_t-CPI_CovidBasket_IP_agg_1$CPI_CovidBasket_tlead1)/(CPI_CovidBasket_IP_agg_1$CPI_CovidBasket_tlead1)*100

# lead 12 (yoy)
CPI_CovidBasket$CovidWeight_Lead12 <- lead(CPI_CovidBasket$CovidWeight, n = 12)
CPI_CovidBasket$CovidWeight_Lead12[CPI_CovidBasket$Date %in% c((max(CPI_CovidBasket$Date)-months(11)):max(CPI_CovidBasket$Date))] <- NA
# create indices with the two weighting schemes
CPI_CovidBasket_IP_agg_12 <- summarise(
  group_by(CPI_CovidBasket, Date),
  CPI_CovidBasket_t = wtd.mean(CPI, weights = CovidWeight, normwt = T),
  CPI_CovidBasket_tlead12 = wtd.mean(CPI, weights = CovidWeight_Lead12, normwt = T)
)
CPI_CovidBasket_IP_agg_12$CPI_CovidBasket_tlead12 <- lag(CPI_CovidBasket_IP_agg_12$CPI_CovidBasket_tlead12, n = 12)
CPI_CovidBasket_IP_agg_12$CPI_CovidBasket_YoY <- c(CPI_CovidBasket_IP_agg_12$CPI_CovidBasket_t-CPI_CovidBasket_IP_agg_12$CPI_CovidBasket_tlead12)/(CPI_CovidBasket_IP_agg_12$CPI_CovidBasket_tlead12)*100


# inflation calculation HG ----
# for any month, calculate two indices based on two different weighting schemes
# such that, when calculating inflation, you can leave the 'basket' constant
CPI_CovidBasket <- CPI_HG

CPI_CovidBasket$CovidWeight_Lead1 <- lead(CPI_CovidBasket$CovidWeight, n = 1)
CPI_CovidBasket$CovidWeight_Lead1[CPI_CovidBasket$Date == max(CPI_CovidBasket$Date)] <- NA
# create indices with the two weighting schemes
# lead 1 (mom)
CPI_CovidBasket_agg_1 <- summarise(
  group_by(CPI_CovidBasket, Date),
  CPI_CovidBasket_t = wtd.mean(CPI, weights = CovidWeight, normwt = T),
  CPI_CovidBasket_tlead1 = wtd.mean(CPI, weights = CovidWeight_Lead1, normwt = T)
)
CPI_CovidBasket_agg_1$CPI_CovidBasket_tlead1 <- lag(CPI_CovidBasket_agg_1$CPI_CovidBasket_tlead1)
CPI_CovidBasket_agg_1$CPI_CovidBasket_MoM <- c(CPI_CovidBasket_agg_1$CPI_CovidBasket_t-CPI_CovidBasket_agg_1$CPI_CovidBasket_tlead1)/(CPI_CovidBasket_agg_1$CPI_CovidBasket_tlead1)*100

# lead 12 (yoy)
CPI_CovidBasket$CovidWeight_Lead12 <- lead(CPI_CovidBasket$CovidWeight, n = 12)
CPI_CovidBasket$CovidWeight_Lead12[CPI_CovidBasket$Date %in% c((max(CPI_CovidBasket$Date)-months(11)):max(CPI_CovidBasket$Date))] <- NA
# create indices with the two weighting schemes
CPI_CovidBasket_agg_12 <- summarise(
  group_by(CPI_CovidBasket, Date),
  CPI_CovidBasket_t = wtd.mean(CPI, weights = CovidWeight, normwt = T),
  CPI_CovidBasket_tlead12 = wtd.mean(CPI, weights = CovidWeight_Lead12, normwt = T)
)
CPI_CovidBasket_agg_12$CPI_CovidBasket_tlead12 <- lag(CPI_CovidBasket_agg_12$CPI_CovidBasket_tlead12, n = 12)
CPI_CovidBasket_agg_12$CPI_CovidBasket_YoY <- c(CPI_CovidBasket_agg_12$CPI_CovidBasket_t-CPI_CovidBasket_agg_12$CPI_CovidBasket_tlead12)/(CPI_CovidBasket_agg_12$CPI_CovidBasket_tlead12)*100
