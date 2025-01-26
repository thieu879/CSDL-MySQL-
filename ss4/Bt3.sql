CREATE DATABASE Bt3;
USE Bt3;

CREATE TABLE Customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL,
    birthday DATE NOT NULL,
    sex BIT NOT NULL,
    job VARCHAR(50),
    phone_number CHAR(11) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    address VARCHAR(255) NOT NULL
);

INSERT INTO Customer (customer_name, birthday, sex, job, phone_number, email, address)
VALUES
('Nguyen Van A', '2000-05-15', 1, 'Teacher', '09876543210', 'nguyenvana@example.com', 'Hanoi'),
('Tran Thi B', '1995-08-22', 0, 'Engineer', '09123456789', 'tranthib@example.com', 'Ho Chi Minh City'),
('Le Van C', '2002-01-10', 1, 'Student', '09345678901', 'levanc@example.com', 'Da Nang'),
('Pham Thi D', '1998-12-05', 0, 'Nurse', '09456789012', 'phamthid@example.com', 'Hai Phong'),
('Hoang Van E', '1997-03-18', 1, NULL, '09567890123', 'hoangvane@example.com', 'Can Tho'),
('Do Thi F', '2001-07-25', 0, 'Accountant', '09678901234', 'dothif@example.com', 'Hue'),
('Vo Van G', '2003-08-30', 1, NULL, '09789012345', 'vovang@example.com', 'Nha Trang'),
('Nguyen Thi H', '1999-09-15', 0, 'Doctor', '09890123456', 'nguyenthih@example.com', 'Ha Long'),
('Bui Van I', '2004-02-28', 1, 'Designer', '09901234567', 'buivani@example.com', 'Quang Ninh'),
('Tran Thi J', '2005-06-12', 0, 'Student', '09112345678', 'tranthij@example.com', 'Vung Tau');

UPDATE Customer
SET customer_name = 'Nguyễn Quang Nhật', birthday = '2004-01-11'
WHERE customer_id = 1;

DELETE FROM Customer
WHERE MONTH(birthday) = 8;

SELECT 
    customer_id,
    customer_name,
    birthday,
    CASE WHEN sex = 1 THEN 'Nam' ELSE 'Nữ' END AS gender,
    phone_number
FROM Customer
WHERE birthday > '2000-01-01';

SELECT * FROM Customer WHERE job IS NULL;
