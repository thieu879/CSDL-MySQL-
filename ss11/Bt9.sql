use chinook;

create view view_high_value_customers as
select 
    c.customerid, 
    concat(c.firstname, ' ', c.lastname) as fullname, 
    c.email, 
    sum(i.total) as total_spending
from customer c
join invoice i on c.customerid = i.customerid
where year(i.invoicedate) >= 2010 
group by c.customerid, fullname, c.email
having total_spending > 200
and c.country <> 'Brazil';

create view view_popular_tracks as
select 
    t.trackid, 
    t.name as track_name, 
    sum(il.quantity) as total_sales
from track t
join invoiceline il on t.trackid = il.trackid
where il.unitprice > 1.00
group by t.trackid, track_name
having total_sales > 15;

alter table customer add index idx_customer_country (country) using hash;
select * from customer where country = 'Canada';
explain select * from customer where country = 'Canada';

alter table track add fulltext index idx_track_name_ft (name);
select * from track 
where match(name) against ('Love' in natural language mode);
explain select * from track 
where match(name) against ('Love' in natural language mode);

select v.* 
from view_high_value_customers v
join customer c on v.customerid = c.customerid
where c.country = 'Canada';

explain select v.* 
from view_high_value_customers v
join customer c on v.customerid = c.customerid
where c.country = 'Canada';
explain select v.*, t.unitprice
from view_popular_tracks v
join track t on v.trackid = t.trackid
where match(t.name) against ('Love' in natural language mode);

delimiter $$

create procedure gethighvaluecustomersbycountry(in p_country varchar(50))
begin
    select v.*
    from view_high_value_customers v
    join customer c on v.customerid = c.customerid
    where c.country = p_country;
end$$

delimiter ;

call gethighvaluecustomersbycountry('Canada');

delimiter $$

create procedure updatecustomerspending(
    in p_customerid int, 
    in p_amount decimal(10,2)
)
begin
    update invoice 
    set total = total + p_amount
    where customerid = p_customerid
    order by invoicedate desc;
end$$

delimiter ;
call updatecustomerspending(5, 50.00);
select * from view_high_value_customers where customerid = 5;
