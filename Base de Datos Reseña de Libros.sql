DROP SCHEMA IF EXISTS resenas_libros;

CREATE SCHEMA resenas_libros;

USE resenas_libros;

CREATE TABLE rating (
	rating_id int NOT NULL,
    numero_base varchar(10),
    CONSTRAINT PK_RATING PRIMARY KEY (rating_id)
);

CREATE TABLE formato (
	formato_id int NOT NULL,
    nombre_formato varchar(20),
    CONSTRAINT PK_FORMATO PRIMARY KEY (formato_id)
);

CREATE TABLE trope (
	trope_id int NOT NULL,
    nombre_trope varchar(100),
    CONSTRAINT PK_TROPE PRIMARY KEY (trope_id)
);

CREATE TABLE genero (
	genero_id int NOT NULL,
    nombre_genero varchar(50),
    CONSTRAINT PK_GENERO PRIMARY KEY (genero_id)
);

CREATE TABLE estado (
	estado_id int NOT NULL,
    nombre_estado varchar(10),
    estado_KEY varchar(10),
    CONSTRAINT PK_GENERO PRIMARY KEY (estado_id)
);

CREATE TABLE autor (
	autor_id int NOT NULL,
    nombre_autor varchar(100),
    nacionalidad_autor varchar(100),
    genero_autor varchar(20),
    status_autor varchar(20),
    aka_autor varchar(100),
    CONSTRAINT PK_AUTOR PRIMARY KEY (autor_id)
);

CREATE TABLE libros (
	libro_id int NOT NULL AUTO_INCREMENT,
    nombre_libro varchar(200),
    autor_id int,
    formato_id int,
    estado_id int,
    start_date date,
    end_date date,
    rating_id int,
    fluff int,
    spice int,
    CONSTRAINT PK_LIBROS PRIMARY KEY (libro_id)
);

ALTER TABLE libros ADD CONSTRAINT FK_AUTOR_LIBRO FOREIGN KEY (autor_id) REFERENCES autor (autor_id);
ALTER TABLE libros ADD CONSTRAINT FK_ESTADO_LIBRO FOREIGN KEY (estado_id) REFERENCES estado (estado_id);
ALTER TABLE libros ADD CONSTRAINT FK_FORMATO_LIBRO FOREIGN KEY (formato_id) REFERENCES formato (formato_id);
ALTER TABLE libros ADD CONSTRAINT FK_RATINGS_LIBRO FOREIGN KEY (rating_id) REFERENCES rating (rating_id);
ALTER TABLE libros ADD CONSTRAINT FK_FLUFF_LIBRO FOREIGN KEY (fluff) REFERENCES rating (rating_id);
ALTER TABLE libros ADD CONSTRAINT FK_SPICE_LIBRO FOREIGN KEY (spice) REFERENCES rating (rating_id);


CREATE TABLE libro_genero (
	libro_id int,
    genero_id int
);

ALTER TABLE libro_genero ADD CONSTRAINT FOREIGN KEY FK_LG_LIBRO (libro_id) REFERENCES libros (libro_id);
ALTER TABLE libro_genero ADD CONSTRAINT FOREIGN KEY FK_LG_GENERO (genero_id) REFERENCES genero (genero_id);

CREATE TABLE libro_trope (
	libro_id int,
    trope_id int
);

ALTER TABLE libro_trope ADD CONSTRAINT FOREIGN KEY FK_LT_LIBRO (libro_id) REFERENCES libros (libro_id);
ALTER TABLE libro_trope ADD CONSTRAINT FOREIGN KEY FK_LT_TROPE (trope_id) REFERENCES trope (trope_id);

## CREACION DE TRIGGERS ##
DROP TABLE IF EXISTS libros_mirror;

CREATE TABLE libros_mirror (
	libro_id int NOT NULL,
    nombre_libro varchar(200),
    autor_id int,
    formato_id int,
    estado_id int,
    start_date date,
    end_date date,
    rating_id int,
    fluff int,
    spice int,
    tipo varchar(10),
    fecha_cambio datetime,
    usuario varchar(100)
);

#Trigge Para Insertar Libro
DROP TRIGGER IF EXISTS tr_new_libro;
CREATE TRIGGER tr_new_libro
AFTER INSERT ON libros
FOR EACH ROW
INSERT INTO libros_mirror(libro_id, nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice, tipo, fecha_cambio, usuario) 
	VALUES (new.libro_id, new.nombre_libro, new.autor_id, new.formato_id, new.estado_id, new.start_date, new.end_date, new.rating_id, new.fluff, new.spice, 'INSERT', current_timestamp(), user());

