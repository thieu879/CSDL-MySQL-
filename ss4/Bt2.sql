create database Bt2;
use Bt2;
create table Supplier(
	SupplierID int primary key,
    NameSupplier varchar(50)
);
create table Material(
	MaterialID int primary key,
    NameMaterial varchar(50)
);
create table address(
	IDAddress int primary key,
    SupplierID int,
    foreign key(SupplierID) references Supplier(SupplierID)
);
create table Purchase(
	SupplierID int,
    MaterialID int,
    price decimal(20,5),
    Quantity int,
    foreign key(SupplierID) references Supplier(SupplierID),
    foreign key(MaterialID) references Material(MaterialID)
);