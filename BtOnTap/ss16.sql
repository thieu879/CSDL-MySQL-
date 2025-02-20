create database BtOn;
use BtOn;

create table Customers(
	customer_id int auto_increment primary key,
    customer_name varchar(100) not null,
    phone varchar(20) not null unique,
    address varchar(255)
);
create table Products(
	product_id int auto_increment primary key,
    product_name varchar(100) not null unique,
    price decimal(10,2) not null,
    quantity int not null check(quantity >= 0),
    category varchar(50) not null
);
create table Employees(
	employee_id int auto_increment primary key,
    employee_name varchar(100) not null,
    birthday date,
    position varchar(50) not null,
    salary decimal(10,2) not null,
    revenue decimal(10,2) default 0
);
create table Orders(
	order_id int auto_increment primary key,
    customer_id int,
    employee_id int,
    order_date datetime default current_timestamp,
	total_amount decimal(10,2) default 0,
    foreign key(customer_id) references Customers(customer_id) on delete cascade,
    foreign key(employee_id) references Employees(employee_id) on delete cascade
);
create table OrderDetails(
	order_detail_id int auto_increment primary key,
    order_id int,
    product_id int,
    quantity int not null check(quantity>0),
    unit_price decimal(10,2) not null,
    foreign key(order_id) references Orders(order_id) on delete cascade,
    foreign key(product_id) references Products(product_id) on delete cascade
);

-- câu 3:
alter table Customers add column email varchar(100) not null unique; 
alter table Employees drop birthday;

-- câu 4:
insert into customers(customer_name, phone, address, email)
values	
("nguyễn Văn A", "0123456789", "Hà Nội", "nva@gmail.com"),
("Nguyễn Văn B", "0123456788", "Sài Gòn", "nvb@gmail.com"),
("Nguyễn Văn c", "0123456787", "Hà Tĩnh", "nvc@gmail.com"),
("Nguyễn Văn D", "0123456786", "Nam định", "nvd@gmail.com"),
("Nguyễn Văn E", "0123456785", "Ninh Bình", "nve@gmail.com");

insert into Products(product_name, price, quantity, category)
values
("Tủ Lạnh", 10000.01, 3, "thiết bị điện tử"),
("ti vi", 10000.00, 3, "thiết bị điện tử"),
("Điện thoại", 10000.01, 3, "thiết bị điện tử"),
("Bàn", 10001.01, 3, "nội thất"),
("Ghế", 10000.01, 3, "nội thất");

insert into employees(employee_name, position, salary, revenue)
values
("Nguyễn văn f", "bán hàng", 5000000.00, 0),
("Nguyễn Văn G", "Giao hàng", 6000000.00, 0),
("nguyễn Văn H", "bán hàng", 5000000.00, 0),
("Nguyễn Văn I", "quản lý tài chính", 7000000.00, 0),
("Nguyễn Văn K", "bán hàng", 5000000.00, 0);

insert into Orders(customer_id, employee_id, order_date, total_amount)
values 
(1, 1, '2022-02-11 00:00:00', 5000000.00),
(2, 2, '2022-02-11 10:00:00', 5000000.00),
(3, 3, '2022-02-11 13:00:00', 5000000.00),
(4, 4, '2022-02-11 15:00:00', 5000000.00),
(5, 5, '2022-02-11 20:00:00', 5000000.00);

insert into orderdetails(order_id, product_id, quantity, unit_price)
values
(1, 1, 1, 10000.01),
(2, 1, 1, 10000.00),
(3, 1, 1, 10000.01),
(4, 1, 1, 10001.01),
(5, 1, 1, 10000.01);

-- câu 5.1:
select 
	*
from customers;
-- câu 5.2:
update Products
set  product_name = "laptop dell XPS", price = 99.99
where  product_id = 1;
select
	*
from products;
-- câu 5.3
select 
	Orders.order_id,
    Customers.customer_name,
    Employees.employee_name,
    sum(Orders.total_amount) as total_amount,
    Orders.order_date
from OrderDetails
join Orders on OrderDetails.order_id = Orders.order_id
join Customers on Orders.customer_id = Customers.customer_id
join Employees on Employees.employee_id = Orders.employee_id
group by OrderDetails.order_id;

-- câu 6.1:
select 
	Orders.order_id,
    Customers.customer_id,
    Customers.customer_name,
    count(Orders.order_id)
from OrderDetails
join Orders on OrderDetails.order_id = Orders.order_id
join Customers on Orders.customer_id = Customers.customer_id
group by OrderDetails.order_id, Customers.customer_name;

-- 6.2
SELECT 
    Employees.employee_id,
    Employees.employee_name,
    SUM(OrderDetails.quantity * OrderDetails.unit_price) AS revenue
