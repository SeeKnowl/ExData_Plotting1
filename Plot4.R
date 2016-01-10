library(RCurl)
library("sqldf")

## Problem - Produce plot 4
## We need to create 4 plots  in 2 by 2 row format on a single plane
## We will use the plots we created in plot 2, plot 3, modify plot 2 to produce the plot on the top righ and bottom right
##

## Step 0 - if the zipped data file does not exist, download the file
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
    if (!file.exists(UnzippedFileName)) 
    {   
      message("Unzipping the data file")
      unzip(DataSetZip, exdir=".")
    }
    
   
## Sql method - a clean method to read a subset of files for the two given dates Feb 1st and 2nd of 2007.
##
    message("Extracting the subset of data for the two given days from the data file")
    PowerConsumption <- read.csv.sql(UnzippedFileName, sql = "select * from file where Date = '1/2/2007' OR Date = '2/2/2007'", header = TRUE, sep = ";")
  
## First we need to combine the Date and Time columns and then format to Posix format using strptime
## DateTime column is used in all 4 plots
    PowerConsumption$DateTime <- strptime(paste(PowerConsumption$Date, PowerConsumption$Time, sep = " "), "%d/%m/%Y %H:%M:%S")

## set the device to plot the graphs in 2 rows and 2 columns format   
    message("Plotting...")
    par(mfrow = c(2, 2))
    
## Top left plot is the plot for Global Active Power vs DateTime
## Global_active_power against the x axis of the newly combined Data and Time field with type = line 
    with(PowerConsumption, plot(DateTime, Global_active_power, type = "l", ylab = "Global Active Power", xlab=""))

## Top right plot is the Voltage on the y axis and DateTime on the x axis, with x asis labeled "datetime"
    with(PowerConsumption, plot(DateTime, Voltage, type = "l", xlab = "datetime", ylab = "Volatge"))

## Bottom left plot - draw the 3 plots for 3 sub metering value sets aganist the Date & Time column and 
## add the legends like we did for plot 3, but without the border
    with(PowerConsumption, plot(DateTime, Sub_metering_1, xlab = "", ylab = "Energy sub metering", type = "l"))
    with(PowerConsumption, lines(DateTime, Sub_metering_2, xlab = "", ylab = "Energy sub metering", col = "red"))
    with(PowerConsumption, lines(DateTime, Sub_metering_3, xlab = "", ylab = "Energy sub metering", col = "blue"))
    
    legend("topright", bty = "n", lty = c(1,1), lwd = c(1,1), col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
    
## Bottom right plot -  Global Reactive POwer values against the Date & Time
## we will not label the  label as per the plot shown in the assignment page
    with(PowerConsumption, plot(DateTime, Global_reactive_power, type = "l", xlab = "datetime"))

## Now let us redirect the plots to a png file to generate plot4.png
## We open the png file, set the mfrow for a 2 x 2 plot format
##
    png(filename = "Plot4.png", width = 480, height = 480)
    par(mfrow = c(2, 2))
    
## Top left plot is the plot 2 (Global Active Power vs DateTime)
    with(PowerConsumption, plot(DateTime, Global_active_power, type = "l", ylab = "Global Active Power", xlab=""))

## Top right plot is the Voltage on the y axis and DateTime on the x axis, with x asis labeled "datetime"    with(PowerConsumption, plot(DateTime, Voltage, type = "l", xlab = "datetime", ylab = "Volatge"))
    with(PowerConsumption, plot(DateTime, Voltage, type = "l", xlab = "datetime", ylab = "Volatge"))

## Bottom left plot - draw the 3 plots for 3 sub metering value sets aganist the Date & Time column and 
## add the legends like we did for plot 3, but without the border
    with(PowerConsumption, plot(DateTime, Sub_metering_1, xlab = "", ylab = "Energy sub metering", type = "l"))
    with(PowerConsumption, lines(DateTime, Sub_metering_2, xlab = "", ylab = "Energy sub metering", col = "red"))
    with(PowerConsumption, lines(DateTime, Sub_metering_3, xlab = "", ylab = "Energy sub metering", col = "blue"))
    legend("topright", bty = "n", lty = c(1,1), lwd = c(1,1), col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
    
## Bottom right plot - Global Reactive POwer values against the Date & Time
## we will not label the  label as per the plot shown in the assignment page
    with(PowerConsumption, plot(DateTime, Global_reactive_power, type = "l", xlab = "datetime"))
    dev.off()
    
