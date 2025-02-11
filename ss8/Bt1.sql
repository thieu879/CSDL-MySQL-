create database Bt1;
use Bt1;

CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    department VARCHAR(50),
    salary DECIMAL(10, 2) NOT NULL,
    manager_id INT NULL
);
-- Thêm dữ liệu vào bảng
INSERT INTO employees (name, department, salary, manager_id) VALUES
('Alice', 'Sales', 6000, NULL),         
('Bob', 'Marketing', 7000, NULL),     
('Charlie', 'Sales', 5500, 1),         
('David', 'Marketing', 5800, 2),       
('Eva', 'HR', 5000, 3),                
('Frank', 'IT', 4500, 1),              
('Grace', 'Sales', 7000, 3),           
('Hannah', 'Marketing', 5200, 2),     
('Ian', 'IT', 6800, 3),               
('Jack', 'Finance', 3000, 1); 

create view view_high_salary_employees as
select employee_id,name, salary
from employees
where salary > 5000;

select 
	employee_id,
    name,
    salary
from view_high_salary_employees;

insert into employees(name, department, salary, manager_id)
values
('Nguyen Van A', 'Finance', 10000, 1);
select 
	employee_id,
    name,
    salary
from view_high_salary_employees;

delete from employees where name = 'Nguyen Van A';
select 
	employee_id,
    name,
    salary
from view_high_salary_employees;