FROM Employees
JOIN Orders ON Employees.employee_id = Orders.employee_id
JOIN OrderDetails ON OrderDetails.order_id = Orders.order_id
WHERE YEAR(Orders.order_date) = YEAR(CURDATE())
GROUP BY Employees.employee_id, Employees.employee_name;


-- câu 6.3:
select 
    products.product_id,
    products.product_name,
    sum(orderdetails.quantity) as total_quantity
from orderdetails
join products on orderdetails.product_id = products.product_id
join orders on orderdetails.order_id = orders.order_id
where month(orders.order_date) = month(curdate())
group by products.product_id, products.product_name
having total_quantity > 100
order by total_quantity desc;

-- câu 7.1:
select customer_id, customer_name
from customers
where customer_id not in (select distinct customer_id from orders);

-- câu 7.2:
select * from products
where price > (select avg(price) from products);

-- câu 7.3:
select customers.customer_id, customers.customer_name, sum(orders.total_amount) as total_spent
from orders
join customers on orders.customer_id = customers.customer_id
group by customers.customer_id, customers.customer_name
having total_spent = (select max(total_spent) from (select sum(total_amount) as total_spent from orders group by customer_id) as temp);

-- câu 8.1:
create view view_order_list as
select 
    orders.order_id, 
    customers.customer_name, 
    employees.employee_name, 
    orders.total_amount, 
    orders.order_date
from orders
join customers on orders.customer_id = customers.customer_id
join employees on orders.employee_id = employees.employee_id
order by orders.order_date desc;

-- câu 8.2:
create view view_order_detail_product as
select 
    orderdetails.order_detail_id, 
    products.product_name, 
    orderdetails.quantity, 
    orderdetails.unit_price
from orderdetails
join products on orderdetails.product_id = products.product_id
order by orderdetails.quantity desc;

-- câu 9.1: tạo thủ tục thêm nhân viên mới và trả về mã nhân viên vừa thêm
delimiter //
create procedure proc_insert_employee(
    in p_employee_name varchar(100),
    in p_position varchar(50),
    in p_salary decimal(10,2)
)
begin
    insert into employees(employee_name, position, salary) 
    values (p_employee_name, p_position, p_salary);
    
    select last_insert_id() as employee_id;
end //
delimiter ;

-- câu 9.2: tạo thủ tục lấy chi tiết đơn hàng theo mã đặt hàng
delimiter //
create procedure proc_get_orderdetails(
    in p_order_id int
)
begin
    select * from orderdetails where order_id = p_order_id;
end //
delimiter ;

-- câu 9.3: tạo thủ tục tính tổng số lượng loại sản phẩm trong đơn hàng
delimiter //
create procedure proc_cal_total_amount_by_order(
    in p_order_id int
)
begin
    select count(distinct product_id) as total_products
    from orderdetails 
    where order_id = p_order_id;
end //
delimiter ;

-- câu 10: tạo trigger cập nhật số lượng sản phẩm trong kho khi thêm chi tiết đơn hàng
delimiter //
create trigger trigger_after_insert_order_details
after insert on orderdetails
for each row
begin
    declare v_current_quantity int;

    -- lấy số lượng sản phẩm hiện có trong kho
    select quantity into v_current_quantity 
    from products 
    where product_id = new.product_id;
    
    -- kiểm tra số lượng tồn kho có đủ không
    if v_current_quantity < new.quantity then
        signal sqlstate '45000' 
        set message_text = 'số lượng sản phẩm trong kho không đủ';
    else
        -- cập nhật số lượng sản phẩm trong kho
        update products 
        set quantity = quantity - new.quantity 
        where product_id = new.product_id;
    end if;
end //
delimiter ;

-- câu 11: quản lý transaction khi thêm chi tiết đơn hàng
delimiter //
create procedure proc_insert_order_details(
    in p_order_id int,
    in p_product_id int,
    in p_quantity int,
    in p_unit_price decimal(10,2)
)
begin
    declare v_order_exists int;
    
    -- kiểm tra xem mã đơn hàng có tồn tại không
    select count(*) into v_order_exists 
    from orders 
    where order_id = p_order_id;
    
    if v_order_exists = 0 then
        signal sqlstate '45000' 
        set message_text = 'không tồn tại mã hóa đơn';
    end if;

    -- bắt đầu transaction
    start transaction;
    
    -- chèn dữ liệu vào bảng order_details
    insert into orderdetails(order_id, product_id, quantity, unit_price)
    values (p_order_id, p_product_id, p_quantity, p_unit_price);

    -- cập nhật tổng tiền của đơn hàng
    update orders 
    set total_amount = (
        select sum(quantity * unit_price) 
        from orderdetails 
        where order_id = p_order_id
    ) 
    where order_id = p_order_id;

    -- commit transaction nếu không có lỗi
    commit;
end //
delimiter ;


