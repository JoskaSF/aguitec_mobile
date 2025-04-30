CREATE DATABASE Aguitec;
USE Aguitec;

CREATE TABLE Usuarios(
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    password VARCHAR(255) NOT NULL,
    nombre_usuario VARCHAR(25) NOT NULL
);

CREATE TABLE Edificios (
    id_edificio INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    cantidad INT NOT NULL
);

CREATE TABLE TiposReporte(
    id_tipo INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    prioridad ENUM('Baja', 'Media', 'Alta', 'Crítica') NOT NULL DEFAULT 'Media'
);

CREATE TABLE Producciones (
    id_produccion INT PRIMARY KEY AUTO_INCREMENT,
    fecha DATETIME NOT NULL
);

CREATE TABLE Dispensador (
    id_dispensador INT PRIMARY KEY AUTO_INCREMENT,
    id_edificio INT NOT NULL,
    nombre VARCHAR(25) NOT NULL,
    url VARCHAR(255) NOT NULL,
    FOREIGN KEY (id_edificio) REFERENCES Edificios(id_edificio)
);

CREATE TABLE Reportes (
    id_reporte INT PRIMARY KEY AUTO_INCREMENT,
    id_dispensador INT NOT NULL,
    id_tipo INT NOT NULL,
    estado ENUM('Pendiente', 'Completado') NOT NULL,
    fecha DATETIME NOT NULL,
    FOREIGN KEY (id_dispensador) REFERENCES Dispensador(id_dispensador),
    FOREIGN KEY (id_tipo) REFERENCES TiposReporte(id_tipo)
);

CREATE TABLE Garrafones (
    id_garrafon INT PRIMARY KEY AUTO_INCREMENT,
    id_edificio INT NOT NULL,
    id_produccion INT NOT NULL,
    FOREIGN KEY (id_edificio) REFERENCES Edificios(id_edificio),
    FOREIGN KEY (id_produccion) REFERENCES Producciones(id_produccion)
);

CREATE TABLE DetallesPlaneacion (
    id_detalles INT PRIMARY KEY AUTO_INCREMENT,
    id_edificio INT NOT NULL,
    cantidad INT NOT NULL,
    FOREIGN KEY (id_edificio) REFERENCES Edificios(id_edificio)
);

CREATE TABLE Planeaciones (
    id_planeacion INT PRIMARY KEY AUTO_INCREMENT,
    id_detalles INT NOT NULL,
    fecha DATETIME NOT NULL,
    FOREIGN KEY (id_detalles) REFERENCES DetallesPlaneacion(id_detalles)
);