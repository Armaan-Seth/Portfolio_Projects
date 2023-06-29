select location,date, total_cases, new_cases, total_deaths, population
from [Portfolio Projects]..CovidDeaths$
order by 1,2

-- Looking at Total Cases vs Total Deaths and percentage of death
-- Shows likelihood of dying if you contract covid in India 

select location,date, total_cases, total_deaths,(total_deaths/total_cases)*100 as deathpercentage
from [Portfolio Projects]..CovidDeaths$
where location like '%india%'
order by 1,2

-- Total Cases vs Population 
-- shows what percentage of population got Covid 

select location,date, total_cases, population,(total_cases/population)*100 as covid_infected_percentage
from [Portfolio Projects]..CovidDeaths$
where location like '%india%'
order by 1,2

-- Looking at Countries with Highest Infection Rate compared to Population 

select location, MAX(total_cases) as Highest_Infection_Count, population, MAX ((total_cases/population))*100 as Percent_Population_Infected
from [Portfolio Projects]..CovidDeaths$
group by location, population
order by Percent_Population_Infected DESC

-- Showing countries with highest death count per population

Select location, MAX(Cast(total_deaths AS INT)) AS Total_Death_Count
From [Portfolio Projects]..CovidDeaths$
Where continent IS NOT NULL
Group By Location
Order By Total_Death_Count DESC

-- Showing Continent with highest death count per population
Select location, MAX(Cast(total_deaths AS INT)) AS Total_Death_Count
From [Portfolio Projects]..CovidDeaths$
Where continent IS NULL
Group By Location
Order By Total_Death_Count DESC

-- Showing continents with highest vaccination
select location, MAX(Cast(total_vaccinations AS INT)) AS Total_Vacc_Cnt 
FROM [Portfolio Projects]..CovidVaccinations$
WHERE continent IS NOT NULL and total_vaccinations IS NOT NULL
Group By Location
Order By Total_Vacc_Cnt DESC


--Global Data 
SELECT  SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS int)) as total_deaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS deathpercentrage
FROM [Portfolio Projects]..CovidDeaths$
WHERE continent IS NOT NULL
Order By 1,2 DESC

--Looking at Total Population vd Vaccinations



--USE CTE 

 With PopvsVac (continent, location, date, population, new_vaccinations, rolling_vacc_sum)
 as
 (Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location  order by dea.location, dea.date) as rolling_vacc_sum
From [Portfolio Projects]..CovidDeaths$ as dea
JOIN [Portfolio Projects]..CovidVaccinations$ as vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL 
--order by 2,3
)

Select *, (rolling_vacc_sum/population)*100
From PopvsVac

---- TEMP TABLE

--DROP TABLE IF exists #PercentPopulationVaccinated
--Create Table #PercentPopulationVaccinated
--(
--continent nvarchar(255),
--location nvarchar(255),
--date datetime,
--population numeric,
--new_vaccinations numeric,
--RollingPeopleVaccinated numeric
--)
--Insert Into #PercentPopulationVaccinated
--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
--SUM(CAST(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location  order by dea.location, dea.date) as RollingPeopleVaccinated
--From [Portfolio Projects]..CovidDeaths$ as dea
--JOIN [Portfolio Projects]..CovidVaccinations$ as vac
--	ON dea.location = vac.location
--	and dea.date = vac.date
----WHERE dea.continent IS NOT NULL 
----order by 2,3

--Select *, (RollingPeopleVaccinated/population)*100
--From #PercentPopulationVaccinated


-- Create View to store data for Later Visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location  order by dea.location, dea.date) as RollingPeopleVaccinated
From [Portfolio Projects]..CovidDeaths$ as dea
JOIN [Portfolio Projects]..CovidVaccinations$ as vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL 


