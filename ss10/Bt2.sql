use world;
delimiter //
	create procedure CalculatePopulation(in code varchar(55), out pPopulation int)
    begin
		select
            sum(Population) into pPopulation
		from city
        where code = CountryCode;
    end
// delimiter ;

set @Population_value = 0;
call CalculatePopulation("USA", @Population_value);
select @Population_value as CalculatePopulation;

drop procedure CalculatePopulation;
