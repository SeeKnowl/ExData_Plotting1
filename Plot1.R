library(RCurl)
library("sqldf")

## Produce the plot in a PNG file for assignment
## From the power consumption data file extracting the data for Feb 1st and Feb 2nd of the year 2007.
## Plot1 is a histogram of Global Active Power reading on those 2 days

## Step 0 - download the files
## Set up the URL, Zip file directory, zip file name
## Check if the zip file exists before we download
    FileURL = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    DownloadDir <- "."
    DataSetZip <- "exdata-data-household_power_consumption.zip"
    UnzippedFileName <- "household_power_consumption.txt"
    DownloadedZip <- paste(DownloadDir, DataSetZip, sep = "/")

## the setInternet2 command is needed to overcome download.file issues on the Windows machine.
    setInternet2(use = TRUE)
    if (!file.exists(DownloadedZip)) {
        message("Downloading the data file")
        download.file(FileURL, DownloadedZip)
    
    }

## unzip the file - check if the file exists before we unzip
    setwd(DownloadDir)
    if (!file.exists(UnzippedFileName)) {
        message("Unzipping the data file")
        unzip(DataSetZip, exdir=".")
    }


## Trial run to read the complete file
## read the file into a data frame
## PowerConsumptionAll <- read.csv(UnzippedFileName, header = TRUE, sep = ";", stringsAsFactors = FALSE)
    
## method 2 - using Read table function, skipping the lines to get up to the required lines
## ColumnNames <- names(read.table(UnzippedFileName, nrow = 1, header = TRUE, sep = ";"))
## PowerConsumption <- read.table(UnzippedFileName, header = FALSE, na.strings = "?", col.names = ColumnNames, sep = ";", stringsAsFactors = FALSE, skip=grep("1/2/2007", readLines(UnzippedFileName)), nrows = 2880)
    
## Sql method - elegant method to only extract those rows that correspond to the 2 days
## We read the file using sqldf package and executing a sql query during the file read
    message("Extracting the subset of data for the two given days from the data file")
    PowerConsumption <- read.csv.sql(UnzippedFileName, sql = "select * from file where Date = '1/2/2007' OR Date = '2/2/2007'", header = TRUE, sep = ";")
  
## Plot the Histogram of Global Active Power; set the main text and X axis label; set the color to Red
## Save the file to a png format of height and width of 480
    message("Plotting....")
    par(mfrow = c(1,1))
    hist(PowerConsumption$Global_active_power, col = "red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)")
    png(filename = "Plot1.png", width = 480, height = 480)
    hist(PowerConsumption$Global_active_power, col = "red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)")
    dev.off()