use classicmodels;

CREATE VIEW view_customer_status AS
SELECT 
    customerNumber, 
    customerName, 
    creditLimit,
    CASE 
        WHEN creditLimit > 100000 THEN 'High'
        WHEN creditLimit BETWEEN 50000 AND 100000 THEN 'Medium'
        ELSE 'Low'
    END AS status
FROM customers;

SELECT * FROM view_customer_status;

SELECT 
    status, 
    COUNT(customerNumber) AS customer_count
FROM view_customer_status
GROUP BY status
ORDER BY customer_count DESC;
