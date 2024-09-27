-- Script to create a stored procedure to add or update the description of a column in a table

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddOrUpdateMSDescription]
    @SchemaName NVARCHAR(128),
    @TableName NVARCHAR(128),
    @ColumnName NVARCHAR(128),
    @Description NVARCHAR(4000)
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the extended property (MS_Description) already exists for the column
    IF EXISTS (
        SELECT 1
        FROM sys.extended_properties ep
        INNER JOIN sys.columns c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
        INNER JOIN sys.tables t ON c.object_id = t.object_id
        INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
        WHERE ep.name = 'MS_Description'
        AND s.name = @SchemaName
        AND t.name = @TableName
        AND c.name = @ColumnName
    )
    BEGIN
        -- Update the existing extended property
        EXEC sys.sp_updateextendedproperty 
            @name = N'MS_Description', 
            @value = @Description, 
            @level0type = N'SCHEMA', @level0name = @SchemaName, 
            @level1type = N'TABLE',  @level1name = @TableName, 
            @level2type = N'COLUMN', @level2name = @ColumnName;
    END
    ELSE
    BEGIN
        -- Add a new extended property
        EXEC sys.sp_addextendedproperty 
            @name = N'MS_Description', 
            @value = @Description, 
            @level0type = N'SCHEMA', @level0name = @SchemaName, 
            @level1type = N'TABLE',  @level1name = @TableName, 
            @level2type = N'COLUMN', @level2name = @ColumnName;
    END
END;
GO
