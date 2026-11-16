-- =====================================================================
-- Script DDL: Partes 1 y 2 (tablas y restricciones)
-- =====================================================================

DROP DATABASE IF EXISTS MiAutoPuntoCom;

CREATE DATABASE MiAutoPuntoCom
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE MiAutoPuntoCom;

-- ---------------------------------------------------------------------
-- Tabla: Vehiculos
-- ---------------------------------------------------------------------
CREATE TABLE Vehiculos (
    id_vehiculo INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    marca       VARCHAR(50)   NOT NULL,
    modelo      VARCHAR(50)   NOT NULL,
    anio        SMALLINT UNSIGNED NOT NULL,
    color       VARCHAR(30)   NOT NULL,
    precio      DECIMAL(12,2) NOT NULL,
    vin         CHAR(17)      NOT NULL,
    tipo        VARCHAR(30)   NOT NULL,            -- sedán, SUV, camioneta, etc.
    estado      VARCHAR(10)   NOT NULL,            -- 'Nuevo' o 'Usado'
    CONSTRAINT pk_vehiculos        PRIMARY KEY (id_vehiculo),
    CONSTRAINT uq_vehiculos_vin    UNIQUE (vin),
    -- El límite superior (año actual) se valida con el trigger de más abajo
    CONSTRAINT ck_vehiculos_anio   CHECK (anio >= 1900),
    CONSTRAINT ck_vehiculos_precio CHECK (precio > 0),
    CONSTRAINT ck_vehiculos_estado CHECK (estado IN ('Nuevo', 'Usado'))
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- Tabla: Clientes
-- ---------------------------------------------------------------------
CREATE TABLE Clientes (
    id_cliente INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre     VARCHAR(50)  NOT NULL,
    apellido   VARCHAR(50)  NOT NULL,
    cedula     VARCHAR(20)  NOT NULL,
    telefono   VARCHAR(20)  NOT NULL,
    email      VARCHAR(100) NOT NULL,
    direccion  VARCHAR(255) NOT NULL,
    CONSTRAINT pk_clientes        PRIMARY KEY (id_cliente),
    CONSTRAINT uq_clientes_cedula UNIQUE (cedula),
    CONSTRAINT uq_clientes_email  UNIQUE (email)
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- Tabla: Vendedores
-- ---------------------------------------------------------------------
CREATE TABLE Vendedores (
    id_vendedor         INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    nombre              VARCHAR(50)   NOT NULL,
    apellido            VARCHAR(50)   NOT NULL,
    cedula              VARCHAR(20)   NOT NULL,
    fecha_nacimiento    DATE          NOT NULL,
    fecha_contratacion  DATE          NOT NULL,
    comision_porcentual DECIMAL(5,2)  NOT NULL,    -- ej: 3.50 = 3.5 %
    CONSTRAINT pk_vendedores        PRIMARY KEY (id_vendedor),
    CONSTRAINT uq_vendedores_cedula UNIQUE (cedula),
    CONSTRAINT ck_vendedores_comision CHECK (comision_porcentual BETWEEN 0 AND 20),
    CONSTRAINT ck_vendedores_contrato CHECK (fecha_contratacion > fecha_nacimiento)
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- Tabla: Ventas
-- ---------------------------------------------------------------------
CREATE TABLE Ventas (
    id_venta     INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    id_vehiculo  INT UNSIGNED  NOT NULL,
    id_cliente   INT UNSIGNED  NOT NULL,
    id_vendedor  INT UNSIGNED  NOT NULL,
    fecha_venta  DATE          NOT NULL,
    precio_final DECIMAL(12,2) NOT NULL,
    metodo_pago  VARCHAR(20)   NOT NULL,           -- 'Efectivo', 'Financiamiento', 'Tarjeta'
    CONSTRAINT pk_ventas          PRIMARY KEY (id_venta),
    CONSTRAINT uq_ventas_vehiculo UNIQUE (id_vehiculo),   -- un vehículo se vende una sola vez
    CONSTRAINT ck_ventas_precio   CHECK (precio_final > 0),
    CONSTRAINT ck_ventas_metodo   CHECK (metodo_pago IN ('Efectivo', 'Financiamiento', 'Tarjeta')),
    CONSTRAINT fk_ventas_vehiculo FOREIGN KEY (id_vehiculo)
        REFERENCES Vehiculos (id_vehiculo)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_ventas_cliente  FOREIGN KEY (id_cliente)
        REFERENCES Clientes (id_cliente)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_ventas_vendedor FOREIGN KEY (id_vendedor)
        REFERENCES Vendedores (id_vendedor)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;

DELIMITER $$

CREATE TRIGGER trg_vehiculos_anio_bi
BEFORE INSERT ON Vehiculos
FOR EACH ROW
BEGIN
    IF NEW.anio > YEAR(CURDATE()) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El año del vehículo no puede ser mayor al año actual';
    END IF;
END$$

CREATE TRIGGER trg_vehiculos_anio_bu
BEFORE UPDATE ON Vehiculos
FOR EACH ROW
BEGIN
    IF NEW.anio > YEAR(CURDATE()) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El año del vehículo no puede ser mayor al año actual';
    END IF;
END$$

-- Los vendedores deben tener al menos 21 años de edad
CREATE TRIGGER trg_vendedores_edad_bi
BEFORE INSERT ON Vendedores
FOR EACH ROW
BEGIN
    IF TIMESTAMPDIFF(YEAR, NEW.fecha_nacimiento, CURDATE()) < 21 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Los vendedores no pueden ser menores de 21 años';
    END IF;
END$$

CREATE TRIGGER trg_vendedores_edad_bu
BEFORE UPDATE ON Vendedores
FOR EACH ROW
BEGIN
    IF TIMESTAMPDIFF(YEAR, NEW.fecha_nacimiento, CURDATE()) < 21 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Los vendedores no pueden ser menores de 21 años';
    END IF;
END$$

DELIMITER ;

-- ---------------------------------------------------------------------
-- Verificación
-- ---------------------------------------------------------------------
SHOW TABLES;
SHOW TRIGGERS;
DESCRIBE Vehiculos;
DESCRIBE Clientes;
DESCRIBE Vendedores;
DESCRIBE Ventas;
