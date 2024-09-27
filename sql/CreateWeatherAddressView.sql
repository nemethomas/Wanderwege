SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CreateWeatherAddressView]
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
    WITH LatestWeather AS (
        SELECT 
            W.*,
            MAX(W.timestamp_apicall) OVER () AS latest_timestamp
        FROM 
            dbo.OPNM_WeatherForecast_1d_H AS W
    )
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
        A.timestamp_apicall AS address_api_timestamp,
        R.name,
        R.timestamp_apicall 
    FROM 
        LatestWeather AS W
    LEFT JOIN 
        dbo.OPNC_Addresses AS A
    ON 
        W.lat = A.lat AND W.lon = A.lon
    LEFT JOIN
        dbo.OVRP_HikingRoutes AS R
    ON W.lat = R.lat AND W.lon = R.lon
    WHERE 
        W.timestamp_apicall = W.latest_timestamp;
    ';

    -- Execute the dynamic SQL to create the view
    EXEC sp_executesql @sql;
END;
GO
