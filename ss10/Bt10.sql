use world;

create view officiallanguageview as
select 
    country.code as countrycode, 
    country.name as countryname, 
    countrylanguage.language
from country
join countrylanguage on country.code = countrylanguage.countrycode
where countrylanguage.isofficial = 'T';

select * from officiallanguageview;

create index idx_city_name on city(name);

delimiter //
create procedure GetSpecialCountriesAndCities(in language_name char(30))
begin
    select 
        country.name as countryname, 
        city.name as cityname, 
        city.population as citypopulation,
        (select sum(city.population) 
         from city 
         where city.countrycode = country.code) as totalpopulation
    from city
    join country on city.countrycode = country.code
    join countrylanguage on country.code = countrylanguage.countrycode
    where countrylanguage.language = language_name 
        and countrylanguage.isofficial = 'T'
        and city.name like 'New%'
    group by country.name, city.name, city.population
    having totalpopulation > 5000000
    order by totalpopulation desc
    limit 10;
end 
//delimiter ;

call GetSpecialCountriesAndCities('English');
