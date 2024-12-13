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

-- [temperature]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'temperature',
    @Description = 'Air temperature at 2 meters above ground (in °C)';

-- [relative_humidity]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'relative_humidity',
    @Description = 'Relative humidity at 2 meters above ground (in %)';

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

-- [cloud_cover]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'cloud_cover',
    @Description = 'Total cloud cover as an area fraction (in %)';

-- [wind_speed]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'wind_speed',
    @Description = 'Wind speed at 10 meters above ground (in km/h)';

-- [sunshine_duration]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'sunshine_duration',
    @Description = 'The number of seconds of sunshine per hour (direct normalized irradiance exceeding 120 W/m², following the WMO definition)';

-- [weather_score]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'weather_score',
    @Description = 'Calculated weather score based on the weather variables';

-- [classification]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'classification',
    @Description = 'Weather classification based on the weather score (< 0.5: bad, 0.5-0.75: ok, >= 0.75: good)';

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

-- [symbol]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'symbol',
    @Description = 'Symbol of the hiking route declaring the type and difficulty';

-------------------------------
-- [dbo].[Google_Elevation] --
-------------------------------

SET @Table = 'Google_Elevation';

-- [id]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'id',
    @Description = 'ID for the waypoint coming from Overpass API';

-- [elevation]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'elevation',
    @Description = 'Elevation in meters';

-- [lat]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'lat',
    @Description = 'Geographical WGS84 latitude of the waypoint';

-- [lon]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'lon',
    @Description = 'Geographical WGS84 longitude of the waypoint';

-- [timestamp_apicall]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'timestamp_apicall',
    @Description = 'Date and time when API call to Google was executed';

----------------------------
-- [dbo].[GEOA_Addresses] --
----------------------------

SET @Table = 'GEOA_Addresses';

-- [id]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'id',
    @Description = 'ID for the hiking route coming from Overpass API';

-- [lat]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'lat',
    @Description = 'Geographical WGS84 latitude of the location used for geocoding';

-- [lon]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'lon',
    @Description = 'Geographical WGS84 longitude of the location used for geocoding';

-- [kanton]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'kanton',
    @Description = 'A subdivision (e.g. district or Bezirk) of a state or country';

-- [gemeindename]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'gemeindename',
    @Description = 'Refers to the smaller administrative unit, usually a municipality, city, or town. It''s a subdivision of the larger state or county';

-- [timestamp_apicall]
EXEC dbo.AddOrUpdateMSDescription
    @SchemaName = @Schema,
    @TableName = @Table,
    @ColumnName = 'timestamp_apicall',
    @Description = 'Date and time when API call to GeoAdmin was executed';

GO