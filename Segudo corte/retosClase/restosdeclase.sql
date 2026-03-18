create database tiendaonline;
use tiendaonline;

create table producto(
idProducto int unique auto_increment,
nombreproducto varchar (20)not null,
precioProducto decimal not null,
stockProducto int default (0),
fechaHoraCreacionProducto datetime default current_timestamp 
);

create table clientes(
idCliente varchar (50) primary key,
nombreCliente varchar (50) not null,
emailCliente varchar (50) unique,
telefono int null
);

create table pedido(
idPedido varchar (50) primary key,
fechaPedido date not null,
totalPedido double not null,
idClienteFK varchar (50) not null
);

alter table pedido
add constraint FKClientespedido
foreign key(idClienteFK)
references clientes (idCliente);

alter table producto add categoriaProducto varchar (50)not null;
alter table producto modify fechaHoraCreacionProducto varchar (15);
alter table pedido change totalPedido montoTotal double not null;
alter table producto drop column fechaHoraCreacionProducto;

