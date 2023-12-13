SELECT * from employee



with a as
(SELECT *, dense_rank() over(order by salary desc) as rnk from employee)
SELECT DIstinct salary from a
where rnk =2


with a as
(SELECT *, dense_rank() over(partition by dept_name order by salary desc) as rnk from employee)
SELECT * from a
where rnk =1

SELECT * from 
(SELECT *, row_number() over(order by emp_id) as row_n from employee) as a
where row_n%2<>0


SELECT *from (SELECT *, rank() over(partition by dept_name order by emp_id) as row_n from employee) as a 
where row_n >1

SELECT * from employee 
where emp_name LIKE '%BB%'

SELECT * from 
(SELECT *, row_number() over(order by emp_id) as row_n from employee) as a
where row_n in(2,4)

