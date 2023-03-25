#----------------PREPARING LIBRARIES AND ENVIRONMENT SETUP----------#

# Loading necessary libraries
library(tidyverse)
library(lubridate)
library(ggplot2)
library(dplyr)
library(hms) # For converting time values

# Set the scientific notation display option to 100 decimal places
options(scipen = 100) 
# Changing language to English for weekday names
Sys.setlocale("LC_TIME", "en_US.UTF-8")

#-----------------------PREPARING DATA----------------------------------#

# Importing csv files as data frames using the readr library
df_032022 <- read.csv("202203-divvy-tripdata.csv")
df_042022 <- read.csv("202204-divvy-tripdata.csv")
df_052022 <- read.csv("202205-divvy-tripdata.csv")
df_062022 <- read.csv("202206-divvy-tripdata.csv")
df_072022 <- read.csv("202207-divvy-tripdata.csv")
df_082022 <- read.csv("202208-divvy-tripdata.csv")
df_092022 <- read.csv("202209-divvy-tripdata.csv")
df_102022 <- read.csv("202210-divvy-tripdata.csv")
df_112022 <- read.csv("202211-divvy-tripdata.csv")
df_122022 <- read.csv("202212-divvy-tripdata.csv")
df_012023 <- read.csv("202301-divvy-tripdata.csv")
df_022023 <- read.csv("202302-divvy-tripdata.csv")

# Checking whether all data frames have the same column names before merging
colnames(df_022023)
colnames(df_012023)
colnames(df_122022)
colnames(df_112022)
colnames(df_102022)
colnames(df_092022)
colnames(df_082022)
colnames(df_072022)
colnames(df_062022)
colnames(df_052022)
colnames(df_042022)
colnames(df_032022)

# Before merging rows, check if data in columns are of the same type
str(df_022023)
str(df_012023)
str(df_122022)
str(df_112022)
str(df_102022)
str(df_092022)
str(df_082022)
str(df_072022)
str(df_062022)
str(df_052022)
str(df_042022)
str(df_032022)

# Merge all data frames into one large data frame using rbind()
df_cyclistic <- rbind(df_022023, df_012023, 
                      df_122022, df_112022, 
                      df_102022, df_092022, 
                      df_082022, df_072022, 
                      df_062022, df_052022, 
                      df_042022, df_032022)

# Recreate the df_cyclistic data frame with relevant data and columns for calculations
df_cyclistic <- df_cyclistic %>%
  select(ride_id, rideable_type, started_at, ended_at, member_casual)

#-----------------------PROCESSING DATA---------------------------------#

# Check if there are missing values in df_cyclistic
missing_values <- df_cyclistic %>%
  filter(ride_id == "" | rideable_type == "" | 
           started_at == "" | 
           ended_at == "" | "member_casual" == "")
View(missing_values) # No data available in table

# Check for duplicates in the dataframe
distinct_values <- df_cyclistic %>% 
  distinct(ride_id, rideable_type, started_at, ended_at, member_casual, 
             keep_all = FALSE) %>%
  filter(duplicated(df_cyclistic)) #No data available in table

# Columns started_at and ended_at contain date and time information, so I change their format from 'character' to 'POSIXct'
df_cyclistic$started_at <- as.POSIXct(df_cyclistic$started_at, format = "%Y-%m-%d %H:%M:%S")
df_cyclistic$ended_at <- as.POSIXct(df_cyclistic$ended_at, format = "%Y-%m-%d %H:%M:%S")
str(df_cyclistic) 

# Additional check: Are all values in the ride_id column of the same length?
df_cyclistic %>%
  select(ride_id) %>%
  filter(nchar(ride_id) > 16 | nchar(ride_id) < 16) # 0 rows

# Additional check: Are all values in the member_casual column 'member' or 'casual'?
factor(df_cyclistic$member_casual) # Levels: casual member

# Creating a new column ride_length that calculates the duration of the ride in seconds
df_cyclistic <- df_cyclistic %>%
  mutate(ride_length = hms(seconds_to_period(as.numeric(difftime(ended_at, started_at, units = "secs")))))

# Finding incorrect values
incorrect_data <- df_cyclistic %>%
  filter(ride_length < 00:00:00)

# Removing incorrect values
df_cyclistic <- anti_join(df_cyclistic, incorrect_data, by="ride_id")

#-----------------------ANALYZING DATA----------------------------------#

# Creating a new column day_of_week that names the day when the ride started using the started_at date
df_cyclistic <- df_cyclistic %>%
  mutate(day_of_week = wday(started_at, label = TRUE, abbr = FALSE))

