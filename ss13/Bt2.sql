create database Bt2;
use Bt2;
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(50),
    price DECIMAL(10,2),
    stock INT NOT NULL
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    quantity INT NOT NULL,
    total_price DECIMAL(10,2),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO products (product_name, price, stock) VALUES
('Laptop Dell', 1500.00, 10),
('iPhone 13', 1200.00, 8),
('Samsung TV', 800.00, 5),
('AirPods Pro', 250.00, 20),
('MacBook Air', 1300.00, 7);

delimiter //
create procedure place_order(
    in p_product_id int,
    in p_quantity int
)
begin
    declare stock_available int default 0;
    declare product_price decimal(10,2);
    start transaction;
    select stock, price into stock_available, product_price
    from products
    where product_id = p_product_id;
    if stock_available < p_quantity then
        rollback;
        signal sqlstate '45000' 
        set message_text = 'số lượng sản phẩm không đủ trong kho';
    else
        insert into orders (product_id, quantity, total_price)
        values (p_product_id, p_quantity, product_price * p_quantity);
        update products
        set stock = stock - p_quantity
        where product_id = p_product_id;
        commit;
    end if;
end 
// delimiter ;

call place_order(2, 3);

select * from products;
select * from orders;
