CREATE DATABASE Bt7;
USE Bt7;

CREATE TABLE departments (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(100) NOT NULL,
    manager VARCHAR(100),
    budget DECIMAL(10,2) NOT NULL
);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    dept_id INT,
    salary DECIMAL(10,2) NOT NULL,
    hire_date DATE NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE projects (
    project_id INT PRIMARY KEY AUTO_INCREMENT,
    project_name VARCHAR(100) NOT NULL,
    emp_id INT,
    start_date DATE NOT NULL,
    end_date DATE,
    status ENUM('In Progress', 'Completed', 'Delayed') NOT NULL,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

CREATE TABLE project_warnings (
    warning_id INT PRIMARY KEY AUTO_INCREMENT,
    project_id INT,
    warning_message TEXT,
    warning_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

CREATE TABLE dept_warnings (
    warning_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_id INT,
    warning_message TEXT,
    warning_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

DELIMITER //
CREATE TRIGGER before_insert_employee
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary < 500 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lương không được dưới 500';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM departments WHERE dept_id = NEW.dept_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Phòng ban không tồn tại';
    END IF;
    
    IF (SELECT COUNT(*) FROM projects p 
        JOIN employees e ON p.emp_id = e.emp_id
        WHERE e.dept_id = NEW.dept_id AND p.status != 'Completed') = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tất cả dự án của phòng ban đã hoàn thành, không thể thêm nhân viên';
    END IF;
END;//
DELIMITER ;

DELIMITER //
CREATE TRIGGER after_update_project_status
AFTER UPDATE ON projects
FOR EACH ROW
BEGIN
    IF NEW.status = 'Delayed' THEN
        INSERT INTO project_warnings (project_id, warning_message)
        VALUES (NEW.project_id, 'Dự án bị trì hoãn');
    END IF;
        IF NEW.status = 'Completed' THEN
        UPDATE projects SET end_date = CURRENT_DATE WHERE project_id = NEW.project_id;
                IF (SELECT SUM(e.salary) FROM employees e WHERE e.dept_id = 
            (SELECT dept_id FROM employees WHERE emp_id = NEW.emp_id)) 
            > (SELECT budget FROM departments WHERE dept_id = 
               (SELECT dept_id FROM employees WHERE emp_id = NEW.emp_id)) THEN
            
            INSERT INTO dept_warnings (dept_id, warning_message)
            VALUES ((SELECT dept_id FROM employees WHERE emp_id = NEW.emp_id), 'Tổng lương nhân viên vượt ngân sách');
        END IF;
    END IF;
END;//
DELIMITER ;
CREATE VIEW FullOverview AS
SELECT e.emp_id, e.name, d.dept_name, 
       CONCAT('$', FORMAT(e.salary, 2)) AS salary,
       p.project_name, p.status
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
LEFT JOIN projects p ON e.emp_id = p.emp_id;
