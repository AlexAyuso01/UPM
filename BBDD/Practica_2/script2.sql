CREATE SCHEMA balonmano;
USE balonmano;

CREATE TABLE Club(
	telefono varchar(15) not null,
	localidad varchar(50) not null,
    cp varchar(5) not null,
    nombre varchar(50) unique not null,
    calle varchar(50) not null,
    numero int not null,
    piso int,
    escalera int,
    persona_contacto varchar(50),
	PRIMARY KEY(nombre)
 );
 
CREATE TABLE Categoria_edad(
	id int unique not null,
    nombre varchar(50) not null,
    descripcion varchar(100),
    edad_minima int not null,
    edad_máxima int not null,
	PRIMARY KEY(id)
 );
 
 CREATE TABLE Categoria_competicion(
	id int unique not null,
    nombre varchar(50) not null,
    descripcion varchar(100),
    numero_max_equipos int not null,
	PRIMARY KEY(id)
 );
 
 CREATE TABLE Equipo(
	licencia char(5) unique not null,
    nombre varchar(50) not null,
    telefono varchar(15) not null,
    
    id_categoria_edad int unique not null,
    id_categoria_competicion int unique not null,
    nombre_club varchar(50) unique not null,
	FOREIGN KEY(id_categoria_edad) REFERENCES Categoria_edad(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(id_categoria_competicion) REFERENCES Categoria_competicion(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(nombre_club) REFERENCES Club(nombre) ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY(licencia)
 );
 
CREATE TABLE Centro_deportivo(
	id int unique not null,
    nombre varchar(50) not null,
    calle varchar(100) not null,
    numero int not null,
    cp varchar(5) not null,
    localidad varchar(50) not null,
	PRIMARY KEY(id)
 );
 
 CREATE TABLE Arbitro(
	numero_colegiado int unique not null,
    nombre varchar(50) not null,
    apellido1 varchar(50) not null,
    apellido2 varchar(50) not null,
	PRIMARY KEY(numero_colegiado)
 );
 
CREATE TABLE Partido(
	id int unique not null,
    fecha date not null,
    
    licencia_equipo_local char(5) unique not null,
    licencia_equipo_visitante char(5) unique not null,
    numero_colegiado_arbitro int unique not null,
    id_centro_deportivo int unique not null,
    FOREIGN KEY (licencia_equipo_local) REFERENCES Equipo(licencia) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (licencia_equipo_visitante) REFERENCES Equipo(licencia) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (numero_colegiado_arbitro) REFERENCES Arbitro(numero_colegiado) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_centro_deportivo) REFERENCES Centro_deportivo(id) ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY(id)
 );
 
CREATE TABLE Jugador(
	nif int unique not null,
    nombre varchar(50) not null,
    apellido1 varchar(50) not null,
    apellido2 varchar(50) not null,
    fecha_nacimiento date not null,
	PRIMARY KEY(nif)
 );
 
CREATE TABLE Acta(
	id int unique not null,
    tantos_equipo_visitante int not null default 0,
    tantos_equipo_local int not null default 0,
    hora_inicio date not null,
    
    id_partido int unique not null,
    FOREIGN KEY(id_partido) REFERENCES Partido(id) ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY(id)
 );
 
 CREATE TABLE Tipo_evento(
	id int unique not null,
    nombre varchar(50) not null,
    descripcion varchar(100),
	PRIMARY KEY(id)
);
 
CREATE TABLE Evento(
	hora_de_partido date unique not null,
    
    id_Acta int unique not null,
    nif_jugador int unique not null,
    id_tipo_evento int unique not null,
    FOREIGN KEY(id_Acta) REFERENCES Acta(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(nif_jugador) REFERENCES Jugador(nif) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(id_tipo_evento) REFERENCES Tipo_evento(id) ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY(id_Acta)
 );

CREATE TABLE acta_jugador(
	id int unique not null,
	nif_jugador int unique not null,
	id_acta int unique not null,
    FOREIGN KEY (nif_jugador) REFERENCES Jugador(nif) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_acta) REFERENCES Acta(id) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY(id)
);

CREATE TABLE equipo_jugador(
fecha_inicio date unique not null,
fecha_fin date unique not null,
licencia_equipo char(5) unique not null,
nif_jugador int unique not null,
FOREIGN KEY (licencia_equipo) REFERENCES Equipo(licencia) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (nif_jugador) REFERENCES Jugador(nif) ON DELETE CASCADE ON UPDATE CASCADE,
PRIMARY KEY(fecha_inicio)
);
