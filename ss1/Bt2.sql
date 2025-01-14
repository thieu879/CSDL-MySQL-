CREATE DATABASE IF NOT EXISTS Bt2;
USE Bt2;

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

INSERT INTO classroom
VALUES (
    1,
    'lop 1',
    'Hong'
);

INSERT INTO student
VALUES (
    1,
    'nam',
    6,
    1
);
