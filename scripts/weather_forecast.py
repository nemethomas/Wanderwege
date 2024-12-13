##########################
# Libraries and settings #
##########################

# Import required libraries

import json
import os
import pandas as pd
import math
import time

# Connection to Open-Meteo API
import openmeteo_requests
import requests_cache
from retry_requests import retry

# Connection to SQL database
import pymssql
from sqlalchemy import create_engine, text

#####################
# Get hiking routes #
#####################

# Load database configuration from config/db_config.json
with open('../config/db_config.json', 'r') as f:
    db_config = json.load(f)

# Get database credentials from file
server = db_config['server']
database = db_config['database']
db_user = db_config['db_user']
db_password = db_config['db_password']

# Establish connection to SQL database
conn = pymssql.connect(server, db_user, db_password, database)

# Execute SQL query
query = "SELECT * FROM dbo.OVRP_HikingRoutes"
cursor = conn.cursor()
cursor.execute(query)

# Fetch all the rows from the executed query
rows = cursor.fetchall()

# Fetch the column names from the cursor description
columns = [col[0] for col in cursor.description]

# Store the results in a Pandas DataFrame
df = pd.DataFrame(rows, columns=columns)

# Close the connection
conn.close()

##################
# Open-Meteo API #
##################

# Only keep id, lat ond lon of the subset
df = df[["id", "lat", "lon"]]

with open("../config/api_config.json", 'r') as f:
    api_config = json.load(f)

api_key = api_config["api_key_openmeteo"]

# Setup the Open-Meteo API client with cache and retry on error
cache_session = requests_cache.CachedSession('.cache', expire_after = 3600)
retry_session = retry(cache_session, retries = 5, backoff_factor = 0.2)
openmeteo = openmeteo_requests.Client(session = retry_session)

# URL for the Open-Meteo API
url = "https://customer-api.open-meteo.com/v1/forecast"

# Initialize a list to store data for all locations
all_hourly_data = []

# Define a the size of each batch
batch_size = 100

# Print information about the batch size
print(f"Number of items: {len(df)}")
print(f"Batch size: {batch_size}")
print(f"Number of expected batches: {len(df) // batch_size + 1}")

# Add time and datestamp of API call to dataframe
timestamp_apicall = pd.Timestamp.now().strftime("%Y-%m-%d %H:%M:%S")

# Loop through all batches and make a request for each batch
for i in range(0, len(df), batch_size):
    latitude = list(df[i:i+batch_size]["lat"])
    longitude = list(df[i:i+batch_size]["lon"])

    item_start = i
    item_end = i + len(latitude) - 1
    batch = int((i + batch_size) / batch_size)

    print("-------------------------")
    print(f"Batch: {batch}")
    print(f"Items: {item_start}-{item_end}")
    print(f"Number of items: {len(latitude)}")

    params = {
        "latitude": latitude,
        "longitude": longitude,
        "hourly": [
            "temperature_2m",
            "relative_humidity_2m",
            "rain",
            "snowfall",
            "snow_depth",
            "cloud_cover",
            "wind_speed_10m",
            "sunshine_duration"
        ],
        "timezone": "Europe/Berlin",
        "past_hours": 1,
        "forecast_days": 1,
        "forecast_hours": 24,
        "apikey": api_key
    }
    
    responses = openmeteo.weather_api(url, params=params)

    print(f"Number of fetched items: {len(responses)}")

    # Loop through all responses and extract data for each location and hourly forecast
    for i, response in enumerate(responses):

        # Process first location. Add a for-loop for multiple locations or weather models
        # response = responses[0]
        # print(f"Coordinates {response.Latitude()}°N {response.Longitude()}°E")
        # print(f"Elevation {response.Elevation()} m asl")
        # print(f"Timezone {response.Timezone()} {response.TimezoneAbbreviation()}")
        # print(f"Timezone difference to GMT+0 {response.UtcOffsetSeconds()} s")

        # Define index to be looked up in df_subset
        i_loc = item_start + i

        # Process hourly data for this location
        hourly = response.Hourly()
        
        # Extract variables (note: needs to be the same order as in request)
        hourly_data = {
            "id": df["id"].iloc[i_loc],
            "date": pd.date_range(
                start=pd.to_datetime(hourly.Time(), unit="s", utc=True),
                end=pd.to_datetime(hourly.TimeEnd(), unit="s", utc=True),
                freq=pd.Timedelta(seconds=hourly.Interval()),
                inclusive="left"
            ),
            "temperature": hourly.Variables(0).ValuesAsNumpy(),
            "relative_humidity": hourly.Variables(1).ValuesAsNumpy(),
            "rain": hourly.Variables(2).ValuesAsNumpy(),
            "snowfall": hourly.Variables(3).ValuesAsNumpy(),
            "snow_depth": hourly.Variables(4).ValuesAsNumpy(),
            "cloud_cover": hourly.Variables(5).ValuesAsNumpy(),
            "wind_speed": hourly.Variables(6).ValuesAsNumpy(),
            "sunshine_duration": hourly.Variables(7).ValuesAsNumpy(),
            "timestamp_apicall": timestamp_apicall,
        }
        # Convert to DataFrame and append to list
        all_hourly_data.append(pd.DataFrame(hourly_data))

