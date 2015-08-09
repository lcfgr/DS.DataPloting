## Load data.table package
if (!require("data.table")) {
	install.packages("data.table")
	require("data.table")
	}

## Retrieve and prepare data file to be read
fileURL = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileURL,destfile='hpc.zip')
unzip('hpc.zip')

## Read Data file, filter it and create DateTimestamp in text form
power_consumption <- fread('household_power_consumption.txt',na.strings=c("?"),sep=";")
needed_power_consumption <- power_consumption [Date=="1/2/2007" | Date=="2/2/2007"]
needed_power_consumption[,DateTime:=paste(Date,Time)]

# Convert to numeric
needed_power_consumption[,Global_active_power:=as.numeric(Global_active_power)]
needed_power_consumption[,Global_reactive_power:=as.numeric(Global_reactive_power)]
needed_power_consumption[,Voltage:=as.numeric(Voltage)]
needed_power_consumption[,Sub_metering_1:=as.numeric(Sub_metering_1)]
needed_power_consumption[,Sub_metering_2:=as.numeric(Sub_metering_2)]
needed_power_consumption[,Sub_metering_3:=as.numeric(Sub_metering_3)]

## create dataframe to add POSIXlt
needed_power_consumption = as.data.frame(needed_power_consumption)
needed_power_consumption$DateTime =strptime(needed_power_consumption$DateTime,format="%d/%m/%Y %H:%M:%S")

## Plot
dev.new()
par(bg="white")
plot(needed_power_consumption$DateTime,needed_power_consumption$Sub_metering_1,type="l",xlab="",ylab="Energy sub metering")
lines(needed_power_consumption$DateTime,needed_power_consumption$Sub_metering_2,col="red")
lines(needed_power_consumption$DateTime,needed_power_consumption$Sub_metering_3,col="blue")
legend("topright",lty=1, col=c("black","red","blue"),legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

# Create png file with specific resolution
dev.copy(png, file="plot3.png", width=480, height=480)
dev.off()