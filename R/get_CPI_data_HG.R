
# read data (FSO)
CPI <- read.xlsx(xlsxFile = paste0(data.path, "su-d-05.02.68.xlsx"),
                 startRow = 4)

# isolate CPI indexes by HG
CPI_HG <- CPI[400:411,]
CPI_HG <- CPI_HG[,c(2,8:ncol(CPI))]
names(CPI_HG) <- c("HG",
                   seq(as.Date("1982-12-01"), by = "month", length.out = ncol(CPI_HG)-1))
CPI_HG %>%
  mutate(
    across(c(1:ncol(.)), as.numeric)
  ) %>%
  pivot_longer(-HG, names_to = "Date", values_to = "CPI",
               names_transform = as.character, values_transform = as.character) -> CPI_HG

# type transformations
CPI_HG <- CPI_HG[with(CPI_HG, order(HG)), ]
CPI_HG$Date <- rep(seq(as.Date("1982-12-01"), by = "month", length.out = length(8:ncol(CPI))), 12)
CPI_HG$CPI <- as.numeric(as.character(CPI_HG$CPI))
CPI_HG$Year <- year(CPI_HG$Date)

# add 2020 CPI weights 2020 to HG
CPI_HG_Weights <- CPI[400:411,c(2,7)]
names(CPI_HG_Weights) <- c("HG", "Weight2020")
CPI_HG_Weights$Weight2020 <- as.numeric(as.character(CPI_HG_Weights$Weight))

CPI_HG <- left_join(x = CPI_HG, y = CPI_HG_Weights, by = c("HG"))
CPI_HG_agg <- summarise(
  group_by(CPI_HG, Date),
  CPI_HG = wtd.mean(CPI, weights = Weight2020, normwt = T)
)
CPI_HG$CPIMoM <- c(rep(NA,1), diff(CPI_HG$CPI, lag = 1))/lag(CPI_HG$CPI, n = 1)*100
CPI_HG$CPIMoM[CPI_HG$Date == "1982-12-01"] <- NA
CPI_HG$CPIYoY <- c(rep(NA,12), diff(CPI_HG$CPI, lag = 12))/lag(CPI_HG$CPI, n = 12)*100
CPI_HG$CPIYoY[year(CPI_HG$Date) %in% 1982:1983] <- NA

# calculate inflation (mom, yoy)
CPI_HG_agg$CPIMoM <- c(rep(NA,1), diff(CPI_HG_agg$CPI_HG, lag = 1))/lag(CPI_HG_agg$CPI_HG, n = 1)*100
CPI_HG_agg$CPIYoY <- c(rep(NA,12), diff(CPI_HG_agg$CPI_HG, lag = 12))/lag(CPI_HG_agg$CPI_HG, n = 12)*100

