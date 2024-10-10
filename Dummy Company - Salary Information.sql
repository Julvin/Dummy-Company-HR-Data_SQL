-- This part will discuss the information surrounding employee salary 

-- Average Salary 
select round(avg(salary), 2) as avg_employee_salary, min(salary), max(salary)
from employee;

-- Average Salary per Department, excluding intern 
select department, round(avg(salary), 2) as avg_employee_salary
from employee
where position not like '%intern'
group by department
order by avg_employee_salary desc;

-- average salary per department, per gender 
select department,sex, avg(salary)
from employee
group by department, sex
order by department;

-- Average Salary per Age Group, limited to top 5
select age, round(avg(salary),2) as avg_salary
from employee
group by age
order by avg_salary desc
limit 5; 

-- Salary that are larger than firm average salary 
select name, department, salary
from employee
where salary > (select avg(salary) from employee)
order by salary desc;

-- Employee Salary that are larger than their respective department salary 
select name, department, salary 
from employee e
where salary > (
	select avg(salary)
    from employee
    where department = e.department
    );
    
-- Female that have lower wages than their department average salary 
select name, sex, department, salary
from employee e
where 
	sex = 'female' and salary < 
(select avg(salary) from employee where e.department = department);

-- what position paid the most in the Human Resources Department 
select name, position 
from employee
where department = 'Human Resources'
order by salary desc
limit 1;

-- For Each Department (or more than one position) 
select name, department, position 
from employee e
where 
	salary = (select max(salary) from employee where department = e.department)
	and department in ('finance', 'it')