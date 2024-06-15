# COVID-19 Data Analysis Project

## Project Overview
This repository contains a collection of SQL queries designed for analyzing COVID-19 data. The analysis covers various aspects including case and death counts, death rates, vaccination rates, and the impact of COVID-19 relative to the population across different continents and countries.

## Data Description
The data used in this project comes from two main tables:
- `coviddeaths`: Contains data related to COVID-19 deaths, cases, and other related metrics.
- `CovidVaccination`: Contains data on COVID-19 vaccinations.

## Features
The project includes the following analyses:
- **Total Cases vs Total Deaths**: Analyzes the death percentage among confirmed cases.
- **Total Cases vs Population**: Studies the percentage of the population that has been infected with COVID-19.
- **Highest Infection Rates**: Identifies countries with the highest infection rates compared to their population.
- **Death Counts by Country and Continent**: Provides the total number of deaths organized by country and continent.
- **Vaccination Analysis**: Looks at vaccination data and calculates the percentage of the population vaccinated.

## SQL Queries
1. **Basic Data Retrieval**:
    ```sql
    SELECT Continent, Location, date, total_cases, new_cases, total_deaths, population_density
    FROM coviddeaths  
    ORDER BY Location, date;
    ```
2. **Death Rate Analysis**:
    ```sql
    SELECT Continent, Location, date, total_cases, total_deaths, ROUND(((total_deaths/total_cases) * 100),2) as death_percentage
    FROM coviddeaths  
    WHERE Location LIKE 'A%'
    ORDER BY Location, date;
    ```
3. **Population Infection Rate**:
    ```sql
    SELECT Continent, Location, date, total_cases, total_deaths, population, ((total_cases/population) * 100) as covid_population
    FROM coviddeaths  
    ORDER BY Location, date;
    ```
4. **Join Analysis with Vaccination Data**:
    ```sql
    -- Using CTE to analyze vaccination data
    WITH PopvsVac AS (
        SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS SIGNED)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) as RollingPeopleVaccinated
        FROM CovidDeaths dea
        JOIN CovidVaccination vac ON dea.location = vac.location AND dea.date = vac.date
        WHERE dea.continent IS NOT NULL 
    )
    SELECT *, (RollingPeopleVaccinated/population)*100
    FROM PopvsVac;
    ```

## Installation
No installation is required to run these queries, but access to a SQL server with the relevant data tables is necessary.

## Contributing
Contributions to the development and enhancement of these SQL queries are welcome. Please fork this repository and submit a pull request with your proposed changes.

## License
This project is available under the MIT License. See the LICENSE file in the repository for more information.

## Acknowledgements
- Data sourced from global COVID-19 tracking projects.
- This project is intended for educational purposes.

