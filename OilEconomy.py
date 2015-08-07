import Quandl
import pandas as pd
import pyper
from pyper import *

#oilData = Quandl.get("CHRIS/CME_CL1", authtoken="cJcRJ2sMsxTVcxMT8BFr", collapse = "monthly", column = "6")
#print oilData
#
#permitsData = Quandl.get("SGE/CANBP", authtoken="cJcRJ2sMsxTVcxMT8BFr")
#print permitsData



import pandas as pd
pd.merge(oilData, permitsData, on = "Date", how="inner")
