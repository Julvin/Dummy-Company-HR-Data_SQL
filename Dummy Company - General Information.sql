-- General Information (Total Employee, Gender Count, Age Distribution, Avg Age)
-- Total Employee 
-- Firstly, i would check for the duplicate 
-- (It is possible to change it the column into primary key, hence this might not be necessary) 

Select employee_id, count(*) as total_employee
from employee
group by employee_id
having count(*) > 1;

-- No duplicate (it must be true since it have already become a primary key)
-- Next, i will check for the total employee, using their id

select distinct count(employee_id) 
from employee;

-- Employee distribution by Gender 
select sex, count(*) as amount
from employee
group by sex
order by amount desc;

-- Age Distribution 
select age, count(*) as amount
from employee
group by age
order by age;

-- Average Age
select 
    min(age) as min_age,
    max(age) as max_age,
    round(avg(age), 2) as avg_age
from employee;

-- Department General Information 
-- in this dummy company, there are 5 department. To inquire:

Select distinct department
from employee;

-- In this section, i would query the general information for each department.
-- This include,

-- Headcount per Department, i will use rollup to ensure the amount counted match with previous query

Select 
	department,
    count(*) as amount, 
	(count(*) * 100)/(select count(*) from employee) as percentage
from employee
group by department with rollup
order by amount desc;

-- Headcount by Gender

explain select 
	department, sex, count(*) as amount,
    (count(*) * 100)/(select count(sex) from employee e2 where e2.department = e1.department ) as percentage
from employee e1
group by department, sex 
order by department;

-- Age Statistics Per Department 

select 
	department, count(*) as total_employee,
	min(age) as min_age, 
    max(age) as max_age, 
    avg(age) as avg_age
from employee
group by department
order by avg_age desc;

select *
from employee
