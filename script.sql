-- 1) Cargar el respaldo de la base de datos unidad2.sql - Asegurarse de tener la base de datos unidad2 previamente creada.
--psql -U sararincon unidad2 < unidad2.sql
DROP DATABASE unidad2 IF EXISTS;


CREATE DATABASE unidad2;


\c unidad2

--Requerimiento del usuario 01
BEGIN TRANSACTION;
INSERT INTO compra(cliente_id,fecha) VALUES(1, '2021-12-11');
INSERT INTO detalle_compra(producto_id, compra_id, cantidad) VALUES(9,39, 5);
UPDATE producto SET stock = stock -5 WHERE id=9;
COMMIT;

--Comprobando  si se descontó del stock
SELECT * FROM producto
WHERE id=9;

--Requerimientos del usuario 02 

BEGIN TRANSACTION;
INSERT INTO compra(cliente_id,fecha) VALUES(2, '2021-12-11');

--Validando stock producto 1
SELECT * FROM producto WHERE id=1;

-- Realizando la Compra de tres productos id 1
INSERT INTO detalle_compra(producto_id, compra_id, cantidad) VALUES(1,40,3);
UPDATE producto SET stock = stock -3 WHERE id=2;
SAVEPOINT punto;

--Validando stock producto 2
SELECT * FROM producto
WHERE id=2;

--Realizando la Compra de tres productos id 2
INSERT INTO detalle_compra(producto_id, compra_id, cantidad) VALUES(2,40,3);
UPDATE producto SET stock = stock -3 WHERE id=2;
--no hay stock, haremos rollback
ROLLBACK TO punto;


-- Validando stock producto 8
SELECT * FROM producto
WHERE id=8;

-- Realizando la compra de tres productos id 8
INSERT INTO detalle_compra(producto_id, compra_id, cantidad) VALUES(8,40,3);
UPDATE producto SET stock = stock -3 WHERE id=2;
ROLLBACK TO punto;

--Validando Stock 
SELECT descripcion ,stock FROM producto
WHERE id in (1, 2, 8);
END TRANSACTION;


\set AUTOCOMMIT OFF

--Insertando nuevo cliente
BEGIN TRANSACTION;
SAVEPOINT client;
INSERT INTO cliente(id, nombre, email) VALUES(11, 'usuario011', 'usuario011@gmail.com');

--Realizando ROLLBACK
ROLLBACK to client;
COMMIT;

--Confirmar que se restauró la información 
SELECT * FROM cliente
WHERE id=11;

--Activando el Autocommit
\set AUTOCOMMIT
