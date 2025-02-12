use world;

delimiter //
	create procedure GetLargeCitiesByCountry(in country_code char(3))
    begin
		select
			ID as CityID,
            name as CityName,
            Population
		from city
        where country_code = CountryCode and Population>1000000
        order by Population desc;
    end;
//delimiter ;

call GetLargeCitiesByCountry("USA");

drop procedure GetLargeCitiesByCountry;