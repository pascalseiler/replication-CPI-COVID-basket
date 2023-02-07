
# read data (Consumption Monitoring Switzerland)
DebitCardData <- read.csv(paste0(data.path, "Merchanttype_Grossregion.csv"))

# restrict on Swiss cards and POS transactions
Expenditure_CH <- subset(DebitCardData) %>%
  filter(COUNTRY == "CHE", TYPE == "POS")
Expenditure_CH$ISSUINGBASEAMOUNT <- as.numeric(as.character(Expenditure_CH$ISSUINGBASEAMOUNT))

# expenditure per category over time
Expenditure_CH_Cat <- summarise(
  group_by(Expenditure_CH, FINALPROCESSINGDATE, OURCATEGORY, OURCODE),
  Exp = sum(ISSUINGBASEAMOUNT, na.rm=T)
)
names(Expenditure_CH_Cat) <- c("Date", "Cat", "Code", "Exp")

# date transformations
Expenditure_CH_Cat$Month <- substr(Expenditure_CH_Cat$Date, start = 4, stop = 6)
Expenditure_CH_Cat$Year <- substr(Expenditure_CH_Cat$Date, start = 8, stop = 9)
Expenditure_CH_Cat$Day <- substr(Expenditure_CH_Cat$Date, start = 1, stop = 2)

Expenditure_CH_Cat$Month[Expenditure_CH_Cat$Month == "JAN"] <- "01"
Expenditure_CH_Cat$Month[Expenditure_CH_Cat$Month == "FEB"] <- "02"
Expenditure_CH_Cat$Month[Expenditure_CH_Cat$Month == "MAR"] <- "03"
Expenditure_CH_Cat$Month[Expenditure_CH_Cat$Month == "APR"] <- "04"
Expenditure_CH_Cat$Month[Expenditure_CH_Cat$Month == "MAY"] <- "05"
Expenditure_CH_Cat$Month[Expenditure_CH_Cat$Month == "JUN"] <- "06"
Expenditure_CH_Cat$Month[Expenditure_CH_Cat$Month == "JUL"] <- "07"
Expenditure_CH_Cat$Month[Expenditure_CH_Cat$Month == "AUG"] <- "08"
Expenditure_CH_Cat$Month[Expenditure_CH_Cat$Month == "SEP"] <- "09"
Expenditure_CH_Cat$Month[Expenditure_CH_Cat$Month == "OCT"] <- "10"
Expenditure_CH_Cat$Month[Expenditure_CH_Cat$Month == "NOV"] <- "11"
Expenditure_CH_Cat$Month[Expenditure_CH_Cat$Month == "DEC"] <- "12"

Expenditure_CH_Cat$Year[Expenditure_CH_Cat$Year == "19"] <- "2019"
Expenditure_CH_Cat$Year[Expenditure_CH_Cat$Year == "20"] <- "2020"

Expenditure_CH_Cat$Date <- as.Date(paste0(Expenditure_CH_Cat$Year, "-", Expenditure_CH_Cat$Month, "-",
                                          Expenditure_CH_Cat$Day))
Expenditure_CH_Cat$YearMon <- as.Date(paste0(Expenditure_CH_Cat$Year, "-", Expenditure_CH_Cat$Month, "-01"))
Expenditure_CH_Cat$KW <- strftime(Expenditure_CH_Cat$Date, format = "%V")

Expenditure_CH_Cat <- Expenditure_CH_Cat[with(Expenditure_CH_Cat, order(Cat, Date)), ]

# weekly aggregation of daily expenditure per category
Expenditure_CH_KWAgg <- summarise(
  group_by(Expenditure_CH_Cat, Cat, Code, Year, KW),
  Exp = sum(Exp, na.rm=T)
)
Expenditure_CH_KWAgg$KWDate <- paste0(Expenditure_CH_KWAgg$Year,"-",Expenditure_CH_KWAgg$KW)

# normalisation
KWRestrict <- c("2020-01", "2020-02", "2020-03", "2020-04", "2020-05", "2020-06")
Base <- subset(Expenditure_CH_KWAgg) %>%
  filter(KWDate %in% KWRestrict)
Base <- summarise(
  group_by(Base, Cat),
  BaseNorm = sum(Exp)/length(KWRestrict)
)
Expenditure_CH_KWAgg <- left_join(x = Expenditure_CH_KWAgg, y = Base, by = ("Cat"))
Expenditure_CH_KWAgg$NormExp <- (Expenditure_CH_KWAgg$Exp/Expenditure_CH_KWAgg$BaseNorm-1)*100

Expenditure_CH_KWAgg$ExpChange <- c(rep(NA,1), diff(Expenditure_CH_KWAgg$NormExp, lag = 1))/lag(Expenditure_CH_KWAgg$NormExp, n = 1)*100
Expenditure_CH_KWAgg$ExpChange[Expenditure_CH_KWAgg$KWDate == "2019-01"] <- NA

# transform calendar weeks into dates
Expenditure_CH_KWAgg$Date <- MMWRweek2Date(MMWRyear = as.numeric(Expenditure_CH_KWAgg$Year),
                                           MMWRweek = as.numeric(Expenditure_CH_KWAgg$KW))

# rename categories
Expenditure_CH_KWAgg %>%
  mutate(
    Cat = case_when(Cat == "Accomodation & Food" ~ "Accommodation & food",
                    Cat == "Human Health Services" ~ "Human health services",
                    Cat == "Motor & Vehicles" ~ "Motor & vehicles",
                    Cat == "Professional Services" ~ "Professional services",
                    TRUE ~ Cat
              )
  ) -> Expenditure_CH_KWAgg

