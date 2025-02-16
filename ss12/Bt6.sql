use bt5;

create table budget_warnings (
    warning_id int auto_increment primary key,
    project_id int not null,
    warning_message varchar(255) not null,
    foreign key (project_id) references projects(project_id) on delete cascade
);

delimiter //
create trigger after_project_update
after update on projects
for each row
begin
    if new.total_salary > new.budget then
        if not exists (select 1 from budget_warnings where project_id = new.project_id) then
            insert into budget_warnings (project_id, warning_message)
            values (new.project_id, 'Budget exceeded due to high salary');
        end if;
    end if;
end;
//
delimiter ;

create view ProjectOverview as
select 
    p.project_id,
    p.name as project_name,
    p.budget,
    p.total_salary,
    case 
        when p.total_salary > p.budget then 'Over Budget'
        else 'Within Budget'
    end as budget_status
from projects p;

insert into workers (name, project_id, salary) values
('Michael', 1, 6000.00),
('Sarah', 2, 10000.00),
('David', 3, 1000.00);

select * from budget_warnings;
select * from ProjectOverview;

