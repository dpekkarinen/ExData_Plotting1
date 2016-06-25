# Check to see if the individual household electric power consumption data directory exists; if not , go get the data
if (!file.exists("./household_power_consumption.txt")) {
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", "./household_power_consumption.zip")  
  unzip("./household_power_consumption.zip")
}

# Read in data and subset
powerData <- read.table(file("./household_power_consumption.txt"), header = TRUE, sep=";", stringsAsFactors = FALSE)
powerData$Date <- as.Date(powerData$Date, format="%d/%m/%Y")
powerDataSub <- subset(powerData, Date == "2007-02-01" | Date == "2007-02-02")

# Transform data elements to numerics and create datetime field
powerDataSub$Global_active_power <- as.numeric(as.character(powerDataSub$Global_active_power))
powerDataSub$Global_reactive_power <- as.numeric(as.character(powerDataSub$Global_reactive_power))
powerDataSub$Voltage <- as.numeric(as.character(powerDataSub$Voltage))
powerDataSub <- transform(powerDataSub, datetime = as.POSIXct(paste(Date, Time), format = "%Y-%m-%d %H:%M:%S"))
powerDataSub$Sub_metering_1 <- as.numeric(as.character(powerDataSub$Sub_metering_1))
powerDataSub$Sub_metering_2 <- as.numeric(as.character(powerDataSub$Sub_metering_2))
powerDataSub$Sub_metering_3 <- as.numeric(as.character(powerDataSub$Sub_metering_3))

# Create plot and save to png file
png(file="plot2.png", width = 480, height = 480)
with(powerDataSub,  {
    plot(Global_active_power~datetime, type="l",  ylab = "Global Active Power (kilowatts)", xlab = " ")
    }
)
dev.off()

