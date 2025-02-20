create database test;
use test;

create table student(
	student_id int primary key auto_increment,
    student_name varchar(100),
    student_Math_Score int,
    student_Physical_Score int,
    student_Chemistry_Score int,
    Rating enum ("Yếu", "TB", "Khá", "Giỏi", "xuất sắc")
);

INSERT INTO student (student_name, student_Math_Score, student_Physical_Score, student_Chemistry_Score, Rating) VALUES
("Nguyễn Văn A", 5, 6, 7, NULL),
("Trần Thị B", 8, 9, 7, NULL),
("Lê Văn C", 3, 5, 4, NULL),
("Hoàng Minh D", 9, 8, 10, NULL),
("Phạm Ngọc E", 6, 7, 5, NULL),
("Đặng Thị F", 7, 6, 8, NULL),
("Vũ Văn G", 4, 3, 5, NULL),
("Bùi Thị H", 10, 9, 9, NULL),
("Ngô Quang I", 2, 4, 3, NULL),
("Đoàn Thanh K", 6, 5, 7, NULL);

delimiter //
	create procedure Grading()
    begin
		declare isFinished bit default 0;
        declare st_id int;
        declare st_Math_Score int;
        declare st_Physical_Score int;
        declare st_Chemistry_Score int;
        declare st_Rating enum ("Yếu", "TB", "Khá", "Giỏi", "xuất sắc");
        declare currsor_AVG cursor for
        select student_id, student_Math_Score, student_Physical_Score, student_Chemistry_Score from student;
        declare continue handler for NOT FOUND set isFinished = 1;
        open currsor_AVG;
		student_loop: loop
			fetch currsor_AVG into st_id, st_Math_Score, st_Physical_Score, st_Chemistry_Score;
            if isFinished then
				leave student_loop;
			end if;
            if ((st_Math_Score + st_Physical_Score + st_Chemistry_Score) / 3 < 5) then 
				update student set Rating = "Yếu" where student_id = st_id;
			elseif ((st_Math_Score + st_Physical_Score + st_Chemistry_Score) / 3 > 5 and (st_Math_Score + st_Physical_Score + st_Chemistry_Score) / 3 < 7 ) then
				update student set Rating = "TB" where student_id = st_id;
			elseif ((st_Math_Score + st_Physical_Score + st_Chemistry_Score) / 3 > 7 and (st_Math_Score + st_Physical_Score + st_Chemistry_Score) / 3 < 8 ) then
				update student set Rating = "Khá" where student_id = st_id;
			elseif ((st_Math_Score + st_Physical_Score + st_Chemistry_Score) / 3 > 8 and (st_Math_Score + st_Physical_Score + st_Chemistry_Score) / 3 < 9 ) then
				update student set Rating = "giỏi" where student_id = st_id;
			else
				update student set Rating = "xuất sắc" where student_id = st_id;
			end if;
        end loop student_loop;
        close currsor_AVG;
        commit;
    end;
// delimiter ;

call Grading();
select * from student;