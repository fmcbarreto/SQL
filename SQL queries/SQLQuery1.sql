SELECT * FROM employee
WHERE (dept_name, salary) IN (SELECT dept_name, MAX(salary) as salary FROM employee GROUP BY dept_name)

SELECT e.*
FROM employee e
JOIN (
    SELECT dept_name, MAX(salary) as max_salary
    FROM employee
    GROUP BY dept_name
) subquery
ON e.dept_name = subquery.dept_name AND e.salary = subquery.max_salary;

SELECT * 
from employee e1
where salary >= (select avg(salary) 
from employee e2
where e2.dept_name =e1.dept_name
)

SELECT d.* FROM employee e
FULL JOIN department d
on e.dept_name =d.dept_name WHERE emp_id IS NULL

SELECT * 
FROM department d 
WHERE NOT EXISTS (Select 1 from employee e where e.dept_name =d.dept_name)




SELECT * FROM revolut

SELECT *, AVG(val) OVER(Partition by id ORDER BY rev_data ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as _3_days_avg FROM revolut 


SELECT * FROM sales

SELECT SUM(price*quantity)  as sum_sales FROM sales GROUP BY store_id

SELECT AVG(price*quantity) FROM sales

SELECT *
FROM (
    SELECT store_name, SUM(price) as sum_sales
    FROM sales
    GROUP BY store_name
) s1
JOIN (
    SELECT AVG(sum_sales) as avg_sales
    FROM (
        SELECT store_name, SUM(price) as sum_sales
        FROM sales
        GROUP BY store_name
    ) subquery
) s2
ON s1.sum_sales > s2.avg_sales;

with s3 as (SELECT store_name, SUM(price) as sum_sales
    FROM sales
    GROUP BY store_name)
SELECT *
FROM s3
join (SELECT AVG(sum_sales) as avg_sales
    FROM (
        SELECT store_name, SUM(price) as sum_sales
        FROM sales
        GROUP BY store_name
    ) subquery
) s2
ON s3.sum_sales > s2.avg_sales;

SELECT *, (case when salary > (select avg(salary) FROM employee)
				then 'Higher than average' 
			else null
			end)
			as remarks from employee


SELECT *, (case when salary > avg_sal.sal
				then 'Higher than average' 
			else null
			end)
			as remarks 
from employee
cross join (select avg(salary) sal from employee) avg_sal

SELECT store_id, avg(quantity) OVER(Partition by store_id) as avg_quantity 
FROM sales


SELECT s1.store_name, s1.quantity 
from(
SELECT store_name, sum(quantity) as quantity
FROM sales
GROUP by store_name) as s1
join (SELECT avg(quantity) as quantity 
FROM sales) subquery 
ON s1.quantity > subquery.quantity

SELECT store_name, sum(quantity)
FROM sales
GROUP BY store_name
having sum(quantity) > (SELECT avg(quantity) as quantity 
FROM sales)

INSERT INTO employee_history
SELECT e.emp_id, e.emp_name, d.dept_name, e.salary,d.dept_location
FROM employee e 
join department d on e.dept_name = d.dept_name
where not exists (select 1 from employee_history eh where eh.emp_id = e.emp_id)

SELECT * from employee_history

SELECT dept_name, max(salary) from employee_history group by dept_name

update employee
SET salary = (select max(salary) + (max(salary)*0.1)
				from employee_history 
				where employee_history .dept_name = employee.dept_name)
where employee.dept_name in (select dept_name from department where dept_location = 'Porto')
and employee.emp_id in (select emp_id from employee_history)

DELETE FROM department WHERE dept_name in(SELECT dept_name
FROM department d 
WHERE NOT EXISTS (Select 1 from employee e where e.dept_name =d.dept_name))

SELECT * 
FROM department d 
WHERE NOT EXISTS (Select 1 from employee e where e.dept_name =d.dept_name)

SELECT * from logs

with numbers as( 
SELECT id, num,LAG(num) OVER(ORDER BY id) as Lag_num, LEAD(num) OVER(ORDER BY id) as Lead_num FROM logs)

Select id from numbers 
where num=lag_num and num = lead_num

with cs_nums as
(Select id, num,
row_number() OVER(ORDER BY id) as RN_ID,
row_number() OVER(Partition by num ORDER BY id) as RN_num,
(row_number() OVER(ORDER BY id)-
row_number() OVER(Partition by num ORDER BY id)) as FN_group
from logs)

SELECT num, count(*)
from cs_nums
GROUP BY FN_group, num

--
SELECT * from (
Select *,
row_number() OVER(PARTITION BY dept_name order by emp_id) as rn from employee) x WHERE x.rn>1


SELECT * from doctors

--doctors working on the same hospital with different specialities--
SELECT d1.* from doctors d1
 join doctors d2
On d1.id <> d2.id and d1.hospital = d2.hospital and d1.speciality <> d2.speciality

SELECT * from logins

--check if a user has 3 consecutive logins--
SELECT distinct username from(
SELECT *,
case when username = lead(username) over(order by login_id)
and username = lead(username,2) over(order by login_id)
then username 
else null
end as repeated_users
from logins) x
where x.repeated_users is not null

SELECT * from weather

--checking if temperatures below 0 3 times in a row--
SELECT id, city,temperature,day from(
SELECT *, case when temperature<0 
and lead(temperature,2) over(order by city) <0
and lead(temperature,1) over(order by city) <0
then 'Yes'
when temperature<0 
and lag(temperature) over(order by city)<0
and lead(temperature) over(order by city)<0
then 'Yes'
when temperature<0 
and lag(temperature,2) over(order by city)<0
and lag(temperature) over(order by city) < 0
then 'Yes'
else null
end as temp
from weather) x
where x.temp is not null

--fetching duplicates--
SELECT user_id, user_name, email from (
SELECT *, row_number() over(partition by user_name order by user_id) as rn from users) x
where x.rn >1


SELECT e1.emp_id, e1.emp_name, e1.salary FROM employee e1
Inner Join employee e2
on e1.salary=e2.salary and e1.emp_name <> e2.emp_name
order by e1.salary