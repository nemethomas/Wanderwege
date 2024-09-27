-- Script used to describe the columns in the tables

USE [www_db]
GO

-- Declare variables for schema and table

DECLARE @Schema NVARCHAR(128) = 'dbo';
DECLARE @Table NVARCHAR(128);

-- Add descriptions for columns in table

---------------------------------------
-- [dbo].[OPNM_WeatherForecast_1d_H] --
---------------------------------------

SET @Table = 'OPNM_WeatherForecast_1d_H';

-- [id]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'id',
    @Description = 'ID for the hiking route coming from Overpass API';

-- [date]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'date',
    @Description = 'Date and time (hourly) for which the weather forecast is valid';

-- [lat]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'lat',
    @Description = 'Geographical WGS84 latitude of the location coming from Overpass API (hiking route mid point)';

-- [lon]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'lon',
    @Description = 'Geographical WGS84 longitude of the location coming from Overpass API (hiking route mid point)';

-- [temperature_2m]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'temperature_2m',
    @Description = 'Air temperature at 2 meters above ground (in °C)';

-- [relative_humidity_2m]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'relative_humidity_2m',
    @Description = 'Relative humidity at 2 meters above ground (in %)';

-- [dew_point_2m]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'dew_point_2m',
    @Description = 'Dew point temperature at 2 meters above ground (in °C)';

-- [apparent_temperature]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'apparent_temperature',
    @Description = 'Apparent temperature is the perceived feels-like temperature combining wind chill factor, relative humidity and solar radiation (in °C)';

-- [precipitation]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'precipitation',
    @Description = 'Total precipitation (rain, showers, snow) sum of the preceding hour (in mm)';

-- [rain]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'rain',
    @Description = 'Rain from large scale weather systems of the preceding hour (in mm)';

-- [snowfall]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'snowfall',
    @Description = 'Snowfall amount of the preceding hour (in cm)';

-- [snow_depth]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'snow_depth',
    @Description = 'Snow depth on the ground (in m)';

-- [weather_code]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'weather_code',
    @Description = 'Weather condition as a numeric code. WMO weather interpretation codes: see https://www.nodc.noaa.gov/archive/arc0021/0002199/1.1/data/0-data/HTML/WMO-CODE/WMO4677.HTM)';

-- [pressure_msl]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'pressure_msl',
    @Description = 'Atmospheric air pressure reduced to mean sea level (msl)';

-- [surface_pressure]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'surface_pressure',
    @Description = 'Atmospheric pressure at surface. Surface pressure gets lower with increasing elevation.';

-- [cloud_cover]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'cloud_cover',
    @Description = 'Total cloud cover as an area fraction (in %)';

-- [cloud_cover_low]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'cloud_cover_low',
    @Description = 'Low level clouds and fog up to 3 km altitude (in %)';

-- [cloud_cover_mid]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'cloud_cover_mid',
    @Description = 'Mid level clouds from 3 to 8 km altitude (in %)';

-- [cloud_cover_high]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'cloud_cover_high',
    @Description = 'High level clouds from 8 km altitude (in %)';

-- [wind_speed_10m]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'wind_speed_10m',
    @Description = 'Wind speed at 10 meters above ground (in km/h)';

-- [wind_gusts_10m]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'wind_gusts_10m',
    @Description = 'Gusts at 10 meters above ground as a maximum of the preceding hour (in km/h)';

-- [is_day]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'is_day',
    @Description = '1 if the current time step has daylight, 0 at night';

-- [sunshine_duration]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'sunshine_duration',
    @Description = 'The number of seconds of sunshine per hour (direct normalized irradiance exceeding 120 W/m², following the WMO definition)';

-- [timestamp_apicall]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'timestamp_apicall',
    @Description = 'Date and time when API call to Open-Meteo was executed';

----------------------------
-- [dbo].[OPNC_Addresses] --
----------------------------

SET @Table = 'OPNC_Addresses';

-- [lat]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'lat',
    @Description = 'Geographical WGS84 latitude of the location coming from Overpass API (hiking route mid point)';

-- [lon]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'lon',
    @Description = 'Geographical WGS84 longitude of the location coming from Overpass API (hiking route mid point)';

-- [country]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'country',
    @Description = 'The name of the country where the geocoded location is found';

-- [county]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'county',
    @Description = 'A subdivision (e.g. district or Bezirk) of a state or country';

-- [local_administrative_area]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'local_administrative_area',
    @Description = 'Refers to the smaller administrative unit, usually a municipality, city, or town. It''s a subdivision of the larger state or county';

-- [locality]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'locality',
    @Description = 'A specific populated place within an area, often a neighborhood, village, or district within a city or town';

-- [postcode]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'postcode',
    @Description = 'A postal code (also called a zip code) that corresponds to a specific geographic area, used for mail sorting';

-- [state]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'state',
    @Description = 'Name of the state (Kanton in Switzerland, Bundesland in Germany)';

-- [state_code]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'state_code',
    @Description = 'The official abbreviation of the state (Kanton in Switzerland, Bundesland in Germany)';

-- [village]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'village',
    @Description = 'A small settlement or community, smaller than a town, typically found in rural areas';

-- [timestamp_apicall]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'timestamp_apicall',
    @Description = 'Date and time when API call to OpenCage Geocoding was executed';

-------------------------------
-- [dbo].[OVRP_HikingRoutes] --
-------------------------------

SET @Table = 'OVRP_HikingRoutes';

-- [id]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'id',
    @Description = 'ID for the hiking route coming from Overpass API';

-- [name]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'name',
    @Description = 'Name of the hiking route (if not available: compound of starting and end point)';

-- [lat]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'lat',
    @Description = 'Geographical WGS84 latitude of the location coming from Overpass API (hiking route mid point)';

-- [lon]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'lon',
    @Description = 'Geographical WGS84 longitude of the location coming from Overpass API (hiking route mid point)';

-- [timestamp_apicall]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'timestamp_apicall',
    @Description = 'Date and time when API call to Overpass was executed';

GO