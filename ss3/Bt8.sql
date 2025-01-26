CREATE DATABASE bt8;
USE bt8;

CREATE TABLE Products (
    product_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) CHECK (price > 0) NOT NULL,
    stock INT CHECK (stock >= 0) NOT NULL,
    category VARCHAR(100)
);

INSERT INTO Products (name, price, stock, category)
VALUES
('iPhone 14', 999.99, 20, 'Electronics'),
('Samsung Galaxy S23', 849.99, 15, 'Electronics'),
('Sony Headphones', 199.99, 30, 'Electronics'),
('Wooden Table', 120.50, 10, 'Furniture'),
('Office Chair', 89.99, 25, 'Furniture'),
('Running Shoes', 49.99, 50, 'Sports'),
('Basketball', 29.99, 100, 'Sports'),
('T-Shirt', 19.99, 200, 'Clothing'),
('Laptop Bag', 39.99, 40, 'Accessories'),
('Desk Lamp', 25.00, 35, 'Electronics');

SELECT * 
FROM Products
WHERE category = 'Electronics' AND price > 200;

SELECT * 
FROM Products
WHERE stock < 20;

SELECT name, price 
FROM Products
WHERE category IN ('Sports', 'Accessories');

UPDATE Products
SET stock = 100
WHERE name LIKE 'S%';

UPDATE Products
SET category = 'Premium Electronics'
WHERE price > 500;

DELETE FROM Products
WHERE stock = 0;

DELETE FROM Products
WHERE category = 'Clothing' AND price < 30;

