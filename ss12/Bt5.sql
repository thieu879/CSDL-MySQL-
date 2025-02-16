create database bt5;
use bt5;

create table projects (
    project_id int auto_increment primary key,
    name varchar(100) not null,
    budget decimal(10,2) not null,
    total_salary decimal(10,2) default 0
);

create table workers (
    worker_id int auto_increment primary key,
    name varchar(100) not null,
    project_id int not null,
    salary decimal(10,2) not null,
    foreign key (project_id) references projects(project_id) on delete cascade
);

insert into projects (name, budget) values
('Bridge Construction', 10000.00),
('Road Expansion', 15000.00),
('Office Renovation', 8000.00);

delimiter //
create trigger after_worker_insert
after insert on workers
for each row
begin
    update projects
    set total_salary = total_salary + new.salary
    where project_id = new.project_id;
end;
//
delimiter ;

delimiter //
create trigger after_worker_delete
after delete on workers
for each row
begin
    update projects
    set total_salary = total_salary - old.salary
    where project_id = old.project_id;
end;
//
delimiter ;

insert into workers (name, project_id, salary) values
('John', 1, 2500.00),
('Alice', 1, 3000.00),
('Bob', 2, 2000.00),
('Eve', 2, 3500.00),
('Charlie', 3, 1500.00);

select * from projects;

delete from workers where name = 'Alice';
select * from projects;
