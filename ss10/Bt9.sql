use world;

create view countrylanguageview as
select 
    country.code as country_code, 
    country.name as country_name, 
    countrylanguage.language, 
    countrylanguage.isofficial
from country
join countrylanguage on country.code = countrylanguage.countrycode
where countrylanguage.isofficial = 'T';

select * from countrylanguageview;

delimiter //
create procedure GetLargeCitiesWithEnglish()
begin
    select 
        city.name as city_name, 
        country.name as country_name, 
        city.population
    from city
    join country on city.countrycode = country.code
    join countrylanguage on country.code = countrylanguage.countrycode
    where countrylanguage.language = 'English' 
        and countrylanguage.isofficial = 'T'
        and city.population > 1000000
    order by city.population desc
    limit 20;
end 
//delimiter ;

call GetLargeCitiesWithEnglish();

drop procedure if exists GetLargeCitiesWithEnglish;
