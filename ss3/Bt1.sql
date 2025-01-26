create database bt1;
use bt1;

create table student (
    student_id int primary key not null auto_increment,
    student_name varchar(255) not null,
    age int not null check (age >= 18),
    gender varchar(10) not null check (gender in ('Male', 'Female', 'Other')),
    registration_date datetime not null default current_timestamp
);

insert into student (student_name, age, gender)
values
('Nguyễn Văn A', 20, 'Male'),
('Trần Thị B', 22, 'Female'),
('Lê Minh C', 19, 'Male'),
('Phan Thị D', 21, 'Female'),
('Hoàng Văn E', 23, 'Male');
