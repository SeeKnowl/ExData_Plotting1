library(RCurl)
library("sqldf")

## Produce the plot 3 as shown in assignment 1
## Read the data from the power consumption file for the 2 specific dates
## Generate 3 line plots for the Sub_meter readings 1 thru 3 against the reformatted combined Data & Time fields.
## Add the legends as shown in the plot 3

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
    if (!file.exists(UnzippedFileName)) 
    {   
      message("Unzipping the data file")
      unzip(DataSetZip, exdir=".")
    }


## Sql method - a clean method to read a subset of files for the two given dates Feb 1st and 2nd of 2007.
##
    message("Extracting the subset of data for the two given days from the file")
    PowerConsumption <- read.csv.sql(UnzippedFileName, sql = "select * from file where Date = '1/2/2007' OR Date = '2/2/2007'", header = TRUE, sep = ";")
## We combine the Date and Time character strings and format to Date and time
    PowerConsumption$DateTime <- strptime(paste(PowerConsumption$Date, PowerConsumption$Time, sep = " "), "%d/%m/%Y %H:%M:%S")
    
## Plot 3 - plot of sub meter values vs Date and Time
## We first draw the line plot of the combined Date Time column vs Sub_metering_1 mainly Kitcen
## then we add the line for the second plot Date Time vs Sub_metering 2 for the laundry room with color = red
## we then add the thrid line for the plot of Date Time Vs Sub_metering_3 for the water heater and air conditioner
## Finally we add the legend, plot it and then save to the PNG file - we use lty and lwd for the legends to show correctly
    message("Plotting...")
    par(mfrow = c(1,1))
    with(PowerConsumption, plot(DateTime, Sub_metering_1, xlab = "", ylab = "Energy sub metering", type = "l"))
  
    with(PowerConsumption, lines(DateTime, Sub_metering_2, xlab = "", ylab = "Energy sub metering", col = "red"))
    
    with(PowerConsumption, lines(DateTime, Sub_metering_3, xlab = "", ylab = "Energy sub metering", col = "blue"))
    
    legend("topright", lty=c(1,1), lwd = c(1,1), col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
## Save the plot to the file
    message("Saving the plot to a PNG file")
    png(filename = "Plot3.png", width = 480, height = 480)
    with(PowerConsumption, plot(DateTime, Sub_metering_1, xlab = "", ylab = "Energy sub metering", type = "l"))
    
    with(PowerConsumption, lines(DateTime, Sub_metering_2, xlab = "", ylab = "Energy sub metering", col = "red"))
    
    with(PowerConsumption, lines(DateTime, Sub_metering_3, xlab = "", ylab = "Energy sub metering", col = "blue"))
    
    legend("topright", lty=c(1,1), lwd = c(1, 1), col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
    dev.off()
   