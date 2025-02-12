use world;

delimiter //
	create procedure in_language(in Language varchar(30))
    begin
		select
			CountryCode,
            Language,
            Percentage
		from countrylanguage
        where Percentage>50;
    end
//delimiter ;

call in_language("English");

drop procedure in_language;