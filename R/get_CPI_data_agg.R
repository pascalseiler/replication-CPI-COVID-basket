
# read data (FSO)
CPI <- read.xlsx(xlsxFile = paste0(data.path, "su-d-05.02.68.xlsx"),
                 startRow = 4)

# isolate aggregate CPI index
CPI_Total <- CPI[1,8:ncol(CPI)]
CPI_Total <- as.data.frame(t(CPI_Total))
names(CPI_Total) <- "CPI"
CPI_Total$Date <- seq(as.Date("1982-12-01"), by = "month", length.out = nrow(CPI_Total))
CPI_Total$CPI <- as.numeric(as.character(CPI_Total$CPI))

# calculate inflation (mom, yoy)
CPI_Total$CPIMoM <- c(rep(NA,1), diff(CPI_Total$CPI, lag = 1))/lag(CPI_Total$CPI, n = 1)*100
CPI_Total$CPIYoY <- c(rep(NA,12), diff(CPI_Total$CPI, lag = 12))/lag(CPI_Total$CPI, n = 12)*100
