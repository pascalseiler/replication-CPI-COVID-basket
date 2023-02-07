
# read data (FSO)
CPI <- read.xlsx(xlsxFile = paste0(data.path, "su-d-05.02.68.xlsx"),
                 startRow = 4)

CPI_IP <- subset(CPI) %>%
  filter(PosType == 4)
CPI_IP <- CPI_IP[,c(2,8:ncol(CPI))]
names(CPI_IP) <- c("IP",
                   as.character(seq(as.Date("1982-12-01"), by = "month", length.out = ncol(CPI_IP)-1)))

CPI_IP %>%
  mutate(
    across(c(1:ncol(.)), as.numeric)
  ) %>%
  pivot_longer(-IP, names_to = "Date", values_to = "CPI",
               names_transform = as.character, values_transform = as.character) %>%
  mutate(
    Date = as.Date(Date),
    Year = year(Date)
  ) -> CPI_IP

# add 2020 CPI weights 2020 to IP
CPI_IP_Weights <- subset(CPI) %>%
  filter(PosType == 4) %>%
  select(c("PosNo", "2020"))
names(CPI_IP_Weights) <- c("IP", "Weight2020")
CPI_IP_Weights$Weight2020 <- as.numeric(as.character(CPI_IP_Weights$Weight))

CPI_IP <- left_join(x = CPI_IP, y = CPI_IP_Weights, by = c("IP"))
CPI_IP_agg <- summarise(
  group_by(CPI_IP, Date),
  CPI_IP = wtd.mean(CPI, weights = Weight2020, normwt = T)
)
CPI_IP$CPIMoM <- c(rep(NA,1), diff(CPI_IP$CPI, lag = 1))/lag(CPI_IP$CPI, n = 1)*100
CPI_IP$CPIMoM[CPI_IP$Date == "1982-12-01"] <- NA

# calculate inflation (mom, yoy)
CPI_IP_agg$CPIMoM <- c(rep(NA,1), diff(CPI_IP_agg$CPI_IP, lag = 1))/lag(CPI_IP_agg$CPI_IP, n = 1)*100
CPI_IP_agg$CPIYoY <- c(rep(NA,12), diff(CPI_IP_agg$CPI_IP, lag = 12))/lag(CPI_IP_agg$CPI_IP, n = 12)*100
