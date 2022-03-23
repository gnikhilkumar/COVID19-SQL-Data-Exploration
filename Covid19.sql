select *
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

select *
from PortfolioProject..CovidVaccinations
order by 3,4

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2

select location, date, total_cases, total_deaths, (total_cases/total_deaths)*100 as deathpercentage
from PortfolioProject..CovidDeaths
where location like 'india'
order by 1,2

select location, date, total_cases, population, (total_cases/population)*100 as deathpercentage
from PortfolioProject..CovidDeaths
where location like 'india'
order by 1,2

select location, max(total_cases) as highestinfectioncount, population, max((total_cases/population))*100 as populationinfected
from PortfolioProject..CovidDeaths
group by location, population
order by populationinfected desc

select location, max(cast(total_deaths as int)) as highestinfectioncount
from PortfolioProject..CovidDeaths
where continent is not null
group by location
order by highestinfectioncount desc

select continent, max(cast(total_deaths as int)) as totaldeathcount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by totaldeathcount desc

select sum(new_cases) total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
from PortfolioProject..CovidDeaths
where continent is not null

order by 1,2

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, sum(CasT(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) 
as rollingpeoplevaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
order by 2,3


with PopvsVac (continent, location, date, population, new_vaccinations, rollingpeoplevaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, sum(CasT(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) 
as rollingpeoplevaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null

)
select *, (rollingpeoplevaccinated/population)*100
from PopvsVac

drop table if exists #percentpopulationvaccinated
create table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rollingpeoplevaccinated numeric
)

insert into #percentpopulationvaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, sum(CasT(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) 
as rollingpeoplevaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date


select *, (rollingpeoplevaccinated/population)*100
from #percentpopulationvaccinated




create view percentpopulationvaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, sum(CasT(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) 
as rollingpeoplevaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *
from percentpopulationvaccinated






