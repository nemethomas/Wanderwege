SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[vw_UnreasonableWeatherData] AS
SELECT
    id,
    date,
    timestamp_apicall,
    CASE
        WHEN temperature < -40 OR temperature > 40 THEN 'temperature'
        WHEN relative_humidity < 0 OR relative_humidity > 100 THEN 'relative_humidity'
        WHEN rain < 0 OR rain > 50 THEN 'rain'
        WHEN snowfall < 0 OR snowfall > 30 THEN 'snowfall'
        WHEN snow_depth < 0 OR snow_depth > 5 THEN 'snow_depth'
        WHEN cloud_cover < 0 OR cloud_cover > 100 THEN 'cloud_cover'
        WHEN wind_speed < 0 OR wind_speed > 150 THEN 'wind_speed'
        WHEN sunshine_duration < 0 OR sunshine_duration > 3600 THEN 'sunshine_duration'
    END AS variable,
    CASE
        WHEN temperature < -40 THEN temperature
        WHEN temperature > 40 THEN temperature
        WHEN relative_humidity < 0 THEN relative_humidity
        WHEN relative_humidity > 100 THEN relative_humidity
        WHEN rain < 0 THEN rain
        WHEN rain > 50 THEN rain
        WHEN snowfall < 0 THEN snowfall
        WHEN snowfall > 30 THEN snowfall
        WHEN snow_depth < 0 THEN snow_depth
        WHEN snow_depth > 5 THEN snow_depth
        WHEN cloud_cover < 0 THEN cloud_cover
        WHEN cloud_cover > 100 THEN cloud_cover
        WHEN wind_speed < 0 THEN wind_speed
        WHEN wind_speed > 150 THEN wind_speed
        WHEN sunshine_duration < 0 THEN sunshine_duration
        WHEN sunshine_duration > 3600 THEN sunshine_duration
    END AS value,
    CASE
        WHEN temperature < -40 THEN temperature - (-40)
        WHEN temperature > 40 THEN temperature - 40
        WHEN relative_humidity < 0 THEN relative_humidity - 0
        WHEN relative_humidity > 100 THEN relative_humidity - 100
        WHEN rain < 0 THEN rain - 0
        WHEN rain > 50 THEN rain - 50
        WHEN snowfall < 0 THEN snowfall - 0
        WHEN snowfall > 30 THEN snowfall - 30
        WHEN snow_depth < 0 THEN snow_depth - 0
        WHEN snow_depth > 5 THEN snow_depth - 5
        WHEN cloud_cover < 0 THEN cloud_cover - 0
        WHEN cloud_cover > 100 THEN cloud_cover - 100
        WHEN wind_speed < 0 THEN wind_speed - 0
        WHEN wind_speed > 150 THEN wind_speed - 150
        WHEN sunshine_duration < 0 THEN sunshine_duration - 0
        WHEN sunshine_duration > 3600 THEN sunshine_duration - 3600
    END AS difference_from_range,
    CASE
        WHEN temperature < -40 THEN 100.0 * (temperature - (-40)) / 40
        WHEN temperature > 40 THEN 100.0 * (temperature - 40) / 40
        WHEN relative_humidity < 0 THEN 100.0 * (relative_humidity - 0) / 100
        WHEN relative_humidity > 100 THEN 100.0 * (relative_humidity - 100) / 100
        WHEN rain < 0 THEN 100.0 * (rain - 0) / 50
        WHEN rain > 50 THEN 100.0 * (rain - 50) / 50
        WHEN snowfall < 0 THEN 100.0 * (snowfall - 0) / 30
        WHEN snowfall > 30 THEN 100.0 * (snowfall - 30) / 30
        WHEN snow_depth < 0 THEN 100.0 * (snow_depth - 0) / 5
        WHEN snow_depth > 5 THEN 100.0 * (snow_depth - 5) / 5
        WHEN cloud_cover < 0 THEN 100.0 * (cloud_cover - 0) / 100
        WHEN cloud_cover > 100 THEN 100.0 * (cloud_cover - 100) / 100
        WHEN wind_speed < 0 THEN 100.0 * (wind_speed - 0) / 150
        WHEN wind_speed > 150 THEN 100.0 * (wind_speed - 150) / 150
        WHEN sunshine_duration < 0 THEN 100.0 * (sunshine_duration - 0) / 3600
        WHEN sunshine_duration > 3600 THEN 100.0 * (sunshine_duration - 3600) / 3600
    END AS percentual_difference
FROM [dbo].[OPNM_WeatherForecast_1d_H]
WHERE 
    temperature < -40 OR temperature > 40 OR
    relative_humidity < 0 OR relative_humidity > 100 OR
    rain < 0 OR rain > 50 OR
    snowfall < 0 OR snowfall > 30 OR
    snow_depth < 0 OR snow_depth > 5 OR
    cloud_cover < 0 OR cloud_cover > 100 OR
    wind_speed < 0 OR wind_speed > 150 OR
    sunshine_duration < 0 OR sunshine_duration > 3600;
GO
