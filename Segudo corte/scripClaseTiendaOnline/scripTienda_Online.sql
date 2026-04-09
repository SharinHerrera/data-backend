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
-- select * from  cliente_backup;
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

## sentencias para concultas
## generales 
-- select * from nombre_tabla
-- select idCliente,docCliente from cliente
## especificas
-- AS-Alios
-- where
-- likes
-- subconsulta
-- agrupados
-- ordenados
-- multitabla
-- subconsulta
-- operacionescalculadas

describe productos;
alter table productos change stockProducto  stoProT int;
select nombreProducto,stoProT from productos;

## alias para darle un alias al nombre de un campo y se usa nombredelcampo as aliasdelcampo

select nombreProducto as Nombre_Producto, stoProT as stock from productos;

## where operacion (aritmetica) + - * / y logistica and or not 

select nombreProducto,stoProT from productos where idProducto=1 ;

select nombreProducto,stoProT from productos where stoProT>=15 and idProducto=1 ;

select nombreProducto as Nombre_Producto, stoProT as stock from productos
where stoProT>=10 and nombreProducto='Laptop Pro';
-- select * from productos;
## select campos from nombre_tabla order by campo_a_ordenar formaOrden(ASC DESC)

select nombreProducto as Nombre_Producto, stoProT AS stock
from productos order by nombreProducto ASC;

select nombreProducto as Nombre_Producto, stoProT as stock from productos
where stoProT>=25 or nombreProducto='Laptop Pro';

## between para selecionar un rango de campos  select * from nombre_tabla between valor1 and valor2

select nombreProducto as Nombre_Producto, precioProducto as precio from productos
where precioProducto between 50000 and 100000 and stoProT>3 order by precioProducto;

## like buscar caracteres que inicion, que terminen o que contengan
## que inicien
select * from productos where nombreProducto like 'm%';
## que contengan
select * from productos where nombreProducto like '%o%';
## que termine
select * from productos where nombreProducto like '%os' order by precioProducto asc limit 10;

select * from productos where nombreProducto not like 'm%';

##  importar un csv con datos sin necesidad de un insert 

load data infile 'C:/xamp/mysql/data/cliente.csv'
into table cliente
fields terminated by ';'
lines terminated by '\n'
ignore 1 rows
(nombreCliente,emailCliente,ciudad);
-- select * from cliente;
-- select idCliente from cliente order by idCliente ;
-- select * from pedido;
-- select 51 in (select idCliente from cliente);

load data infile 'C:/xamp/mysql/data/productos.csv'
into table productos
fields terminated by ';'
lines terminated by '\n'
ignore 1 rows
(nombreProducto,precioProducto,stoProT,categoriaProducto);

load data infile 'C:/xamp/mysql/data/pedido.csv'
into table pedido
fields terminated by ';'
lines terminated by '\r\n'
ignore 1 rows
(cantidadProducto,fechaPedido,idClienteFK,idProductoFK);

## cargar archivos

-- set foreign_key_checks=0; desactiva las llavez foraneas para que no de problema al cargar los datos
-- set foreign_key_checks=1; despues de cargar los datos se vuelve a activar 

/* Agrupar group by select camposConsultar from nombreTabla group by campoAgrupar */

select * from productos group by categoriaProducto;

-- count()
-- AVG ()
-- Sum ()
-- max ()
-- min ()

select categoriaProducto, 
count(*)as cantidad,
avg(precioProducto) as promedioMedio
from productos 
group by categoriaProducto
having avg(precioProducto)>5000
order by promedioMedio desc;

select format (precioProducto,2,'es_CO') as precio 
from productos;

## funciones calculadas
select 
count(*) as Total,
avg (precioProducto) as PromedioPrecio,
max(precioProducto) as PrecioMaximo,
min(precioProducto) as PrecioMinimo,
sum(stoProT) as StockTotal
from productos;

-- describe productos;

select upper(nombreCliente) as NombreMayuscula,
concat('nombre Cliente: ',nombreCliente,' email Cliente: ',emailCliente) as Concatenar,
length(nombreCliente) as TamanioNombre
from cliente;

## consultar los clientes que realizaron 2 pedidos de un producto cuyo precio es mayor a 100.000

