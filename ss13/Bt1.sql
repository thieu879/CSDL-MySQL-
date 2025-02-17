create database Bt1;
use Bt1;

create table account(
	account_id int primary key,
    account_name varchar(50),
    balance decimal(10,2)
);

INSERT INTO accounts (account_name, balance) 
VALUES 
('Nguyễn Văn An', 1000.00),
('Trần Thị Bảy', 500.00);

DELIMITER //
CREATE PROCEDURE TransferMoney(
    IN from_account INT,
    IN to_account INT,
    IN amount DECIMAL(10,2)
)
BEGIN
    DECLARE insufficient_balance INT DEFAULT 0;
        START TRANSACTION;
        SELECT CASE 
        WHEN balance < amount THEN 1
        ELSE 0
    END INTO insufficient_balance
    FROM account
    WHERE account_id = from_account;
        IF insufficient_balance = 1 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Số dư không đủ để thực hiện giao dịch.';
    ELSE
        UPDATE account 
        SET balance = balance - amount 
        WHERE account_id = from_account;
        UPDATE account 
        SET balance = balance + amount 
        WHERE account_id = to_account;
                COMMIT;
    END IF;
END 
// DELIMITER ;

CALL TransferMoney(1, 2, 200.00);

SELECT * FROM account;
