/*ANDREA HERRERA*/

-- =====================================================
-- DDL: CREACION DE BASE DE DATOS Y TABLAS
-- =====================================================
CREATE DATABASE tienda_tech;
USE tienda_tech;

CREATE TABLE clientes (
    cliente_id      INT AUTO_INCREMENT PRIMARY KEY,
    nombre          VARCHAR(100) NOT NULL,
    email           VARCHAR(100) UNIQUE NOT NULL,
    ciudad          VARCHAR(60),
    fecha_registro  DATE DEFAULT (CURRENT_DATE)
);


CREATE TABLE productos (
    producto_id  INT AUTO_INCREMENT PRIMARY KEY,
    nombre       VARCHAR(100) NOT NULL,
    categoria    VARCHAR(60),
    precio       DECIMAL(10,2) NOT NULL CHECK (precio > 0),
    stock        INT DEFAULT 0
);

CREATE TABLE pedidos (
    pedido_id    INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id   INT NOT NULL,
    producto_id  INT NOT NULL,
    cantidad     INT NOT NULL CHECK (cantidad > 0),
    fecha_pedido DATE DEFAULT (CURRENT_DATE),
    estado       VARCHAR(20) DEFAULT "pendiente"
	CHECK (estado IN ("pendiente","entregado","cancelado")),
    FOREIGN KEY (cliente_id)  REFERENCES clientes(cliente_id),
    FOREIGN KEY (producto_id) REFERENCES productos(producto_id)
);

-- =====================================================
-- DML: DATOS DE PRUEBA
-- =====================================================
INSERT INTO clientes VALUES
 (1,"Ana Lopez","ana@mail.com","Bogota","2023-01-15"),
 (2,"Carlos Ruiz","carlos@mail.com","Medellin","2023-03-22"),
 (3,"Maria Torres","maria@mail.com","Cali","2023-05-10"),
 (4,"Pedro Gomez","pedro@mail.com","Bogota","2023-07-08"),
 (5,"Sofia Herrera","sofia@mail.com","Barranquilla","2023-09-01"),
 (6,"Luis Martinez","luis@mail.com","Bogota","2024-01-20"),
 (7,"Camila Vargas","camila@mail.com","Cali","2024-02-14"),
 (8,"Diego Morales","diego@mail.com","Medellin","2024-03-30");

INSERT INTO productos VALUES
 (1,"Laptop Pro 15","Computadores",3500000.00,12),
 (2,"Mouse Inalambrico","Perifericos",85000.00,50),
 (3,"Teclado Mecanico","Perifericos",220000.00,30),
 (4,"Monitor 27","Pantallas",1200000.00,8),
 (5,"Auriculares BT","Audio",350000.00,25),
 (6,"Webcam HD","Perifericos",180000.00,20),
 (7,"Disco SSD 1TB","Almacenamiento",420000.00,40),
 (8,"Tablet 10","Moviles",1800000.00,6);

INSERT INTO pedidos VALUES
 (1,1,1,1,"2024-01-10","entregado"),(2,1,2,2,"2024-01-15","entregado"),
 (3,2,3,1,"2024-02-05","entregado"),(4,2,5,1,"2024-02-20","cancelado"),
 (5,3,4,1,"2024-03-01","entregado"),(6,3,7,2,"2024-03-15","pendiente"),
 (7,4,2,3,"2024-04-02","entregado"),(8,4,6,1,"2024-04-10","pendiente"),
 (9,5,8,1,"2024-04-18","entregado"),(10,6,1,2,"2024-05-05","entregado"),
 (11,6,3,1,"2024-05-12","pendiente"),(12,7,5,2,"2024-05-20","entregado"),
 (13,1,7,1,"2024-06-01","entregado"),(14,8,4,1,"2024-06-10","cancelado"),
 (15,5,2,4,"2024-06-15","entregado"),(16,3,1,1,"2024-07-01","pendiente");

SELECT * FROM CLIENTES;
SELECT * FROM PRODUCTOS;
SELECT * FROM PEDIDOS;
DESCRIBE PRODUCTOS;

## PREGUNTA 13
-- Agregue la columna descuento DECIMAL(5,2) DEFAULT 0 a la tabla productos con una restricción CHECK que garantice valores entre 0 y 50.

ALTER TABLE productos ADD COLUMN descuento DECIMAL(5,2) DEFAULT 0 
CHECK (descuento >= 0 AND descuento <= 50);

SELECT * FROM productos;

-- Cree la función fn_precio_final(p_producto_id INT) que retorne el precio del producto aplicando su descuento (precio * (1 - descuento/100)). 

DELIMITER //

CREATE FUNCTION fn_precio_final(p_producto_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_precio    DECIMAL(10,2);
    DECLARE v_descuento DECIMAL(5,2);
	
    SELECT precio, descuento
    INTO v_precio, v_descuento
    FROM productos
    WHERE producto_id = p_producto_id;
 
    RETURN v_precio * (1 - v_descuento / 100);
END//
 
DELIMITER ;

-- Luego escriba una consulta que muestre nombre, precio, descuento y precio_final para los 3 productos con mayor precio_final, usando la función.

SELECT nombre, precio, descuento,fn_precio_final(producto_id) AS precio_final FROM productos
ORDER BY precio_final DESC
LIMIT 3;