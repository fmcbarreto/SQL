SELECT * from employee

SELECT e.*,
max(salary) over(partition by dept_name) as max_salary
from employee e

SELECT * from (
SELECT e.*,
row_number() over(PARTITION BY  dept_name order by emp_id) as rn
from employee e) f
where f.rn<3

SELECT * from(
SELECT e.*,
rank() over(partition by dept_name order by salary desc ) as rnk
from employee e) x
where x.rnk < 4


SELECT e.*,
rank() over(partition by dept_name order by salary desc ) as rnk,
dense_rank() over(partition by dept_name order by salary desc ) as DENSErnk
from employee e