USE sakila;

CREATE UNIQUE INDEX idx_unique_email ON customer(email);
INSERT INTO customer (store_id, first_name, last_name, email, address_id, active, create_date)
VALUES (1, 'Jane', 'Doe', 'johndoe@example.com', 6, 1, NOW());

DELIMITER $$

CREATE PROCEDURE CheckCustomerEmail(IN email_input VARCHAR(50), OUT exists_flag INT)
BEGIN
    DECLARE count_email INT;

    SELECT COUNT(*) INTO count_email 
    FROM customer 
    WHERE email = email_input;

    IF count_email > 0 THEN
        SET exists_flag = 1;
    ELSE
        SET exists_flag = 0;
    END IF;
END $$

DELIMITER ;
CALL CheckCustomerEmail('johndoe@example.com', @exists_flag);
SELECT @exists_flag;

CREATE INDEX idx_rental_customer_id ON rental(customer_id);

CREATE VIEW view_active_customer_rentals AS
SELECT 
    c.customer_id, 
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    r.rental_date,
    CASE 
        WHEN r.return_date IS NOT NULL THEN 'Returned' 
        ELSE 'Not Returned' 
    END AS status
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
WHERE c.active = 1
AND r.rental_date >= '2023-01-01'
AND (r.return_date IS NULL OR DATEDIFF(NOW(), r.return_date) <= 30);
SELECT * FROM view_active_customer_rentals;

CREATE INDEX idx_payment_customer_id ON payment(customer_id);

CREATE VIEW view_customer_payments AS
SELECT 
    c.customer_id, 
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    SUM(p.amount) AS total_payment
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
WHERE p.payment_date >= '2023-01-01'
GROUP BY c.customer_id
HAVING total_payment > 100;
SELECT * FROM view_customer_payments;

DELIMITER $$

CREATE PROCEDURE GetCustomerPaymentsByAmount(
    IN min_amount DECIMAL(10,2), 
    IN date_from DATE
)
BEGIN
    SELECT * FROM view_customer_payments
    WHERE total_payment >= min_amount 
    AND customer_id IN (
        SELECT DISTINCT customer_id 
        FROM payment 
        WHERE payment_date >= date_from
    );
END $$

DELIMITER ;
CALL GetCustomerPaymentsByAmount(200, '2023-01-01');

DROP VIEW IF EXISTS view_active_customer_rentals;
DROP VIEW IF EXISTS view_customer_payments;
DROP INDEX idx_unique_email ON customer;
DROP INDEX idx_rental_customer_id ON rental;
DROP INDEX idx_payment_customer_id ON payment;
DROP PROCEDURE IF EXISTS CheckCustomerEmail;
DROP PROCEDURE IF EXISTS GetCustomerPaymentsByAmount;
