use world;

delimiter //
	create procedure GetCountriesWithLargeCities()
    begin
		select
			Name as CountryName,
            Population as TotalPopulation 
		from country
        where Population > 10000000
        order by Population desc;
    end;
// delimiter ;

call GetCountriesWithLargeCities();

drop procedure GetCountriesWithLargeCities;