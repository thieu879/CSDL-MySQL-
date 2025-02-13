use chinook;

create view view_album_artist as
select 
    album.albumid, 
    album.title as album_title, 
    artist.name as artist_name
from album
join artist on album.artistid = artist.artistid;

create view view_customer_spending as
select 
    customer.customerid, 
    customer.firstname, 
    customer.lastname, 
    customer.email, 
    coalesce(sum(invoice.total), 0) as total_spending
from customer
left join invoice on customer.customerid = invoice.customerid
group by customer.customerid;

create index idx_employee_lastname on employee(lastname);
select * from employee where lastname = 'King';
explain select * from employee where lastname = 'King';

delimiter //
create procedure GetTracksByGenre(in GenreId int)
begin
    select 
        track.trackid, 
        track.name as track_name, 
        album.title as album_title, 
        artist.name as artist_name
    from track
    join album on track.albumid = album.albumid
    join artist on album.artistid = artist.artistid
    where track.genreid = GenreId;
end;
// delimiter ;
call GetTracksByGenre(1);

delimiter //
create procedure GetTrackCountByAlbum(in p_AlbumId int, out Total_Tracks int)
begin
    select count(*) into Total_Tracks
    from track
    where albumid = p_AlbumId;
end;
// delimiter ;
set @total_tracks = 0;
call GetTrackCountByAlbum(1, @total_tracks);
select @total_tracks as total_tracks;

drop view if exists view_album_artist;
drop view if exists view_customer_spending;
drop procedure if exists GetTracksByGenre;
drop procedure if exists GetTrackCountByAlbum;
drop index idx_employee_lastname on employee;

