# Import required libraries

import json
import os
import pandas as pd
import math
import time

import requests_cache
from retry_requests import retry

# connection to SQL database
import pymssql
from sqlalchemy import create_engine, text



# Load configuration from config/db_config.json
with open('../config/db_config.json', 'r') as f:
    db_config = json.load(f)

# Get database credentials
server = db_config['server']
database = db_config['database']
db_user = db_config['db_user']
db_password = db_config['db_password']


# Add time and datestamp of API call to dataframe
timestamp_autoLocal = pd.Timestamp.now().strftime("%Y-%m-%d %H:%M:%S")
data = {'timestamp_autoLocal': [timestamp_autoLocal]}
df_test = pd.DataFrame(data)



# Create table if it doesn't exist
table_name = "autmationTest_local"
query = f"""
    IF OBJECT_ID(N'dbo.{table_name}', N'U') IS NULL
    BEGIN
        CREATE TABLE {table_name} (
            timestamp_autoLocal DATETIME NOT NULL,

            PRIMARY KEY (timestamp_autoLocal)
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



# Ingest data to tabledatabase table

df_test.to_sql(table_name, con=engine, if_exists='append', index=False)

print("DataFrame erfolgreich in die MSSQL-Datenbank geladen!")
