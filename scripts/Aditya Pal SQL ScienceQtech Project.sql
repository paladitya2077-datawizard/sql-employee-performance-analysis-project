/*
1.	Create a database named employee, then import data_science_team.csv 
proj_table.csv and emp_record_table.csv into the employee database from the given resources.
*/

create database project1_employees;

use project1_employees;

-- Modifying data types
alter table data_science_team
modify column EMP_ID char(10),
modify column EXP int;

alter table emp_record_table
modify column EMP_ID char(10),
modify column EXP int,
modify column SALARY decimal(10,2),
modify column EMP_RATING int,
modify column MANAGER_ID char(10),
modify column PROJ_ID char(10);

set sql_safe_updates = 0;

UPDATE proj_table 
SET 
    `START _DATE` = '07-15-2021'
WHERE
    PROJECT_ID = 'P204';

-- Updating the dates
UPDATE proj_table 
SET 
    `START _DATE` = STR_TO_DATE(`START _DATE`, '%m-%d-%Y'),
    CLOSURE_DATE = STR_TO_DATE(CLOSURE_DATE, '%m/%d/%Y');

-- Modifying data types
alter table proj_table
modify column PROJECT_ID char(10),
modify column `START _DATE` date,
modify column CLOSURE_DATE date;

-- Adding Primary and Foreign Keys
alter table emp_record_table
add primary key (EMP_ID);

alter table data_science_team
add foreign key (EMP_ID)
	 references emp_record_table(EMP_ID);

alter table proj_table
add primary key (PROJECT_ID);

alter table emp_record_table
add foreign key (MANAGER_ID)
	references emp_record_table(EMP_ID);

-- Identify problematic row in proj_table
SELECT DISTINCT
    e.PROJ_ID
FROM
    emp_record_table e
        LEFT JOIN
    proj_table p ON e.PROJ_ID = p.PROJECT_ID
WHERE
    p.PROJECT_ID IS NULL
        AND e.PROJ_ID IS NOT NULL;

-- Updating the value
UPDATE emp_record_table 
SET 
    PROJ_ID = NULL
WHERE
    EMP_ID = 'E260';

-- Adding Foreign Key
alter table emp_record_table
add foreign key (PROJ_ID)
	references proj_table (PROJECT_ID);

-- Renaming column
ALTER TABLE proj_table 
RENAME COLUMN `START _DATE` TO START_DATE;

/*
2.	Create an ER diagram for the given employee database.
*/
-- Done

/*
3. Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table,
and make a list of employees and details of their department.
*/
SELECT 
    EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT AS 'Department'
FROM
    emp_record_table
ORDER BY 1;

/*
4.	Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, 
and EMP_RATING if the EMP_RATING is: 
●	less than two
●	greater than four = WHERE EMP_RATING > 4
●	between two and four = WHERE EMP_RATING BETWEEN 2 AND 4
*/

-- (1)
SELECT 
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    GENDER,
    DEPT AS 'Department',
    EMP_RATING
FROM
    emp_record_table
WHERE
    EMP_RATING < 2
ORDER BY 6;

-- (2)
SELECT 
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    GENDER,
    DEPT AS 'Department',
    EMP_RATING
FROM
    emp_record_table
WHERE
    EMP_RATING > 4
ORDER BY 6;

-- (3)
SELECT 
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    GENDER,
    DEPT AS 'Department',
    EMP_RATING
FROM
    emp_record_table
WHERE
    EMP_RATING BETWEEN 2 AND 4
ORDER BY 6;

/*
5.	Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees 
in the Finance department from the employee table and then
give the resultant column alias as NAME.
*/
SELECT 
    EMP_ID,
    CONCAT_WS(' ', TRIM(FIRST_NAME), TRIM(LAST_NAME)) AS 'Name',
    DEPT AS 'Department'
FROM
    emp_record_table
WHERE
    DEPT = 'Finance';

/*
6. Write a query to list only those employees 
who have someone reporting to them. 
Also, show the number of reporters (including the President).
SELF JOIN
*/
SELECT 
    e.EMP_ID AS 'Manager_ID',
    CONCAT_WS(' ',
            TRIM(e.FIRST_NAME),
            TRIM(e.LAST_NAME)) AS 'Name',
    COUNT(e.EMP_ID) AS 'No_of_Reporters'
FROM
    emp_record_table e
        INNER JOIN
    emp_record_table m ON e.EMP_ID = m.MANAGER_ID
GROUP BY 1 , 2
ORDER BY 1;

/*
7.Write a query to list down all the employees from the 
healthcare and finance departments using union.
Take data from the employee record table.
*/

