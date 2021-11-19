
-- Covid Data from https://ourworldindata.org/covid-deaths.  
-- Between January 18, 2020 to 14 November 2021.
-- Queries executed in mysql.


Select *
From coviddeaths
Where continent is not null -- this excludes continents; only countries are retrieved.
Order by 1,2;


-- Looking at the Total Cases vs Total Deaths | Shows likelihood of dying if you contract covid in your country: 

Select Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From coviddeaths
Where location like '%kingdom%'  -- = United Kingdom
and continent is not null
Order by 1,2;

-- Looking at Total cases vs Population | Demostartes the percentage of population got covid:

Select Location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From coviddeaths
Where location like '%kingdom%'  -- = United Kingdom
and continent is not null
Order by 1,2;

-- Countries with the highest infection rate compared to population:

Select Location, Population, MAX(total_cases) as HighestInfectionCount, 
MAX((total_cases/population))*100 as PercentPopulationInfected
From coviddeaths
Where continent is not null
Group by Location, Population 
Order by PercentPopulationInfected desc;

-- Demonstrates the countries with the highest death count per population: 

Select Location, MAX((Total_deaths)) as  TotalDeathCount
From coviddeaths
Where continent is not null
Group by Location 
Order by TotalDeathCount Desc;


-- Continents with the highest death count per population:

Select continent, MAX((Total_deaths)) as TotalDeathCount
From CovidDeaths
Where continent is not null 
Group by continent 
order by TotalDeathCount desc;


-- Total cases and deaths caused by covid:


Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, 
  SUM(new_deaths) /  SUM(New_Cases) *100 as DeathPercentage
From coviddeaths
Where continent is not null 
Order by 1,2;

-- vaccination data: 

Select * FROM CovidVaccinations;


-- Percentage of Population that has recieved at least one Covid Vaccine:

Select A.continent, A.location, A.date, A.population, B.new_vaccinations, 
   SUM(B.new_vaccinations) OVER (Partition by A.Location Order by A.location, A.Date) as PeopleVaccinated
From CovidDeaths A
JOIN CovidVaccinations B ON A.location = B.location
and A.date = B.date
Where A.continent is not null
Order by 2,3; 


-- Percentage people vaccinated - COVID-19:


With XI (Continent, Location, Date, Population, New_Vaccinations, PeopleVaccinated)
as
(
Select A.continent, A.location, A.date, A.population, B.new_vaccinations, 
   SUM(B.new_vaccinations) OVER(Partition by A.Location Order by A.location, A.Date) as PeopleVaccinated
From coviddeaths A
Join covidvaccinations B
	On A.location = B.location
	and A.date = B.date
where A.continent is not null 

)
Select *, (PeopleVaccinated/Population)*100
From XI;


-- Temperarory table for the next. 

Create table if not exists PercentPopulationVaccinated
(
Continent varchar(50),
Location varchar(50),
Date datetime,
Population numeric,
New_vaccinations numeric,
PeopleVaccinated numeric
);

Insert into PercentagePopulationVaccinated
Select A.continent, A.location, A.date, A.population, B.new_vaccinations, SUM(B.new_vaccinations) OVER (Partition by A.Location Order by A.location, A.Date) as PeopleVaccinated
From CovidDeaths A
Join CovidVaccinations B
	On A.location = B.location
	and A.date = B.date;


Select *, (PeopleVaccinated/Population)*100
From PercentagePopulationVaccinated;

-- Creating View, this will be used for visualization purposes.

CREATE OR REPLACE VIEW PercentagePopulationVaccinated as
Select A.continent, A.location, A.date, A.population, B.new_vaccinations, SUM(B.new_vaccinations) OVER (Partition by A.Location Order by A.location, A.Date) as PeopleVaccinated
From CovidDeaths A
Join CovidVaccinations B
	On A.location = B.location
	and A.date = B.date
where A.continent is not null; 


