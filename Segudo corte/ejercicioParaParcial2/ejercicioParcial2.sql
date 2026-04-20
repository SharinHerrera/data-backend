/* Andrea herrera 
EJERCICIO PARA EL PARCIAL */
create database homelike;
use homelike;

create table clientes (
    cliente_id int primary key auto_increment,
    nombre varchar(100) not null,
    email varchar(100) unique,
    ciudad varchar(50),
    fecha_registro date default (curdate())
);
 
create table categorias (
    categoria_id int primary key auto_increment,
    nombre varchar(50) not null
);
 
create table productos (
    producto_id int primary key auto_increment,
    nombre varchar(100) not null,
    categoria varchar(50),
    precio decimal(12,2) not null,
    stock int default 0
);
 
create table pedidos (
    pedido_id int primary key auto_increment,
    cliente_id int,
    producto_id int,
    cantidad int not null,
    estado varchar(20) default 'pendiente',
    fecha_pedido datetime default now(),
    foreign key (cliente_id) references clientes(cliente_id),
    foreign key (producto_id) references productos(producto_id)
);
 
create table detalle_pedido (
    detalle_id int primary key auto_increment,
    pedido_id int,
    producto_id int,
    cantidad int,
    precio_unitario decimal(12,2),
    foreign key (pedido_id) references pedidos(pedido_id),
    foreign key (producto_id) references productos(producto_id)
);

insert into clientes (nombre, email, ciudad) values
('laura rios', 'laura@mail.com', 'manizales'),
('carlos perez', 'carlos@mail.com', 'bogota'),
('maria lopez', 'maria@mail.com', 'medellin'),
('juan garcia', 'juan@mail.com', 'cali'),
('sofia torres', 'sofia@mail.com', 'barranquilla'),
('pedro gomez', 'pedro@mail.com', 'bogota');
 
insert into categorias (nombre) values
('electrodomesticos'),
('tecnologia'),
('cocina'),
('climatizacion');

insert into productos (nombre, categoria, precio, stock) values
('nevera samsung', 'electrodomesticos', 1800000, 10),
('lavadora lg', 'electrodomesticos', 1200000, 8),
('televisor sony 55', 'tecnologia', 2500000, 5),
('licuadora oster', 'cocina', 150000, 20),
('microondas haceb', 'cocina', 350000, 15),
('aire acondicionado', 'climatizacion', 3200000, 4);
 
insert into pedidos (cliente_id, producto_id, cantidad, estado, fecha_pedido) values
(1, 1, 1, 'entregado', '2025-01-10'),
(2, 3, 2, 'entregado', '2025-01-15'),
(3, 2, 1, 'pendiente', '2025-02-01'),
(4, 4, 3, 'cancelado', '2025-02-10'),
(5, 5, 1, 'entregado', '2025-03-05'),
(6, 6, 1, 'pendiente', '2025-03-20'),
(1, 4, 2, 'entregado', '2025-04-01'),
(2, 5, 1, 'cancelado', '2025-04-05');
 
insert into detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario) values
(1, 1, 1, 1800000),
(2, 3, 2, 2500000),
(3, 2, 1, 1200000),
(4, 4, 3, 150000),
(5, 5, 1, 350000),
(6, 6, 1, 3200000);

select * from clientes;
select * from categorias;
select * from productos;
select * from pedidos;
select * from detalle_pedido;

-- agrega total_valor y lo calcula con update + join
alter table pedidos add column total_valor decimal(12,2);

update pedidos p
join productos pr on p.producto_id = pr.producto_id
set p.total_valor = p.cantidad * pr.precio;

create index idx_estado on pedidos(estado);

-- Agregue la columna descuento DECIMAL(5,2) DEFAULT 0 a la tabla productos con una restricción CHECK

alter table productos add column  descuento decimal(5,2) default 0 
check (descuento >= 0 and descuento <= 50);

 -- vista: ventas por ciudad

create view vista_ventas_ciudad as
select
    c.ciudad,
    count(p.pedido_id) as total_pedidos_entregados,
    sum(p.cantidad * pr.precio) as suma_ingresos,
    avg(p.cantidad * pr.precio) as promedio_ingreso_por_pedido
from pedidos p
join clientes c on p.cliente_id = c.cliente_id
join productos pr on p.producto_id = pr.producto_id
where p.estado = 'entregado'
group by c.ciudad;

-- consulta sobre la vista: ciudades con ingresos > 500000
select * from vista_ventas_ciudad
where suma_ingresos > 500000
order by suma_ingresos desc;

-- subconsulta  productos con stock bajo el promedio de su categoria

select nombre, categoria, stock
from productos
where stock < (
    select avg(stock) from productos p2
    where p2.categoria = productos.categoria
);

-- subconsulta  clientes sin pedidos entregados

select nombre, ciudad from clientes c
where not exists (
    select 1 from pedidos p
    where p.cliente_id = c.cliente_id
    and p.estado = 'entregado'
);


-- multitabla  detalle de pedidos entregados con cliente y producto

select c.nombre as cliente, pr.nombre as producto,
       p.cantidad, p.total_valor, p.fecha_pedido
