/*
#1. Find and remove classic/docked bike trips which do not begin or end at a docking station
*/

DELETE
FROM `psyched-subset-395016.cyclistic_trip_dataset.combined_trips_table`
WHERE
rideable_type = "classic_bike" AND
start_station_name IS NULL

DELETE
FROM `psyched-subset-395016.cyclistic_trip_dataset.combined_trips_table`
WHERE
rideable_type = "classic_bike" AND
start_station_id IS NULL

DELETE
FROM `psyched-subset-395016.cyclistic_trip_dataset.combined_trips_table`
WHERE
rideable_type = "classic_bike" AND
end_station_name IS NULL

DELETE
FROM `psyched-subset-395016.cyclistic_trip_dataset.combined_trips_table`
WHERE
rideable_type = "classic_bike" AND
end_station_id IS NULL

DELETE
FROM `psyched-subset-395016.cyclistic_trip_dataset.combined_trips_table`
WHERE
rideable_type = "docked_bike" AND
start_station_name IS NULL
  
DELETE
FROM `psyched-subset-395016.cyclistic_trip_dataset.combined_trips_table`
WHERE
rideable_type = "docked_bike" AND
start_station_id IS NULL

DELETE
FROM `psyched-subset-395016.cyclistic_trip_dataset.combined_trips_table`
WHERE
rideable_type = "docked_bike" AND
end_station_name IS NULL

DELETE
FROM `psyched-subset-395016.cyclistic_trip_dataset.combined_trips_table`
WHERE
rideable_type = "docked_bike" AND
end_station_id IS NULL

/*
#2. Remove rows that do not have a starting/ending latitude and longitude
*/
  
DELETE
FROM `psyched-subset-395016.cyclistic_trip_dataset.combined_trips_table`
WHERE
start_lat IS NULL OR start_lng IS NULL

DELETE
FROM `psyched-subset-395016.cyclistic_trip_dataset.combined_trips_table`
WHERE
end_lat IS NULL OR end_lng IS NULL

/*
#3. Replace occurrences of docked_bike with classic bike by:
a) creating a new column called “ride_type” and saving the results as a table, and
b) Querying from new table all but old rideable_type column and saving results the finished table
*/

CREATE TABLE cyclistic_trip_dataset.combined_trips_extra_column as (
SELECT
REPLACE(rideable_type, 'docked_bike', 'classic_bike') AS ride_type,
*
FROM
`psyched-subset-395016.cyclistic_trip_dataset.combined_trips_table`)

CREATE TABLE cyclistic_trip_dataset.combined_trips_2types as (
SELECT
*
except(rideable_type)
FROM `psyched-subset-395016.cyclistic_trip_dataset.combined_trips_extra_column`)

/*
#4 Remove rows that contain bike maintenance and testing data
*/

DELETE
FROM `psyched-subset-395016.cyclistic_trip_dataset.combined_trips_2types`
WHERE
start_station_name = "DIVVY CASSETTE REPAIR MOBILE STATION" OR
start_station_name = "Lyft Driver Center Private Rack" OR
start_station_name = '351' OR
start_station_name = 'Base - 2132 W Hubbard Warehouse' OR
start_station_name = 'Hubbard Bike-checking (LBS-WH-TEST)' OR
start_station_name = 'WEST CHI-WATSON' OR
end_station_name = 'DIVVY CASSETTE REPAIR MOBILE STATION' OR
end_station_name = 'Lyft Driver Center Private Rack' OR
end_station_name = '351' OR
end_station_name = 'Base - 2132 W Hubbard Warehouse' OR
end_station_name = 'Hubbard Bike-checking (LBS-WH-TEST)'
  
/*
#5 Remove rows when ride time was less than one minute or greater than a 24 hr
*/
  
DELETE
FROM `psyched-subset-395016.cyclistic_trip_dataset.combined_trips_2types`
WHERE TIMESTAMP_DIFF(ended_at, started_at, MINUTE) <= 1 OR
   TIMESTAMP_DIFF(ended_at, started_at, MINUTE) >= 1440;
  
/*
#6 Create a columns for trip duration, day of the week, and month and save results as table
*/

SELECT
*,
TIMESTAMP_DIFF(ended_at, started_at, MINUTE) AS duration_minutes,
format_date('%A', started_at) AS day_of_week,
format_date('%B', started_at) AS month,
FROM `psyched-subset-395016.cyclistic_trip_dataset.combined_trips_2types`

/*
The original table contained 5,779,444 rows of data. The table now has 5,511,772 clean rows of data to analyze. That’s 267,672 rows removed that would have otherwise skewed results.
*/
