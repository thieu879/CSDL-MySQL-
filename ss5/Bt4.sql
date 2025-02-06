create database Bt4;
use Bt4;
-- Tạo bảng products
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY, 
    product_name VARCHAR(100) NOT NULL,        
    category VARCHAR(50) NOT NULL,            
    price DECIMAL(10, 2) NOT NULL,            
    stock_quantity INT NOT NULL               
);

-- Thêm bản ghi vào products
INSERT INTO products (product_name, category, price, stock_quantity)
VALUES
('Laptop Dell XPS 13', 'Electronics', 25999.99, 10),
('Nike Air Max 270', 'Footwear', 4999.00, 50),
('Samsung Galaxy S22', 'Electronics', 19999.99, 25),
('T-Shirt Uniqlo', 'Clothing', 299.99, 100),
('Apple AirPods Pro', 'Accessories', 5999.00, 15),
('T-Shirt Apolo', 'Clothing', 199.99, 100);

select 
    product_name, 
    category, 
    max(price) as max_price, 
    stock_quantity
from products;

select product_name, category, price, stock_quantity
from products
limit 2 offset 2;

select product_name, category, price, stock_quantity
from products
where category = 'electronics'
order by price desc;

select product_name, category, price, stock_quantity
from products
where category = 'clothing'
order by price asc
limit 1;


