use sakila;

create view view_long_action_movies as
select f.film_id, f.title, f.length, c.name as category_name
from film f
join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id
where c.name = 'Action' and f.length > 100;

create view view_texas_customers as
select c.customer_id, c.first_name, c.last_name, a.city
from customer c
join address a on c.address_id = a.address_id
join rental r on c.customer_id = r.customer_id
where a.district = 'Texas'
group by c.customer_id;

create view view_high_value_staff as
select s.staff_id, s.first_name, s.last_name, sum(p.amount) as total_payment
from staff s
join payment p on s.staff_id = p.staff_id
group by s.staff_id
having total_payment > 100;

alter table film add fulltext index idx_film_title_description (title, description);

alter table rental add index idx_rental_inventory_id (inventory_id) using hash;

select * 
from view_long_action_movies 
where match(title, description) against ('war' in natural language mode);

delimiter //

create procedure get_rental_by_inventory(in inventory_id int)
begin
    select * 
    from rental
    where inventory_id = inventory_id;
end
// delimiter ;

drop view if exists view_long_action_movies;
drop view if exists view_texas_customers;
drop view if exists view_high_value_staff;

alter table film drop index idx_film_title_description;
alter table rental drop index idx_rental_inventory_id;

drop procedure if exists get_rental_by_inventory;