# Concatenate all location data into a single DataFrame
all_hourly_data = pd.concat(all_hourly_data)

###################
# Weather Scoring #
###################

def calculate_hiking_weather_score(data):
    """
    Calculate the final hiking weather score and the corresponding classification with seasonality adjustments.
    
    Parameters:
    - data (dict): Weather data with keys:
        'date', 'temperature', 'relative_humidity', 'rain', 'snowfall', 'snow_depth', 'cloud_cover', 'wind_speed', 'sunshine_duration'
    
    Returns:
    - dict: Scores for each factor and the final weighted score.
    """

    # Define season based on date
    if data["date"].month in [3, 4, 5]:
        season = "spring"
    elif data["date"].month in [6, 7, 8]:
        season = "summer"
    elif data["date"].month in [9, 10, 11]:
        season = "autumn"
    else:
        season = "winter"

    # Define seasonal weights
    weights = {
        "spring": {
            "temperature": 0.30, "relative_humidity": 0.15, "rain": 0.20, 
            "snowfall": 0.05, "snow_depth": 0.05, "cloud_cover": 0.10, 
            "wind_speed": 0.05, "sunshine": 0.10
        },
        "summer": {
            "temperature": 0.30, "relative_humidity": 0.15, "rain": 0.20, 
            "snowfall": 0.10, "snow_depth": 0.05, "cloud_cover": 0.10, 
            "wind_speed": 0.05, "sunshine": 0.05
        },
        "autumn": {
            "temperature": 0.25, "relative_humidity": 0.10, "rain": 0.20, 
            "snowfall": 0.10, "snow_depth": 0.10, "cloud_cover": 0.10, 
            "wind_speed": 0.05, "sunshine": 0.05
        },
        "winter": {
            "temperature": 0.25, "relative_humidity": 0.10, "rain": 0.20, 
            "snowfall": 0.15, "snow_depth": 0.15, "cloud_cover": 0.10, 
            "wind_speed": 0.05, "sunshine": 0.05
        }
    }

    # Scoring functions
    def score_temperature(temperature, season):
        if season in ["autumn", "winter"]:
            return max(0, 1 - abs(temperature - 5) / 10)  # Ideal range: -5°C to 15°C
        else:
            score = max(0, 1 - abs(temperature - 17.5) / 7.5)  # Ideal range: 10°C to 25°C
            return score - max(0, (temperature - 30) / 10)  # Penalize extreme heat

    def score_relative_humidity(humidity):
        return 1 - min(humidity / 100, 1)

    def score_rain(rain):
        return max(0, 1 - rain / 5)

    def score_snowfall(snowfall, season):
        if season == "winter":
            return max(0, 1 - snowfall / 10)  # More tolerance in winter
        return max(0, 1 - snowfall / 5)

    def score_snow_depth(snow_depth, season):
        if season == "winter":
            return max(0, 1 - snow_depth / 30)  # More tolerance in winter
        return max(0, 1 - snow_depth / 15)

    def score_cloud_cover(cloud_cover, season):
        if season in ["autumn", "winter"]:
            return max(0.5, 1 - cloud_cover / 200)  # More tolerance for cloud cover
        return 1 - min(cloud_cover / 100, 1)

    def score_wind_speed(wind_speed, season):
        base_score = max(0, 1 - wind_speed / 15)
        if season == "winter":
            return base_score - max(0, (wind_speed - 20) / 10)  # Penalize high wind in winter
        return base_score

    def score_sunshine_duration(sunshine_duration, season):
        sunshine_ratio  = sunshine_duration / 3600.0  # # Normalize to 0-1 range
        return min(1, sunshine_ratio)

    # Individual scores
    scores = {
        "temperature": score_temperature(data["temperature"], season),
        "relative_humidity": score_relative_humidity(data["relative_humidity"]),
        "rain": score_rain(data["rain"]),
        "snowfall": score_snowfall(data["snowfall"], season),
        "snow_depth": score_snow_depth(data["snow_depth"], season),
        "cloud_cover": score_cloud_cover(data["cloud_cover"], season),
        "wind_speed": score_wind_speed(data["wind_speed"], season),
        "sunshine": score_sunshine_duration(data["sunshine_duration"], season),
    }

    # Final weighted score
    season_weights = weights[season]
    final_score = sum(scores[key] * season_weights[key] for key in scores)

    # Determine classification
    if final_score >= 0.75:
        classification = "Good"
    elif 0.5 <= final_score < 0.75:
        classification = "OK"
    else:
        classification = "Bad"

    return {"scores":  scores, "final_score": final_score, "classification": classification}

