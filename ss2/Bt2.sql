CREATE DATABASE Bt2;
USE Bt2;
-- a,
-- 1, PRIMARY KEY: Ràng buộc xác định cột hoặc nhóm cột có giá trị duy nhất, không trùng lặp.
-- vd:
CREATE TABLE Student (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(100),
    Age INT
);
-- 2, Ràng buộc yêu cầu cột không được để trống.
-- vd:
CREATE TABLE Teacher (
    TeacherID INT PRIMARY KEY,
    TeacherName VARCHAR(100) NOT NULL,
    Subject VARCHAR(50)
);

-- 3, FOREIGN KEY: Ràng buộc xác định mối quan hệ giữa hai bảng, đảm bảo tính toàn vẹn của dữ liệu giữa các bảng.
-- vd: 
CREATE TABLE classroom (
    malop INT PRIMARY KEY,
    tenlop VARCHAR(50) NOT NULL,
    giaovienchunhiem VARCHAR(50)
);

CREATE TABLE student (
    mahocsinh INT PRIMARY KEY,
    ten VARCHAR(50) NOT NULL,
    tuoi INT NOT NULL,
    malop INT,
    FOREIGN KEY (malop) REFERENCES classroom (malop)
);
-- b, tại vì:
-- - Ngăn ngừa lỗi dữ liệu.
-- - Đảm bảo sự đáng tin cậy và tính nhất quán.
-- - Giảm bớt khối lượng công việc kiểm tra trong ứng dụng.
-- - Làm cho cơ sở dữ liệu mạnh mẽ hơn và bảo trì dễ dàng hơn.
