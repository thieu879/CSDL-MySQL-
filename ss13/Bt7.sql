create database Bt7;
use Bt7;

CREATE TABLE company_funds (
    fund_id INT PRIMARY KEY AUTO_INCREMENT,
    balance DECIMAL(15,2) NOT NULL -- Số dư quỹ công ty
);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(50) NOT NULL,   -- Tên nhân viên
    salary DECIMAL(10,2) NOT NULL    -- Lương nhân viên
);

CREATE TABLE payroll (
    payroll_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,                      -- ID nhân viên (FK)
    salary DECIMAL(10,2) NOT NULL,   -- Lương được nhận
    pay_date DATE NOT NULL,          -- Ngày nhận lương
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

CREATE TABLE transaction_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    log_message VARCHAR(255) NOT NULL,
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE bank (
    bank_id INT AUTO_INCREMENT PRIMARY KEY,
    bank_name VARCHAR(255) NOT NULL,
    status ENUM('ACTIVE', 'ERROR') NOT NULL DEFAULT 'ACTIVE'
);

ALTER TABLE employees ADD COLUMN last_pay_date DATE NULL;

INSERT INTO company_funds (balance) 
VALUES 
(50000.00);

INSERT INTO employees (emp_name, salary) 
VALUES
('Nguyễn Văn An', 5000.00),
('Trần Thị Bốn', 4000.00),
('Lê Văn Cường', 3500.00),
('Hoàng Thị Dung', 4500.00),
('Phạm Văn Em', 3800.00);

INSERT INTO bank (bank_id, bank_name, status) 
VALUES 
(1,'VietinBank', 'ACTIVE'),   
(2,'Sacombank', 'ERROR'),    
(3, 'Agribank', 'ACTIVE');   

alter table company_funds
add column bank_id int,
add constraint fk_company_funds_bank foreign key(bank_id) references bank(bank_id);

UPDATE company_funds SET bank_id = 1 WHERE balance = 50000.00;
INSERT INTO company_funds (balance, bank_id) VALUES (45000.00,2);

DELIMITER //

CREATE TRIGGER CheckBankStatus
BEFORE INSERT ON payroll
FOR EACH ROW
BEGIN
    DECLARE v_bank_status VARCHAR(20);
    SELECT b.status INTO v_bank_status 
    FROM company_funds cf
    JOIN banks b ON cf.bank_id = b.bank_id
    WHERE cf.bank_id = NEW.bank_id
    LIMIT 1;
    IF v_bank_status = 'ERROR' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ngân hàng đang gặp sự cố. Giao dịch bị hủy.';
    END IF;
END //

DELIMITER ;
DELIMITER //

CREATE PROCEDURE TransferSalary(IN p_emp_id INT)
BEGIN
    DECLARE v_salary DECIMAL(10,2);
    DECLARE v_balance DECIMAL(10,2);
    DECLARE v_bank_status VARCHAR(20);
    DECLARE v_company_bank_id INT;
    DECLARE v_employee_exists INT DEFAULT 0;
    DECLARE v_error_message VARCHAR(255);
    START TRANSACTION;
    SELECT COUNT(*) INTO v_employee_exists FROM employees WHERE emp_id = p_emp_id;
    IF v_employee_exists = 0 THEN
        SET v_error_message = 'Nhân viên không tồn tại';
        ROLLBACK;
        INSERT INTO transaction_log (emp_id, log_message) VALUES (p_emp_id, v_error_message);
        LEAVE;
    END IF;
    SELECT cf.balance, cf.bank_id, b.status INTO v_balance, v_company_bank_id, v_bank_status
    FROM company_funds cf
    JOIN banks b ON cf.bank_id = b.bank_id
    WHERE cf.bank_id = (SELECT bank_id FROM employees WHERE emp_id = p_emp_id)
    LIMIT 1;
    IF v_bank_status = 'ERROR' THEN
        SET v_error_message = 'Ngân hàng có lỗi. Giao dịch bị hủy.';
        ROLLBACK;
        INSERT INTO transaction_log (emp_id, log_message) VALUES (p_emp_id, v_error_message);
        LEAVE;
    END IF;
    SELECT salary INTO v_salary FROM employees WHERE emp_id = p_emp_id;
    IF v_balance < v_salary THEN
        SET v_error_message = 'Quỹ công ty không đủ tiền.';
        ROLLBACK;
        INSERT INTO transaction_log (emp_id, log_message) VALUES (p_emp_id, v_error_message);
        LEAVE;
    END IF;
    UPDATE company_funds SET balance = balance - v_salary WHERE bank_id = v_company_bank_id;
    INSERT INTO payroll (emp_id, amount, pay_date, bank_id) 
    VALUES (p_emp_id, v_salary, NOW(), v_company_bank_id);
    UPDATE employees SET last_pay_date = NOW() WHERE emp_id = p_emp_id;
    INSERT INTO transaction_log (emp_id, log_message) 
    VALUES (p_emp_id, 'Lương đã được chuyển thành công');

    COMMIT;
END //

DELIMITER ;

CALL TransferSalary(1);

SELECT * FROM company_funds;
SELECT * FROM payroll;
SELECT * FROM employees;
SELECT * FROM transaction_log;