from pedidos p
join clientes c on p.cliente_id = c.cliente_id
join productos pr on p.producto_id = pr.producto_id
where p.estado = 'entregado'
order by p.total_valor desc;


-- multitabla 2: pedidos cuyo total supera el promedio general

select c.nombre, c.ciudad, pr.nombre as producto,
       p.cantidad, p.fecha_pedido, p.total_valor
from pedidos p
join clientes c on p.cliente_id = c.cliente_id
join productos pr on p.producto_id = pr.producto_id
where p.estado = 'entregado'
  and p.total_valor > (
      select avg(total_valor) from pedidos where estado = 'entregado'
  )
order by p.total_valor desc;


-- funcion ingreso total de un cliente


delimiter //
create function fn_ingreso_cliente(p_cliente_id int)
returns decimal(12,2)
deterministic
begin
    declare total decimal(12,2);
    select sum(p.cantidad * pr.precio) into total
    from pedidos p
    join productos pr on p.producto_id = pr.producto_id
    where p.cliente_id = p_cliente_id and p.estado = 'entregado';
    return ifnull(total, 0);
end//
delimiter ;

-- uso de la funcion
select nombre, ciudad, fn_ingreso_cliente(cliente_id) as ingreso_total
from clientes
order by ingreso_total desc;


-- funcion: verificar stock suficiente

delimiter //
create function fn_stock_suficiente(p_producto_id int, p_cantidad int)
returns int
deterministic
begin
    declare stock_actual int;
    select stock into stock_actual from productos where producto_id = p_producto_id;
    if stock_actual >= p_cantidad then return 1;
    else return 0;
    end if;
end//
delimiter ;

-- productos con menos de 5 unidades
select nombre, stock from productos
where fn_stock_suficiente(producto_id, 5) = 0;


-- procedimiento: actualizar estado de pedido y registrar en log


delimiter //
create procedure sp_actualizar_estado_pedido(p_pedido_id int, p_nuevo_estado varchar(20))
begin
    declare estado_actual varchar(20);
    declare cant int;
    declare prod_id int;

    select estado, cantidad, producto_id
    into estado_actual, cant, prod_id
    from pedidos where pedido_id = p_pedido_id;

    if estado_actual is null then
        select 'error: pedido no existe' as mensaje;
    else
        insert into log_cambios_estado (pedido_id, estado_anterior, estado_nuevo)
        values (p_pedido_id, estado_actual, p_nuevo_estado);

        update pedidos set estado = p_nuevo_estado
        where pedido_id = p_pedido_id;

        if p_nuevo_estado = 'cancelado' then
            update productos set stock = stock + cant
            where producto_id = prod_id;
        end if;
    end if;
end//
delimiter ;

-- procedimiento resumen de cliente


delimiter //
create procedure sp_resumen_cliente(p_cliente_id int)
begin
    select c.nombre, c.ciudad,
        sum(case when p.estado = 'entregado' then 1 else 0 end) as entregados,
        sum(case when p.estado = 'pendiente' then 1 else 0 end) as pendientes,
        sum(case when p.estado = 'cancelado' then 1 else 0 end) as cancelados,
        sum(case when p.estado = 'entregado' then p.total_valor else 0 end) as ingreso_total
    from clientes c
    left join pedidos p on c.cliente_id = p.cliente_id
    where c.cliente_id = p_cliente_id
    group by c.nombre, c.ciudad;
end//
delimiter ;


-- procedimiento  registrar pedido completo


delimiter //
create procedure sp_registrar_pedido(p_cliente_id int, p_producto_id int, p_cantidad int)
begin
    declare existe_cliente int;
    declare stock_disp int;

    select count(*) into existe_cliente from clientes where cliente_id = p_cliente_id;
    select stock into stock_disp from productos where producto_id = p_producto_id;

    if existe_cliente = 0 then
        select 'error: cliente no existe' as mensaje;
    elseif stock_disp < p_cantidad then
        select 'error: stock insuficiente' as mensaje;
    else
        insert into pedidos (cliente_id, producto_id, cantidad, estado)
        values (p_cliente_id, p_producto_id, p_cantidad, 'pendiente');

        update productos set stock = stock - p_cantidad
        where producto_id = p_producto_id;

        select c.nombre as cliente, pr.nombre as producto,
               p.cantidad, p.estado, p.fecha_pedido
        from pedidos p
        join clientes c on p.cliente_id = c.cliente_id
        join productos pr on p.producto_id = pr.producto_id
        where p.pedido_id = last_insert_id();
    end if;
end//
delimiter ;

 -- ejercicio 15 - funcion clasificar + vista catalogo


delimiter //
create function fn_clasificar_producto(p_producto_id int)
returns varchar(20)
deterministic
begin
    declare precio_prod decimal(12,2);
    select precio into precio_prod from productos where producto_id = p_producto_id;
    if precio_prod > 1000000 then return 'premium';
    elseif precio_prod >= 200000 then return 'estandar';
    else return 'basico';
    end if;
end//
delimiter ;

create view vista_catalogo_clasificado as
select nombre, categoria, precio,
       fn_clasificar_producto(producto_id) as clasificacion,
       stock
from productos;

-- consulta solo productos premium con stock > 5
select * from vista_catalogo_clasificado
where clasificacion = 'premium' and stock > 5;