#Trigger Para Actualizar Libro
DROP TRIGGER IF EXISTS tr_update_libro;
CREATE TRIGGER tr_update_libro
AFTER UPDATE ON libros
FOR EACH ROW
INSERT INTO libros_mirror(libro_id, nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice, tipo, fecha_cambio, usuario) 
	VALUES (old.libro_id, old.nombre_libro, old.autor_id, old.formato_id, old.estado_id, old.start_date, old.end_date, old.rating_id, old.fluff, old.spice, 'UPDATE', current_timestamp(), user());

#Trigger Para Eliminar Libro
DROP TRIGGER IF EXISTS tr_delete_libro;    
CREATE TRIGGER tr_delete_libro
AFTER DELETE ON libros
FOR EACH ROW
INSERT INTO libros_mirror(libro_id, nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice, tipo, fecha_cambio, usuario) 
	VALUES (old.libro_id, old.nombre_libro, old.autor_id, old.formato_id, old.estado_id, old.start_date, old.end_date, old.rating_id, old.fluff, old.spice, 'DELETE', current_timestamp(), user());

## INSERCION DE DATOS ##
INSERT INTO rating (rating_id, numero_base) VALUES (1, '1/5');
INSERT INTO rating (rating_id, numero_base) VALUES (2, '2/5');
INSERT INTO rating (rating_id, numero_base) VALUES (3, '3/5');
INSERT INTO rating (rating_id, numero_base) VALUES (4, '4/5');
INSERT INTO rating (rating_id, numero_base) VALUES (5, '5/5');
INSERT INTO rating (rating_id, numero_base) VALUES (6, '0/5');

INSERT INTO genero (genero_id, nombre_genero) VALUES (1, 'Romance');
INSERT INTO genero (genero_id, nombre_genero) VALUES (2, 'Deportes');
INSERT INTO genero (genero_id, nombre_genero) VALUES (3, 'Suspenso');
INSERT INTO genero (genero_id, nombre_genero) VALUES (4, 'Sci-Fi');
INSERT INTO genero (genero_id, nombre_genero) VALUES (5, 'Fantasia');
INSERT INTO genero (genero_id, nombre_genero) VALUES (6, 'Ficcion');
INSERT INTO genero (genero_id, nombre_genero) VALUES (7, 'No Ficcion');
INSERT INTO genero (genero_id, nombre_genero) VALUES (8, 'Contemporaneo');
INSERT INTO genero (genero_id, nombre_genero) VALUES (9, 'Aventura');
INSERT INTO genero (genero_id, nombre_genero) VALUES (10, 'Policiaca');
INSERT INTO genero (genero_id, nombre_genero) VALUES (11, 'Terror');
INSERT INTO genero (genero_id, nombre_genero) VALUES (12, 'Dystopia');
INSERT INTO genero (genero_id, nombre_genero) VALUES (13, 'Infantil');
INSERT INTO genero (genero_id, nombre_genero) VALUES (14, 'Young Adult');
INSERT INTO genero (genero_id, nombre_genero) VALUES (15, 'New Adult');

INSERT INTO trope (trope_id,  nombre_trope) VALUES (1, 'Enemigos a Amantes');
INSERT INTO trope (trope_id,  nombre_trope) VALUES (2, 'Amigos a Amantes');
INSERT INTO trope (trope_id,  nombre_trope) VALUES (3, 'Hermano de mi Mejor amig@');
INSERT INTO trope (trope_id,  nombre_trope) VALUES (4, 'Mejor Amigo de mi Hermano');
INSERT INTO trope (trope_id,  nombre_trope) VALUES (5, 'Una sola Cama');
INSERT INTO trope (trope_id,  nombre_trope) VALUES (6, 'Segunda Oportunidad');
INSERT INTO trope (trope_id,  nombre_trope) VALUES (7, 'Relacion Falsa');
INSERT INTO trope (trope_id,  nombre_trope) VALUES (8, 'Grumpy Sunshine');
INSERT INTO trope (trope_id,  nombre_trope) VALUES (9, 'Romance en el Trabajo');
INSERT INTO trope (trope_id,  nombre_trope) VALUES (10, 'Pueblo Pequeño');
INSERT INTO trope (trope_id,  nombre_trope) VALUES (11, 'Triangulo Amoroso');
INSERT INTO trope (trope_id,  nombre_trope) VALUES (12, 'Proximidad Forzada');
INSERT INTO trope (trope_id,  nombre_trope) VALUES (13, 'Familia Encontrada');
INSERT INTO trope (trope_id,  nombre_trope) VALUES (14, 'Amigos de la Infancia');
INSERT INTO trope (trope_id,  nombre_trope) VALUES (15, 'Extraños a Amantes');
INSERT INTO trope (trope_id,  nombre_trope) VALUES (16, 'Matrimonio Arreglado');
INSERT INTO trope (trope_id,  nombre_trope) VALUES (17, 'Compañeros de Crimen');
INSERT INTO trope (trope_id,  nombre_trope) VALUES (18, 'Rivales Academicos');
INSERT INTO trope (trope_id,  nombre_trope) VALUES (19, 'Relacion Lenta');
INSERT INTO trope (trope_id,  nombre_trope) VALUES (20, 'Compañeros de Cuarto');
INSERT INTO trope (trope_id,  nombre_trope) VALUES (21, 'Destinados a Estar Juntos');

