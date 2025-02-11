use classicmodels;

create index idx_customernumber on payments(customernumber);

create view view_customer_payments as
select 
    payments.customernumber, 
    sum(payments.amount) as total_payments, 
    count(payments.checknumber) as payment_count
from payments
group by payments.customernumber;

select * from view_customer_payments;

select 
    customers.customernumber, 
    customers.customername, 
    view_customer_payments.total_payments, 
    view_customer_payments.payment_count
from view_customer_payments
join customers on view_customer_payments.customernumber = customers.customernumber
where view_customer_payments.total_payments > 150000 
      and view_customer_payments.payment_count > 3
order by view_customer_payments.total_payments desc
limit 5;