-- With UNION 
select EMP_ID, 
CONCAT_WS(' ', TRIM(FIRST_NAME), TRIM(LAST_NAME)) AS 'Name',
DEPT as 'Department'
from emp_record_table
where DEPT = 'Finance'
union
select EMP_ID, 
CONCAT_WS(' ', TRIM(FIRST_NAME), TRIM(LAST_NAME)) AS 'Name',
DEPT as 'Department'
from emp_record_table
where DEPT = 'Healthcare';

-- Without UNION 
SELECT 
    EMP_ID, CONCAT_WS(' ', TRIM(FIRST_NAME), TRIM(LAST_NAME)) AS 'Name',
    DEPT as 'Department'
FROM
    emp_record_table
WHERE
    DEPT IN ('Finance' , 'Healthcare')
ORDER BY 3;

/*
8.	Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT,
and EMP_RATING grouped by dept. Also include the respective employee rating along with the max emp rating
for the department.
*/
select EMP_ID, 
CONCAT_WS(' ', TRIM(FIRST_NAME), TRIM(LAST_NAME)) AS 'Name',
ROLE,
DEPT as 'Department',
max(EMP_RATING) over(partition by DEPT) as 'Max_Emp_Rating'
from emp_record_table
order by 5 desc;

/*
9.Write a query to calculate the minimum and the maximum salary of the employees in each role.
 Take data from the employee record table.
*/

-- By Roles
SELECT 
    ROLE,
    MIN(SALARY) AS 'Min_Salary',
    MAX(SALARY) AS 'Max_Salary'
FROM
    emp_record_table
GROUP BY 1;

-- By Employees and thier Roles
SELECT 
	EMP_ID, 
    CONCAT_WS(' ', TRIM(FIRST_NAME), TRIM(LAST_NAME)) AS 'Name',
    ROLE,
    SALARY,
    MIN(SALARY) over(partition by ROLE) AS 'Min_Salary',
    MAX(SALARY) over(partition by ROLE) AS 'Max_Salary'
FROM
    emp_record_table;

/*
10.	Write a query to assign ranks to each employee based on their experience. 
Take data from the employee record table.
*/
select EMP_ID, CONCAT_WS(' ', TRIM(FIRST_NAME), TRIM(LAST_NAME)) AS 'Name',
EXP, dense_rank() over(order by EXP desc) as 'Rank_by_Exp'
from emp_record_table;

/*
11.	Write a query to create a view that displays employees in various countries 
whose salary is more than six thousand. Take data from the employee record table.
*/
create view emp_countries_views
as
select EMP_ID, CONCAT_WS(' ', TRIM(FIRST_NAME), TRIM(LAST_NAME)) AS 'Name',
COUNTRY, SALARY
from emp_record_table
where SALARY > 6000
order by 3,4;

/*
12.	Write a nested query to find employees with experience of more than ten years. 
Take data from the employee record table.
*/

-- sub query
select EMP_ID
from emp_record_table
where EXP > 10;

-- main query
select *
from emp_record_table
where EMP_ID in (select EMP_ID
from emp_record_table
where EXP > 10);

/*
13.	Write a query to create a stored procedure to 
retrieve the details of the employees whose experience is more than three years. 
Take data from the employee record table.
*/
delimiter //
create procedure emp_details()
begin
select *
from emp_record_table
where EXP > 3;
end //
delimiter ;

call project1_employees.emp_details();

/*
14.	Write a query using stored functions in the project table to check whether the 
job profile assigned to each employee in the data science team matches the organization’s set standard.
The standard being:
For an employee with experience less than or equal to 2 years assign 'JUNIOR DATA SCIENTIST',
For an employee with the experience of 2 to 5 years assign 'ASSOCIATE DATA SCIENTIST',
For an employee with the experience of 5 to 10 years assign 'SENIOR DATA SCIENTIST',
For an employee with the experience of 10 to 12 years assign 'LEAD DATA SCIENTIST',
For an employee with the experience of 12 to 16 years assign 'MANAGER'.
*/
		
delimiter &&
create function emp_job_profile(experience int)
returns varchar(50)
deterministic
begin
declare roles varchar(50) default '';
    if experience <= 2 then
		set roles = 'JUNIOR DATA SCIENTIST' ;
	elseif experience > 2 and experience <= 5 then
		set roles = 'ASSOCIATE DATA SCIENTIST' ;
	elseif experience > 5 and experience <= 10 then
		set roles = 'SENIOR DATA SCIENTIST' ;
	elseif experience > 10 and experience <= 12 then
		set roles = 'LEAD DATA SCIENTIST' ;
     elseif experience > 12 and experience <= 16 then
		set roles = 'MANAGER'  ;
	else 
        set roles = 'UNKNOWN';
	end if ;
return (roles);
end &&
delimiter ;

select EMP_ID, FIRST_NAME, LAST_NAME, EXP, ROLE, emp_job_profile(EXP) as 'Roles'
from emp_record_table;

































