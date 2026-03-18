/*
autor: andrea herrera
*/
## Query instruccion o peticion a la base de datos
/*
lenguje de definicion de datos
create
alter
drop
truncate
*/

##Creacion de la base de datos create database nombre_base_datos
create database companiaseguros;

##Habilitar o encende DB use nombre_DB
use companiaseguros;

/* Crear tablas 
create table nombre_tabla(
campo 1 tipodato tamaño restriccion,
campo 2 tipodato tamaño restriccion,
campo 3 tipodato tamaño restriccion
);*/

create table compania(
idCompania varchar (50) primary key,
nit varchar (20) unique not null,
nombreCompania varchar (50) not null,
fechaFundacion date null,
representanteLegal varchar (50) not null
);

create table seguros(
idSeguro varchar(50) primary key,
estado varchar (20) not null,
costo double not null,
fechaInicio date not null,
fechaExpiracion date not null,
valorAsegurado double not null,
idCompaniaFK varchar (50) not null,
idAutomovilFK varchar (50) not null
);

create table automovil(
idAutomovil varchar (50) primary key,
placa varchar(10) not null,
marca varchar (50) not null,
modelo varchar (50) not null,
tipo varchar (50) not null,
anoFabricacion int not null,
serialChasis varchar (50) not null,
pasajeros int not null,
cilindraje varchar (20) not null
);

create table detalleaccidente(
iddetalleAccidente varchar(50) primary key,
idAutomovilFK varchar (50) not null,
idAccidenteFK varchar (50) not null);

create table accidente(
idAccidente varchar (50) primary key,
fatalidades varchar (50) not null,
heridos int not null,
lugar varchar(50) not null,
fechaAccidente date not null
);

## Describir la estructura de las tablas describe Nombre_tabla

## relaciones
## opcion 2 crear un alter table cuando la tabla ya esta creada

alter table seguros
add constraint FKCompaniaSeguros
foreign key(idCompaniaFK)
references compania(idCompania);

alter table seguros
add constraint FKSegurosAutomovil
foreign key (idAutomovilFK)
references automovil (idAutomovil);

alter table detalleaccidente
add constraint FKAutomovilDetalleaccidente
foreign key (idAutomovilFK)
references automovil (idAutomovil);

alter table detalleaccidente 
add constraint FKDetalleaccidenteAccidente
foreign key (idAccidenteFK)
references accidente (idAccidente);

## 1.cambiar el nombre de una tabla ( rename table nombre_tabla to nuevo_nombre_tabla
rename table detalleaccidente to registroaccidente;
show columns from registroaccidente;

## 2. eliminar un campo de una tabla ( alter table nombre_tabla drop column nombre_columna que sera borrada )
alter table automovil drop column cilindraje;

## 3. Borrar un llave foranea (alter table nombre_table      drop foreign key nombre_llave_foranea)
alter table seguros
drop foreign key FKCompaniaSeguros;

## Para ver el nombre de la llave foranea ( show create table nombre_tabla)