# Calculating the average ride length of all users and converting the numeric to char
avg_of_ride_length <- df_cyclistic %>%
  summarize(avg_of_ride_length = substr(
    format(hms(seconds_to_period(mean(ride_length, na.rm = TRUE))), 
           format = "%H:%M:%S.%OS"), 1, 8)) 
print(avg_of_ride_length)

# Calculate the average ride length by member_casual column and convert the numeric to char
avg_of_ride_length_by_user <- df_cyclistic %>%
  group_by(member_casual) %>%
  summarize(avg_of_ride_length = substr(
    format(hms(seconds_to_period(mean(ride_length, na.rm = TRUE))), 
           format = "%H:%M:%S.%OS"), 1, 8)) 
print(avg_of_ride_length_by_user)

# Calculate the average ride length by user type and day of the week
avg_of_ride_length_by_day_of_week <- df_cyclistic %>%
  group_by(member_casual, day_of_week) %>%
  summarize(avg_of_ride_length_by_day_of_week = substr(
    format(hms(seconds_to_period(mean(ride_length, na.rm = TRUE))), 
           format = "%H:%M:%S.%OS"), 1, 8)) 

# Rename columns in avg_of_ride_length_by_day_of_week
colnames(avg_of_ride_length_by_day_of_week) <- c("User Type", "Day of Week", "Average Trip Length")

# Remove NA values from avg_of_ride_length_by_day_of_week
avg_of_ride_length_by_day_of_week <- na.omit(avg_of_ride_length_by_day_of_week)

# Total number of rides per user
total_number_of_rides_by_user <- df_cyclistic %>%
  group_by(member_casual) %>%
  summarize(total_number_of_rides_by_user = n())

# Total number of rides per user and day of the week
total_number_of_rides_by_user_and_day <- df_cyclistic %>%
  group_by(member_casual, day_of_week) %>%
  summarize(total_number_of_rides_u_d = n())

# Removing NA values
total_number_of_rides_by_user_and_day <- na.omit(total_number_of_rides_by_user_and_day)

# Total number of rides per month
total_number_of_rides_by_month <- df_cyclistic %>%
  group_by(month = month(started_at)) %>%
  summarize(total_number_of_rides_by_month = n())

# Removing NA values
total_number_of_rides_by_month <- na.omit(total_number_of_rides_by_month)


#-----------------------VISUALIZING DATA--------------------------------#

# Visualize the average ride length by user type
ggplot(data = avg_of_ride_length_by_user, aes(x = member_casual, y = avg_of_ride_length, fill = member_casual)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = c("#424787", "#E680A8")) +
  labs(title = "Average ride length by user", x = "User Type", y = "Average of ride length")

# Visualize the average ride length by user type and day of the week in seconds
ggplot(data = avg_of_ride_length_by_day_of_week, aes(x = `Day of Week`, y = `Average Trip Length`, fill = `User Type`)) +
  geom_bar(position="dodge", stat = "identity") +
  scale_fill_manual(values = c("#424787", "#E680A8")) +
  labs(title = "Average ride length by user and day of the week", x = "Day of the week", y = "Average of ride length")

# Visualization of the total number of rides per user, pie chart 
ggplot(data = total_number_of_rides_by_user, aes(x = "", y = total_number_of_rides_by_user, fill = member_casual)) +
  geom_bar(width = 1, stat = "identity") +
  scale_fill_manual(values = c("#424787", "#E680A8")) +
  labs(title = "Total number of rides by members and casual users", x = "", y = "") +
  geom_text(aes(y = total_number_of_rides_by_user/2 + c(0, cumsum(total_number_of_rides_by_user)[-length(total_number_of_rides_by_user)]),
                label = total_number_of_rides_by_user),
            color = "white") +
  coord_polar(theta = "y", start=0) +
  theme_void()

# Visualization of the total number of rides per user and day of the week
ggplot(data = total_number_of_rides_by_user_and_day, aes(x = day_of_week, y = total_number_of_rides_u_d, fill = member_casual)) +
  geom_bar(position="dodge", stat = "identity") + 
  scale_fill_manual(values = c("#424787", "#E680A8")) +
  labs(title="Total number of rides by user and day of the week", x="Day of the week", y="Total number of rides") +
  scale_y_continuous(limits = c(0, 600000))

# Visualization of the total number of rides per month 
ggplot(data = total_number_of_rides_by_month, aes(x = month, y = total_number_of_rides_by_month, fill = total_number_of_rides_by_month)) +
  geom_bar(stat="identity") +
  scale_fill_gradient(low = "#7D86FF", high = "#34386B") +
  labs(title="Total number of rides per month in the year 2022-2023", x="Months", y="Number of rides") +
  scale_x_continuous(breaks = 1:12, labels = 1:12) +
  theme(legend.position = "none")