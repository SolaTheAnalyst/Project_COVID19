-- DATA EXPLORATION ON COVID

-- This query shows new infections on a daily basis from 2020-01-03 to 2023-03-07
SELECT location, date, new_cases, total_cases, total_deaths, population 
FROM CovidDeaths 
WHERE continent is not null
ORDER BY 1,2,3

-- This query shows total cases vs total deaths in Canada
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as death_percentage 
FROM CovidDeaths 
WHERE location = 'Canada';

-- This query shows the chances of dying from an infection 
SELECT location, date, total_cases , total_deaths, (total_deaths/total_cases) * 100 as death_percentage 
FROM CovidDeaths 
WHERE location = 'Canada' and date = (select max(date) from CovidDeaths) order by 1,2;

-- This query shows the percentage of people who contracted covid in Canada
SELECT location, date, total_cases, population, (total_cases/population) * 100 as infection_percentage 
FROM CovidDeaths 
WHERE location = 'Canada';

-- This query shows what percentage of population got infected per country on a daily basis
SELECT location, date, total_cases, population, (total_cases/population) * 100 as infection_percentage 
FROM CovidDeaths 
ORDER BY 1,2;

-- This query shows total cases vs population per country as at 2023-03-07 (This doesn't consider reinfection)

SELECT location, population, max(total_cases), max((total_cases/population)) * 100 as infection_percentage 
FROM CovidDeaths 
GROUP BY location, population
order by 1 ;

--  This query can be filtered using HAVING to view total death vs population in any country of choice

SELECT location,  max(total_deaths) total_death_count, max((total_deaths/population)) * 100 as death_percentage 
FROM CovidDeaths 
GROUP BY location
HAVING location = 'United States'
ORDER BY 3 desc;


-- This query shows total death vs population per country
SELECT location,  max(total_deaths) total_death_count, max((total_deaths/population)) * 100 as death_percentage FROM CovidDeaths 
WHERE continent is not null
GROUP BY location
ORDER BY 2 desc;


-- This query shows percentage death per continent
SELECT continent,  max(total_deaths) total_death_count, max((total_deaths/population)) * 100 as death_percentage FROM CovidDeaths 
WHERE continent is not null
GROUP BY continent
ORDER BY 2 desc;

-- This query shows death count accross the world as at 2023-03-07 by country
SELECT location, max(total_deaths) total_death_count, max((total_deaths/population)) * 100 as death_percentage FROM CovidDeaths
WHERE continent is not null and  date = (select max(date) from CovidDeaths)
GROUP BY location
ORDER BY 2 desc;

-- This query shows death count across the world per day
SELECT date, max(total_deaths) as total_death_count FROM CovidDeaths
WHERE continent is null 
GROUP BY date
ORDER BY 1 ;

-- This qery shows new cases new deaths per day
SELECT date, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths from CovidDeaths
WHERE continent is null
GROUP BY date
ORDER BY 1  ;

-- This query shows number of new vaccinations per day per country
SELECT d.continent, d.location, d.date, d.population, sum(cast(v.new_vaccinations as real)) as total_new_vax FROM CovidDeaths d
JOIN CovidVaccinations v
ON d.location = v.location and d.date = v.date 
WHERE d.continent is not null
GROUP BY d.continent, d.location, d.date, d.population
ORDER BY 2,3 ;


-- This query shows rolling count of total vaccinations 
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations, SUM(cast(v.new_vaccinations as real)) OVER (partition by d.location
ORDER BY d.location, d.date) as rolling_count FROM CovidDeaths d
JOIN CovidVaccinations v
ON d.location = v.location and d.date = v.date 
WHERE d.continent is not null
ORDER BY 2,3;

-- This query shows rolling percentage vaccination
WITH People_Vaxed AS

(SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations, SUM(cast(v.new_vaccinations as real)) OVER (partition by d.location
ORDER BY d.location, d.date) as rolling_count FROM CovidDeaths d
JOIN CovidVaccinations v
ON d.location = v.location and d.date = v.date 
where d.continent is not null)

--order by 2,3)

SELECT *, (rolling_count/population) * 100 as Percentage_vaxxed FROM People_Vaxed;


-- VIEWS FOR LATER VISIOS

CREATE VIEW percentage_death AS
SELECT continent,  max(total_deaths) total_death_count, max((total_deaths/population)) * 100 as death_percentage FROM CovidDeaths 
where continent is not null
group by continent














