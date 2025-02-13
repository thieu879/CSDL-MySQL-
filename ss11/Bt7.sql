use chinook;

create view View_Track_Details as
select 
    t.TrackId, 
    t.Name as Track_Name, 
    a.Title as Album_Title, 
    ar.Name as Artist_Name, 
    t.UnitPrice
from Track t
join Album a on t.AlbumId = a.AlbumId
join Artist ar on a.ArtistId = ar.ArtistId
where t.UnitPrice > 0.99;
select * from View_Track_Details;

create view View_Customer_Invoice as
select 
    c.CustomerId, 
    concat(c.LastName, ' ', c.FirstName) as FullName, 
    c.Email, 
    sum(i.Total) as Total_Spending, 
    e.LastName as Support_Rep
from Customer c
join Invoice i on c.CustomerId = i.CustomerId
join Employee e on c.SupportRepId = e.EmployeeId
group by c.CustomerId
having Total_Spending > 50;
select * from View_Customer_Invoice;

create view View_Top_Selling_Tracks as
select 
    t.TrackId, 
    t.Name as Track_Name, 
    g.Name as Genre_Name, 
    sum(il.Quantity) as Total_Sales
from Track t
join InvoiceLine il on t.TrackId = il.TrackId
join Genre g on t.GenreId = g.GenreId
group by t.TrackId
having Total_Sales > 10;
select * from View_Top_Selling_Tracks;

create index idx_Track_Name on Track(Name);
select * from Track where Name like '%Love%';
explain select * from Track where Name like '%Love%';

create index idx_Invoice_Total on Invoice(Total);
select * from Invoice where Total between 20 and 100;
explain select * from Invoice where Total between 20 and 100;

delimiter //
create procedure GetCustomerSpending(in p_CustomerId int, out p_TotalSpending decimal(10,2))
begin
    select coalesce(Total_Spending, 0) into p_TotalSpending
    from View_Customer_Invoice
    where CustomerId = p_CustomerId;
end;
// delimiter ;
set @spending = 0;
call GetCustomerSpending(1, @spending);
select @spending as Total_Spending;

delimiter //
create procedure SearchTrackByKeyword(in p_Keyword varchar(255))
begin
    select * from Track where Name like concat('%', p_Keyword, '%');
end;
// delimiter ;
call SearchTrackByKeyword('lo');

delimiter //
create procedure GetTopSellingTracks(in p_MinSales int, in p_MaxSales int)
begin
    select * from View_Top_Selling_Tracks
    where Total_Sales between p_MinSales and p_MaxSales;
end;
// delimiter ;
call GetTopSellingTracks(10, 50);

drop view if exists View_Track_Details;
drop view if exists View_Customer_Invoice;
drop view if exists View_Top_Selling_Tracks;
drop index idx_Track_Name on Track;
drop index idx_Invoice_Total on Invoice;
drop procedure if exists GetCustomerSpending;
drop procedure if exists SearchTrackByKeyword;
drop procedure if exists GetTopSellingTracks;
