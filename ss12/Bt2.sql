use Bt1;

CREATE TABLE price_changes (
    change_id INT AUTO_INCREMENT PRIMARY KEY,
    product VARCHAR(100) NOT NULL,
    old_price DECIMAL(10, 2) NOT NULL,
    new_price DECIMAL(10, 2) NOT NULL
);

delimiter //
	create trigger trigger_price_changes
    before update on price_changes
    for each row
    begin
		if new.new_price != old.old_price
			then insert price_changes(product, old_price, new_price)
				values(old.product, old.old_price, new.new_price);
		end if;
    end;
// delimiter ;

update price_changes 
set new_price = 1400.00 
where product = 'Laptop';

update price_changes 
set new_price = 800.00 
where product = 'Smartphone';

select * from price_changes;

drop trigger trigger_price_changes;