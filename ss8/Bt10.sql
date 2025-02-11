use classicmodels;

create index idx_productline on products(productline);

create view view_total_sales as
select 
    products.productline, 
    sum(orderdetails.quantityordered * orderdetails.priceeach) as total_sales, 
    sum(orderdetails.quantityordered) as total_quantity
from orderdetails
join products on orderdetails.productcode = products.productcode
group by products.productline;

select * from view_total_sales;

select 
    productlines.productline, 
    productlines.textdescription, 
    view_total_sales.total_sales, 
    view_total_sales.total_quantity,
    case 
        when length(productlines.textdescription) > 30 
        then concat(left(productlines.textdescription, 30), '...')
        else productlines.textdescription
    end as description_snippet,
    case 
        when view_total_sales.total_quantity > 1000 
        then view_total_sales.total_sales / view_total_sales.total_quantity * 1.1
        when view_total_sales.total_quantity between 500 and 1000 
        then view_total_sales.total_sales / view_total_sales.total_quantity
        else view_total_sales.total_sales / view_total_sales.total_quantity * 0.9
    end as sales_per_product
from view_total_sales
join productlines on view_total_sales.productline = productlines.productline
where view_total_sales.total_sales > 2000000
order by view_total_sales.total_sales desc;
