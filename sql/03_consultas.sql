-- =====================================================================
-- Quiz #5 - SQL | CE 2103 Algoritmos y Estructuras de Datos II
-- Script de Consultas: Parte 4 de MiAutoPuntoCom
-- Requiere haber ejecutado antes 01_ddl.sql y 02_dml.sql
-- =====================================================================

USE MiAutoPuntoCom;

-- ---------------------------------------------------------------------
-- 1. Listar todos los vehículos disponibles (no vendidos)
--    ordenados por precio descendente
-- ---------------------------------------------------------------------
SELECT v.id_vehiculo, v.marca, v.modelo, v.anio, v.color, v.tipo, v.estado, v.precio
FROM Vehiculos v
LEFT JOIN Ventas ve ON ve.id_vehiculo = v.id_vehiculo
WHERE ve.id_venta IS NULL
ORDER BY v.precio DESC;

-- ---------------------------------------------------------------------
-- 2. Total de ventas realizadas por cada vendedor
--    (nombre del vendedor y cantidad de ventas)
-- ---------------------------------------------------------------------
SELECT CONCAT(vd.nombre, ' ', vd.apellido) AS vendedor,
       COUNT(ve.id_venta)                  AS cantidad_ventas
FROM Vendedores vd
LEFT JOIN Ventas ve ON ve.id_vendedor = vd.id_vendedor
GROUP BY vd.id_vendedor, vd.nombre, vd.apellido
ORDER BY cantidad_ventas DESC;

-- ---------------------------------------------------------------------
-- 3. Ingreso total generado por cada vendedor
-- ---------------------------------------------------------------------
SELECT CONCAT(vd.nombre, ' ', vd.apellido)    AS vendedor,
       COALESCE(SUM(ve.precio_final), 0)      AS ingreso_total
FROM Vendedores vd
LEFT JOIN Ventas ve ON ve.id_vendedor = vd.id_vendedor
GROUP BY vd.id_vendedor, vd.nombre, vd.apellido
ORDER BY ingreso_total DESC;

-- ---------------------------------------------------------------------
-- 4. Cliente que ha realizado la compra más costosa
--    (se usa MAX en una subconsulta para manejar posibles empates)
-- ---------------------------------------------------------------------
SELECT CONCAT(c.nombre, ' ', c.apellido) AS cliente,
       c.cedula,
       v.marca, v.modelo,
       ve.precio_final,
       ve.fecha_venta
FROM Ventas ve
JOIN Clientes c  ON c.id_cliente  = ve.id_cliente
JOIN Vehiculos v ON v.id_vehiculo = ve.id_vehiculo
WHERE ve.precio_final = (SELECT MAX(precio_final) FROM Ventas);

-- ---------------------------------------------------------------------
-- 5. Vehículos vendidos en el último mes con información
--    del cliente comprador
-- ---------------------------------------------------------------------
SELECT ve.fecha_venta,
       v.marca, v.modelo, v.anio, v.vin,
       ve.precio_final,
       CONCAT(c.nombre, ' ', c.apellido) AS cliente,
       c.cedula, c.telefono, c.email
FROM Ventas ve
JOIN Vehiculos v ON v.id_vehiculo = ve.id_vehiculo
JOIN Clientes c  ON c.id_cliente  = ve.id_cliente
WHERE ve.fecha_venta BETWEEN DATE_SUB(CURDATE(), INTERVAL 1 MONTH) AND CURDATE()
ORDER BY ve.fecha_venta DESC;

-- ---------------------------------------------------------------------
-- 6. Comisión ganada por cada vendedor basada en sus ventas
--    comisión = suma(precio_final) * comision_porcentual / 100
-- ---------------------------------------------------------------------
SELECT CONCAT(vd.nombre, ' ', vd.apellido)                               AS vendedor,
       vd.comision_porcentual                                            AS porcentaje,
       COALESCE(SUM(ve.precio_final), 0)                                 AS total_vendido,
       ROUND(COALESCE(SUM(ve.precio_final), 0) * vd.comision_porcentual / 100, 2) AS comision_ganada
FROM Vendedores vd
LEFT JOIN Ventas ve ON ve.id_vendedor = vd.id_vendedor
GROUP BY vd.id_vendedor, vd.nombre, vd.apellido, vd.comision_porcentual
ORDER BY comision_ganada DESC;

-- ---------------------------------------------------------------------
-- 7. Promedio de precios de los vehículos vendidos, agrupados por tipo
--    (se muestran el precio de lista y el precio final de venta)
-- ---------------------------------------------------------------------
SELECT v.tipo,
       COUNT(*)                      AS vehiculos_vendidos,
       ROUND(AVG(v.precio), 2)       AS promedio_precio_lista,
       ROUND(AVG(ve.precio_final), 2) AS promedio_precio_final
FROM Ventas ve
JOIN Vehiculos v ON v.id_vehiculo = ve.id_vehiculo
GROUP BY v.tipo
ORDER BY promedio_precio_final DESC;

-- ---------------------------------------------------------------------
-- 8. Marca de vehículo que se ha vendido más veces
--    (devuelve todas las marcas en caso de empate)
-- ---------------------------------------------------------------------
SELECT v.marca, COUNT(*) AS veces_vendida
FROM Ventas ve
JOIN Vehiculos v ON v.id_vehiculo = ve.id_vehiculo
GROUP BY v.marca
HAVING COUNT(*) = (
    SELECT MAX(conteo)
    FROM (
        SELECT COUNT(*) AS conteo
        FROM Ventas ve2
        JOIN Vehiculos v2 ON v2.id_vehiculo = ve2.id_vehiculo
        GROUP BY v2.marca
    ) AS t
);
