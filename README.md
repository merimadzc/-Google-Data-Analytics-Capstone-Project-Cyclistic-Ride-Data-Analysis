# Google Data Analytics Capstone Project: Cyclistic Ride Data Analysis

## Project Description:

This is a case study for Cyclistic, a bike-share company in Chicago. **As a junior data analyst in the marketing analytics team, my role is to help understand how casual riders and annual members use Cyclistic bikes differently. By analyzing the data, we aim to design a new marketing strategy to convert casual riders into annual members, which will maximize the company's revenue and ensure future growth.**

To achieve this goal, we will follow the data analysis process, which includes asking the right questions, preparing the data, processing and analyzing it, sharing the findings, and finally, taking action based on those insights. **We will work alongside different characters and teams, including Lily Moreno, the director of marketing and our manager, and Cyclistic's executive team, who will ultimately approve our recommendations.**

Cyclistic sets itself apart from other bike-share programs by offering various types of bikes, including reclining bikes, hand tricycles, and cargo bikes, making it more inclusive to people with disabilities and those who cannot use standard two-wheeled bikes. The majority of riders use traditional bikes, while about 8% use assistive options. Cyclistic users are more likely to ride for leisure, but around 30% use them to commute to work daily.
The company's finance analysts have found that annual members are much more profitable than casual riders, and Moreno believes that converting casual riders into members will be the key to future growth. Therefore, our team's primary objective is to analyze the historical bike trip data to identify trends and understand how annual members and casual riders differ. We will also explore why casual riders would buy a membership and how digital media could affect our marketing tactics.

**Note:** *This scenario is purely imaginary and part of the Google Data Analytics Capstone Case Study, designed to provide learners with a real-world data analysis experience. The company, Cyclistic, is fictional and any resemblance to real companies is purely coincidental.*

#### The business task:

**The business task of the company Cyclistic is to find solutions for a marketing campaign that will reach casual riders and sell them a membership, with the ultimate goal of maximizing the number of annual memberships sold to their casual users.**

#### Key stakeholders:

**Lily Moreno: The director of marketing and the manager of the team responsible for developing marketing campaigns and initiatives to promote the bike-share program.**
**Cyclistic executive team: The executive team that makes high-level decisions regarding Cyclistic's business goals and approves marketing programs. Their approval is necessary for the success of any marketing campaign developed by the marketing team.**

## Description of Data Sources:

For this analysis, Cyclistic's historical trip data was used as the primary data source. This first-party data was collected by Cyclistic and covers the period from March 2022 to February 2023. The data is organized into separate CSV files, with each month's data consisting of 13 columns. The data can be accessed and downloaded from the following link: <https://divvy-tripdata.s3.amazonaws.com/index.html>. It's important to note that Motivate International Inc. has made this data available under a license agreement and Cyclistic has taken steps to ensure the privacy of its riders is protected. However, it's possible that some data points may be missing, which could potentially impact the results of the analysis.

## Documentation of any cleaning or manipulation of data that has been performed with in R, including code:

The analysis began by downloading the dataset of 12 files in .zip format and unzipping the files. The relevant files and folders were then renamed and moved to the relevant folder. The rest of the analysis was performed using “R and RStudio”, where necessary libraries such as tidyverse, lubridate, ggplot2, dplyr, and hms were imported.

To ensure consistency in the data, the option scipen was set to 100, which displays a maximum of 100 decimal places, and the language was changed to English for weekday names. The 12 csv files, representing trip data for each month, were imported using the read.csv() function and stored as data frames.

Before merging the data frames, it was important to check if all data frames had the same column names using the colnames() function and whether the data in columns were of the same type by using the str() function. The data frames were merged into one large data frame using rbind().

To prepare the merged data frame for further calculations, irrelevant columns were removed, and only relevant columns were kept. It was then checked if there were missing values in the data frame using filter(), and since there were no missing values, no action was taken. The data frame was checked for duplicates using distinct() and duplicated() functions, and since there were no duplicate values, no action was taken.

The format of the started_at and ended_at columns was changed from character to POSIXct using as.POSIXct(). The ride_id column was checked to ensure that all values were of the same length using nchar() and that all values in the member_casual column were either 'member' or 'casual' using factor() function.

A new column ride_length was created that calculates the duration of the ride in seconds using mutate(), hms(), and difftime() functions. The ride_length column was checked for incorrect values using filter() and removed using anti_join(). A new column day_of_week was created to name the day when the ride started using the wday() function.

The average ride length of all users was calculated using summarize(), and the numeric value was converted to a character. 

The average ride length was further analyzed by user type and day of the week, and the numeric result was converted to a string format. The columns of the previous result were renamed, and any rows with missing values were removed. 

The total number of rides per user type was calculated and visualized using a bar chart, with each bar labeled with the respective value. The total number of rides per user type and day of the week was calculated, and any rows with missing values were removed. 

Finally, the total number of rides per month was calculated, and any rows with missing values were removed. 

## A Summary of Data Analysis Findings

