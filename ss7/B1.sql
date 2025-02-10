create database ss7;
use ss7;

create table Categories (
category_id int primary key,
category_name varchar(255) 
);

create table Books (
book_id int primary key,
title varchar(255),
author varchar (225),
publication_year int,
available_quality int,
category_id int,
foreign key (category_id) references Categories(category_id) on delete cascade
);
create table Readers (
reader_id int primary key ,
name varchar(255),
phone_number varchar(15),
email varchar(255)
);

create table Borrowing (
borrow_id int primary key,
reader_id int,
book_id int,
foreign key ( reader_id) references Readers(reader_id),
foreign key ( book_id) references Books(book_id)  on delete cascade,
borrow_date date ,
due_date date 
);

create table Returning (
return_id int primary key,
borrow_id int,
foreign key (borrow_id) references Borrowing(borrow_id)  on delete cascade,
return_date date
);

create table Fines  (
fine_id int primary key,
return_id int,
foreign key (return_id) references Returning(return_id)  on delete cascade,
fine_amount decimal(10,2)
);
INSERT INTO Categories (category_id, category_name) VALUES
(1, 'Science'),
(2, 'Literature'),
(3, 'History'),
(4, 'Technology'),
(5, 'Psychology');

-- Inserting books into the Books table with details such as title, author, and category
INSERT INTO Books (book_id, title, author, publication_year, available_quality, category_id) VALUES
(1, 'The History of Vietnam', 'John Smith', 2001, 10, 1),
(2, 'Python Programming', 'Jane Doe', 2020, 5, 4),
(3, 'Famous Writers', 'Emily Johnson', 2018, 7, 2),
(4, 'Machine Learning Basics', 'Michael Brown', 2022, 3, 4),
(5, 'Psychology and Behavior', 'Sarah Davis', 2019, 6, 5);

-- Inserting library users (readers) into the Readers table
INSERT INTO Readers (reader_id, name, phone_number, email) VALUES
(1, 'Alice Williams', '123-456-7890', 'alice.williams@email.com'),
(2, 'Bob Johnson', '987-654-3210', 'bob.johnson@email.com'),
(3, 'Charlie Brown', '555-123-4567', 'charlie.brown@email.com');

-- Inserting borrowing records for books
INSERT INTO Borrowing (borrow_id, reader_id, book_id, borrow_date, due_date) VALUES
(1, 1, 1, '2025-02-19', '2025-02-15'),
(2, 2, 2, '2025-02-03', '2025-02-17'),
(3, 3, 3, '2025-02-02', '2025-02-16'),
(4, 1, 2, '2025-03-10', '2025-02-24'),
(5, 2, 3, '2025-05-11', '2025-02-25'),
(6, 2, 3, '2025-02-11', '2025-02-25');


-- Inserting book return records into the Returning table
INSERT INTO Returning (return_id, borrow_id, return_date) VALUES
(1, 1, '2025-03-14'),
(2, 2, '2025-02-28'),
(3, 3, '2025-02-15'),
(4, 4, '2025-02-20'),  
(5, 4, '2025-02-20');

-- Inserting penalty records into the Fines table for late returns
INSERT INTO Fines (fine_id, return_id, fine_amount) VALUES
(1, 1, 5.00),
(2, 2, 0.00),
(3, 3, 2.00);


-- 4
UPDATE Readers
SET phone_number = '111-222-3333'
WHERE reader_id = 1;
-- 5
DELETE FROM Books WHERE book_id = 1;