INSERT INTO formato (formato_id, nombre_formato) VALUES (1, 'Pasta Dura');
INSERT INTO formato (formato_id, nombre_formato) VALUES (2, 'Pasta Suave');
INSERT INTO formato (formato_id, nombre_formato) VALUES (3, 'Kindle');
INSERT INTO formato (formato_id, nombre_formato) VALUES (4, 'Kobo');
INSERT INTO formato (formato_id, nombre_formato) VALUES (5, 'Wattpad');
INSERT INTO formato (formato_id, nombre_formato) VALUES (6, 'BookFunnel');

INSERT INTO estado (estado_id, nombre_estado, estado_KEY) VALUES (1, 'No termino', 'DNF');
INSERT INTO estado (estado_id, nombre_estado, estado_KEY) VALUES (2, 'Por leer', 'TBR');
INSERT INTO estado (estado_id, nombre_estado, estado_KEY) VALUES (3, 'Leyendo', 'CR');
INSERT INTO estado (estado_id, nombre_estado, estado_KEY) VALUES (4, 'Terminado', 'A');

INSERT INTO autor (autor_id, nombre_autor, nacionalidad_autor, genero_autor, status_autor, aka_autor) VALUES ('1', 'Suzanne Collins', 'Estados Unidos', 'Femenino', 'Vivo', NULL);
INSERT INTO autor (autor_id, nombre_autor, nacionalidad_autor, genero_autor, status_autor, aka_autor) VALUES ('2', 'Joanne Rowling', 'Reino Unido', 'Femenino', 'Vivo', 'J.K. Rowling');
INSERT INTO autor (autor_id, nombre_autor, nacionalidad_autor, genero_autor, status_autor, aka_autor) VALUES ('3', 'Clive Staples Lewis', 'Reino Unido', 'Masculino', 'Muerto', 'C.S. Lewis');
INSERT INTO autor (autor_id, nombre_autor, nacionalidad_autor, genero_autor, status_autor, aka_autor) VALUES ('4', 'John Micheal Green', 'Estados Unidos', 'Masculino', 'Vivo', 'John Green');
INSERT INTO autor (autor_id, nombre_autor, nacionalidad_autor, genero_autor, status_autor, aka_autor) VALUES ('5', 'Rainbow Rowell', 'Estados Unidos', 'Femenino', 'Vivo', NULL);
INSERT INTO autor (autor_id, nombre_autor, nacionalidad_autor, genero_autor, status_autor, aka_autor) VALUES ('6', 'Kerstin Gier', 'Alemania', 'Femenino', 'Vivo', NULL);
INSERT INTO autor (autor_id, nombre_autor, nacionalidad_autor, genero_autor, status_autor, aka_autor) VALUES ('7', 'Leonardo Patrignani', 'Italia', 'Masculino', 'Vivo', NULL);
INSERT INTO autor (autor_id, nombre_autor, nacionalidad_autor, genero_autor, status_autor, aka_autor) VALUES ('8', 'Wendelin Van Draanen', 'Estados Unidos', 'Femenino', 'Vivo', NULL);
INSERT INTO autor (autor_id, nombre_autor, nacionalidad_autor, genero_autor, status_autor, aka_autor) VALUES ('9', 'Daniel Handler', 'Estados Unidos', 'Masculino', 'Vivo', 'Lemony Snicket');
INSERT INTO autor (autor_id, nombre_autor, nacionalidad_autor, genero_autor, status_autor, aka_autor) VALUES ('10', 'Darlis Stefany', 'Venezuela', 'Femenino', 'Vivo', NULL);
INSERT INTO autor (autor_id, nombre_autor, nacionalidad_autor, genero_autor, status_autor, aka_autor) VALUES ('11', 'Ariana Godoy', 'Venezuela', 'Femenino', 'Vivo', NULL);
INSERT INTO autor (autor_id, nombre_autor, nacionalidad_autor, genero_autor, status_autor, aka_autor) VALUES ('12', 'Karen M. McManus', 'Estados Unidos', 'Femenino', 'Vivo', NULL);
INSERT INTO autor (autor_id, nombre_autor, nacionalidad_autor, genero_autor, status_autor, aka_autor) VALUES ('13', 'Ransom Riggs', 'Estados Unidos', 'Masculino', 'Vivo', NULL);
INSERT INTO autor (autor_id, nombre_autor, nacionalidad_autor, genero_autor, status_autor, aka_autor) VALUES ('14', 'Lauren Kate', 'Estados Unidos', 'Femenino', 'Vivo', NULL);
INSERT INTO autor (autor_id, nombre_autor, nacionalidad_autor, genero_autor, status_autor, aka_autor) VALUES ('15', 'Lauren Asher', 'Estados Unidos', 'Femenino', 'Vivo', NULL);
INSERT INTO autor (autor_id, nombre_autor, nacionalidad_autor, genero_autor, status_autor, aka_autor) VALUES ('16', 'Grace Reilly', 'Estados Unidos', 'Femenino', 'Vivo', NULL);
INSERT INTO autor (autor_id, nombre_autor, nacionalidad_autor, genero_autor, status_autor, aka_autor) VALUES ('17', 'Morgan Elizabeth', 'Estados Unidos', 'Femenino', 'Vivo', NULL);
INSERT INTO autor (autor_id, nombre_autor, nacionalidad_autor, genero_autor, status_autor, aka_autor) VALUES ('18', 'Charlotte Farnsworth', 'Estados Unidos', 'Femenino', 'Vivo', 'C. W. Farnsworth');
INSERT INTO autor (autor_id, nombre_autor, nacionalidad_autor, genero_autor, status_autor, aka_autor) VALUES ('19', 'Catharina Maura', 'Holanda', 'Femenino', 'Vivo', NULL);
INSERT INTO autor (autor_id, nombre_autor, nacionalidad_autor, genero_autor, status_autor, aka_autor) VALUES ('20', 'Gitty Daneshvari', 'Estados Unidos', 'Femenino', 'Vivo', NULL);
INSERT INTO autor (autor_id, nombre_autor, nacionalidad_autor, genero_autor, status_autor, aka_autor) VALUES ('21', 'Marie Lu', 'China', 'Femenino', 'Vivo', NULL);
INSERT INTO autor (autor_id, nombre_autor, nacionalidad_autor, genero_autor, status_autor, aka_autor) VALUES ('22', 'Holly Jackson', 'Reino Unido', 'Femenino', 'Vivo', NULL);
INSERT INTO autor (autor_id, nombre_autor, nacionalidad_autor, genero_autor, status_autor, aka_autor) VALUES ('23', 'Emily Jenkins', 'Estados Unidos', 'Femenino', 'Vivo', 'E. Lockhart');
INSERT INTO autor (autor_id, nombre_autor, nacionalidad_autor, genero_autor, status_autor, aka_autor) VALUES ('24', 'Veronica Roth', 'Estados Unidos', 'Femenino', 'Vivo', NULL);

INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Los Juegos del Hambre', '1', '2', '4', '2014-03-13', '2014-03-17', '5', '3', '6');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('One of Us is Lying', '12', '1', '4', '2021-01-03', '2021-01-05', '5', '3', '1');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('The Fine Print', '15', '2', '4', '2023-01-15', '2023-01-27', '5', '4', '3');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Kiss Now, Lie Later', '18', '3', '4', '2023-01-03', '2023-01-04', '5', '5', '2');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('First Flight, Final Fall', '18', '3', '4', '2023-01-10', '2023-01-17', '5', '4', '1');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Friday Night Lies', '18', '3', '4', '2023-01-23', '2023-01-26', '4', '3', '1');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Terms and Conditions', '15', '2', '4', '2023-01-30', '2023-02-06', '5', '4', '3');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Breakaway', '16', '3', '4', '2023-02-01', '2023-02-09', '5', '5', '4');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Final Offer', '15', '3', '4', '2023-02-10', '2023-02-13', '5', '5', '1');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('The Temporary Wife', '19', '3', '3', '2023-02-14', NULL, NULL, NULL, NULL);
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('The Wrong Bride', '19', '3', '4', '2022-10-15', '2022-10-20', '5', '3', '2');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('The Protector', '17', '3', '4', '2023-03-02', '2023-03-07', '5', '4', '3');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('The Playlist', '17', '3', '4', '2023-03-27', '2023-03-30', '5', '5', '3');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Escuela de Frikis', '20', '2', '4', '2012-07-09', '2012-07-11', '5', '6', '6');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Escuela de Frikis y llego Hicklebee-Riyatulle', '20', '2', '4', '2012-10-20', '2012-10-25', '4', '6', '6');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Escuela de Frikis: El Examen Final', '20', '2', '4', '2012-10-26', '2012-10-30', '5', '6', '6');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Legend', '21', '2', '4', '2017-10-10', '2017-10-12', '5', '3', '6');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Prodigy', '21', '2', '4', '2017-10-14', '2017-10-16', '5', '4', '6');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Champion', '21', '2', '4', '2017-10-20', '2017-10-21', '5', '5', '6');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Rubi', '6', '2', '4', '2018-02-01', '2018-02-03', '5', '4', '6');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Zafiro', '6', '2', '4', '2018-02-05', '2018-02-07', '5', '5', '6');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Esmeralda', '6', '2', '4', '2018-02-10', '2018-02-12', '5', '5', '6');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('A Good Girl´s Guide To Murder', '22', '2', '4', '2022-08-13', '2022-09-02', '5', '5', '6');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Good Girl, Bad Blood', '22', '2', '2', NULL, NULL, NULL, NULL, NULL);
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Two Can Keep A Secret', '12', '2', '2', NULL, NULL, NULL, NULL, NULL);
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('We Were Liars', '23', '2', '4', '2022-06-19', '2022-07-10', '5', '3', '6');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Flipped', '8', '1', '4', '2020-08-23', '2020-08-25', '5', '4', '6');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Harry Potter y La Piedra Filosofal', '2', '2', '4', '2013-03-21', '2013-03-23', '5', '2', '6');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Harry Potter y La Camara de los Secretos', '2', '2', '4', '2013-03-18', '2013-03-20', '5', '2', '6');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Harry Potter y El Prisionero de Azkaban', '2', '2', '4', '2013-03-15', '2013-03-17', '5', '3', '6');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Harry Potter y El Caliz de Fuego', '2', '2', '4', '2013-03-09', '2013-03-14', '5', '2', '6');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Harry Potter y La Orden del Fenix', '2', '2', '4', '2013-01-08', '2013-01-12', '5', '3', '6');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Harry Potter y El Misterio del Pricipe', '2', '2', '4', '2013-01-06', '2013-01-07', '5', '4', '6');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Harry Potter y Las Reliquias de la Muerte', '2', '2', '4', '2012-07-12', '2012-07-15', '5', '1', '6');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Harry Potter and The Cursed Child', '2', '1', '4', '2016-08-01', '2016-08-02', '2', '1', '6');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Divergente', '24', '2', '4', '2014-11-05', '2014-11-08', '5', '5', '6');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Insurgente', '24', '2', '4', '2014-11-13', '2014-11-14', '5', '4', '6');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Leal', '24', '2', '4', '2014-11-15', '2014-11-16', '5', '3', '6');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Four', '24', '1', '4', '2015-03-02', '2015-03-05', '5', '4', '6');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Throttled', '15', '3', '4', '2022-07-31', '2022-08-01', '5', '5', '3');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Collided', '15', '3', '4', '2022-08-02', '2022-08-03', '5', '5', '4');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Wrecked', '15', '3', '4', '2022-10-03', '2022-10-07', '5', '4', '2');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Una Serie de Catastroficas Desdichas: Un Mal Principio', '9', '2', '4', '2012-07-12', '2012-07-14', '5', '6', '6');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Una Serie de Catastroficas Desdichas: La Habitacion de Los Reptiles', '9', '2', '4', '2012-07-15', '2012-07-17', '5', '6', '6');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Una Serie de Catastroficas Desdichas: La Villa Vil', '9', '1', '4', '2012-11-06', '2012-11-09', '5', '6', '6');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Una Serie de Catastroficas Desdichas: El Hospital Hostil', '9', '1', '4', '2012-11-10', '2012-11-13', '5', '6', '6');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Oscuros', '14', '2', '4', '2018-11-04', '2018-11-08', '5', '3', '6');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Oscuros: El Poder de las Sombras', '14', '2', '4', '2018-11-10', '2018-11-20', '3', '1', '6');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Oscuros: La Trampa del Amor', '14', '2', '4', '2019-01-05', '2019-01-07', '5', '4', '6');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Oscuros: La Primera Maldicion', '14', '2', '4', '2019-01-09', '2019-01-10', '5', '4', '6');
INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice) VALUES ('Redeemed', '15', '3', '2', NULL, NULL, NULL, NULL, NULL);

