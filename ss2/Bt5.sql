create database Bt5;
use Bt5;
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    PhoneNumber VARCHAR(10) NOT NULL
);

CREATE TABLE Invoice (
    InvoiceID INT PRIMARY KEY,
    IssueDate DATE,
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);
