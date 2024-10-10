-- Job Level Classification Based on in company years
-- notes: while their in company years does not reflect their position, 
-- i use it simply as parameter for classification 
drop view if exists class;
create view class as
select 
	employee_id, name, department, position, in_company_years,
    case 
		when position like '%intern%' then 'intern' 
        when in_company_years >=0 and in_company_years <=5 then 'entry_level'
        when in_company_years >=6 and in_company_years <=11 then 'senior_staff'
        when in_company_years >=12 and in_company_years <=17 then 'first_level'
        when in_company_years >=17 and in_company_years <=22 then 'mid_management' 
        when in_company_years >22 then 'c_suite'
	end as Classification 
from employee
order by in_company_years;

-- what is the avg salary from each level?

-- to ensure easier code,
-- i use the view function so i can return classification level without rewriting the command
select classification, round(avg(e.salary),2) as avg_salary
from class c
left join 
	employee e
on c.employee_id = e.employee_id
group by c.classification    	
order by avg_salary desc;

-- Next, i would like to alter the table. By Updating New Colomn to determine on their new bonus 
-- New Bonus, Bonus Formula (5% of their gross salary * in_company_years)

alter table employee
add column bonus decimal(9,2);

update employee
set Bonus = 5/100*Gross_salary*in_company_years;

-- Lastly, i wanted to calculate tax rate and gender pay gap
-- tax rate 
-- tax rate formula = gross salary - salary/gross salary * 100 

select 
	name, department, position, 
	round(gross_salary - salary,2) as tax_paid, 
    round(((gross_salary - salary)/gross_salary) * 100,2) as tax_rate
from employee;

-- Gender pay gap 
select 
    department,
    male_avg_salary,
    female_avg_salary,
    (male_avg_salary - female_avg_salary) as pay_gap
from (
    select 
        department, 
        round(avg(case when sex = 'male' then salary end)) as male_avg_salary,
        round(avg(case when sex = 'female' then salary end)) as female_avg_salary
    from employee
    group by department
) as salary_averages;