INSERT INTO libro_genero (libro_id, genero_id) VALUES ('1', '1');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('1', '6');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('1', '12');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('2', '1');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('2', '3');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('2', '14');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('3', '1');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('3', '8');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('3', '15');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('4', '1');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('4', '2');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('4', '14');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('5', '1');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('5', '2');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('5', '14');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('6', '1');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('6', '14');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('7', '1');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('7', '8');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('7', '15');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('8', '1');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('8', '2');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('8', '15');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('9', '1');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('9', '8');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('9', '15');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('11', '1');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('11', '8');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('11', '15');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('12', '1');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('12', '8');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('12', '15');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('13', '1');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('13', '8');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('13', '15');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('14', '9');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('14', '13');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('15', '9');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('15', '13');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('16', '9');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('16', '13');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('17', '1');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('17', '12');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('17', '14');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('18', '1');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('18', '12');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('18', '14');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('19', '1');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('19', '12');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('19', '14');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('20', '1');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('20', '4');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('20', '14');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('21', '1');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('21', '4');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('21', '14');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('22', '1');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('22', '4');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('22', '14');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('23', '1');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('23', '10');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('23', '14');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('26', '3');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('26', '14');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('27', '1');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('27', '13');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('28', '5');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('28', '9');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('28', '13');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('29', '5');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('29', '9');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('29', '13');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('30', '5');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('30', '9');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('30', '13');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('31', '5');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('31', '9');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('31', '13');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('32', '5');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('32', '9');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('32', '13');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('33', '5');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('33', '9');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('33', '13');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('34', '5');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('34', '9');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('34', '13');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('35', '5');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('35', '9');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('35', '13');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('36', '1');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('36', '12');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('36', '14');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('37', '1');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('37', '12');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('37', '14');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('38', '1');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('38', '12');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('38', '14');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('39', '1');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('39', '12');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('39', '14');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('40', '1');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('40', '2');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('40', '15');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('41', '1');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('41', '2');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('41', '15');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('42', '1');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('42', '2');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('42', '15');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('43', '3');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('43', '9');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('43', '13');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('44', '3');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('44', '9');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('44', '13');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('45', '3');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('45', '9');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('45', '13');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('46', '3');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('46', '9');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('46', '13');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('47', '1');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('47', '5');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('47', '14');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('48', '5');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('48', '14');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('49', '1');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('49', '5');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('49', '14');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('50', '1');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('50', '5');
INSERT INTO libro_genero (libro_id, genero_id) VALUES ('50', '14');

