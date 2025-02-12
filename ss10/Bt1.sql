use world;
delimiter //
	create procedure country_code()
    begin
		select 
			ID,
            Name,
            Population
		from city;
    end
// delimiter ;

call country_code();

drop procedure country_code;
