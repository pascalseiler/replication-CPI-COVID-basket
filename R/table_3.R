
IncidenceTab <- data.frame(
  HG =trimws(CPI[400:411,5]),
  CPIMoM = CPI_HG$CPIMoM[CPI_HG$Date == "2020-04-01"],
  WeightCPI = CPI_HG$Weight2020[CPI_HG$Date == "2020-04-01"],
  WeightCOVID = CPI_HG$CovidWeight[CPI_HG$Date == "2020-04-01"]/sum(CPI_HG$CovidWeight[CPI_HG$Date == "2020-04-01"])*100
)
IncidenceTab$IncidenceCPI <- IncidenceTab$CPIMoM*IncidenceTab$WeightCPI/100
IncidenceTab$IncidenceCOVID <- IncidenceTab$CPIMoM*IncidenceTab$WeightCOVID/100

IncidenceTab$HG <- unique(subset(CPI_Weights) %>%
                            filter(PosType == 2) %>%
                            select(PosTxt_E) %>%
                            unlist())

IncidenceTab %>%
  mutate(
    CPIMoM = format(CPIMoM, digits = 1),
    WeightCPI = format(WeightCPI, digits = 2, nsmall = 2),
    WeightCOVID = format(WeightCOVID, digits = 1, nsmall = 2),
    IncidenceCPI = format(IncidenceCPI, digits = 0, nsmall = 2),
    IncidenceCOVID = format(IncidenceCOVID, digits = 0, nsmall = 2)
  ) -> IncidenceTab

names(IncidenceTab) <- c("Main group", "CPI inflation", "CPI", "Covid basket", "CPI ", "Covid basket ")

write_csv(IncidenceTab, paste0(output.path, "table_3.csv"))