INSERT INTO libro_trope (libro_id, trope_id) VALUES ('1', '7');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('1', '8');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('1', '11');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('2', '10');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('2', '13');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('2', '17');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('3', '8');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('3', '9');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('4', '10');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('5', '15');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('6', '2');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('6', '3');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('7', '7');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('7', '8');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('7', '9');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('8', '15');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('9', '8');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('9', '10');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('9', '13');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('11', '3');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('11', '16');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('12', '4');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('12', '10');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('12', '8');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('13', '3');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('13', '5');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('13', '8');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('13', '10');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('14', '13');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('14', '17');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('15', '13');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('15', '17');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('16', '13');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('16', '17');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('17', '12');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('17', '15');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('18', '12');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('18', '17');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('19', '12');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('19', '17');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('20', '12');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('20', '15');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('20', '17');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('21', '12');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('21', '17');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('22', '2');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('22', '12');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('22', '17');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('23', '15');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('23', '17');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('26', '13');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('27', '8');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('27', '10');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('28', '13');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('28', '17');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('29', '13');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('29', '17');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('30', '13');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('30', '17');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('31', '13');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('31', '17');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('32', '13');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('32', '17');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('33', '3');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('33', '13');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('33', '17');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('34', '13');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('34', '17');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('35', '17');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('36', '13');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('36', '15');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('37', '13');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('37', '17');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('38', '13');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('38', '17');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('39', '13');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('39', '15');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('39', '17');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('40', '8');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('40', '12');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('40', '19');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('41', '2');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('41', '13');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('42', '1');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('42', '9');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('43', '17');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('44', '17');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('45', '17');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('46', '17');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('47', '21');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('47', '15');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('48', '21');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('48', '17');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('49', '17');
INSERT INTO libro_trope (libro_id, trope_id) VALUES ('50', '17');

