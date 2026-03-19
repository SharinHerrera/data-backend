/*
autor: andrea herrera
*/
-- SENTENCIAS DLM: Lnguaje de manipulacion de datos
-- 0. es crear la estructura de la BD (modelo fisico-diccionario de datos)
-- 1. DATOS PUROS O LIMPIOS (ETL)
-- 2. Manipulacion de datos (hacer registros, consultar resgistros, modificar registros, eliminar registros)
-- un logico transacional (sentencias) (indicacion orden de una peticion transacion ) MySQL SQL
-- trabajar sobre el contenido
-- Transaccional: crear-insertar agergar registros (insert)
-- Modificar actualizar (Update)
-- Consultas sobre la DB (select)
-- Eliminar (Delete)

-- insert (agregar crear registrar insertar datos)
-- consulta general select * from nombre_ tabla

create database if not exists tienda_online;
use tienda_online;

create table cliente(
idCliente int primary key auto_increment,
nombreCliente varchar (100) not null,
emailCliente varchar (150) unique,
ciudad varchar (80) null,
creado_en datetime default now()
);

create table productos(
idProducto int primary key auto_increment,
nombreProducto varchar (120) not null,
precioProducto decimal (10,2),
stockProducto int default 0 ,
categoriaProducto varchar (50)
);

create table pedido(
idPedido int primary key auto_increment,
cantidadProducto int not null,
fechaPedido date,
idClienteFK int,
idProductoFK int,
foreign key (idClienteFK) references cliente (idCliente),
foreign key (idProductoFK) references productos (idProducto)
);

create table cliente_backup(
idCliente int primary key auto_increment,
nombreCliente varchar (100),
emailCliente varchar (150),
creado_en datetime default now()
);

-- select consulta general de las tablas 
-- select * from cliente;
-- select * from productos;
-- select * from pedido;

-- Inserciones insert into nombre_tabla (campos1,campo2,campo3,...) values (valor1,valor2,valor3,...)
-- si el campo es varchar va entre comillas
-- si el campo es autoincrement s debe enviar el campo sin valor ''
-- si el campo es una fecha debe revisar el formato

-- agregar un registro
-- describe cliente;
-- select * from cliente;
insert into cliente(nombreCliente,emailCliente,ciudad ) values ('Ana Garcia', 'ana@mail','Madrid');
insert into cliente(nombreCliente,emailCliente,ciudad ) values ('Pedro Perez','pedro@mail','Barcelona');
insert into cliente(nombreCliente,emailCliente,ciudad ) values ('Andrea Herrera', 'andreh@mail','Barcelona');
insert into cliente(nombreCliente,emailCliente,ciudad ) values ('David Suarez','suarezd@mail','Sevilla');
insert into cliente(nombreCliente,emailCliente,ciudad ) values ('Maria Arias', 'mariasarias@mail','Cuenca');

-- Agregar Varios registros
-- describe productos;
insert into productos (nombreProducto,precioProducto,stockProducto,categoriaProducto)
values ('Laptop Pro',1200000,15,'Electrónica'), 
('Mouse USB',50000,80,'Accesorios'),
('Monitor 32"',500000,20,'Electrónica'),
('Teclados',100000,35,'Accesorios'),
('Tablet',800000,25,'Electronica'),
('FundasTablets',60000,60,'Accesorios');

insert into cliente_backup (nombreCliente,emailCliente)
select nombreCliente,emailCliente
from cliente
where creado_en<'2026-03-19';

insert into pedido (cantidadProducto, fechaPedido, idClienteFK, idProductoFK)
values (3, '2026-03-19', 5, 6);

-- Update actualizar o modificar los registros en una tabla
-- update nombreTabla set columna1=valor1,columna2=valor2,.... where condicion
-- Actualizar un campo
update cliente
set ciudad='Valencia'
where idCliente=1;

update cliente
set ciudad='Murcia'
where idCliente=3;

-- Actualizar varios campos
 -- select * from productos;

update productos
set
precioProducto=1099000,
stockProducto=10
where idProducto=1;

update productos
set
stockProducto=30
where idProducto=5;

update productos
set precioProducto=precioProducto * 1.10
where categoriaProducto='Accesorios';

update productos
set precioProducto=precioProducto * 0.90
where nombreProducto='Mouse USB';

-- select * from cliente;
delete from cliente 
where idCliente=2;

-- select * from productos;
delete from productos
where stockProducto=0 AND categoriaProducto='Descatalogado';

-- select * from pedido;
delete from pedido
where idPedido=1;

delete from cliente 
where idCliente=3;

delete from productos
where stockProducto<3;