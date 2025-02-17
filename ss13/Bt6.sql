use Bt4;

DELIMITER //
CREATE PROCEDURE RegisterStudent(
    IN p_student_name VARCHAR(50), 
    IN p_course_name VARCHAR(100)
)
BEGIN
    DECLARE v_student_id INT;
    DECLARE v_course_id INT;
    DECLARE v_available_seats INT;
    DECLARE v_already_enrolled INT;
    START TRANSACTION;
    SELECT student_id INTO v_student_id FROM students WHERE student_name = p_student_name LIMIT 1;
    SELECT course_id, available_seats INTO v_course_id, v_available_seats 
    FROM courses 
    WHERE course_name = p_course_name LIMIT 1;
    IF v_student_id IS NULL OR v_course_id IS NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Sinh viên hoặc môn học không tồn tại';
    END IF;
    SELECT EXISTS (
        SELECT 1 FROM enrollments 
        WHERE student_id = v_student_id AND course_id = v_course_id
    ) INTO v_already_enrolled;
    IF v_already_enrolled = 1 THEN
        INSERT INTO enrollments_history (student_id, course_id, action) 
        VALUES (v_student_id, v_course_id, 'FAILED');
        ROLLBACK;
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Sinh viên đã đăng ký môn học này';
    END IF;
    IF v_available_seats > 0 THEN
        INSERT INTO enrollments (student_id, course_id) VALUES (v_student_id, v_course_id);
        UPDATE courses SET available_seats = available_seats - 1 WHERE course_id = v_course_id;
        INSERT INTO enrollments_history (student_id, course_id, action) 
        VALUES (v_student_id, v_course_id, 'REGISTERED');
        COMMIT;
    ELSE
        INSERT INTO enrollments_history (student_id, course_id, action) 
        VALUES (v_student_id, v_course_id, 'FAILED');

        ROLLBACK;
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Môn học đã hết chỗ';
    END IF;
END //
DELIMITER ;
CALL RegisterStudent('Nguyễn Văn An', 'Lập trình C');
SELECT * FROM enrollments;
SELECT * FROM courses;
SELECT * FROM enrollments_history;

