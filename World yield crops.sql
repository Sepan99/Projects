--deleting any entity that contains the term 'FAO'

delete from KeyGroupYeilds
where Entity like '%FAO%'


-- The average tonnes per hectar for what entities have produced throughout the years

SELECT Entity, (SUM([KeyGroupYeilds].[Rice in tonnes per hectar])) / ((select count(*) from KeyGroupYeilds)) AS AverageYield
FROM KeyGroupYeilds
WHERE Entity = 'Japan'
GROUP BY Entity


--Top 5 entities for the overall production of crops

select top 5 Entity, SUM([Wheat in tonnes per hectar]) as OverallRiceProduction
from KeyGroupYeilds
group by Entity
order by OverallRiceProduction desc


-- Entities that have produced between 50 and 75 tonnes of Soybeans from 1961 to 2021

select entity, SUM(cast([Soybeans in tonnes per hectar] as float)) as TotalProduction
from KeyGroupYeilds
group by Entity
Having SUM(cast([Soybeans in tonnes per hectar] as float)) between 50 and 75


-- Each entity vs all other entities for percentage of production in year 2021

Select Entity, [Maize in tonnes per hectar], [Maize in tonnes per hectar] / TotalYield * 100 AS YieldPercentage
FROM KeyGroupYeilds
Cross Join (Select SUM([Maize in tonnes per hectar]) AS TotalYield From KeyGroupYeilds Where Year = 2021) AS T
Where Year = 2021
order by YieldPercentage desc


-- Max production year and the production value or each entity

select  kgy.Entity, kgy.Year, MAX(cast(kgy.[Banana in tonnes per hectar] as float)) as MaxYield
from KeyGroupYeilds as kgy
inner join(
		select entity, 	MAX(cast([Banana in tonnes per hectar] as float)) as MaxYield
		from KeyGroupYeilds
		group by Entity
		) as T
on kgy.Entity = T.entity and cast(kgy.[Banana in tonnes per hectar] as float) = T.Maxyield
group by kgy.Entity, year
order by Entity


-- getitng the year of the max and min production of each entity

drop table if exists #Max_Yield
create table #MaxYield
(Entity varchar(100), Year int, Max_Yield float)
insert into #MaxYield
select  kgy.Entity, kgy.Year, MAX(cast(kgy.[rice in tonnes per hectar] as float)) as MaxYield
from KeyGroupYeilds as kgy
inner join(
		select entity, 	MAX(cast([rice in tonnes per hectar] as float)) as MaxYield
		from KeyGroupYeilds
		group by Entity
		) as T
on kgy.Entity = T.entity and (cast(kgy.[rice in tonnes per hectar] as float) = T.Maxyield)
group by kgy.Entity, year
order by MaxYield desc

drop table if exists #Min_Yield
create table #MinYield
(Entity varchar(100), Year int, Min_Yield float)
insert into #MinYield
select  kgy.Entity, kgy.Year, MIN(cast(kgy.[rice in tonnes per hectar] as float)) as MinYield
from KeyGroupYeilds as kgy
inner join(
		select entity, 	MIN(cast([rice in tonnes per hectar] as float)) as MinYield
		from KeyGroupYeilds
		group by Entity
		) as T
on kgy.Entity = T.entity and (cast(kgy.[rice in tonnes per hectar] as float) = T.Minyield)
group by kgy.Entity, year
order by MinYield desc

drop table if exists MaxMinYieldRice
create table MaxMinYieldRice
(Entity varchar(100), Year_Max int, Max_Yield float, Year_Min int, Min_Yield float)
insert into MaxMinYieldRice
select #MaxYield.Entity, #MaxYield.year, Max_Yield, #MinYield.year, Min_Yield
from #MaxYield
inner join #MinYield on #MaxYield.Entity = #MinYield.Entity


--The summation of all the productes combined over the years

select Entity, 
(SUM(isnull([Wheat in tonnes per hectar], 0)) + SUM(isnull([Rice in tonnes per hectar], 0))
+ SUM(isnull(convert(float, [Banana in tonnes per hectar]), 0)) + SUM(isnull([Maize in tonnes per hectar], 0)) 
+ SUM(isnull(convert(float, [Soybeans in tonnes per hectar]), 0)) + SUM(isnull([Potatoes in tonnes per hectar], 0))
+ SUM(isnull(convert(float, [Dry Beans in tonnes per hectar]), 0)) + SUM(isnull(convert(float, [Dry peas in tonnes per hectar]), 0))
+ SUM(isnull(convert(float, [Cassava in tonnes per hectar]), 0)) + SUM(isnull(convert(float, [Cocoa beans in tonnes per hectar]), 0)) 
+ SUM(isnull([Barley in tonnes per hectar], 0))) as TotalYield
from KeyGroupYeilds as kgy
group by Entity
order by Entity


--The summation of all the productes combined for a specefic year

select entity, year,
((isnull([Wheat in tonnes per hectar], 0)) + (isnull([Rice in tonnes per hectar], 0))
+ (isnull(convert(float, [Banana in tonnes per hectar]), 0)) + (isnull([Maize in tonnes per hectar], 0)) 
+ (isnull(convert(float, [Soybeans in tonnes per hectar]), 0)) + (isnull([Potatoes in tonnes per hectar], 0))
+ (isnull(convert(float, [Dry Beans in tonnes per hectar]), 0)) + (isnull(convert(float, [Dry peas in tonnes per hectar]), 0))
+ (isnull(convert(float, [Cassava in tonnes per hectar]), 0)) + (isnull(convert(float, [Cocoa beans in tonnes per hectar]), 0)) 
+ (isnull([Barley in tonnes per hectar], 0))) as TotalYield
from KeyGroupYeilds
where year = 2000





