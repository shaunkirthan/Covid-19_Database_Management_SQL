use Portfolio_Project_1;

-- SELECT Data that we are going to use

SELECT Continent,Location , date , total_cases , new_cases , total_deaths , population_density
FROM coviddeaths  
order by 2,3;

-- Looking at Total Cases VS Total Deaths (percentage of death rate )
-- Shows the Likely hood of dieing if you were infected with covid

SELECT Continent,Location , date , total_cases ,total_deaths ,ROUND(((total_deaths/total_cases) * 100),2) as death_percentage
FROM coviddeaths  
WHERE Location LIKE 'A%'
order by 2,3;

-- Looking at total cases VS Population
-- What population percentage got covid 


SELECT Continent,Location , date , total_cases ,total_deaths ,population , ((total_cases/population) * 100) as covid_population
FROM coviddeaths  
order by 2,3;

-- Looking at the countries with the highest infection rate compared to populationin order

SELECT Continent ,Location , Population , Max(total_cases) as HighestInfectioCount , MAX((total_cases/population)* 100) as PercentagePopulationInfected
FROM coviddeaths
GROUP BY Location , Population , Continent
ORDER BY PercentagePopulationInfected DESC ;

-- Showing the country orderd by  death count per population

SELECT continent ,Location, MAX(cast(total_deaths as SIGNED)) as TotalDeathCount
FROM coviddeaths
GROUP BY Location, continent
ORDER BY TotalDeathCount DESC;

-- LET BREAK THINGS DOWN BY CONTINENT 

SELECT DISTINCT(continent), MAX(cast(total_deaths as SIGNED)) as TotalDeathCount
FROM coviddeaths
GROUP BY continent
ORDER BY TotalDeathCount;

-- GLOBAL NUMBERS 

SELECT SUM(new_cases) as total_cases,SUM(CAST(new_deaths AS SIGNED)) as total_deaths,(SUM(CAST(new_deaths AS SIGNED)) / SUM(new_cases) * 100) as death_percentage
FROM coviddeaths
WHERE Continent is NOT NULL
ORDER BY 1,2;

-- JOIN THE CovidDeaths and CovidVaccination tables 
-- Looking for Total Vaccination VS Vaccinations

with PopvsVac (Continent ,location , date , population, new_vaccination, rollingpeoplevaccinated )
as
(
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(CAST(vac.new_vaccinations AS SIGNED)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) as RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN CovidVaccination vac ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
)
SELECT *, (RollingPeopleVaccinated/population)*100
FROM PopvsVac;

-- CREATE VIEW 
CREATE VIEW PercentPopulationVaccinated AS
SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(CAST(vac.new_vaccinations AS SIGNED)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) as RollingPeopleVaccinated
FROM
    CovidDeaths dea
JOIN
    CovidVaccination vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE
    dea.continent IS NOT NULL;
