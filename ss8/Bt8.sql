use classicmodels;

create index idx_productline on products(productline);

create view view_highest_priced_products as
select 
    products.productline, 
    products.productname, 
    products.msrp
from products
where products.msrp = (
    select max(products_sub.msrp) 
    from products as products_sub 
    where products_sub.productline = products.productline
);

select * from view_highest_priced_products;

select 
    view_highest_priced_products.productline, 
    view_highest_priced_products.productname, 
    view_highest_priced_products.msrp, 
    productlines.textdescription
from view_highest_priced_products
join productlines on view_highest_priced_products.productline = productlines.productline
order by view_highest_priced_products.msrp desc
limit 10;

