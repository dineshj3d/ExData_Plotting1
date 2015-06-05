## Exploratory Data Analysis  Course Project 1

# Make sure needed packages loaded
if ( !(require(dplyr) && require(lubridate)) ) {
    stop ("You need to install the dplyr, lubridate packages to run this script")
}

# only download if zip file has not been downloaded before
if ( !file.exists(zipFile) ) {
    download.file(sourceUrl, zipFile)
}

## download and unzip file to ./data folder
sourceUrl <- "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipFile <- "household_power_consumption.zip"  # file to be downloaded
dataDir <- "./data"      # This is where the files will be unzipped to

# unzip the files (will do nothing if we previously did this)
filepaths <- unzip(zipFile, exdir="./data")

## Read downloaded file 

dataEpc <- read.csv (file="./data/household_power_consumption.txt"
                     ,header=TRUE
                        ,sep =";"
                            ,stringsAsFactors = FALSE)
dataEpc <- tbl_df(dataEpc)
## alternate way to read csv file and filter on date
## dataEpc2007 <- read.csv.sql("./data/household_power_consumption.txt"
##                    ,sql = 'select * from file where Date = "2/1/2007" OR Date = "2/2/2007"'
##                        ,sep =";")
## closeAllConnections()


## Select only 2 days worth of observations

dataEpc2007 <- filter(dataEpc,Date == '2/1/2007' | Date == "2/2/2007")

## verify needs records are there.
filter(dataEpc2007,Date == '2/1/2007')
filter(dataEpc2007,Date == '2/2/2007')


## convert variables to numeric
dataEpc2007$Global_active_power = as.numeric(dataEpc2007$Global_active_power)
dataEpc2007$Global_reactive_power = as.numeric(dataEpc2007$Global_reactive_power)
dataEpc2007$Voltage = as.numeric(dataEpc2007$Voltage)
dataEpc2007$Sub_metering_1 = as.numeric(dataEpc2007$Sub_metering_1)
dataEpc2007$Sub_metering_2 = as.numeric(dataEpc2007$Sub_metering_2)
dataEpc2007$Sub_metering_3 = as.numeric(dataEpc2007$Sub_metering_3)
dataEpc2007$Date = as.Date(mdy(dataEpc2007$Date))

## add a Weekday column "Mon", "Tue" etc
dataEpc2007 <- mutate(dataEpc2007, Weekday = wday(mdy(Date), label = TRUE, abbr = TRUE))
dataEpc2007$Weekday = as.character(dataEpc2007$Weekday)

## add Timestamp column
dataEpc2007 <- transform(dataEpc2007, Timestamp=as.POSIXct(paste(Date, Time)))

## dataEpc, not needed

rm(dataEpc)

## Plot 3

plot(dataEpc2007$Timestamp,dataEpc2007$Sub_metering_1
     ,ylab = "Global Active Power (kilowatts)",xlab="",type="l",ylim=c(0.5, 40))
lines(dataEpc2007$Timestamp,dataEpc2007$Sub_metering_2)
lines(dataEpc2007$Timestamp,dataEpc2007$Sub_metering_3)

dev.copy(png, file="plot3.png")  ## write plot to fill
dev.off ## close pdf file device
