USE Bt9;

DELIMITER $$
CREATE PROCEDURE GetDoctorDetails(IN input_doctor_id INT)
BEGIN
    SELECT 
        d.name AS doctor_name,
        d.specialization,
        COUNT(DISTINCT a.patient_id) AS total_patients,
        SUM(IF(a.status = 'Completed', 100, 0)) AS total_revenue,
        COUNT(p.prescription_id) AS total_medicines_prescribed
    FROM doctors d
    LEFT JOIN appointments a ON d.doctor_id = a.doctor_id
    LEFT JOIN prescriptions p ON a.appointment_id = p.appointment_id
    WHERE d.doctor_id = input_doctor_id
    GROUP BY d.doctor_id;
END $$
DELIMITER ;

CREATE TABLE cancellation_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT,
    log_message VARCHAR(255),
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE appointment_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT,
    log_message VARCHAR(255),
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$
CREATE TRIGGER after_appointment_delete
AFTER DELETE ON appointments
FOR EACH ROW
BEGIN
    DELETE FROM prescriptions WHERE appointment_id = OLD.appointment_id;
    
    IF OLD.status = 'Cancelled' THEN
        INSERT INTO cancellation_logs (appointment_id, log_message) 
        VALUES (OLD.appointment_id, 'Cancelled appointment was deleted');
    END IF;
        IF OLD.status = 'Completed' THEN
        INSERT INTO appointment_logs (appointment_id, log_message) 
        VALUES (OLD.appointment_id, 'Completed appointment was deleted');
    END IF;
END $$
DELIMITER ;

CREATE VIEW FullRevenueReport AS
SELECT 
    d.doctor_id,
    d.name AS doctor_name,
    d.specialization,
    COUNT(DISTINCT a.patient_id) AS total_patients,
    SUM(IF(a.status = 'Completed', 100, 0)) AS total_revenue,
    COUNT(p.prescription_id) AS total_medicines_prescribed
FROM doctors d
LEFT JOIN appointments a ON d.doctor_id = a.doctor_id
LEFT JOIN prescriptions p ON a.appointment_id = p.appointment_id
GROUP BY d.doctor_id;

CALL GetDoctorDetails(1);

DELETE FROM appointments WHERE appointment_id = 3;
DELETE FROM appointments WHERE appointment_id = 2;

SELECT * FROM FullRevenueReport;