CREATE DATABASE bt6;
USE bt6;

CREATE TABLE Employee (
    employee_id CHAR(4) PRIMARY KEY,
    employee_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    sex BIT NOT NULL,
    base_salary INT NOT NULL CHECK (base_salary > 0),
    phone_number CHAR(11) NOT NULL UNIQUE
);

CREATE TABLE Department (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL UNIQUE,
    address VARCHAR(50) NOT NULL
);

ALTER TABLE Employee
ADD COLUMN department_id INT NOT NULL;

ALTER TABLE Employee
ADD CONSTRAINT fk_department
FOREIGN KEY (department_id) REFERENCES Department(department_id);

INSERT INTO Department (department_name, address)
VALUES
('Hành chính', 'Tầng 1'),
('Kỹ thuật', 'Tầng 2'),
('Kinh doanh', 'Tầng 3'),
('Marketing', 'Tầng 4'),
('Tài chính', 'Tầng 5');

INSERT INTO Employee (employee_id, employee_name, date_of_birth, sex, base_salary, phone_number, department_id)
VALUES
('E001', 'Nguyễn Minh Nhật', '2004-12-11', 1, 4000000, '0987836473', 1),
('E002', 'Đồ Đức Long', '2004-01-12', 1, 3500000, '0982378673', 2),
('E003', 'Mai Tiến Linh', '2004-02-03', 1, 3500000, '0976734562', 3),
('E004', 'Nguyễn Ngọc Ánh', '2004-10-04', 0, 5000000, '0987352772', 4),
('E005', 'Phạm Minh Sơn', '2003-03-12', 1, 4000000, '0987236568', 5),
('E006', 'Nguyễn Ngọc Minh', '2003-11-11', 0, 5000000, '0928864736', 1),
('E007', 'Lê Thành Công', '2000-04-01', 1, 4500000, '0987531234', 2),
('E008', 'Vũ Thị Thanh', '1999-12-12', 0, 5000000, '0988456372', 3),
('E009', 'Phạm Văn Dũng', '1998-05-10', 1, 6000000, '0912356487', 4),
('E010', 'Nguyễn Phương Anh', '1997-07-15', 0, 5500000, '0912346578', 5);

ALTER TABLE Employee
DROP FOREIGN KEY fk_department;

DELETE FROM Department
WHERE department_id = 1;

UPDATE Department
SET department_name = 'Hành chính - Quản trị'
WHERE department_id = 1;

SELECT * FROM Employee;

SELECT * FROM Department;
