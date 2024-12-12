SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

    CREATE VIEW [dbo].[vw_WeatherAddressRoute]
    AS
    WITH LatestWeather AS (
        SELECT 
            *
        FROM 
            dbo.OPNM_WeatherForecast_1d_H AS W
        WHERE
            timestamp_apicall = (SELECT MAX(timestamp_apicall) FROM dbo.OPNM_WeatherForecast_1d_H)
    )
    SELECT 
         W.[id]
        ,W.[date]
        ,W.[temperature]
        ,W.[relative_humidity]
        ,W.[rain]
        ,W.[snowfall]
        ,W.[snow_depth]
        ,W.[cloud_cover]
        ,W.[wind_speed]
        ,W.[sunshine_duration]
        ,W.[weather_score]
        ,W.[classification]
        ,W.[timestamp_apicall] AS weather_api_timestamp
        ,R.[id] AS R_id
        ,R.[name] AS RouteName
        ,R.[lat]
        ,R.[lon]
        ,R.[symbol]
        ,R.[timestamp_apicall] AS route_api_timestamp
        ,A.[id] AS A_id
        ,A.[lat] AS A_lat
        ,A.[lon] AS A_lon
        ,A.[gemeindename]
        ,A.[kanton]
        ,A.[timestamp_apicall] AS address_api_timestamp
    FROM 
        LatestWeather AS W
    LEFT JOIN 
        dbo.OVRP_HikingRoutes AS R
    ON 
        W.id = R.id
    LEFT JOIN
        dbo.GEOA_Addresses AS A
    ON W.id = A.id
    
GO
