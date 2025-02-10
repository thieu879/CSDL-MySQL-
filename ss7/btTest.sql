create database test1;
use test1;
create table tbl_users(
	user_id int auto_increment primary key,
    user_name varchar(50) not null unique,
    user_fullname varchar(100) not null,
    Email varchar(100) not null unique,
    user_address varchar(255),
    user_phone varchar(20) not null unique
);

create table tbl_employees(
	emp_id char(5) primary key,
    user_id int unique,
    emp_position varchar(50),
    emp_hire_date date,
    salary int not null check(salary>0),
    emp_status enum ("đang làm", "đang nghỉ") default "đang làm",
    foreign key(user_id) references tbl_users(user_id)
);

create table tbl_orders(
	order_id int auto_increment primary key,
	user_id int,
    order_date date default (current_date),
    order_total_amount int,
    foreign key (user_id) references tbl_users(user_id)
);

create table tbl_products(
	pro_id char(5) primary key,
    pro_name varchar(100) unique not null,
    pro_price int not null check(pro_price>0),
    pro_quantity int,
    pro_status enum ("hết hàng", "còn hàng") default("còn hàng")
);
create table tbl_order_detail(
	order_detail_id int auto_increment primary key,
    order_id int,
    pro_id char(5),
    order_detail_quantity int check(order_detail_quantity>0),
    order_detail_price int,
    foreign key(order_id) references tbl_orders(order_id),
    foreign key(pro_id) references tbl_products(pro_id)
);

alter table tbl_orders add order_status enum( "Pending", "Processing", "Completed", "Cancelled");
alter table tbl_users modify column user_phone varchar(11);
alter table tbl_users drop column Email;

-- Thêm dữ liệu vào bảng tbl_users (bao gồm ít nhất 1 nhân viên)
INSERT INTO tbl_users (user_name, user_fullname, user_address, user_phone)
VALUES 
('john_doe', 'John Doe', '123 Main St', '0987654321'),
('jane_smith', 'Jane Smith', '456 Elm St', '0976543210'),
('michael_lee', 'Michael Lee', '789 Oak St', '0965432109');

-- Thêm dữ liệu vào bảng tbl_employees (liên kết với user_id của nhân viên)
INSERT INTO tbl_employees (emp_id, user_id, emp_position, emp_hire_date, salary, emp_status)
VALUES 
('E001', 3, 'Manager', '2023-01-15', 20000000, 'đang làm');

-- Thêm dữ liệu vào bảng tbl_orders
INSERT INTO tbl_orders (user_id, order_date, order_total_amount, order_status)
VALUES 
(1, '2024-02-01', 500000, 'Completed'),
(2, '2024-02-02', 750000, 'Processing'),
(1, '2024-02-03', 300000, 'Pending');

-- Thêm dữ liệu vào bảng tbl_products
INSERT INTO tbl_products (pro_id, pro_name, pro_price, pro_quantity, pro_status)
VALUES 
('P001', 'Laptop', 15000000, 10, 'còn hàng'),
('P002', 'Smartphone', 8000000, 20, 'còn hàng'),
('P003', 'Tablet', 5000000, 15, 'hết hàng');

-- Thêm dữ liệu vào bảng tbl_order_detail (chi tiết đơn hàng)
INSERT INTO tbl_order_detail (order_id, pro_id, order_detail_quantity, order_detail_price)
VALUES 
(1, 'P001', 1, 15000000),
(2, 'P002', 2, 16000000),
(3, 'P003', 1, 5000000);

select order_id, order_date, order_total_amount, order_status from tbl_orders;

select 
	user_name 
from tbl_users 
join tbl_orders on tbl_users.user_id = tbl_orders.user_id
group by user_name;

select 
	pro_name, 
    sum(tbl_order_detail.order_detail_quantity) as "tổng"
from tbl_order_detail
join tbl_products on tbl_order_detail.pro_id = tbl_products.pro_id
group by tbl_products.pro_name;

select 
	tbl_products.pro_name,
	sum(tbl_order_detail.order_detail_price * tbl_order_detail.order_detail_quantity) as sum_
from tbl_order_detail
join tbl_products on tbl_order_detail.pro_id = tbl_products.pro_id
group by tbl_products.pro_name
order by sum_ desc;

select 
	tbl_users.user_fullname, 
    count(tbl_orders.order_id)
from tbl_orders 
join tbl_users on tbl_orders.user_id = tbl_users.user_id
group by tbl_users.user_fullname;

select 
	tbl_users.user_fullname,
    count(tbl_orders.order_id) as total_order
from tbl_orders
join tbl_users on tbl_orders.user_id = tbl_users.user_id
group by tbl_users.user_fullname
having total_order >= 2;

select
	tbl_users.user_fullname,
    sum(order_total_amount)
from tbl_orders
join tbl_users on tbl_orders.user_id = tbl_users.user_id
group by tbl_users.user_fullname
limit 5;

select 
	tbl_employees.emp_id,
    tbl_employees.emp_position,
    sum(tbl_orders.order_total_amount)
from tbl_employees
join tbl_users on tbl_users.user_id = tbl_employees.user_id
left join tbl_orders on tbl_orders.user_id = tbl_users.user_id
group by tbl_employees.emp_id;

select 
	tbl_users.user_fullname,
    tbl_orders.order_total_amount
from tbl_users
join tbl_orders on tbl_orders.user_id = tbl_users.user_id
having tbl_orders.order_total_amount = (select max(order_total_amount) from tbl_orders);

SELECT p.pro_id, p.pro_name, p.pro_quantity
FROM tbl_products p
WHERE p.pro_id NOT IN (SELECT DISTINCT od.pro_id FROM tbl_order_detail od);
