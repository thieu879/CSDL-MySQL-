use classicmodels;

CREATE VIEW view_orders_summary AS
SELECT 
    customers.customerNumber, 
    customers.customerName, 
    COUNT(orders.orderNumber) AS total_orders
FROM customers
LEFT JOIN orders ON customers.customerNumber = orders.customerNumber
GROUP BY customers.customerNumber, customers.customerName;

SELECT 
    customerNumber, 
    customerName, 
    total_orders
FROM view_orders_summary
WHERE total_orders > 3;
