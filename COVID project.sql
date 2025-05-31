USE Portfolio_Project;

-- Data from Feb 2020 to April 2021
-- USING COVIDDEATHS TABLE

-- Percentage of population with a COVID case  
SELECT location, population, total_cases, (total_cases/population)*100 AS case_percentage
FROM coviddeaths
WHERE continent IS NOT NULL 
ORDER BY case_percentage DESC; 

-- Highest COVID Cases by country 
SELECT location, population, MAX(total_cases) AS highest_cases, MAX((total_cases/population)*100) AS highest_case_percentage  
FROM coviddeaths
WHERE continent IS NOT NULL 
GROUP BY location, population 
ORDER BY highest_case_percentage DESC;

-- Top 10 Countries with Highest COIVD Cases 
SELECT location, population, MAX(total_cases) AS highest_cases, MAX((total_cases/population)*100) AS highest_case_percentage  
FROM coviddeaths
WHERE continent IS NOT NULL 
GROUP BY location, population 
ORDER BY highest_case_percentage DESC
LIMIT 10;

-- Highest COVID cases by continents 
SELECT location, population, MAX(total_cases) AS highest_cases, MAX((total_cases/population)*100) AS highest_case_percentage  
FROM coviddeaths
WHERE continent IS NULL 
GROUP BY location, population 
ORDER BY highest_case_percentage DESC; 





-- Percentage COVID Death each day 
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_by_COVID
FROM coviddeaths
WHERE continent IS NOT NULL 
ORDER BY death_by_COVID;

-- Hightest COVID Deaths by country 
SELECT location, MAX(total_deaths) AS hightest_death, MAX((total_deaths/total_cases)*100) AS hightest_death_percentage
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY hightest_death_percentage DESC;

-- Top 10 Countries with Highest COVID Deaths
SELECT location, MAX(total_deaths) AS hightest_death, MAX((total_deaths/total_cases)*100) AS hightest_death_percentage
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY hightest_death_percentage DESC
LIMIT 10;

-- Hightest COVID Deaths by continent 
SELECT location AS continent, MAX(total_deaths) AS hightest_death, MAX((total_deaths/total_cases)*100) AS hightest_death_percentage
FROM coviddeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY hightest_death_percentage DESC;




-- COVID Death rate (percentage of population which is death) 
SELECT location, population, MAX(total_deaths), MAX((total_deaths/population)*100) AS death_rate 
FROM coviddeaths
WHERE continent IS NOT NULL 
GROUP BY location, population
ORDER BY death_rate DESC;

-- Top 10 COVID Death rate (percentage of population which is death) 
SELECT location, population, MAX(total_deaths), MAX((total_deaths/population)*100) AS death_rate 
FROM coviddeaths
WHERE continent IS NOT NULL 
GROUP BY location, population
ORDER BY death_rate DESC
LIMIT 10;



-- Global Death by COVID 
SELECT date, sum(new_cases), sum(new_deaths), sum(new_cases)/sum(new_deaths)*100 AS global_deaths
FROM coviddeaths 
WHERE continent IS NOT NULL 
GROUP BY date
ORDER BY date, sum(new_cases);






-- USING COVIDVACCINATION TABLE 

-- vaccination rate per country 
SELECT cd.location, MAX(cv.people_fully_vaccinated), MAX(cd.population), MAX((cv.people_fully_vaccinated/cd.population) *100) AS percentage_vaccinated
FROM covidvaccinations cv
JOIN coviddeaths cd
	USING (location)
WHERE cd.continent IS NOT NULL
GROUP BY cd.location
ORDER BY percentage_vaccinated DESC; 

-- total death vs vaccination 
SELECT cd.date, SUM(cd.total_deaths), SUM(cv.people_fully_vaccinated)
FROM covidvaccinations cv
JOIN coviddeaths cd
	USING (date)
WHERE cv.people_fully_vaccinated != '0' OR (date > '2020-01-01' AND date < '2021-01-01')
GROUP BY cd.date
ORDER BY cd.date DESC;

-- total vaccination globally each day 
SELECT cd.date, SUM(cv.people_fully_vaccinated), '7900000000' AS global_population, (SUM(cv.people_fully_vaccinated)/'7900000000')*100
FROM covidvaccinations cv
JOIN coviddeaths cd
	USING (date)
WHERE cv.people_fully_vaccinated != '0' OR (date > '2020-01-01' AND date < '2021-01-01')
GROUP BY date
ORDER BY cd.date DESC;
