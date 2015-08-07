library("Quandl")
library("lubridate")
oilData = read.csv("OIL PRICES.CSV")
date = gsub("/","-", oilData[,1])
a = as.Date(date, format = "%b-%d-%Y") ## This line is not used
b = mdy(date, locale = Sys.getlocale("LC_TIME"))

df <- data.frame(date = b, oilData = oilData[,2])
b1 = strftime(df$date, "%Y/%m")
## This is the base data frame
df1 = aggregate(df$oilData ~ b1, FUN = mean)

permits_raw = read.csv("BuildingPermits.csv")
date_permits = parse_date_time(permits_raw$Ref_Date, "%Y/%m")
# df_permits is the summarized data sets for time frame since 1948
df_permits = aggregate(permits_raw$Value ~ permits_raw$Ref_Date, FUN = sum)
df_permits_subset = subset(df_permits, df_permits[,1] %in% as.character(b1))
df2 = data.frame(df1[1:346, ], df_permits_subset[,2])

export_raw = read.csv("US_CANADA IM_EXPORT.csv")
## The following step is to flip the sign to adjust for the Canadian perspective
export_raw_adj = apply(export_raw[,2:4], 2, function(x) (-1)*x)
export_subset = export_raw_adj[13:358,]
df3 = data.frame(df2, export_subset[,3])

inflation_raw = read.csv("CPIAUCSL.csv")
inflation_raw_adj = diff(log(inflation_raw[,2]))
inflation_subset = inflation_raw_adj[468:813]
df4 = data.frame(df3,inflation_subset)

stock_raw = read.csv("YAHOO-INDEX_S&P.csv")
d = mdy(stock_raw[,1], locale = Sys.getlocale("LC_TIME"))
short_date = strftime(d, "%Y/%m")
df_stock = data.frame(date = d, stockData = stock_raw[,7])
df_stock_agg = aggregate(df_stock$stockData ~ short_date, FUN = mean)
df_stock_diff = diff(log(df_stock_agg[,2]))
df_stock_subset = df_stock_diff[434:779]
df5 = data.frame(df4, df_stock_subset)

## write csv file for python consumption
write.csv(df5, file = "oilEconomy.csv")
write.table(df5, file = "oilEconomy.txt")
