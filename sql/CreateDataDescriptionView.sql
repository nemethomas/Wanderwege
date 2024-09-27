-- Script to create a view to describe the columns in the tables

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_DataDescription] AS

WITH CTE_COLUMN_INFO_AND_CHECK_CONSTRAINTS AS (
    -- Retrieve information about columns from all tables in database
    SELECT DISTINCT
        SCHEMA_NAME(st.[schema_id]) + '.' + st.[name] AS [Table Name],
        sc.[name] AS [Column Name],			
        isc.DATA_TYPE AS [Data Type],
        sc.max_length AS [Max Length (Bytes)],
        CASE WHEN isc.IS_NULLABLE = 'YES' then 'Yes' else 'No' END AS [Is Nullable],
        ISNULL(ep.[value], 'N/A') AS [Description]		
    FROM sys.tables AS st	
    INNER JOIN sys.columns AS sc 
        ON st.[object_id] = sc.[object_id]
    INNER JOIN information_schema.columns AS isc 
        ON sc.[name] = isc.COLUMN_NAME AND st.[name] = isc.TABLE_NAME															
    LEFT JOIN sys.extended_properties AS ep 
        ON st.[object_id] = ep.major_id AND sc.column_id = ep.minor_id AND ep.[name] = 'MS_Description'					
    LEFT OUTER JOIN sys.check_constraints AS con 
        ON con.parent_column_id = sc.column_id AND con.parent_object_id = sc.[object_id]
    LEFT JOIN sys.computed_columns AS syscc 
        ON syscc.object_id = sc.object_id AND syscc.[name] = sc.[name]
),
CTE_PRIMARY_KEYS AS (
    -- Retrieve primary keys for each table
    SELECT 
        t.[object_id],
        SCHEMA_NAME(t.[schema_id]) + '.' + t.[name] AS table_view,        
        c.[type] AS [Primery Key],
        ISNULL(c.[name], i.[name]) AS constraint_name,
        SUBSTRING(column_names, 1, LEN(column_names)-1) AS [details]
    FROM sys.objects AS t
    LEFT OUTER JOIN sys.indexes AS i
        ON t.[object_id] = i.[object_id]
    LEFT OUTER JOIN sys.key_constraints AS c
        ON i.[object_id] = c.parent_object_id AND i.index_id = c.unique_index_id
    CROSS APPLY (
        SELECT
            col.[name] + ', '
        FROM sys.index_columns AS ic
        INNER JOIN sys.columns AS col
            ON ic.[object_id] = col.[object_id] AND ic.column_id = col.column_id
        WHERE ic.[object_id] = t.[object_id] AND ic.index_id = i.index_id
        ORDER BY col.column_id
        FOR XML PATH ('') 
    ) AS D (column_names)
    WHERE is_unique = 1
    AND t.is_ms_shipped <> 1
)
SELECT 
    CICC.*,
    PK.details AS [Primary Key Constraint]
FROM CTE_COLUMN_INFO_AND_CHECK_CONSTRAINTS AS CICC
INNER JOIN CTE_PRIMARY_KEYS AS PK
    ON CICC.[Table Name] = PK.table_view

GO