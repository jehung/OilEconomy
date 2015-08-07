library("Quandl")
library("lubridate")
oilData = read.csv("OIL PRICES.CSV")
date = gsub("/","-", oilData[,1])
b = mdy(date, locale = Sys.getlocale("LC_TIME"))

df <- data.frame(date = b, oilData = oilData[,2])
b1 = strftime(df$date, "%Y/%m")
## This is the base data frame
oil = aggregate(df$oilData ~ b1, FUN = mean)
oil_subset = oil[1:346, ]
oil_percent = diff(log(oil_subset[,2]))

permits_raw = read.csv("BuildingPermits.csv")
date_permits = parse_date_time(permits_raw$Ref_Date, "%Y/%m")
# df_permits is the summarized data sets for time frame since 1948
df_permits = aggregate(permits_raw$Value ~ permits_raw$Ref_Date, FUN = sum)


df_permits_subset = df_permits[457:802, ]
df_permits_percent = diff(log(df_permits_subset[,2]))
df2 = data.frame(oil_subset[2:346,1], oil_percent, df_permits_percent)

export_raw = read.csv("US_CANADA IM_EXPORT.csv")
## The following step is to flip the sign to adjust for the Canadian perspective
export_raw_adj = apply(export_raw[,2:4], 2, function(x) (-1)*x)
export_subset = export_raw_adj[14:359,]
export_percent = diff(log(export_subset[,3]))
df3 = data.frame(df2, export_percent)

inflation_raw = read.csv("CPIAUCSL.csv")
inflation_raw_subset = inflation_raw[470:815,]
inflation_raw_percent = diff(log(inflation_raw_subset[,2]))
df4 = data.frame(df3, inflation_raw_percent)

stock_raw = read.csv("YAHOO-INDEX_S&P.csv")
d = mdy(stock_raw[,1], locale = Sys.getlocale("LC_TIME"))
short_date = strftime(d, "%Y/%m")
df_stock = data.frame(date = d, stockData = stock_raw[,7])
df_stock_agg = aggregate(df_stock$stockData ~ short_date, FUN = mean)
df_stock_subset = df_stock_agg[433:778, ]
df_stock_percent = diff(log(df_stock_subset[,2]))
df5 = data.frame(df4, df_stock_percent)

##df_stock_diff = diff(log(df_stock_agg[,2]))
##df_stock_subset = df_stock_diff[434:779]
##df5 = data.frame(df4, df_stock_subset)

## write csv file for python consumption
write.csv(df5, file = "oilEconomy.csv")
write.table(df5, file = "oilEconomy.txt")