# Calculate weather scores
all_hourly_data["scores"] = all_hourly_data.apply(calculate_hiking_weather_score, axis=1)
all_hourly_data["weather_score"] = all_hourly_data["scores"].apply(lambda x: x["final_score"])
all_hourly_data["classification"] = all_hourly_data["scores"].apply(lambda x: x["classification"])

# Remove column scores
all_hourly_data = all_hourly_data.drop("scores", axis=1)

#############
# Ingestion #
#############

# Create table if it doesn't exist
table_name = "OPNM_WeatherForecast_1d_H"
query = f"""
    IF OBJECT_ID(N'dbo.{table_name}', N'U') IS NULL
    BEGIN
        CREATE TABLE {table_name} (
            id                      INT         NOT NULL,
            date                    DATETIME    NOT NULL,
            temperature             FLOAT       NULL,
            relative_humidity       FLOAT       NULL,
            rain                    FLOAT       NULL,
            snowfall                FLOAT       NULL,
            snow_depth              FLOAT       NULL,
            cloud_cover             FLOAT       NULL,
            wind_speed              FLOAT       NULL,
            sunshine_duration       INT         NULL,
            weather_score           FLOAT       NULL,
            classification          VARCHAR(10) NULL,
            timestamp_apicall       DATETIME    NOT NULL,

            PRIMARY KEY (id, date, timestamp_apicall),
            CONSTRAINT FK_WeatherForecast_HikingRoutes FOREIGN KEY (id) REFERENCES dbo.OVRP_HikingRoutes(id)
        );
    END
    """

conn = pymssql.connect(server, db_user, db_password, database)
cursor = conn.cursor()
cursor.execute(query)

conn.commit()
conn.close()

# Create connection string for SQLAlchemy
connection_string = f"mssql+pymssql://{db_user}:{db_password}@{server}/{database}"
engine = create_engine(connection_string)

# Ingest data to database table
all_hourly_data.to_sql(table_name, con=engine, if_exists='append', index=False)