## CREACION DE VISTAS ##
CREATE OR REPLACE VIEW autores AS
	SELECT l.nombre_libro AS Nombre, a.nombre_autor AS Autor, a.aka_autor AS Alias FROM libros l
		INNER JOIN autor a
        ON a.autor_id = l.autor_id;

CREATE OR REPLACE VIEW Info_Libros AS
	SELECT l.nombre_libro AS Nombre, a.nombre_autor AS Autor, f.nombre_formato AS Formato FROM libros l 
		INNER JOIN autor a 
			ON a.autor_id = l.autor_id
		INNER JOIN formato f 
			ON f.formato_id = l.formato_id;

CREATE OR REPLACE VIEW spicebooks AS
	SELECT l.nombre_libro AS Nombre, r.numero_base AS 'Calificacion de Spice' FROM libros l
		INNER JOIN rating r
			ON r.rating_id = l.spice
		WHERE l.spice <> 6
        ORDER BY l.spice DESC;

CREATE OR REPLACE VIEW fluffbooks AS
	SELECT l.nombre_libro AS Nombre, r.numero_base AS 'Calificacion de Fluff' FROM libros l
		INNER JOIN rating r
			ON r.rating_id = l.fluff
		WHERE l.fluff <> 6
        ORDER BY l.fluff DESC;

CREATE OR REPLACE VIEW favoritos AS
	SELECT nombre_libro AS Favoritos FROM libros
    WHERE rating_id = 5;
    
## CREACION DE PROCEDIMIENTOS ALMACENADOS Y FUNCIONES ##
# Procedimiento almacenado para insertar registro de libro #
DROP procedure IF EXISTS `sp_insertar_libro`;
DELIMITER $$
CREATE PROCEDURE `sp_insertar_libro` (IN nombre VARCHAR(200), autor INT, formato INT, estado INT, inicio DATE, final DATE, rating INT, fluff INT, spice INT)
BEGIN
	INSERT INTO libros (nombre_libro, autor_id, formato_id, estado_id, start_date, end_date, rating_id, fluff, spice)
	VALUES (nombre, autor, formato, estado, inicio, final, rating, fluff, spice);
END$$
DELIMITER ;

# Procedimiento almacenado para actualizar si un autor muere #
DROP procedure IF EXISTS `sp_actualizar_autor`;
DELIMITER $$
CREATE PROCEDURE `sp_actualizar_autor` (IN estado VARCHAR(20), autor INT)
BEGIN
	UPDATE autor SET status_autor = estado WHERE autor_id = autor;
END$$
DELIMITER ;

# Procedimiento almacenado para eliminar una trope de un libro #
DROP procedure IF EXISTS `sp_eliminar_TROPElibro`;
DELIMITER $$
CREATE PROCEDURE `sp_eliminar_TROPElibro` (IN trope INT, libro INT)
BEGIN
	DELETE FROM libro_trope
		WHERE libro_id = libro AND trope_id = trope;
END$$
DELIMITER ;

# Funcion para obtener la cantidad de dias que tomo una lectura #
DROP function IF EXISTS `dias_libros`;
DELIMITER $$
CREATE FUNCTION `dias_libros` (libro VARCHAR(200))
RETURNS int
READS SQL DATA
BEGIN
	DECLARE dias int;
    DECLARE inicio date;
    DECLARE fin date;
    SET inicio = (SELECT start_date FROM libros WHERE nombre_libro = libro);
    SET fin = (SELECT end_date FROM libros WHERE nombre_libro = libro);
    SET dias = timestampdiff(day, inicio, fin);
RETURN dias;
END$$
DELIMITER ;

