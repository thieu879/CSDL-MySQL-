create database Bt4;
use Bt4;
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    FullName VARCHAR(50),
    DateOfHire DATE,
    Salary DECIMAL(4, 0) DEFAULT 5000
);
