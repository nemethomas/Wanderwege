-- SQL script to create a view in SQL database to join weather data with address data

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CreateWeatherAddressView]
AS
BEGIN
    -- Drop the view if it already exists
    IF OBJECT_ID('dbo.vw_WeatherAddress', 'V') IS NOT NULL
    BEGIN
        DROP VIEW dbo.vw_WeatherAddress;
    END;

    -- Declare a variable to store the dynamic SQL query
    DECLARE @sql NVARCHAR(MAX);

    -- Build the dynamic SQL query for creating the view
    SET @sql = '
    CREATE VIEW dbo.vw_WeatherAddress
    AS
    SELECT 
        W.id,
        W.[date],
        W.lat,
        W.lon,
        W.temperature_2m,
        W.relative_humidity_2m,
        W.dew_point_2m,
        W.apparent_temperature,
        W.precipitation,
        W.rain,
        W.snowfall,
        W.snow_depth,
        W.weather_code,
        W.pressure_msl,
        W.surface_pressure,
        W.cloud_cover,
        W.cloud_cover_low,
        W.cloud_cover_mid,
        W.cloud_cover_high,
        W.wind_speed_10m,
        W.wind_gusts_10m,
        W.is_day,
        W.sunshine_duration,
        W.timestamp_apicall AS weather_api_timestamp,
        A.country,
        A.county,
        A.local_administrative_area,
        A.locality,
        A.postcode,
        A.state,
        A.state_code,
        A.village,
        A.timestamp_apicall AS address_api_timestamp
    FROM 
        dbo.OPNM_WeatherForecast_7d_H AS W
    LEFT JOIN 
        dbo.OPNC_Addresses AS A
    ON 
        W.lat = A.lat AND W.lon = A.lon;
    ';

    -- Execute the dynamic SQL to create the view
    EXEC sp_executesql @sql;
END;
GO