## subconsulta  

/*Consultas Anidadas: SubQuery select 
select col1,col2
from tabla_Princial
where columna operador
	(select col1,col2
from tabla_Secundaria
where condicion); 
tipos de subconsultas
Escalar: devuelve  un único valor (fila o columna Se utiliza en operadores de comparación (<, >...)
de fila: devuelve una sola fila con varias columnas row()
de tabla: devuelve una tabla (varios registros(filas) y campos(columnas)) se usa en clausulas from
Correlacionales: referencia relaciona la consulta exterior con la interior. Se usa con FK
*/

/* retos
1.crear tabla empleados (id,nombre,deptoId, salario)
producto (id,nombre,precio,categoria)
departamento(id,nombre)
 2. Vamos a registrar 5 empleados 3 departamentos y 5 productos*/

create table departamentos(
idDepto int primary key,
nombreDepto varchar(50)
);

create table empleados(
idEmpleado int primary key,
nombreEmpleado varchar(50),
depto_id int,
salarioEmpleado decimal(10,2),
foreign key (depto_id) references departamentos(idDepto)
);

create table producto(
idProducto int primary key,
nombreProducto varchar(60),
precioProducto decimal(10,2),
categoriaProducto varchar(40)
);
 
insert into departamentos (idDepto, nombreDepto) values
(1, 'Recursos Humanos'),
(2 , 'contabilidad'),
(3 ,'Finanzas');
 
insert into empleados (idEmpleado, nombreEmpleado, depto_id, salarioEmpleado) values
(1,'David lizmar', 2, 2500000.00),
(2,'Andrea Herrera', 1, 1800000.00),
(3,'Sonia Suarez', 3, 3000000.00),
(4,'María Ruiz', 3, 3000000.00),
(5, 'Santiago Martínez', 2, 2500000.00);
 
insert into producto (idProducto, nombreProducto, precioProducto, categoriaProducto) values
(1,'vestido', 200000.00, 'Ropa'),
(2,'tacones', 80000.00, 'Calzado'),
(3,'cadena plata', 150000.00, 'Accesorios'),
(4,'falda corta', 50000.00, 'Ropa'),
(5,'polvo compacto', 35000.00, 'Maquillaje');

select*from empleados;


/*Subconsultas*/
###-----Where----
select nombreEmpleado,salarioEmpleado 
from empleados
where salarioEmpleado>
	(select AVG(salarioEmpleado)
    from empleados);
    
 ###-----Where+in----
select nombreEmpleado,salarioEmpleado 
from empleados
where depto_id in 
	(select idDepto
    from departamentos
    where nombreDepto in ('Recursos Humanos','Finanzas'));
   
   
 ###-----tabla derivada----
select depto_id,prom_salario
from 
	(select depto_id,AVG(salarioEmpleado)as prom_salario
	from empleados
    group by depto_id) as promedios
where prom_salario > 2000000.00;


## reto 
select nombreEmpleado,salarioEmpleado,
(select avg(salarioEmpleado) from empleados) as promGeneral,
salarioEmpleado - (select avg(salarioEmpleado) from empleados ) as diferencia
from empleados;

select categoriaProducto, nombreProducto,
max(precioProducto) AS precioMaximo from producto
where precioProducto > (
select avg(precioProducto) from producto as promedioPrecio
)
group by categoriaProducto
order by precioMaximo desc;

select * from producto;
select avg(precioProducto) from producto as promedioPrecio;


create table pedidos(
idPed int primary key auto_increment,
cantidadProducto int not null,
fechaPedido date,
idEmpleadoFK int,
foreign key (idEmpleadoFK) references empleados (idEmpleado)
);

create table detpedido(
idDetpedido int primary key auto_increment,
cantidad int not null,
precioUnitario decimal(10,2) not null,
subTotal decimal(10,2) not null,
idPedFK int,
idProductoFK int,
foreign key (idPedFK) references pedidos (idPed),
foreign key (idProductoFK) references producto (idProducto));

select p.idPedido,
c.nombre as empleados,
c.ciudad,
p.fechaPedido,
p.estado,
p.total
from pedidos p
inner join empleados c on p.idEmpleado=c.idCliente
order by p.fechaPedido desc;


