create database Bt1;
use Bt1;
create table MachineRoom(
	IDMachineRoom int primary key,
    NameManager varchar(50),
    NameRoom varchar(50)
);
create table computer(
	IDComputer int primary key,
    HardDriveCapacity varchar(50),
    RAMCapacity varchar(50),
    CPUSpeed varchar(50),
    IDMachineRoom int,
    foreign key(IDMachineRoom) references MachineRoom(IDMachineRoom)
);
create table Subjects(
	IdSubject int primary key,
    NameSubject varchar(50),
    CourseDuration int
);
create table signIn(
	RegistrationDate varchar(50),
    IDMachineRoom int,
    IdSubject int,
    foreign key(IDMachineRoom) references MachineRoom(IDMachineRoom),
    foreign key(IdSubject) references Subjects(IdSubject)
);
