/*
#1. Check length combinations for ride_id and confirm values are unique as ride_id is a primary key
*/

SELECT LENGTH(ride_id), count(*)
FROM `psyched-subset-395016.cyclistic_trip_dataset.combined_trips_table`
GROUP BY LENGTH(ride_id);

SELECT COUNT (DISTINCT ride_id)
FROM `psyched-subset-395016.cyclistic_trip_dataset.combined_trips_table`;

/*
NOTES: All ride_id strings are 16 characters long and they are all distinct. 
No cleaning necessary on this column. 


#2. Check the allowable rideable_types
*/

SELECT DISTINCT rideable_type
FROM `psyched-subset-395016.cyclistic_trip_dataset.combined_trips_table`;

/*
NOTES: 
As seen above, there are 3 types of 'rideable_type': 
electric_bike, classic_bike, docked_bike.
But docked_bikes is a naming error, should be changed to classic_bike,

#3. Check started_at and ended_at columns.
We only want the rows where the time length of the ride was longer than one minute,
but shorter than one day.
*/

SELECT *
FROM `psyched-subset-395016.cyclistic_trip_dataset.combined_trips_table`
WHERE TIMESTAMP_DIFF(ended_at, started_at, MINUTE) <= 1 OR
   TIMESTAMP_DIFF(ended_at, started_at, MINUTE) >= 1440;

/*
NOTES: 
Seeing as there are 266,657 rows shorter than 1 min or longer than 1 day, these will need to be removed in the cleaning phase.

#4. Check the start/end station name/id columns for naming inconsistencies
*/

SELECT start_station_name, count(*)
FROM `psyched-subset-395016.cyclistic_trip_dataset.combined_trips_table`
GROUP BY start_station_name
ORDER BY start_station_name;


SELECT end_station_name, count(*)
FROM `psyched-subset-395016.cyclistic_trip_dataset.combined_trips_table`
GROUP BY end_station_name
ORDER BY end_station_name;

SELECT COUNT(DISTINCT(start_station_name)) AS unq_startname,
   COUNT(DISTINCT(end_station_name)) AS unq_endname,
   COUNT(DISTINCT(start_station_id)) AS unq_startid,
   COUNT(DISTINCT(end_station_id)) AS unq_endid
FROM `psyched-subset-395016.cyclistic_trip_dataset.combined_trips_table`;

/*
NOTES:
1821 different start stations, “null” being the most popular with 857,860 trips. 
1822 different end stations, “null” being the most popular with 915,655 trips.
1498 unique end and start_station_id’s 
Start and end station names need to be cleaned up:
 -Found starting/end_names with "DIVVY CASSETTE REPAIR MOBILE STATION", "Lyft Driver Center Private Rack",
  "351", "Base - 2132 W Hubbard Warehouse", Hubbard Bike-checking (LBS-WH-TEST), "WEST CHI-WATSON".
   We will delete these as they are maintenance trips.
 -Start and end station id columns have many naming convention errors and different string lengths.
  As they do not offer any use to the analysis and there is no benefit to cleaning them, they will be ignored.


#5. Check NULLS in start and end station name columns
*/

SELECT count(*) as num_of_rides
FROM `psyched-subset-395016.cyclistic_trip_dataset.combined_trips_table`
WHERE start_station_name IS NULL OR
start_station_id IS NULL OR
end_station_name IS NULL OR
end_station_id IS NULL;

/*
NOTES:
Query Results: 1370345
Classic_bikes/docked_bikes will always start and end their trip locked in a docking station,
but electric bikes have more versatility. Electric bikes can be locked up using their bike lock
in the general vicinity of a docking station; thus, trips do not have to start or end at a station.
As such we will do the following:
- remove classic/docked bike trips that do not have a start or end station name and have no start/end station id to use to fill in the null.
- change the null station names to 'On Bike Lock' for electric bikes

#6. Check rows were latitude and longitude are null
*/

SELECT *
FROM `psyched-subset-395016.cyclistic_trip_dataset.combined_trips_table`
WHERE start_lat IS NULL OR
 start_lng IS NULL OR
 end_lat IS NULL OR
 end_lng IS NULL;

/*
NOTE: 
Query Results - 5795 rows where lat/long is missing, we will remove these rows as all rows should have location points

#7. Confirm that there are only 2 member types in the member_casual column:
*/

SELECT DISTINCT member_casual
FROM `psyched-subset-395016.cyclistic_trip_dataset.combined_trips_table`

/*
NOTE: Yes the only values in this field are 'member' or 'casual'
*/
