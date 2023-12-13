SELECT * from comments

SELECT case when translation =''
	then comments
	else translation 
	end as output 
from comments

SELECT coalesce(comments,translation) as output 
from comments

SELECT * from source
SELECT * from target

SELECT s.id , 'Mismatch' as Comment
from source  as s
join target  as t
on s.id = t.id and s.name <> t.name
Union
SELECT s.id, 'Not in Target' as Comment
from source as s 
left join target as t
on s.id = t.id
where t.id is null
Union
SELECT t.id, 'Not in Source' as Comment
from source as s 
right join target as t
on s.id = t.id
where s.id is null

SELECT team.team_name as team, opponent.team_name as opponent
From teams team
join teams opponent on team.team_name <> opponent. team_name

with matches as 
 (SELECT row_number() over(order by team_name) as ID, team_code, team_name
from teams t 
)
SELECT team.team_name as team, opponent.team_name as opponent from matches team 
join matches opponent  
on team.id<opponent.id
order by team.team_name



with g as (SELECT row_number() over(order by source) as id,* from geo)
SELECT g.source, g.destination, g.distance from g
join g f
on g.source = f.destination and g.id>f.id

SELECT * from position
SELECT * from employees


WITH Numbers AS (
    SELECT n
    FROM (VALUES (1), (2), (3), (4), (5),(6),(7),(8),(9),(10) /* List numbers up to the desired range */) AS NumberSeries(n)
)
SELECT p.* 
FROM position p
CROSS JOIN Numbers
WHERE n <= p.Totalpost 

SELECT p.title,p.groups,p.level,p.payScale,e.name as Employee_name from position p
join employees e
on p.id=e.position_id


SELECT * from billing

SELECT TOP 2 * from billing

SELECT TOP 2 * from billing order by customer_id desc

with sums as(
SELECT customer_id case when format(billing_creation_date,'yyyy') ='2019'
	then billing_amount
	else 0
	end as sum_2019,
	case when format(billing_creation_date,'yyyy') ='2020'
	then billing_amount
	else 0
	end as sum_2020,
	case when format(billing_creation_date,'yyyy') ='2021'
	then billing_amount
	else 0
	end as sum_2021,
	count(case when format(billing_creation_date,'yyyy') ='2021'
	then billing_amount
	else null
	end) as count_2021
from billing
group by customer_id
)
Select customer_id, sum(sum_2019) as s2019, sum(sum_2020) as s2020,sum(sum_2021) as s2021 from sums group by customer_id



SELECT * from brands


with cte as(
SELECT *, case when amount < lead(amount,1,amount+1) over(partition by brand order by year) then 1 else 0 end as flag
from brands)
SELECT * from brands
where brand not in (select brand from cte where flag =0)