
-- Ejercicio propuesto (1)
-- La empresa Mawashi Cars Spa ha detectado un problema con el sistema que permite
-- registrar ventas de los autos que no tienen stock y ha provocado incomodidades con los
-- clientes, por lo que necesita urgentemente que se arregle este error y evitar futuras ventas
-- en donde no se tenga disponibilidad del auto que se quiera vender. En el apoyo lectura de
-- esta sesión encontrarás 2 archivos llamados autos.csv y ventas.csv para el desarrollo de
-- este ejercicio propuesto.


-- - 1.-*******************
CREATE TABLE autos (
id_auto INT UNIQUE PRIMARY KEY,
marca VARCHAR(25),
modelo VARCHAR (35),
año INT,
color VARCHAR (20),
precio INT,
stock INT CHECK (stock >= 0)
);


CREATE TABLE ventas (
fecha DATE,
id_auto INT,
cliente VARCHAR (25),
referencia INT,
cantidad INT,
metodo_pago VARCHAR (25),
FOREIGN KEY (id_auto) REFERENCES autos (id_auto)
);

-- 1.1.-*******************************************
-- \copy autos FROM 'H:\CSV_BD\autos.csv' csv header    //cambiar ruta, dependiendo donde estan los archivos
-- \copy ventas FROM 'H:\CSV_BD\ventas.csv' csv header   //cambiar ruta, dependiendo donde estan los archivos


-- Realizar una transacción que incluya la inserción de un registro en la tabla “ventas” del auto
-- con id 5 y una actualización en la tabla “autos” que reste 1 al stock de dicho auto.
-- ************************************************************

BEGIN TRANSACTION;

INSERT INTO ventas(fecha,id_auto,cliente,referencia,cantidad,metodo_pago)
VALUES('2020-02-02', 5 , 'Diana Palma', 40302, 2000000,'credito');
UPDATE autos SET stock =stock-1 WHERE id_auto=5;

COMMIT;

--//El auto id=5, es el ferrari que tenia un stock=1, pero al hacer la venta quedo en stock=0
--//por lo cual, si existe otra venta debera mostrar error


-- 2. Continuando con el ejercicio propuesto de Mawashi Cars, realiza otra transacción en
-- donde insertes registros en la tabla ventas pero ahora con los autos de id 2, 3 y 5.
-- Considera que alguno de estos autos podría no tener stock por lo que deberás
-- realizar un rollback al recibir el error por consola y confirmar que los cambios no
-- fueron realizados consultando ambas tablas


BEGIN TRANSACTION;

INSERT INTO ventas (fecha,id_auto,cliente,referencia,cantidad,metodo_pago)
VALUES ('2020-02-03', 2 , 'Maria Urbaez', 23302, 2000000,'debito');
UPDATE autos
SET stock = stock -1 
WHERE id_auto=2;

INSERT INTO ventas (fecha,id_auto,cliente,referencia,cantidad,metodo_pago)
VALUES ('2020-02-04', 3 , 'Chary Malave', 43302, 1200000,'credito');
UPDATE autos
SET stock =stock-1
WHERE id_auto=3;

INSERT INTO ventas (fecha, id_auto, cliente, referencia, cantidad,metodo_pago)
VALUES ('2020-02-05', 5 , 'Diana Palma', 12302, 50000000,'credito');
UPDATE autos
SET stock =stock-1
WHERE id_auto=5;

ROLLBACK;

-- //Entreag un erro la consulta, porque el id_auto=5 tiene stock=0, POR LO CUAL SE TERMINA DE REALIZAR LA TRANSACTION
-- //el nuevo registro para la relación «autos» viola la restricción «check» «autos_stock_check»

-- 3. Realizar una nueva transacción intentando volver a registrar las ventas de los autos
-- de id 2, 3 y 5, pero para evitar que no se realice ningún cambio crea un punto de
-- guardado por cada auto que no arroje un error en su actualización de stock y si
-- recibes algún error realiza un ROLLBACK a último SAVEPOINT. Posteriormente revisa
-- ambas tablas para verificar que se realizaron los cambios correspondientes
-- *****************************************************************************

BEGIN TRANSACTION ;

INSERT INTO ventas (fecha,id_auto,cliente,referencia,cantidad,metodo_pago)
VALUES ('2020-02-03', 2 , 'aaaaaaaa', 23302, 2000000,'debito');
UPDATE autos
SET stock = stock - 1 WHERE id_auto=2;
SAVEPOINT a;

INSERT INTO ventas (fecha,id_auto,cliente,referencia,cantidad,metodo_pago)
VALUES ('2020-02-04', 3 , 'bbbbbbbb', 43302, 1200000,'credito');
UPDATE autos
SET stock =stock - 1 WHERE id_auto=3;
SAVEPOINT b;


INSERT INTO ventas (fecha, id_auto, cliente, referencia, cantidad,metodo_pago)
VALUES ('2020-02-05', 5 , 'Diana Palma', 12302, 50000000,'credito');
UPDATE autos
SET stock =stock - 1 WHERE id_auto=5;

ROLLBACK TO SAVEPOINT  b;


