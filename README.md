## AIT-614
### This repository contains the AIT 614 project

1.'Traffic_Violations.csv' is the raw data file used for analysis.Save this file on your local machine and use the path at which this file is saved in the R code.

2. In the 'Code.R' file , mention the path of the raw data file while reading the file into a dataframe.
  #Read the file into a dataframe
  tv <- read_csv("<path>")

3.Once the preprocessing is done, the 'CleanData.csv' is outputted.Mention the path where you want this file to be saved.
  write.csv(clean_data,"<path>",row.names=TRUE)




