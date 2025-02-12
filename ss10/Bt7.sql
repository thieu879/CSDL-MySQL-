use world;

delimiter //
create procedure GetEnglishSpeakingCountriesWithCities(in language varchar(50))
begin
    select 
        country.name as country_name, 
        sum(city.population) as total_population
    from country
    join countrylanguage on country.code = countrylanguage.countrycode
    join city on country.code = city.countrycode
    where countrylanguage.language = language 
        and countrylanguage.isofficial = 'T'
    group by country.name
    having total_population > 5000000
    order by total_population desc
    limit 10;
end 
//delimiter ;

call GetEnglishSpeakingCountriesWithCities('english');

drop procedure get_english_speaking_countries_with_cities;
