use classicmodels;
EXPLAIN ANALYZE
select 
	contactLastName,
    contactFirstName,
    country
from customers
where country = "Germany";

create index idx_country on customers(country);
EXPLAIN ANALYZE
select 
	contactLastName,
    contactFirstName,
    country
from customers
where country = "Germany";

drop index idx_country on customers;