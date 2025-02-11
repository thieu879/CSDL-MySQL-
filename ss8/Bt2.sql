create database Bt2;
use Bt2;

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

create view view_manager_summary as
select manager_id, count(employee_id) as total_employees 
from employees
where manager_id is not null
group by manager_id;

select
	manager_id,
    total_employees
from view_manager_summary
group by manager_id;

select
	employees.name,
    view_manager_summary.total_employees
from employees
join view_manager_summary on view_manager_summary.manager_id = employees.manager_id;
