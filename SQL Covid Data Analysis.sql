/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

Select *
From PortfolioProject.dbo.['Covid Deaths$']
Where continent is not null 
order by 3,4


-- Select Data that we are going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject.dbo.['Covid Deaths$']
Where continent is not null 
order by 1,2


-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject.dbo.['Covid Deaths$']
Where location like '%states%'
and continent is not null 
order by 1,2


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject.dbo.['Covid Deaths$']
--Where location like '%states%'
order by 1,2


-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject.dbo.['Covid Deaths$']
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


-- Continent with Highest Death Count per Population
SELECT continent, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM ['Covid Deaths$']
WHERE continent is NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- Global Numbers
SELECT  SUM(new_cases) AS TotalCases, SUM(cast(new_deaths as int)) AS TotalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS DeathPercentage
FROM ['Covid Deaths$']
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as float)) OVER (Partition by vac.location, vac.date)
FROM ['Covid Deaths$'] dea
JOIN ['COVID Vaccinations$'] vac
On dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3

SELECT *
FROM ['COVID Vaccinations$']
WHERE location LIKE 'United States'
ORDER BY total_boosters DESC

SELECT dea.location, dea.date, dea.population, vac.people_fully_vaccinated, (vac.people_fully_vaccinated/dea.population)*100 AS PercentVaccinted
FROM ['Covid Deaths$'] dea
JOIN ['COVID Vaccinations$'] vac
On dea.location = vac.location
and dea.date = vac.date
WHERE dea.location LIKE 'United States' 
ORDER BY dea.date DESC

-- Found 61.8% of the US population are fully vaccinated as of 1/8/22