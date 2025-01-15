CREATE DATABASE Bt1;
USE Bt1;
-- a, 5 kiểu dữ liệu cơ bản thường dùng trong SQL: int, varchar, char, date, boolean, decimal
-- b, 
CREATE TABLE Student (
    StudentID INT PRIMARY KEY,
    FullName CHAR(50),
    BirthDate DATE,
    AverageScore DECIMAL(5, 2)
);
