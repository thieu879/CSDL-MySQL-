use sakila;

create view view_film_category as
select 
    film.film_id, 
    film.title, 
    category.name as category_name
from film
join film_category on film.film_id = film_category.film_id
join category on film_category.category_id = category.category_id;

create view view_high_value_customers as
select 
    customer.customer_id, 
    customer.first_name, 
    customer.last_name, 
    sum(payment.amount) as total_payment
from customer
join payment on customer.customer_id = payment.customer_id
group by customer.customer_id
having total_payment > 100;

create index idx_rental_rental_date on rental(rental_date);
select * from rental where rental_date = '2005-06-14';
explain select * from rental where rental_date = '2005-06-14';

delimiter //
create procedure CountCustomerRentals(in customer_id int, out rental_count int)
begin
    select count(*) into rental_count
    from rental
    where rental.customer_id = customer_id;
end;
// delimiter ;
set @rental_count = 0;
call CountCustomerRentals(1, @rental_count);
select @rental_count as rental_count;

delimiter //
create procedure GetCustomerEmail(in customer_id int)
begin
    select email from customer where customer.customer_id = customer_id;
end;
// delimiter ;
call GetCustomerEmail(1);

drop view if exists view_film_category;
drop view if exists view_high_value_customers;
drop procedure if exists CountCustomerRentals;
drop procedure if exists GetCustomerEmail;
drop index idx_rental_rental_date on rental;

