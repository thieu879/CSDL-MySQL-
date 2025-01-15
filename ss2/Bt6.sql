use Bt4;
INSERT INTO Employee (EmployeeID, FullName, DateOfHire, Salary)
values 
(1, 'Nguyen Van A', '2023-01-01', 5000),
(2, 'Tran Thi B', '2023-05-15', 5000),
(3, 'Le Van C', '2024-03-10', 5000),
(4, 'Pham Thi D', '2025-01-01', 5000);
UPDATE Employee
SET Salary = 7000
WHERE EmployeeID = 1;
DELETE FROM Employee
WHERE EmployeeID = 3;




