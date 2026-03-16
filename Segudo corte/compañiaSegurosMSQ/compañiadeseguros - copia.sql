## Query instruccion o peticion a la base de datos
/*
lenguaje de definicion de datos
create
alter
drop
truncate
*/
## creacion de la base de datos creare database nombre_base_datos
create database compañiaseguros;

## Hbilitar o encender BD use nombre_BD
use compañiaseguros;

/* Create tablas
create table nombre_tabla(
campo1 tipodato tamaño restriccion,
campo2 tipodato tamaño restriccion,
campo3 tipodato tamaño restriccion

);*/

create table compañia(
idCompañia varchar (50) primary key,
nit varchar (20) unique not null,
nombreCompañia varchar (50) not null,
fechaFundacion date null,
representantelegal varchar (50) not null);

create table seguros(
idSeguro varchar (50) primary key,
estado varchar (20) not null,
costo double not null,
fechaInicio date not null,
valorAsegurado double not null,
idCompañiaFK varchar(50) not null,
idAutomovilFK varchar (50) not null);

create table automovil(
idAutomovil varchar(50) primary key,
placa varchar(10) not null,
marca varchar (50) not null,
modelo varchar (50) not null,
tipo varchar (50) not null,
añoFabricacion date not null,
serialChasis varchar (50) not null,
pasajeros varchar (50)not null,
cilindraje varchar (20) not null);

create table detalleAccidente(
iddetalleAccidente varchar(50) primary key,
idAutomovilFK varchar (50) not null,
idAccidenteFK varchar (50) not null);

create table accidente(
ideAccidente varchar (50) primary key,
fatalidades varchar (50) not null,
heridos int not null,
lugar varchar(50) not null,
fechaAccidente date not null);
