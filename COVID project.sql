USE Portfolio_Project;

-- Data from Feb 2020 to April 2021
-- USING COVIDDEATHS TABLE

-- Case count each day in North America 
SELECT date, total_cases, (total_cases/population)*100 AS case_percent
FROM coviddeaths
WHERE location= 'North America'
ORDER BY date DESC; 

-- Highest COVID Cases by country 
SELECT location, population, MAX(total_cases) AS case_count, MAX((total_cases/population)*100) AS case_percent 
FROM coviddeaths
WHERE continent IS NOT NULL 
GROUP BY location, population 
ORDER BY case_count DESC;

-- Top 10 Countries with Highest COIVD Cases 
SELECT location, population, MAX(total_cases) AS case_count, MAX((total_cases/population)*100) AS case_percent 
FROM coviddeaths
WHERE continent IS NOT NULL 
GROUP BY location, population 
ORDER BY case_count DESC
LIMIT 10;

-- Highest COVID cases by continents 
SELECT location AS continent, population, MAX(total_cases) AS case_count, MAX((total_cases/population)*100) AS case_percent 
FROM coviddeaths
WHERE continent IS NULL AND location <> 'European Union'
GROUP BY location, population 
ORDER BY case_count DESC; 

-- 


-- BREAK--

-- Data from Feb 2020 to April 2021
-- USING COVIDDEATHS TABLE

-- Global Death by COVID each day 
SELECT date, SUM(new_cases) AS global_cases, SUM(new_deaths) AS global_death, (SUM(new_deaths)/SUM(new_cases))*100 AS global_death_percent
FROM coviddeaths
WHERE continent IS NOT NULL 
GROUP BY date
ORDER BY date DESC;

-- Hightest COVID Deaths by country 
SELECT location, SUM(new_deaths) AS death_count, (SUM(new_deaths)/SUM(new_cases))*100 AS death_percent
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY death_count DESC;

-- Top 10 Countries with Highest COVID Deaths
SELECT location, SUM(new_deaths) AS death_count, (SUM(new_deaths)/SUM(new_cases))*100 AS death_percent
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY death_count DESC
LIMIT 10;

-- Hightest COVID Deaths by continent 
SELECT location AS continent, SUM(new_deaths) AS death_count, (SUM(new_deaths)/SUM(new_cases))*100 AS death_percent
FROM coviddeaths
WHERE continent IS NULL AND location <>'European Union'
GROUP BY location
ORDER BY death_count DESC;

-- COVID Death rate (percentage of population which is death) 
SELECT location, MAX(population) AS country_population, MAX(total_deaths) AS death_count, (SUM(new_deaths)/MAX(population))*100 AS death_rate 
FROM coviddeaths
WHERE continent IS NOT NULL 
GROUP BY location
ORDER BY death_count DESC;

-- Top 10 COVID Death rate (percentage of population which is death) 
SELECT location, MAX(population) AS country_population, MAX(total_deaths) AS death_count, (SUM(new_deaths)/MAX(population))*100 AS death_rate 
FROM coviddeaths
WHERE continent IS NOT NULL 
GROUP BY location
ORDER BY death_count DESC
LIMIT 10;

-- Global Death by COVID 
SELECT sum(new_cases) AS global_cases, sum(new_deaths) AS global_deaths, (sum(new_deaths)/sum(new_cases))*100 AS global_death_percent
FROM coviddeaths 
WHERE continent IS NOT NULL;





-- BREAK--

-- Data from Feb 2020 to April 2021
-- USING COVIDVACCINATION TABLE 

-- vaccination rate per country 
SELECT cd.location ,SUM(cv.new_vaccinations) AS total_vaccination, MAX(cd.population) AS total_population, MAX((cv.people_fully_vaccinated/cd.population) *100) AS vaccinated_percent
FROM covidvaccinations cv
JOIN coviddeaths cd
	USING (location)
WHERE cd.continent IS NOT NULL
GROUP BY cd.location
ORDER BY percentage_vaccinated DESC; 

-- total death vs vaccination 
SELECT cd.date, SUM(cd.new_deaths) AS death_count, MAX(cv.people_fully_vaccinated) AS total_vaccination
FROM covidvaccinations cv
JOIN coviddeaths cd
	USING (date)
WHERE cd.continent IS NOT NULL
GROUP BY cd.date
ORDER BY cd.date DESC;

-- Population vs vaccination 
WITH Pop_Vac (continent, location, date, Population, new_Vaccinations, rolling_people_vaccinated)
AS
(
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
, SUM(cv.new_vaccinations) OVER (PARTITION BY cd.Location ORDER BY cd.location, cd.date) AS rolling_people_vaccinated
FROM coviddeaths cd
JOIN covidvaccinations cv
	USING(location, date)
WHERE cd.continent IS NOT NULL
)
SELECT *, (rolling_people_vaccinated/Population)*100 AS percent_people_vaccinated
FROM Pop_Vac
;
