create database Bt8;
use Bt8;
-- 1, Thiếu ràng buộc khóa chính
-- 2, Thiếu ràng buộc NOT NULL:Cột MaSV và Diem có thể chứa giá trị NULL, dẫn đến dữ liệu không đầy đủ hoặc không hợp lệ.
-- 3, Thiếu ràng buộc kiểm tra giá trị (CHECK):Cột Diem không có ràng buộc để đảm bảo giá trị chỉ nằm trong khoảng từ 0 đến 10.
CREATE TABLE Score (
    StudentID VARCHAR(20) NOT NULL,
    Score INT NOT NULL,
    CONSTRAINT PK_Score PRIMARY KEY (StudentID),
    CONSTRAINT CK_Score_Valid CHECK (Score >= 0 AND Score <= 10)
);

