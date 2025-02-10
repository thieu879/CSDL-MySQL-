use ss7;
-- Lấy tên sách, tác giả và tên thể loại của sách, sắp xếp theo tên sách
select b.title,b.author,c.category_name
from books b join categories c
on b.category_id=c.category_id
order by b.title;
-- Lấy tên bạn đọc và số lượng sách mà mỗi bạn đọc đã mượn.
select r.name,count(b.book_id)
from readers r join borrowing b
on r.reader_id=b.reader_id
group by r.name;
-- Lấy số tiền phạt trung bình mà các bạn đọc phải trả.
select avg(fine_amount),re.name from
fines f join returning r
on f.return_id=r.return_id
join borrowing b 
on b.borrow_id=r.borrow_id
join readers re on
re.reader_id=b.reader_id
group by re.name;
-- Lấy tên sách và số lượng có sẵn của các sách có số lượng tồn kho cao nhất.
select title,available_quantity from books 
where available_quantity=(select max(available_quantity) from books);
-- Lấy tên bạn đọc và số tiền phạt mà họ phải trả, chỉ những bạn đọc có khoản phạt lớn hơn 0.
select r.name,f.fine_amount,re.return_date
from readers r join borrowing b 
on r.reader_id=b.reader_id
join returning re
on re.borrow_id=b.borrow_id
join fines f on
f.return_id=re.return_id
where f.fine_amount>0;
-- Lấy tên sách và số lần mượn của mỗi sách, chỉ sách có số lần mượn nhiều nhất
select b.title,count(bor.borrow_id)
from books b join borrowing bor
on b.book_id=bor.book_id
group by b.title
order by count(bor.borrow_id) desc limit 1 ;
-- Lấy tên sách, tên bạn đọc và ngày mượn của các sách chưa trả, sắp xếp theo ngày mượn.
select b.title,r.name,bor.borrow_date
from readers r join borrowing bor
on r.reader_id=bor.reader_id
join books b on
b.book_id=bor.book_id
where bor.borrow_id not in (
select borrow_id from returning re
) order by bor.borrow_date;
-- Lấy tên bạn đọc và tên sách của các bạn đọc đã trả sách đúng hạn
select r.name,b.title
from readers r join borrowing bor
on bor.reader_id=r.reader_id
join returning re on re.borrow_id=bor.borrow_id
join books b on b.book_id=bor.book_id
where bor.due_date=re.return_date;
-- Lấy tên sách và năm xuất bản của sách có số lần mượn lớn nhất.
select b.title,b.publication_year,count(borrowing.borrow_id)
from books b join borrowing 
on borrowing.book_id=b.book_id
group by borrowing.book_id,b.title,b.publication_year
order by count(borrowing.borrow_id) desc limit 1
;
