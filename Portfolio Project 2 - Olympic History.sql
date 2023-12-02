
-- 1 which team has won the maximum gold medals over the years.

with cte as (
select *
from athletes as a
inner join athlete_events as b
on a.id = b.athlete_id
)
select team,count(distinct event) as gold_medals
from cte 
where medal = "gold"
group by team
order by gold_medals desc
limit 1;

-- or

select B.team, count(distinct A.event) as Gold_medals  
from athlete_events A 
inner join athletes B on A.athlete_id=B.id
where A.medal='Gold'
group by B.team
order by Gold_medals desc
limit 1;

-- 2 for each team print total silver medals and year in which they won maximum silver medal..output 3 columns
	-- team,total_silver_medals, year_of_max_silver

with cte as ( 
select B.team, A.year,  count(distinct A.event) as silver_medals,
rank() over(partition by team order by  count(distict A.event) desc) as RK 
from athlete_events A inner join athletes B on A.athlete_id=B.id
where A.medal='Silver' 
group by B.team,A.year
)
select team, SUM(silver_medals) as total_silver_medals, max(case when RK=1 then year end) as year_of_max_silver
from cte
group by  team
order by total_silver_medals desc;


-- 3 which player has won maximum gold medals  amongst the players 
	-- which have won only gold medal (never won silver or bronze) over the years

with cte as (
select B.name,A.medal 
from athlete_events A 
inner join athletes B on A.athlete_id=B.id
)
select name,count(1) as No_of_goldmedals from cte
where name not in (select distinct name from cte where medal in ('silver','bronze')) and medal='Gold'
group by name
order by No_of_goldmedals desc
limit 1;

 -- 4 in each year which player has won maximum gold medal . Write a query to print year,player name 
	-- and no of golds won in that year . In case of a tie print comma separated player names.

with cte as (
select A.year, B.name, count(1) as No_of_goldmedals 
from athlete_event A inner join athlete B on A.athlete_id=B.id
where medal='Gold'
group by A.year,B.name
)
select year,No_of_goldmedals,STRING_AGG(name,',') as players 
from(select *,
rank() over(partition by year order by No_of_goldmedals desc) AS RK
from cte) a where RK=1
group by  year,No_of_goldmedals;

-- 5 in which event and year India has won its first gold medal,first silver medal and first bronze medal
	-- print 3 columns medal,year,sport 

with cte as (
select year,event as sport,medal
from athletes as a
inner join athlete_events as b
on a.id = b.athlete_id
where team = "india" and medal in ("gold","silver","bronze")
group by year,event,medal
),
cte2 as (
select *,
rank () over (partition by medal order by year asc) as rn
from cte
)
select * 
from cte2
where rn = 1;

-- 6 find players who won gold medal in summer and winter olympics both.

with cte as (
select *
from athletes as a
inner join athlete_events as b
on a.id = b.athlete_id
)
select name,count(distinct season) as gold_medals
from cte 
where medal = "gold" and season in  ("summer","winter")
group by name
having count(distinct season) =2;


-- 7 find players who won gold, silver and bronze medal in a single olympics. print player name along with year.

with cte as (
select *
from athletes as a
inner join athlete_events as b
on a.id = b.athlete_id
)
select name,year  
from cte
where medal in ('Gold','silver','bronze')
group by name,year
having count(distinct medal) =3
order by name asc;

-- 8 find players who have won gold medals in consecutive 3 summer olympics in the same event . Consider only olympics 2000 onwards. 
	-- Assume summer olympics happens every 4 year starting 2000. print player name and event name.

with cte as (
select B.name, A.year,A.event  
from athlete_events A 
inner join athletes B on A.athlete_id=B.id
where A.year>=2000 and A.season='Summer' and A.medal='Gold'
), 
cte2 as (
select *,
lag(year,1) over(partition by name,event order by year ) as Prev_year,
lead(year,1) over(partition by name,event order by year ) as Nex_year
from cte
)
select * 
from cte2
where year=Prev_year+4 and year=Nex_year-4;


-- congratulations you have unlocked datalemur premium subscription:

-- URL : https://datalemur.com/questions
-- username : ashish677568@gmail.com
-- password : Allthebest1



