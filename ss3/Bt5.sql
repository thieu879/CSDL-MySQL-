create database bt5;
use bt5;

create table Employees (
    employee_id int primary key not null auto_increment,
    name varchar(255) not null,
    email varchar(225) not null unique,
    department varchar(100) not null,
    salary decimal(10,2) check (salary > 0)
);

 INSERT INTO Employees (name, email, department, salary) 
VALUES 
('Nguyen Van A', 'nguyenvana@example.com', 'Sales', 50000.00), 
('Le Thi B', 'lethib@example.com', 'IT', 60000.00), 
('Tran Van C', 'tranvanc@example.com', 'HR', 45000.00), 
('Pham Thi D', 'phamthid@example.com', 'Marketing', 55000.00);

select * from Employees where department = Sales;
UPDATE Employees
SET salary = salary * 1.10
WHERE department = 'Marketing';
