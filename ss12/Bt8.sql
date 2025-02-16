CREATE DATABASE Bt8;
USE Bt8;

CREATE TABLE salary_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT NOT NULL,
    old_salary DECIMAL(10,2) NOT NULL,
    new_salary DECIMAL(10,2) NOT NULL,
    change_date DATETIME NOT NULL,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id) ON DELETE CASCADE
);

CREATE TABLE salary_warnings (
    warning_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT NOT NULL,
    warning_message VARCHAR(255) NOT NULL,
    warning_date DATETIME NOT NULL,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id) ON DELETE CASCADE
);

DELIMITER //
CREATE TRIGGER after_salary_update
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    IF OLD.salary <> NEW.salary THEN
        INSERT INTO salary_history (emp_id, old_salary, new_salary, change_date)
        VALUES (NEW.emp_id, OLD.salary, NEW.salary, NOW());
                IF NEW.salary < OLD.salary * 0.7 THEN
            INSERT INTO salary_warnings (emp_id, warning_message, warning_date)
            VALUES (NEW.emp_id, 'Salary decreased by more than 30%', NOW());
        END IF;
                IF NEW.salary > OLD.salary * 1.5 THEN
            UPDATE employees SET salary = OLD.salary * 1.5 WHERE emp_id = NEW.emp_id;
            INSERT INTO salary_warnings (emp_id, warning_message, warning_date)
            VALUES (NEW.emp_id, 'Salary increased above allowed threshold (adjusted to 150% of previous salary)', NOW());
        END IF;
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER after_project_insert
AFTER INSERT ON projects
FOR EACH ROW
BEGIN
    DECLARE project_count INT;
        SELECT COUNT(*) INTO project_count FROM projects
    WHERE emp_id = NEW.emp_id AND status IN ('In Progress', 'Pending');
    
    IF project_count > 3 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Employee is assigned to more than 3 active projects';
    END IF;
    
    IF NEW.status = 'In Progress' AND NEW.start_date > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Project start date cannot be in the future for In Progress status';
    END IF;
END //
DELIMITER ;

CREATE VIEW PerformanceOverview AS
SELECT 
    e.emp_id, e.name AS employee_name, d.name AS department_name, 
    p.name AS project_name, p.status, 
    CONCAT('$', FORMAT(e.salary, 2)) AS salary, 
    sw.warning_message
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
LEFT JOIN projects p ON e.emp_id = p.emp_id
LEFT JOIN salary_warnings sw ON e.emp_id = sw.emp_id;

UPDATE employees SET salary = salary * 0.5 WHERE emp_id = 1;
UPDATE employees SET salary = salary * 2 WHERE emp_id = 2;

INSERT INTO projects (name, emp_id, start_date, status) VALUES ('New Project 1', 1, CURDATE(), 'In Progress');
INSERT INTO projects (name, emp_id, start_date, status) VALUES ('New Project 2', 1, CURDATE(), 'In Progress');
INSERT INTO projects (name, emp_id, start_date, status) VALUES ('New Project 3', 1, CURDATE(), 'In Progress');
INSERT INTO projects (name, emp_id, start_date, status) VALUES ('New Project 4', 1, CURDATE(), 'In Progress');
INSERT INTO projects (name, emp_id, start_date, status) VALUES ('Future Project', 2, DATE_ADD(CURDATE(), INTERVAL 5 DAY), 'In Progress');

SELECT * FROM PerformanceOverview;