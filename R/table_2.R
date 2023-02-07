
CPIRatesTable <- data.frame(
  Date = CPI_HG_agg$Date,
  CPIMoM = CPI_HG_agg$CPIMoM,
  COVIDMoM = CPI_CovidBasket_agg_1$CPI_CovidBasket_MoM,
  CPIYoY = CPI_HG_agg$CPIYoY,
  COVIDYoY = CPI_CovidBasket_agg_12$CPI_CovidBasket_YoY
)
CPIRatesTable <- CPIRatesTable[CPIRatesTable$Date >= "2020-01-01",]
CPIRatesTable$Date <- c("January", "February", "March", "April", "May")
names(CPIRatesTable) <- c("", "CPI", "Covid basket", "CPI ", "Covid basket ")

CPIRatesTable <- format(CPIRatesTable, digits = 1)
write_csv(CPIRatesTable, paste0(output.path, "table_2.csv"))
