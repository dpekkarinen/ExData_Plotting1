# Check to see if the individual household electric power consumption data directory exists; if not , go get the data
if (!file.exists("./household_power_consumption.txt")) {
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", "./household_power_consumption.zip")  
  unzip("./household_power_consumption.zip")
}

# Read in data and subset
powerData <- read.table(file("./household_power_consumption.txt"), header = TRUE, sep=";", stringsAsFactors = FALSE, dec=".")
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

# Create histogram plot and save to a png file
png(file="plot4.png", width = 480, height = 480)
par(mfrow = c(2,2))
with(powerDataSub, {
    plot(Global_active_power~datetime, type="l",  ylab = "Global Active Power", xlab = " ")
    plot(Voltage~datetime, type="l", ylab = "Voltage")
    plot(Sub_metering_1~datetime, type="l", ylab = "Energy sub metering", xlab = " ")
      lines(Sub_metering_2~datetime, col = "red")
      lines(Sub_metering_3~datetime, col = "blue")
      legend("topright", col=c("black", "red", "blue"), lty = 1, lwd = 1, bty = "n", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
    plot(Global_reactive_power~datetime, type = "l", ylab = "Global_rective_power")
  }
)
dev.off()