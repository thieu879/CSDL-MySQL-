use Bt3;

CREATE TABLE transaction_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    log_message VARCHAR(255) NOT NULL,
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE employees ADD COLUMN last_pay_date DATE NULL;
DELIMITER //

CREATE PROCEDURE PaySalary (IN p_emp_id INT)
BEGIN
    DECLARE v_salary DECIMAL(10,2);
    DECLARE v_balance DECIMAL(15,2);
    DECLARE v_emp_exists INT;


    START TRANSACTION;


    SELECT COUNT(*), salary INTO v_emp_exists, v_salary
    FROM employees
    WHERE emp_id = p_emp_id;

    IF v_emp_exists = 0 THEN

        INSERT INTO transaction_log (emp_id, log_message)
        VALUES (p_emp_id, 'Nhân viên không tồn tại');

        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nhân viên không tồn tại';
    END IF;


    SELECT balance INTO v_balance FROM company_funds LIMIT 1;


    IF v_balance < v_salary THEN

        INSERT INTO transaction_log (emp_id, log_message)
        VALUES (p_emp_id, 'Quỹ không đủ tiền');

        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quỹ không đủ tiền';
    END IF;

    UPDATE company_funds
    SET balance = balance - v_salary;

    INSERT INTO payroll (emp_id, salary, pay_date)
    VALUES (p_emp_id, v_salary, CURDATE());
    UPDATE employees
    SET last_pay_date = CURDATE()
    WHERE emp_id = p_emp_id;

    INSERT INTO transaction_log (emp_id, log_message)
    VALUES (p_emp_id, 'Chuyển lương cho nhân viên thành công');

    COMMIT;
END //

DELIMITER ;
CALL PaySalary(1);