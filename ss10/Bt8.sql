use world;

delimiter //
create procedure GetCountriesByCityNames()
    select 
        country.name as country_name, 
        countrylanguage.language as official_language, 
        sum(city.population) as total_population
    from country
    join countrylanguage on country.code = countrylanguage.countrycode
    join city on country.code = city.countrycode
    where city.name like 'a%' 
        and countrylanguage.isofficial = 'T'
    group by country.name, countrylanguage.language
    having total_population > 2000000
    order by country_name asc;
end 
//delimiter ;

call GetCountriesByCityNames();

drop procedure GetCountriesByCityNames;
