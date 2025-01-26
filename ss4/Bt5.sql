CREATE DATABASE bt5;
USE bt5;

CREATE TABLE Employee (
    employee_id CHAR(4) PRIMARY KEY,
    employee_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    sex BIT NOT NULL,
    base_salary INT NOT NULL CHECK (base_salary > 0),
    phone_number CHAR(11) NOT NULL UNIQUE
);

INSERT INTO Employee (employee_id, employee_name, date_of_birth, sex, base_salary, phone_number)
VALUES
('E001', 'Nguyễn Minh Nhật', '2004-12-11', 1, 4000000, '0987836473'),
('E002', 'Đồ Đức Long', '2004-01-12', 1, 3500000, '0982378673'),
('E003', 'Mai Tiến Linh', '2004-02-03', 1, 3500000, '0976734562'),
('E004', 'Nguyễn Ngọc Ánh', '2004-10-04', 0, 5000000, '0987352772'),
('E005', 'Phạm Minh Sơn', '2003-03-12', 1, 4000000, '0987236568'),
('E006', 'Nguyễn Ngọc Minh', '2003-11-11', 0, 5000000, '0928864736');

SELECT employee_id, employee_name, date_of_birth, phone_number
FROM Employee;

UPDATE Employee
SET base_salary = base_salary * 1.1
WHERE sex = 0;

DELETE FROM Employee
WHERE YEAR(date_of_birth) = 2003;

