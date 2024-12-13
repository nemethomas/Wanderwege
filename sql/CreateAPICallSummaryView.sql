SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_API_Call_Summary] AS
SELECT
    w.timestamp_apicall,
    MIN(w.date) AS min_date,
    MAX(w.date) AS max_date,
    COUNT(DISTINCT w.id) AS locations,
    COUNT(*) AS data_points,
    COALESCE(SUM(u.unreasonable_count), 0) AS unreasonable_data_points,
    SUM(CASE WHEN w.classification = 'Good' THEN 1 ELSE 0 END) AS classifications_good,
    SUM(CASE WHEN w.classification = 'OK' THEN 1 ELSE 0 END) AS classifications_ok,
    SUM(CASE WHEN w.classification = 'Bad' THEN 1 ELSE 0 END) AS classifications_bad,
    AVG(w.weather_score) AS weather_score_avg,
    STDEV(w.weather_score) AS weather_score_std
FROM
    [dbo].[OPNM_WeatherForecast_1d_H] AS w
LEFT JOIN (
    SELECT
        timestamp_apicall,
        COUNT(*) AS unreasonable_count
    FROM dbo.vw_UnreasonableWeatherData
    GROUP BY timestamp_apicall
) AS u ON w.timestamp_apicall = u.timestamp_apicall
GROUP BY
    w.timestamp_apicall
GO
