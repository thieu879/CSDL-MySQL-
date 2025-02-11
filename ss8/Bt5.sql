use classicmodels;
CREATE INDEX idx_creditlimit ON customers(creditLimit);

SELECT 
    customers.customerNumber, 
    customers.customerName, 
    customers.city, 
    customers.creditLimit, 
    offices.country
FROM customers
JOIN offices ON customers.salesRepEmployeeNumber = offices.officeCode
WHERE customers.creditLimit BETWEEN 50000 AND 100000
ORDER BY customers.creditLimit DESC
LIMIT 5;


EXPLAIN ANALYZE 
SELECT 
    customers.customerNumber, 
    customers.customerName, 
    customers.city, 
    customers.creditLimit, 
    offices.country
FROM customers
JOIN offices ON customers.salesRepEmployeeNumber = offices.officeCode
WHERE customers.creditLimit BETWEEN 50000 AND 100000
ORDER BY customers.creditLimit DESC
LIMIT 5;
