# WanderWetter: What is the weather like on my hiking route?

## Description

This repository contains the scripts used to create a data engineering pipeline to visualize weather for selected hiking routes in Switzerland, created as part of the group project of the CAS Data Engineering HS 2024 at ZHAW.

There are different scripts that handle the generation (via API calls to external providers), ingestion (feed to own database) and transformation (data wrangling and further processing) of data used for this project. Furthermore, the data is then leveraged to build a dynamic user interface for the visualization (Power BI) of the weather forecast data on hiking routes.

## Main folders and files

* `notebooks`: contains the Jupyter notebooks used to call the external APIs and ingest the data to our database

    - `overpass.ipynb`: Overpass API ([_Link_](https://overpass-turbo.eu/), [_Documentation_](https://wiki.openstreetmap.org/wiki/Overpass_API))
    - `opencage_addressdata.ipynb`: OpenCage Geocoding API ([_Link_](https://opencagedata.com/), [_Documentation_](https://opencagedata.com/api))
    - `WeatherForecast.ipynb`: Open-Meteo API ([_Link_](https://open-meteo.com/), [_Documentation_](https://open-meteo.com/en/docs))

* `sql`: SQL scripts used for transformation (view generation) and data description

    - `CreateDataDescriptionSP.sql`: creates a stored procedure to efficiently store data description in the `sys` table
    - `DataDescription.sql`: makes use of the stored procedure and contains the description for all columns in our tables
    - `CreateDataDescriptionView.sql`: creates a view that dynamically displays the metadata of our data (data description)
    - `CreateWeatherAddressView.sql`: generates an 'analyst' view used for the serving part to load the data to Power BI

* `serving`: contains files used for the data visualization

    - `Wanderwege Dashboard.pbix`: Power BI dashboard used to visualize the data and dynamically interact with the data

* `data/processed`: raw (sample) data from APIs stored as `.csv` files (only used for data analysis and sandbox purposes)

* `environment.yaml`: configuration file handling the dependency management and required packages used to create the `conda` environment

## Configuration and preparation

**Pre-requisites**

We use [Conda](https://conda.io/projects/conda/en/latest/user-guide/install/index.html) to cleanly manage the installation, updating, and handling of software packages and dependencies.

A new environment can be created with all the necessary libraries by incorporating the `environment.yaml` file which is included in the repository:

```bash
conda env create -f environment.yaml -n [YOUR_ENV_NAME]
```

Activate the new environment:

```bash
conda activate www
```

**Access to database**

In order to access the database on Azure Cloud, the file `db_config.json` must be placed in a folder called `config` on the top level. Additionally, the user's IP address must be registered in Azure.

## Generation, ingestion and transformation

**Hiking routes: Overpass**

File: `overpass.ipynb`

In order to retrieve the coordinates and names of hiking routes within Switzerland, we make use of the freely available Overpass API ([_Link_](https://overpass-turbo.eu/), [_Documentation_](https://wiki.openstreetmap.org/wiki/Overpass_API)).

The query (Overpass Query Language (OQL)) searches for hiking routes within a specified area (rectangle representing Switzerland), excludes non-Swiss hiking routes by only considering routes with specific route symbols (e.g. red-white-red or yellow routes) and returns the center point coordinates of the corresponding route.

We transform the data, create a new table `OVRP_HikingRoutes` in the database `www_db` on SQL Server on Azure Cloud and ingest the data given the adjusted data types. There's a total of over 15'000 hiking routes that we store in the database.

**Weather forecast data: Open-Meteo**

File: `WeatherForecast.ipynb`

We retrieve the weather forecast data from the Open-Meteo API ([_Link_](https://open-meteo.com/), [_Documentation_](https://open-meteo.com/en/docs)).

For the given coordinates, you can request forecast data for intervals of 15min, 1h or 1d for the next 16 days. It is also possible to get historical forecast data or historical weather data. For our use case, we decided to go for hourly forecast data for one day (next 24h).

There is a time-bound limit of API calls that can be used within the freely available non-commercial use which forces us to restrict the requests for the weather forecast data. Therefore, we reduced our hiking routes to be queried to 300. This way, we can ensure a seamless integration and operation of the data engineering pipeline.

The coordinates of the hiking routes are first retrieved from the table `OVRP_HikingRoutes`. We then gather the weather forecast data, where we extract 19 meteorological data points for each location and hour. We process the data, generate a new table `OPNM_WeatherForecast` in the `www_db` database, and ingest the data using the appropriate data types.

**Geocoding addresses: OpenCage**

File: `opencage_addressdata.ipynb`

To get more information about the extracted hiking route coordinates from Overpass, we call the OpenCage Geocoding API ([_Link_](https://opencagedata.com/), [_Documentation_](https://opencagedata.com/api)). This gives us more granular geographical data like postal code, region and Canton.

The free version of this API also has a limit (2500 calls per day), i.e. we can't request data for all 15'000 coordinates. Given the hiking route coordinates in table `overpass`, we request 8 more data points for each location. After transforming the data, we create the `OPNC_Addresses` table in the `www_db` database and import the data assigning the fitting data types.

<!---
## Database engineering / SQL transformation

File: `CreateDataDescription.sql`
File: `CreateDataDescriptionView.sql`
File: `CreateWeatherAddressView.sql`
File: `DataDescription.sql`
-->
