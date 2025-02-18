-- demo currsor - loop
create database currsor_loop_db;
use currsor_loop_db;
create table student(
	student_id int primary key auto_increment,
    student_name varchar(100),
    student_age int,
    student_status bit
);
create table student_log(
	st_log_id int primary key auto_increment,
    st_log_age int
) engine = "MyISAM";
create table transaction_log(
	log_id int primary key auto_increment,
    log_message text,
    log_created date default(curdate())
);

INSERT INTO student (student_name, student_age, student_status) VALUES
('Nguyễn Văn A', 18, 1),
('Trần Thị B', 20, 0),
('Lê Văn C', 17, 1),
('Phạm Minh D', 19, 1),
('Hoàng Thị E', 22, 1);

select * from student;
/* 
	1. viết trigger chặn insert student và bật exception có tuổi nhỏ hơn 18 vào bảng student_log
	2. viết procedure cho phép thực hiện:
		- Lấy cả sinh viên có trạng thái 1 đẩy vào bảng student_log
			+ thêm dữ liệu vào bảng student_log
            + Ghi log vào bảng transaction log
        - Nếu mà có sql exceoption thì rollback lại toàn bộ
			+ Ghi log vào bảng transaction log
*/
-- 1.
delimiter //
	create trigger trg_before_insert before insert on student_log
    for each row
    begin
		if new.st_log_age < 18 then
			signal sqlstate '45000'
				set message_text = "tuổi sinh viên phải lớn hơn hoặc bằng 18";
		end if;
    end
// delimiter ;

-- 2.
delimiter //
	create procedure pro_insert_student_log()
    begin
		-- 0. khai báo các biến cần thiết cho procedure
        declare isFinished bit default 0;
        declare st_id int;
        declare st_name varchar(100);
        declare st_age int;
        -- 1. khai báo currsor chứa tất cả các sinh viên có status = 1
        declare currsor_students cursor for 
			select student_id, student_name, student_age from student where student_status = 1;
            -- {{1,18}, {3,17}, {5,22}}
        -- 2. khai bái biến nhận biết kết thúc trình duyệt(NOT FOUND)
        declare continue handler for NOT FOUND set isFinished = 1;
        -- khai báo biến nhật biết khi nào có exception xảy ra thì xử lý
        
        declare exit handler for sqlexception
        begin
			-- ghi log
            insert into transaction_log(log_message)
				values(concat('student ID: ', st_id, '- student name: ', st_name, 'age: ', st_age, '- not'));
            -- rollback
            rollback;
        end;
        start transaction;
        -- 3. mở currsor
        open currsor_students;
        -- 4. sử dụng loop duyệt dữ liệu currsor
        student_loop: loop
			-- fetch từng dữ liệu trong currsor đẩy ra biến để sử lý
            fetch currsor_students into st_id, st_name, st_age;
            if isFinished then
				leave student_loop;
			end if;
            -- tính toántreen các dữ liệu của currsor
            insert into student_log(st_log_age)
            values(st_age);
            insert into transaction_log(log_message) 
				values (concat(st_id,'- inserted'));
        end loop student_loop;
        -- 5. đóng currsor
        close currsor_students;
        commit;
    end
// delimiter ;

select * from student_log;
select * from transaction_log;
drop procedure pro_insert_student_log;
set autocommit = 0;
call pro_insert_student_log();