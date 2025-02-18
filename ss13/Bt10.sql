create database Bt10;
use Bt8;

CREATE TABLE course_fees (
    course_id INT PRIMARY KEY,
    fee DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
);

CREATE TABLE student_wallets (
    student_id INT PRIMARY KEY,
    balance DECIMAL(10,2) NOT NULL DEFAULT 0,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE
);

INSERT INTO course_fees (course_id, fee) VALUES
(1, 100.00),
(2, 150.00);

INSERT INTO student_wallets (student_id, balance) VALUES
(1, 200.00),
(2, 50.00);

CREATE TABLE enrollment_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    course_id INT,
    status VARCHAR(50),
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
);

DELIMITER //

CREATE PROCEDURE RegisterCourse(
    IN p_student_name VARCHAR(50), 
    IN p_course_name VARCHAR(100)
)
BEGIN
    DECLARE v_student_id INT;
    DECLARE v_course_id INT;
    DECLARE v_balance DECIMAL(10,2);
    DECLARE v_fee DECIMAL(10,2);
    DECLARE v_available_seats INT;
    DECLARE v_error_message VARCHAR(255);

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO enrollment_history (student_id, course_id, status, log_time) 
        VALUES (v_student_id, v_course_id, v_error_message, NOW());
        ROLLBACK;
    END;
    START TRANSACTION;
    SELECT student_id INTO v_student_id FROM students WHERE name = p_student_name;
    IF v_student_id IS NULL THEN
        SET v_error_message = 'FAILED: Student does not exist';
        INSERT INTO enrollment_history (status, log_time) VALUES (v_error_message, NOW());
        ROLLBACK;
        LEAVE;
    END IF;
    SELECT course_id INTO v_course_id FROM courses WHERE name = p_course_name;
    IF v_course_id IS NULL THEN
        SET v_error_message = 'FAILED: Course does not exist';
        INSERT INTO enrollment_history (student_id, status, log_time) VALUES (v_student_id, v_error_message, NOW());
        ROLLBACK;
        LEAVE;
    END IF;
    IF EXISTS (SELECT 1 FROM enrollments WHERE student_id = v_student_id AND course_id = v_course_id) THEN
        SET v_error_message = 'FAILED: Already enrolled';
        INSERT INTO enrollment_history (student_id, course_id, status, log_time) 
        VALUES (v_student_id, v_course_id, v_error_message, NOW());
        ROLLBACK;
        LEAVE;
    END IF;
    SELECT available_seats INTO v_available_seats FROM courses WHERE course_id = v_course_id;
    IF v_available_seats <= 0 THEN
        SET v_error_message = 'FAILED: No available seats';
        INSERT INTO enrollment_history (student_id, course_id, status, log_time) 
        VALUES (v_student_id, v_course_id, v_error_message, NOW());
        ROLLBACK;
        LEAVE;
    END IF;
    SELECT balance INTO v_balance FROM student_wallets WHERE student_id = v_student_id;
    SELECT fee INTO v_fee FROM course_fees WHERE course_id = v_course_id;
    IF v_balance < v_fee THEN
        SET v_error_message = 'FAILED: Insufficient balance';
        INSERT INTO enrollment_history (student_id, course_id, status, log_time) 
        VALUES (v_student_id, v_course_id, v_error_message, NOW());
        ROLLBACK;
        LEAVE;
    END IF;
    INSERT INTO enrollments (student_id, course_id, enroll_date) VALUES (v_student_id, v_course_id, NOW());
    UPDATE student_wallets SET balance = balance - v_fee WHERE student_id = v_student_id;
    UPDATE courses SET available_seats = available_seats - 1 WHERE course_id = v_course_id;
    INSERT INTO enrollment_history (student_id, course_id, status, log_time) 
    VALUES (v_student_id, v_course_id, 'REGISTERED', NOW());
    COMMIT;
END //

DELIMITER ;
CALL RegisterCourse('Nguyễn Văn An', 'Lập trình C');
CALL RegisterCourse('Trần Thị Ba', 'Cơ sở dữ liệu');
CALL RegisterCourse('Nguyễn Văn An', 'Cơ sở dữ liệu');
SELECT * FROM student_wallets;
SELECT * FROM enrollment_history;
SELECT * FROM enrollments;
SELECT * FROM courses;