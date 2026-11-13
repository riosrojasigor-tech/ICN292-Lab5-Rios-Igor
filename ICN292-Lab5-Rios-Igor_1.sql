-- ICN-292 Sistemas de Información para la Gestión
-- Laboratorio 5 - SQL (2/2) - Base andesbike
-- Igor Rios

-- =========================================================
-- ENTREGABLE 1: CREACIÓN DE LA BASE
-- =========================================================

DROP DATABASE IF EXISTS andesbike;
CREATE DATABASE andesbike CHARACTER SET utf8mb4;
USE andesbike;

CREATE TABLE tiendas (
    id_tienda INT AUTO_INCREMENT PRIMARY KEY,
    nombre    VARCHAR(60) NOT NULL,
    comuna    VARCHAR(50) NOT NULL
);

CREATE TABLE vendedores (
    id_vendedor   INT AUTO_INCREMENT PRIMARY KEY,
    nombre        VARCHAR(80) NOT NULL,
    id_tienda     INT NULL,
    fecha_ingreso DATE NOT NULL,
    FOREIGN KEY (id_tienda) REFERENCES tiendas(id_tienda)
);

CREATE TABLE bicicletas (
    id_bicicleta INT AUTO_INCREMENT PRIMARY KEY,
    modelo       VARCHAR(60) NOT NULL,
    categoria    ENUM('Eléctrica', 'Infantil', 'Montaña', 'Ruta', 'Urbana') NOT NULL,
    precio       DECIMAL(10,2) NOT NULL,
    CHECK (precio > 0)
);

CREATE TABLE ventas (
    id_venta     INT AUTO_INCREMENT PRIMARY KEY,
    id_vendedor  INT NOT NULL,
    id_bicicleta INT NOT NULL,
    fecha        DATE NOT NULL,
    unidades     INT NOT NULL,
    CHECK (unidades > 0),
    FOREIGN KEY (id_vendedor) REFERENCES vendedores(id_vendedor),
    FOREIGN KEY (id_bicicleta) REFERENCES bicicletas(id_bicicleta)
);

-- =========================================================
-- CARGA OFICIAL
-- =========================================================

INSERT INTO tiendas (id_tienda, nombre, comuna) VALUES
(1, 'Andes Providencia', 'Providencia'),
(2, 'Andes Maipú', 'Maipú'),
(3, 'Andes Concepción', 'Concepción'),
(4, 'Andes La Serena', 'La Serena');

INSERT INTO vendedores (id_vendedor, nombre, id_tienda, fecha_ingreso) VALUES
(1, 'Camila Ortiz', 1, '2024-06-20'),
(2, 'Diego Fuentes', 1, '2024-01-15'),
(3, 'Javiera Soto', 2, '2023-07-24'),
(4, 'Matías Herrera', 2, '2024-01-15'),
(5, 'Paula Riquelme', 3, '2022-11-02'),
(6, 'Ignacio Vera', 3, '2024-08-19'),
(7, 'Fernanda Lillo', 1, '2025-02-03'),
(8, 'Rubén Castro', NULL, '2025-06-10');

INSERT INTO bicicletas (id_bicicleta, modelo, categoria, precio) VALUES
(1, 'Cordillera 29', 'Montaña', 549990.00),
(2, 'Ruta Austral', 'Ruta', 899990.00),
(3, 'Urbana Pro', 'Urbana', 329990.00),
(4, 'Pequeño Andes', 'Infantil', 149990.00),
(5, 'Volt City', 'Eléctrica', 1249990.00),
(6, 'Trail Master', 'Montaña', 749990.00),
(7, 'Urbana Lite', 'Urbana', 229990.00),
(8, 'Sprint R7', 'Ruta', 1099990.00);

INSERT INTO ventas (id_vendedor, id_bicicleta, fecha, unidades) VALUES
(1, 1, '2025-03-04', 2),
(1, 3, '2025-03-18', 1),
(1, 5, '2025-04-02', 1),
(2, 2, '2025-03-04', 1),
(2, 1, '2025-04-11', 3),
(2, 7, '2025-05-06', 2),
(3, 4, '2025-03-21', 4),
(3, 3, '2025-04-15', 2),
(3, 6, '2025-05-20', 1),
(4, 1, '2025-03-27', 1),
(4, 5, '2025-05-09', 2),
(5, 2, '2025-04-08', 1),
(5, 6, '2025-04-23', 2),
(5, 4, '2025-06-02', 5),
(6, 3, '2025-05-13', 3),
(6, 7, '2025-06-17', 1),
(6, 1, '2025-06-24', 2),
(1, 6, '2025-06-30', 1);

