-- Díaz, Agustín. Legajo: D-4094/1
-- Farizano, Juan Ignacio. Legajo: F-3562/9
-- Mellino, Natalia. Legajo: M-6686/9

-- Ejercicio 1

CREATE DATABASE IF NOT EXISTS Biblioteca;

USE Biblioteca;

DROP TABLE IF EXISTS Escribe;
DROP TABLE IF EXISTS Autor;
DROP TABLE IF EXISTS Libro;

CREATE TABLE Autor(
    ID            INT UNSIGNED    NOT NULL    AUTO_INCREMENT,
    Nombre        VARCHAR(20)     NOT NULL,
    Apellido      VARCHAR(20)     NOT NULL,
    Nacionalidad  VARCHAR(20)     NOT NULL,
    Residencia    VARCHAR(20)     NOT NULL,
    PRIMARY KEY (ID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Libro(
    ISBN          int (13) UNSIGNED   NOT NULL,
    Titulo        VARCHAR(100)        NOT NULL,
    Editorial     VARCHAR(20)         NOT NULL,
    Precio        DECIMAL(8, 2)       NOT NULL,
    PRIMARY KEY (ISBN)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Escribe(
    ID_autor       INT UNSIGNED   NOT NULL,
    ISBN_libro     INT UNSIGNED   NOT NULL,
    Año            INT UNSIGNED   NOT NULL,
    PRIMARY KEY (ID_Autor, ISBN_libro),
    FOREIGN KEY (ID_autor) REFERENCES Autor (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ISBN_libro) REFERENCES Libro (ISBN) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Ejercicio 2

CREATE INDEX titulo_libro
ON Libro (Titulo);

CREATE INDEX apellido_autor
ON Autor (Apellido);


-- Ejercicio 3

INSERT INTO Autor VALUES(DEFAULT, 'Julio', 'Cortázar', 'Argentina', 'Buenos Aires');
INSERT INTO Autor VALUES(DEFAULT, 'Abelardo', 'Castillo', 'Argentina', 'Rosario');
INSERT INTO Autor VALUES(DEFAULT, 'Natalia', 'Mellino', 'Argentina', 'Buenos Aires');
INSERT INTO Autor VALUES(DEFAULT, 'Agustín', 'Díaz', 'Rusia', 'Moscú');
INSERT INTO Autor VALUES(DEFAULT, 'Juan Ignacio', 'Farizano', 'Francia', 'París');
INSERT INTO Autor VALUES(DEFAULT, 'Stephen', 'Kinga', 'Estados Unidos', 'Portland');
INSERT INTO Autor VALUES(DEFAULT, 'Eduardo', 'Galeano', 'Uruguay', 'Montevideo');


INSERT INTO Libro VALUES(420, 'LOTR', 'DeBolsillo', 70);
INSERT INTO Libro VALUES(42, 'Farry Potter y el misterio del recursado', 'UNR', 500);
INSERT INTO Libro VALUES(123, 'Cómo leer un libro', 'Anonymus', 999.99);
INSERT INTO Libro VALUES(1230, 'Rayuela', 'Alfaguara', 350);
INSERT INTO Libro VALUES(456, 'IT', 'Penguin', 300);

INSERT INTO Escribe VALUES(
    (SELECT ID FROM Autor WHERE Nombre = 'Juan Ignacio' AND Apellido = 'Farizano'), 
    (SELECT ISBN FROM Libro WHERE Titulo = 'LOTR' AND Editorial = 'DeBolsillo'), 
    1940);
INSERT INTO Escribe VALUES(
    (SELECT ID FROM Autor WHERE Nombre = 'Natalia' AND Apellido = 'Mellino'), 
    (SELECT ISBN FROM Libro WHERE Titulo = 'Farry Potter y el misterio del recursado' AND Editorial = 'UNR'), 
    2019);
INSERT INTO Escribe VALUES(
    (SELECT ID FROM Autor WHERE Nombre = 'Agustín' AND Apellido = 'Díaz'),
    (SELECT ISBN FROM Libro WHERE Titulo = 'Cómo leer un libro' AND Editorial = 'Anonymus'), 
    1998);
INSERT INTO Escribe VALUES(
    (SELECT ID FROM Autor WHERE Nombre = 'Julio' AND Apellido = 'Cortázar'), 
    (SELECT ISBN FROM Libro WHERE Titulo = 'Rayuela' AND Editorial = 'Alfaguara'), 
    1967);
INSERT INTO Escribe VALUES(
    (SELECT ID FROM Autor WHERE Nombre = 'Stephen' AND Apellido = 'Kinga'), 
    (SELECT ISBN FROM Libro WHERE Titulo = 'IT' AND Editorial = 'Penguin'), 
    1986);

-- Ejercicio 4

-- a

UPDATE Autor
SET
    Residencia = 'Buenos Aires'
WHERE 
    Nombre = 'Abelardo' AND Apellido = 'Castillo';

-- b

UPDATE Libro
SET
    Precio = Precio * 1.1
WHERE
    Editorial = 'UNR';

-- c

UPDATE Libro
SET 
    Precio = IF (Precio <= 200, Precio * 1.2, Precio * 1.1) 
WHERE 
    ISBN IN
         (SELECT ISBN_Libro FROM Escribe 
          WHERE ID_autor IN
                         (SELECT ID From Autor 
                          WHERE Nacionalidad <> 'Argentina'));

-- d

DELETE FROM Libro
WHERE ISBN IN 
           (SELECT ISBN_libro FROM Escribe
           WHERE Año = 1998);
