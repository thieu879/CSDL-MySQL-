CREATE DATABASE bt4;
USE bt4;

CREATE TABLE Category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL,
    description TEXT,
    status BIT NOT NULL
);

CREATE TABLE Film (
    film_id INT AUTO_INCREMENT PRIMARY KEY,
    film_name VARCHAR(50) NOT NULL,
    content TEXT NOT NULL,
    duration TIME NOT NULL,
    director VARCHAR(50),
    release_date DATE NOT NULL
);

CREATE TABLE Category_Film (
    category_id INT NOT NULL,
    film_id INT NOT NULL, 
    PRIMARY KEY (category_id, film_id),
    FOREIGN KEY (category_id) REFERENCES Category(category_id),
    FOREIGN KEY (film_id) REFERENCES Film(film_id)
);

ALTER TABLE Film
ADD COLUMN status TINYINT DEFAULT 1;

ALTER TABLE Category
DROP COLUMN status;

ALTER TABLE Category_Film
DROP FOREIGN KEY category_film_category_id_fk;

ALTER TABLE Category_Film
DROP FOREIGN KEY category_film_film_id_fk;

