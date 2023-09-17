/*
#1 type of ride:
*/

CREATE TABLE cyclistic_trip_dataset.type_of_ride AS
SELECT ride_type, member_casual, count(*) AS amount_of_rides
   FROM psyched-subset-395016.cyclistic_trip_dataset.cleaned_trips_table
   GROUP BY ride_type, member_casual
   ORDER BY member_casual, amount_of_rides DESC

/*
#2 amount of rides per month:
*/
CREATE TABLE cyclistic_trip_dataset.rides_per_month AS
SELECT member_casual, month, count(*) AS num_of_rides
   FROM psyched-subset-395016.cyclistic_trip_dataset.cleaned_trips_table
   GROUP BY member_casual, month

/*
#3 amount of rides per day:
*/
CREATE TABLE cyclistic_trip_dataset.rides_per_day AS
SELECT member_casual, day_of_week, count(*) AS num_of_rides
   FROM psyched-subset-395016.cyclistic_trip_dataset.cleaned_trips_table
   GROUP BY member_casual, day_of_week

/*
#4 amount of rides per hour:
*/
CREATE TABLE cyclistic_trip_dataset.rides_per_hour AS
SELECT member_casual, EXTRACT(HOUR FROM started_at) AS time_of_day, count(*) as num_of_rides
   FROM psyched-subset-395016.cyclistic_trip_dataset.cleaned_trips_table
   GROUP BY member_casual, time_of_day

/*
#5 average length of ride per day:
*/
CREATE TABLE cyclistic_trip_dataset.avg_trip_length AS
SELECT member_casual,
      day_of_week,
      ROUND(AVG(duration_minutes), 0) AS avg_ride_time_minutes,
      AVG(AVG(duration_minutes)) OVER(PARTITION BY member_casual) AS combined_avg_ride_time
   FROM psyched-subset-395016.cyclistic_trip_dataset.cleaned_trips_table
   GROUP BY member_casual, day_of_week

/*
#6 starting docking station location for casuals:
*/
CREATE TABLE cyclistic_trip_dataset.start_station_casual AS
SELECT start_station_name,
      ROUND(AVG(start_lat), 4) AS start_lat,
      ROUND(AVG(start_lng), 4) AS start_lng,  
      count(*) AS num_of_rides
   FROM `psyched-subset-395016.cyclistic_trip_dataset.cleaned_trips_table`
   WHERE member_casual = 'casual' AND start_station_name <> 'On Bike Lock'
   GROUP BY start_station_name

/*
#7 starting docking station location for members:
*/
CREATE TABLE cyclistic_trip_dataset.start_station_member AS
SELECT start_station_name,
      ROUND(AVG(start_lat), 4) AS start_lat,
      ROUND(AVG(start_lng), 4) AS start_lng,  
      count(*) AS num_of_rides
   FROM `psyched-subset-395016.cyclistic_trip_dataset.cleaned_trips_table`
   WHERE member_casual = 'member' AND start_station_name <> 'On Bike Lock'
   GROUP BY start_station_name

/*
#8 ending docking station name for casuals:
*/
CREATE TABLE cyclistic_trip_dataset.end_station_casual AS
SELECT end_station_name,
      ROUND(AVG(start_lat), 4) AS end_lat,
      ROUND(AVG(start_lng), 4) AS end_lng,  
      count(*) AS num_of_rides
   FROM `psyched-subset-395016.cyclistic_trip_dataset.cleaned_trips_table`
   WHERE member_casual = 'casual' AND end_station_name <> 'On Bike Lock'
   GROUP BY end_station_name

/*
#9 ending bike station for members:
*/
CREATE TABLE cyclistic_trip_dataset.end_station_member AS
SELECT end_station_name,
      ROUND(AVG(start_lat), 4) AS end_lat,
      ROUND(AVG(start_lng), 4) AS end_lng,  
      count(*) AS num_of_rides
   FROM `psyched-subset-395016.cyclistic_trip_dataset.cleaned_trips_table`
   WHERE member_casual = 'member' AND end_station_name <> 'On Bike Lock'
   GROUP BY end_station_name

/*
#10 ending bike lock location for casuals:
*/
CREATE TABLE cyclistic_trip_dataset.lock_location_casual AS
SELECT end_lat, end_lng, count(*) AS num_of_rides
   FROM `psyched-subset-395016.cyclistic_trip_dataset.cleaned_trips_table`
   WHERE member_casual = 'casual'
   GROUP BY end_lat, end_lng


#11 ending bike lock location for members:
CREATE TABLE cyclistic_trip_dataset.lock_location_member AS
SELECT end_lat, end_lng, count(*) AS num_of_rides
   FROM `psyched-subset-395016.cyclistic_trip_dataset.cleaned_trips_table`
   WHERE member_casual = 'member'
   GROUP BY end_lat, end_lng
