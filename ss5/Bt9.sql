create database Bt9;
use Bt9;

create table Patients (
    PatientId int primary key auto_increment,
    FullName varchar(255) not null,
    DateOfBirth date not null,
    Gender varchar(10) not null,
    PhoneNumber varchar(15) unique not null
);

create table Doctors (
    DoctorId int primary key auto_increment,
    FullName varchar(255) not null,
    Specialization varchar(100) not null,
    PhoneNumber varchar(15) unique not null,
    Email varchar(100) unique not null
);

create table Appointments (
    AppointmentId int primary key auto_increment,
    PatientId int not null,
    DoctorId int not null,
    AppointmentDate datetime not null,
    Status varchar(20) not null,
    foreign key (PatientId) references Patients(PatientId),
    foreign key (DoctorId) references Doctors(DoctorId)
);

create table MedicalRecords (
    RecordId int primary key auto_increment,
    PatientId int not null,
    DoctorId int not null,
    Diagnosis text not null,
    TreatmentPlan text not null,
    foreign key (PatientId) references Patients(PatientId),
    foreign key (DoctorId) references Doctors(DoctorId)
);

-- Insert dữ liệu vào bảng Patients (Thông tin bệnh nhân)
INSERT INTO Patients (FullName, DateOfBirth, Gender, PhoneNumber)
VALUES
    ('Nguyen Van An', '1985-05-15', 'Nam', '0901234567'),
    ('Tran Thi Binh', '1990-09-12', 'Nu', '0912345678'),
    ('Pham Van Cuong', '1978-03-20', 'Nam', '0923456789'),
    ('Le Thi Dung', '2000-11-25', 'Nu', '0934567890'),
    ('Vo Van Em', '1982-07-08', 'Nam', '0945678901'),
    ('Hoang Thi Phuong', '1995-01-18', 'Nu', '0956789012'),
    ('Ngo Van Giang', '1988-12-30', 'Nam', '0967890123'),
    ('Dang Thi Hanh', '1992-06-10', 'Nu', '0978901234'),
    ('Bui Van Hoa', '1975-10-22', 'Nam', '0989012345');

-- Insert dữ liệu vào bảng Doctors (Thông tin bác sĩ)
INSERT INTO Doctors (FullName, Specialization, PhoneNumber, Email)
VALUES
    ('Le Minh', 'Noi Tong Quat', '0908765432', 'leminh@hospital.vn'),
    ('Phan Huong', 'Nhi Khoa', '0918765432', 'phanhuong@hospital.vn'),
    ('Nguyen Tuan', 'Tim Mach', '0928765432', 'nguyentuan@hospital.vn'),
    ('Dang Quang', 'Than Kinh', '0938765432', 'dangquang@hospital.vn'),
    ('Hoang Dung', 'Da Lieu', '0948765432', 'hoangdung@hospital.vn'),
    ('Vu Hanh', 'Phu San', '0958765432', 'vuhanh@hospital.vn'),
    ('Tran An', 'Noi Tiet', '0968765432', 'tranan@hospital.vn'),
    ('Lam Phong', 'Ho Hap', '0978765432', 'lamphong@hospital.vn'),
    ('Pham Ha', 'Chan Thuong Chinh Hinh', '0988765432', 'phamha@hospital.vn');

-- Insert dữ liệu vào bảng Appointments (Lịch hẹn khám)
INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, Status)
VALUES
    (1, 2, '2025-01-20 09:00:00', 'Da Dat'),
    (3, 1, '2025-01-21 10:30:00', 'Da Dat'),
    (5, 3, '2025-01-22 08:00:00', 'Da Dat'),
    (2, 4, '2025-01-23 14:00:00', 'Da Dat'),
    (4, 5, '2025-01-24 11:00:00', 'Da Dat'),
    (6, 6, '2025-01-25 15:00:00', 'Da Dat'),
    (7, 7, '2025-01-26 16:30:00', 'Da Dat'),
    (8, 8, '2025-01-27 09:00:00', 'Da Dat'),
    (9, 9, '2025-01-28 10:00:00', 'Da Dat');

-- Insert dữ liệu vào bảng MedicalRecords (Hồ sơ y tế)
INSERT INTO MedicalRecords (PatientID, DoctorID, Diagnosis, TreatmentPlan)
VALUES
    (1, 2, 'Cam Cum', 'Nghi ngoi, uong nhieu nuoc, su dung paracetamol 500mg khi sot.'),
    (3, 1, 'Dau Dau Man Tinh', 'Kiem tra huyet ap dinh ky, giam cang thang, su dung thuoc giam dau khi can.'),
    (5, 3, 'Roi Loan Nhip Tim', 'Theo doi tim mach 1 tuan/lan, dung thuoc dieu hoa nhip tim.'),
    (2, 4, 'Dau Cot Song', 'Vat ly tri lieu, giam van dong manh.'),
    (4, 5, 'Viêm Da Tiep Xuc', 'Su dung kem boi da, tranh tiep xuc voi chat gay di ung.'),
    (6, 6, 'Thieu Mau', 'Tang cuong thuc pham giau sat, bo sung vitamin.'),
    (7, 7, 'Tieu Duong Type 2', 'Duy tri che do an lanh manh, kiem tra duong huyet thuong xuyen.'),
    (8, 8, 'Hen Suyen', 'Su dung thuoc xit hen hang ngay, tranh tiep xuc bui ban.'),
    (9, 9, 'Gay Xuong', 'Bo bot, kiem tra xuong dinh ky, vat ly tri lieu sau khi thao bot.');

select 
    patients.fullname as PatientName,
    doctors.fullname as DoctorName,
    appointments.appointmentdate,
    doctors.specialization,
    appointments.status
from appointments
join patients on appointments.patientid = patients.patientid
join doctors on appointments.doctorid = doctors.doctorid
where appointments.appointmentdate between '2025-01-20' and '2025-01-25'
order by appointments.appointmentdate asc
limit 3;

select 
    patients.fullname as PatientName,
    patients.dateofbirth,
    doctors.fullname as DoctorName,
    doctors.specialization,
    medicalrecords.diagnosis
from appointments
join patients on appointments.patientid = patients.patientid
join doctors on appointments.doctorid = doctors.doctorid
join medicalrecords on appointments.patientid = medicalrecords.patientid 
    and appointments.doctorid = medicalrecords.doctorid
where appointments.appointmentdate between '2025-01-20' and '2025-01-25'
order by appointments.appointmentdate asc
limit 5;


select 
    patients.fullname as patient_name,
    patients.dateofbirth,
    timestampdiff(year, patients.dateofbirth, appointments.appointmentdate) as age_at_appointment,
    appointments.appointmentdate,
    patients.dateofbirth, -- cái này thì e chịu thua
    timestampdiff(year, patients.dateofbirth, appointments.appointmentdate) * 365 as days_difference -- cái này thì e chịu thua
from appointments
join patients on appointments.patientid = patients.patientid
join medicalrecords on appointments.patientid = medicalrecords.patientid
order by appointments.appointmentdate asc;




