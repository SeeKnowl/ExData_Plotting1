library(RCurl)
library("sqldf")

## Assignment 1 - code to produce the plot 2 - plot of Global_active_power readings from the 
## household power consumption data for Feb 1st and 2nd of the year 2007
##

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

## Sql method - a clean method to read a subset of files for the two given dates Feb 1st and 2nd of 2007.
##
    message("Extracting the subset of data for the two given days from the data file")
    PowerConsumption <- read.csv.sql(UnzippedFileName, sql = "select * from file where Date = '1/2/2007' OR Date = '2/2/2007'", header = TRUE, sep = ";")
  
## Plot 2  draw a plot of Global Active power Vs Date and Time
## First we need to combine the Date and Time columns and then format to Posix format using strptime
## Then we plot the Global_active_power against the newly combined Data and Time field with type = line
    message("Plotting...")
    PowerConsumption$DateTime <- strptime(paste(PowerConsumption$Date, PowerConsumption$Time, sep = " "), "%d/%m/%Y %H:%M:%S")
    par(mfrow = c(1,1))
    with(PowerConsumption, plot(DateTime, Global_active_power, type = "l", ylab = "Global Active Power (kilowatts)", xlab=""))

##  Now let us save the plot to a png file with height and width of 480 pixels
    png(filename = "Plot2.png", width = 480, height = 480)
    with(PowerConsumption, plot(DateTime, Global_active_power, type = "l", ylab = "Global Active Power (kilowatts)", xlab=""))
    dev.off()
    
