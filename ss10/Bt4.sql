use world;

delimiter //
create procedure UpdateCityPopulation(inout city_id int, in new_population int)
begin
	update city
    set population = new_population
    where ID = city_id;
    select
		ID as city_id,
        name, 
        population
	from city
    where ID = city_id;
end
// delimiter ;

set @city_id = 1;
call UpdateCityPopulation(@city_id, 500000);

drop procedure UpdateCityPopulation;