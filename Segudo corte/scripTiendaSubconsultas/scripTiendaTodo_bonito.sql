/*
autor: andrea herrera
*/
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


create database todo_bonito;
use todo_bonito;

create table cliente(
idCliente int primary key auto_increment,
nombreCliente varchar (100) not null,
emailCliente varchar (150) unique,
ciudad varchar (80) null,
creado_en datetime default now()
);

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

create table productos(
idProducto int primary key,
nombreProducto varchar(60),
precioProducto decimal(10,2),
categoriaProducto varchar(40)
);
 
insert into departamentos (idDepto, nombreDepto) values
(1,'ventas'),
(2,'contabilidad'),
(3,'Finanzas');
 
insert into empleados (idEmpleado, nombreEmpleado, depto_id, salarioEmpleado) values
(11,'David lizmar', 2, 2500000.00),
(12,'Andrea Herrera', 1, 1800000.00),
(13,'Sonia Suarez', 3, 3000000.00),
(14,'María Ruiz', 3, 3000000.00),
(5, 'Santiago Martínez', 2, 2500000.00);
 
insert into productos (idProducto, nombreProducto, precioProducto, categoriaProducto) values
(1,'vestido', 200000.00, 'Ropa'),
(2,'tacones', 150000.00, 'Calzado'),
(3,'cadena plata', 250000.00, 'Accesorios'),
(4,'falda corta', 100000.00, 'Ropa'),
(5,'polvo compacto', 55000.00, 'Maquillaje');

insert into cliente(idCliente,nombreCliente,emailCliente,ciudad ) values
(1,'Ana Garcia', 'ana@mail','Medellin'),
(2,'Pedro Perez','pedro@mail','bogota'),
(3,'Andres arias', 'andre@mail','Barranquilla'),
(4,'David Suarez','suarezd@mail','Cartagena'),
(5,'Maria Arias', 'mariasarias@mail','Cucuta');

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
max(precioProducto) AS precioMaximo from productos
where precioProducto > (
select avg(precioProducto) from productos as promedioPrecio
)
group by categoriaProducto
order by precioMaximo desc;

select * from productos;
select avg(precioProducto) from productos as promedioPrecio;


create table pedido(
idPed int primary key auto_increment,
fechaPedido datetime default now(),
total decimal(10,2),
idClienteFK int,
idEmpleadoFK int,
foreign key (idClienteFK) references cliente(idCliente),
foreign key (idEmpleadoFK) references empleados(idEmpleado)
);

create table detpedido(
idDetpedido int primary key auto_increment,
cantidad int not null,
precioUnitario decimal(10,2) not null,
idPedFK int,
idProductoFK int,
foreign key (idPedFK) references pedido (idPed),
foreign key (idProductoFK) references productos (idProducto));

insert into pedido (fechaPedido,total,idClienteFK,idEmpleadoFK) values
(now(),350000,1,11),
(now(),150000,2,12),
(now(),250000,3,13);

insert into detpedido (cantidad,precioUnitario,idPedFK,idProductoFK) values
(1,200000,1,1),
(1,150000,1,2),
(1,150000,2,2),
(1,250000,3,3);

select * from detpedido;
select p.idPed, 
c.nombreCliente as cliente, 
c.ciudad, 
p.fechaPedido, 
p.total 
from pedido p 
inner join cliente c on p.idClienteFK=c.idCliente 
order by p.fechaPedido desc;

select p.idPed,
c.nombreCliente as cliente,
c.ciudad,
pr.nombreProducto,
d.cantidad
from pedido p
inner join cliente c on p.idClienteFK = c.idCliente
inner join detpedido d on p.idPed = d.idPedFK
inner join productos pr on d.idProductoFK = pr.idProducto
order by p.fechaPedido desc;

