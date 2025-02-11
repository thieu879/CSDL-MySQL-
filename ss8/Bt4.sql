use classicmodels;

EXPLAIN ANALYZE
select 
	orderNumber,
    orderDate,
    status
from orders 
where status = "Shipped" and year(orderDate) = "2003";
create index idx_orderDate_status on orders(orderDate, status);

EXPLAIN ANALYZE
select
	customerNumber,
    customerName,
    phone
from customers
where phone = "2035552570";
create unique index idx_customerNumber on customers(customerNumber);
create unique index idx_phone on customers(phone);