* The avg_of_ride_length variable contains the average ride length for all users. This value is in the format of 00:19:13, indicating **an average ride duration of 19 minutes and 13 seconds**.

* The avg_of_ride_length_by_user table shows the average ride length for two user types: casual and member. **The average ride length for casual users was 28 minutes and 56 seconds, while for member users it was only 12 minutes and 34 seconds**. 

* Based on the "avg_of_ride_length_by_day_of_week" table, **it can be observed that casual users have significantly longer rides on average than members**. Specifically, on Sundays, casual users have an average ride length of 33 minutes and 55 seconds, while members have an average ride length of 13 minutes and 56 seconds. Moreover, **the data indicates that casual users are more likely to take longer rides on weekends, whereas members tend to have more consistent ride lengths throughout the week**.

* **The total number of rides is 5829084**, based on the number of rows in the dataset.

* The total number of rides by members is higher than that of casual users, with **3463918 rides by members and 2365065 rides by casual users**.

* **The highest number of rides by casual users occurred on Saturday (478474 rides), while the highest number of rides by members occurred on Sunday (402808 rides)**. The lowest number of rides by casual users occurred on Tuesday (272307 rides), while the lowest number of rides by members occurred on Friday (481191 rides).

* **The highest number of rides occurred in July (823472 rides), while the lowest number of rides occurred in December (181806 rides)**. There is an overall trend of increasing ride numbers from January to July, with a peak in July, followed by a decline from August to December. The months with the highest ride numbers were from May to August, while the months with the lowest ride numbers were from October to December.

## Supporting visualizations in R with ggplot2

### The following visualizations were created to represent different aspects of the ride data:
Average Ride Length by User Type - A bar chart was used to represent the average ride length by user type. The avg_of_ride_length_by_user data was used and visualized using the ggplot function. The x-axis represents user type, the y-axis represents the average ride length, and the bars are filled with different colors for member_casual. The scale_fill_manual function was used to define the colors.

Average Ride Length by User Type and Day of the Week - This visualization shows the average ride length by user type and day of the week. The avg_of_ride_length_by_day_of_week data was used and visualized using the ggplot function. The x-axis represents the day of the week, the y-axis represents the average ride length, and the bars are filled with different colors for member_casual. The geom_bar function with position="dodge" was used to display the bars side-by-side.

Total Number of Rides per User - This bar chart displays the total number of rides per user type. The total_number_of_rides_by_user data was used and visualized using the ggplot function. The x-axis does not display any data, the y-axis represents the total number of rides, and the bars are filled with different colors for member_casual. The geom_text function was used to add labels to each bar.

Total Number of Rides per User and Day of the Week - This grouped bar chart displays the total number of rides per user type and day of the week. The total_number_of_rides_by_user_and_day data was used and visualized using the ggplot function. The x-axis represents the day of the week, the y-axis represents the total number of rides, and the bars are filled with different colors for member_casual. The geom_bar function with position="dodge" was used to display the bars side-by-side.

Total Number of Rides per Month - This bar chart displays the total number of rides per month with a color gradient representing the number of rides. The total_number_of_rides_by_month data was used and visualized using the ggplot function. The x-axis represents the month, the y-axis represents the total number of rides, and the bars are filled with different colors based on the total number of rides. The scale_fill_gradient function was used to define the colors.

# Check out the dashboard for supporting visualizations in [Tableau](https://public.tableau.com/app/profile/merima.dzinovic/viz/Cyclistic_16796697439380/CyclisticRideDataAnalysis)!

## Key findings:

The average ride duration for casual users is almost twice as long as for members, with casual users having an average ride length of 28 minutes and 56 seconds compared to 12 minutes and 34 seconds for members. Users tend to take longer rides on weekends, whereas members have more consistent ride lengths throughout the week. Moreover, there is a difference in the number of rides taken by each user type, with members having a higher number of rides than casual users.

Overall, these findings suggest that members and casual users have distinct usage patterns and preferences. Members tend to use the service more frequently but for shorter durations, while casual users take longer trips, especially on weekends.

## Top three recommendations based on analysis:

1. Cyclistic can utilize digital media to showcase the perks of its annual membership and offer tailored promotions. This could include targeted social media ads and email campaigns to engage with casual riders and emphasize the advantages of membership, such as enhanced bike availability, extended ride times, and discounted future rides.

2. To better serve the needs of current casual users who tend to ride for longer periods, Cyclistic could offer a discount on membership for rides lasting over 30 minutes.

3. Moreover, Cyclistic could introduce membership options that cater to the specific preferences and requirements of customers who are hesitant to commit to an annual plan. For instance, the company could offer weekend-only or summer-only memberships on an annual basis to accommodate users who solely utilize the service during certain times of the year or those who seek greater flexibility than an annual plan but still desire the benefits of membership. By providing a range of membership options, Cyclistic can cater to a wider customer base and deliver personalized solutions to meet their diverse needs. This could boost customer satisfaction and loyalty, leading to increased revenue and growth for the company.
