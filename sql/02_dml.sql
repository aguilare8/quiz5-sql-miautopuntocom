-- =====================================================================
-- Script DML: Parte 3 (datos de prueba)
-- Antes se tuvo que ejecutar 01_ddl.sql
-- =====================================================================

USE MiAutoPuntoCom;

-- ---------------------------------------------------------------------
-- 10 vehículos (marcas, modelos, tipos, estados)
-- ---------------------------------------------------------------------
INSERT INTO Vehiculos (marca, modelo, anio, color, precio, vin, tipo, estado) VALUES
('Toyota',    'Corolla', 2023, 'Blanco',   24500.00, '1HGCM82633A004352', 'Sedán',     'Nuevo'),
('Honda',     'CR-V',    2022, 'Gris',     31800.00, '2T1BURHE0JC034871', 'SUV',       'Usado'),
('Ford',      'Ranger',  2024, 'Azul',     42500.00, '1FTFW1ET5DFC10312', 'Camioneta', 'Nuevo'),
('Nissan',    'Sentra',  2019, 'Negro',    12900.00, '3N1AB7AP5KY250918', 'Sedán',     'Usado'),
('Hyundai',   'Tucson',  2024, 'Rojo',     35900.00, 'KM8J33A47NU123456', 'SUV',       'Nuevo'),
('Toyota',    'Hilux',   2021, 'Plateado', 33500.00, 'MR0FB8CD500567890', 'Camioneta', 'Usado'),
('Kia',       'Rio',     2020, 'Blanco',   11800.00, '3KPA24AD5LE789012', 'Hatchback', 'Usado'),
('Mazda',     'CX-5',    2025, 'Gris',     38900.00, 'JM3KFBCM8P0345678', 'SUV',       'Nuevo'),
('Chevrolet', 'Spark',   2018, 'Amarillo',  7900.00, 'KL8CD6SA9JC456789', 'Hatchback', 'Usado'),
('Suzuki',    'Vitara',  2023, 'Verde',    26700.00, 'JS3TD62S5P4567890', 'SUV',       'Nuevo');

-- ---------------------------------------------------------------------
-- 6 clientes
-- ---------------------------------------------------------------------
INSERT INTO Clientes (nombre, apellido, cedula, telefono, email, direccion) VALUES
('María',  'Jiménez', '1-1456-0789', '8812-3456', 'maria.jimenez@example.com', 'San José, Escazú, 200 m sur del parque'),
('Carlos', 'Solano',  '3-0412-0657', '8723-9981', 'carlos.solano@example.com', 'Cartago, Paraíso, Barrio Los Ángeles'),
('Laura',  'Vargas',  '2-0678-0123', '8650-1122', 'laura.vargas@example.com',  'Alajuela, Grecia, Calle Central'),
('José',   'Quesada', '1-0987-0456', '8399-4410', 'jose.quesada@example.com',  'Heredia, Barva, 100 m norte de la iglesia'),
('Ana',    'Campos',  '4-0211-0398', '8577-2036', 'ana.campos@example.com',    'San José, Curridabat, Residencial Las Flores'),
('Diego',  'Araya',   '6-0345-0782', '8901-7765', 'diego.araya@example.com',   'Puntarenas, Esparza, Barrio San Juan');

-- ---------------------------------------------------------------------
-- 4 vendedores (mayores de 21 años)
-- ---------------------------------------------------------------------
INSERT INTO Vendedores (nombre, apellido, cedula, fecha_nacimiento, fecha_contratacion, comision_porcentual) VALUES
('Andrea', 'Chaves',   '1-1100-0234', '1990-03-14', '2019-02-01', 3.50),
('Luis',   'Fernández','2-0599-0872', '1985-07-22', '2017-06-15', 4.00),
('Sofía',  'Brenes',   '3-0480-0511', '1995-11-05', '2022-01-10', 3.00),
('Mateo',  'Zúñiga',   '1-1301-0645', '2000-09-30', '2024-03-18', 2.50);

-- ---------------------------------------------------------------------
-- 8 ventas
-- - Andrea: 3 ventas, Luis: 2, Sofía: 2, Mateo: 1
-- - Los vehículos 9 y 10 quedan sin vender (disponibles)
-- - Las fechas son relativas a hoy, así la consulta del "último mes"
--   siempre devuelve resultados al ejecutarla
-- ---------------------------------------------------------------------
INSERT INTO Ventas (id_vehiculo, id_cliente, id_vendedor, fecha_venta, precio_final, metodo_pago) VALUES
(1, 1, 1, DATE_SUB(CURDATE(), INTERVAL 8   DAY), 24100.00, 'Tarjeta'),
(2, 2, 2, DATE_SUB(CURDATE(), INTERVAL 20  DAY), 31000.00, 'Financiamiento'),
(3, 3, 1, DATE_SUB(CURDATE(), INTERVAL 45  DAY), 41800.00, 'Financiamiento'),
(4, 4, 3, DATE_SUB(CURDATE(), INTERVAL 60  DAY), 12500.00, 'Efectivo'),
(5, 5, 2, DATE_SUB(CURDATE(), INTERVAL 12  DAY), 35500.00, 'Tarjeta'),
(6, 6, 4, DATE_SUB(CURDATE(), INTERVAL 75  DAY), 33000.00, 'Efectivo'),
(7, 1, 1, DATE_SUB(CURDATE(), INTERVAL 100 DAY), 11500.00, 'Efectivo'),
(8, 3, 3, DATE_SUB(CURDATE(), INTERVAL 3   DAY), 38500.00, 'Financiamiento');

-- ---------------------------------------------------------------------
-- Verificación
-- ---------------------------------------------------------------------
SELECT 'Vehiculos'  AS tabla, COUNT(*) AS filas FROM Vehiculos
UNION ALL SELECT 'Clientes',   COUNT(*) FROM Clientes
UNION ALL SELECT 'Vendedores', COUNT(*) FROM Vendedores
UNION ALL SELECT 'Ventas',     COUNT(*) FROM Ventas;