-- =========================================================
-- ENTREGABLE 2: CONSULTAS
-- =========================================================

-- Consulta 1: vendedores con su cantidad de ventas, incluidos los que no vendieron
SELECT v.nombre, COUNT(ve.id_venta) AS cantidad_ventas
FROM vendedores v
LEFT JOIN ventas ve ON v.id_vendedor = ve.id_vendedor
GROUP BY v.id_vendedor, v.nombre
ORDER BY cantidad_ventas DESC, v.nombre;

-- Consulta 2: ventas y unidades por tienda, incluidas las tiendas sin vendedores
SELECT t.nombre, COUNT(ve.id_venta) AS cantidad_ventas,
       IFNULL(SUM(ve.unidades), 0) AS unidades
FROM tiendas t
LEFT JOIN vendedores v ON t.id_tienda = v.id_tienda
LEFT JOIN ventas ve ON v.id_vendedor = ve.id_vendedor
GROUP BY t.id_tienda, t.nombre
ORDER BY unidades DESC;

-- Consulta 3: tiendas sin ningún vendedor asignado
SELECT t.nombre, t.comuna
FROM tiendas t
LEFT JOIN vendedores v ON t.id_tienda = v.id_tienda
WHERE v.id_vendedor IS NULL;

-- Consulta 4: modelos que no se vendieron en junio de 2025
SELECT b.modelo
FROM bicicletas b
LEFT JOIN ventas ve ON b.id_bicicleta = ve.id_bicicleta
    AND ve.fecha BETWEEN '2025-06-01' AND '2025-06-30'
WHERE ve.id_venta IS NULL;

-- Consulta 5: vendedores sin ventas, con el nombre de su tienda
SELECT v.nombre, t.nombre AS tienda
FROM vendedores v
LEFT JOIN tiendas t ON v.id_tienda = t.id_tienda
LEFT JOIN ventas ve ON v.id_vendedor = ve.id_vendedor
WHERE ve.id_venta IS NULL;

-- Consulta 6: pares de vendedores que trabajan en la misma tienda
SELECT a.nombre AS vendedor_1, a.fecha_ingreso AS ingreso_1,
       b.nombre AS vendedor_2, b.fecha_ingreso AS ingreso_2,
       t.nombre AS tienda
FROM vendedores a
JOIN vendedores b ON a.id_tienda = b.id_tienda
JOIN tiendas t ON a.id_tienda = t.id_tienda
WHERE a.fecha_ingreso < b.fecha_ingreso
   OR (a.fecha_ingreso = b.fecha_ingreso AND a.id_vendedor < b.id_vendedor);

-- Consulta 7: monto en Montaña y Ruta por tienda, sobre 2.000.000
SELECT t.nombre, SUM(ve.unidades * b.precio) AS monto
FROM tiendas t
JOIN vendedores v ON t.id_tienda = v.id_tienda
JOIN ventas ve ON v.id_vendedor = ve.id_vendedor
JOIN bicicletas b ON ve.id_bicicleta = b.id_bicicleta
WHERE b.categoria IN ('Montaña', 'Ruta')
GROUP BY t.id_tienda, t.nombre
HAVING SUM(ve.unidades * b.precio) > 2000000
ORDER BY monto DESC;

-- Consulta 8: bicicletas con precio sobre el promedio del catálogo
SELECT modelo, precio, (SELECT AVG(precio) FROM bicicletas) AS promedio_catalogo
FROM bicicletas
WHERE precio > (SELECT AVG(precio) FROM bicicletas)
ORDER BY precio DESC;

-- Consulta 9: vendedores con promedio de unidades sobre el de la cadena
SELECT v.nombre, AVG(ve.unidades) AS promedio_unidades
FROM vendedores v
JOIN ventas ve ON v.id_vendedor = ve.id_vendedor
GROUP BY v.id_vendedor, v.nombre
HAVING AVG(ve.unidades) > (SELECT AVG(unidades) FROM ventas)
ORDER BY promedio_unidades DESC, v.nombre;

-- Consulta 10: monto total vendido por vendedor, incluidos los que no vendieron
SELECT v.nombre, SUM(ve.unidades * b.precio) AS monto_total
FROM vendedores v
LEFT JOIN ventas ve ON v.id_vendedor = ve.id_vendedor
LEFT JOIN bicicletas b ON ve.id_bicicleta = b.id_bicicleta
GROUP BY v.id_vendedor, v.nombre
ORDER BY monto_total DESC;
