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
stock int default 0 ,
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
 
insert into productos (idProducto, nombreProducto, precioProducto,stock,categoriaProducto) values
(1,'vestido', 200000.00, 50,'Ropa'),
(2,'tacones', 150000.00, 20,'Calzado'),
(3,'cadena plata', 250000.00,60, 'Accesorios'),
(4,'falda corta', 100000.00,40, 'Ropa'),
(5,'polvo compacto', 55000.00, 35,'Maquillaje');

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

use todo_bonito;
##cliente,pedido,producto
select 
c.nombreCliente as cliente,
p.idPed,
pr.nombreProducto,
d.cantidad,
d.precioUnitario,
(d.cantidad*precioUnitario)as subTotal
from pedido p
inner join cliente c on p.idClienteFK = c.idCliente
inner join detpedido d on p.idPed = d.idPedFK
inner join productos pr on d.idProductoFK = pr.idProducto
order by c.nombrecliente, p.idPed desc;


## == procedimientos almacenados - funciones - vistas
/* ===== procedimientos almacenados stored procedures====
son bloques de codigo de SQL que tienen un nombre que se almacenan en el servidor y se ejecutan con invocacion 
o llamandolos CALL registro o de consulta de modificacion o actualizacion de eliminacion

con parametros entrada in salida out ambos (inout)

sintaxis
CREAR PROCEDIMEINTO

DELIMITAR//alterCREATE PROCEDURE nombreProcedimiento(
	IN parametro_entrada tipo,
	OUT parametro_salida tipo,
	INOUT parametro_entradasalida tipo
)
BEGIN
----declaracion de variables locales
DECLARE variable tipo DEFAULT valor;

---- cuerpo de procedimiento
---- sentencias SQL, control flujo....

END //

DELIMITER;
--invocar procedimiento
CALL nombreProcedimiento(valor_entrada,@variable_salida,@variable_entrada_salida);
*/
## ejemplo 1 registro de un pedido completo

DELIMITER //
create procedure crearPedido(
	in p_idCliente int,
    in p_idProducto int,
    in p_cantidad int,
    out p_idPed int,
    out p_mensaje varchar(200)
)
begin
	declare v_stock int;
    declare v_precioProducto decimal(10,2);
    declare v_total decimal(10,2);
    -- mensaje de error 
		declare exit handler for sqlexception
        begin
			rollback;
            set p_mensaje='ERROR:Transaccion revertida';
            set p_idPed=-1;
		end;
        -- validar disponibilidad de stock
        select stock, precio into v_stock, v_precioProducto
        from productos where idProducto=p_idProducto;
        if v_stock>p_cantidad then
        set p_mensaje=concat('stock insuficiente.Disponible:',v_stock);
        set p_idPed=0;
        else
        start transaction;
		set v_total=v_precioProducto*p_cantidad;
        -- crear pedido
        insert into pedido(idClienteFK,total) values (p_idCliente,v_total);
        set p_idPed=last_insert_id();
        -- insertar el detalle
        insert into detalle_pedido(idPed,idProducto,cantidad,precioUnitario)
		values(p_idPed,p_idProducto,p_cantidad,v_precio);
		-- descontar del stock
        update productos
        set stock = stock-p_cantidad
        where idProducto = p_idProducto;
        commit;
        set p_mensaje=concat('pedido #',p_idPed,'creado correctamente');
        end if;
end//
delimiter ;/* siempre debe tener ese espacio*/
-- invocar o ejecutar el procedimiento
	call crearPedido (1,3,10,@pedido_id,@mensaje);        
    
    select @pedido_id as id_Pedido, @mensaje as mensaje;
    select * from pedido;
    select * from cliente;
        
        
## hacer ejemplo de procedimiento con cursor en mysql        
## crear un procedimiento almacenado que permita cancelar un pedido
## recibir como parametro de entrada idPedio y el idCliente (verificar que el pedido pertenece al cliente)
## validar que el pedido exista y permanezca al cliente indicado, si no debe mostar mensaje de error
##validar que el pedido no este cancelado ni entregado. solo se va a  poder cancelar pedidos que esten pendientes o enviado
## actualizar el estado del pedido a cancelado
## actualizar o restaurar el stock de cada producto de ese pedido (detPed)
##retornar como parametro de salida un mensaje que pedido#x: cancelado stock restaurado para n productos
## 1.exitosa pedido#x:cancelado stock restaurado para n productos
## 2. no exista el pedido no existe o no pertenece

DELIMITER //
create procedure cancelarPedido(
	in p_idPed int,
    in p_idCliente int,
    out p_mensaje varchar(200)
)
begin
    declare v_estado varchar(40);
    declare v_contador int default 0;
    -- mensaje de error 
		declare exit handler for sqlexception
        begin
			rollback;
            set p_mensaje='ERROR:Transaccion revertida';
		end;
        start transaction;
        -- validar que exista el pedido 
		select estado
		into v_estado
		from pedido
		where idPed = p_idPed
		and idClienteFK = p_idCliente;
        -- si el pedido no existe
		if v_estado is null then
        set p_mensaje = 'ERROR: pedido no existe o no pertenece al cliente';
        rollback;
        -- validar que no este cancelado
		elseif v_estado in ('cancelado', 'entregado') then
        set p_mensaje = concat(
            'ERROR: pedido #', p_idPed,
            ' no se puede cancelar porque esta ',
            v_estado
        );
       else
		-- restaurar el stock
        update productos pr
        inner join detpedido d on pr.idProducto = d.idProductoFK
        set pr.stock = pr.stock + d.cantidad
        where d.idPedFK = p_idPed;
        
        -- cuento cuantos productos se restauraron
		select count(*)
        into v_contador
        from detpedido
        where idPedFK = p_idPed;
        -- cambio el estado del pedido
		update pedido
        set estado = 'cancelado'
        where idPed = p_idPed;

        commit;
                set p_mensaje = concat(
            'EXITOSA: pedido #', p_idPedido,
            ' cancelado. Stock restaurado para ',
            v_contador, ' productos'
        );
    end if;
end//
delimiter ;/* siempre debe tener ese espacio*/
-- invocar o ejecutar el procedimiento
	call cancelarPedido(1,1,@mensaje);
	select @mensaje;  
    
    
    
    