library("Quandl")
library("lubridate")
FRED_data = read.csv("FREDData.CSV", header = TRUE, stringsAsFactors = FALSE)
FRED_data_subset = FRED_data[6:351,]
for (i in 2:74)
    {
        FRED_data_subset[,i] = as.numeric(as.character(FRED_data_subset[,i]))
    }


write.table(FRED_data_subset, file = "oilEconomyFRED.txt")
write.csv(FRED_data_subset, file = "OilEconomyFRED.csv")


