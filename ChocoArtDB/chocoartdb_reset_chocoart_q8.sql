CREATE DATABASE IF NOT EXISTS `chocoartdb` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */;
USE `chocoartdb`;

-- Reset coherente para catalogo ChocoArt con precio global de venta Q8.00.
-- Ejecutar despues de crear/importar las tablas base del sistema.
-- Chocolate y toppings son insumos. Los productos son combinaciones vendibles.

SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS;
SET @OLD_SQL_SAFE_UPDATES=@@SQL_SAFE_UPDATES;
SET FOREIGN_KEY_CHECKS=0;
SET SQL_SAFE_UPDATES=0;

DELETE FROM `ventas_detalle` WHERE `idVenta_detalle` >= 0;
DELETE FROM `ventas` WHERE `idVenta` >= 0;
DELETE FROM `compras_detalle` WHERE `idCompra_detalle` >= 0;
DELETE FROM `compras` WHERE `idCompra` >= 0;
DELETE FROM `recetas` WHERE `idReceta` >= 0;
DELETE FROM `productos` WHERE `idProducto` >= 0;
DELETE FROM `insumos` WHERE `idInsumo` >= 0;

ALTER TABLE `ventas_detalle` AUTO_INCREMENT = 1;
ALTER TABLE `ventas` AUTO_INCREMENT = 1;
ALTER TABLE `compras_detalle` AUTO_INCREMENT = 1;
ALTER TABLE `compras` AUTO_INCREMENT = 1;
ALTER TABLE `recetas` AUTO_INCREMENT = 1;
ALTER TABLE `productos` AUTO_INCREMENT = 1;
ALTER TABLE `insumos` AUTO_INCREMENT = 1;

SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET SQL_SAFE_UPDATES=@OLD_SQL_SAFE_UPDATES;

-- Insumos. Chocolate, Mania, Chococrispis y Anicillo se usan en recetas; no son productos.
INSERT INTO `insumos` (`idInsumo`, `nombre`, `unidad_medida`, `costo_unitario`, `existencia`) VALUES
(1, 'Pina', 'porcion', 1.33, 43.00),
(2, 'Melon', 'porcion', 1.33, 28.00),
(3, 'Fresa', 'porcion', 0.75, 37.00),
(4, 'Chocolate 350g', 'porcion', 0.34, 140.00),
(5, 'Bandeja de carton', 'unidad', 0.40, 140.00),
(6, 'Mania molida', 'porcion', 0.25, 57.00),
(7, 'Chococrispis', 'porcion', 0.25, 59.00),
(8, 'Anicillo', 'porcion', 0.25, 54.00),
(9, 'Sticker con logo', 'unidad', 0.41, 140.00),
(10, 'Palillo', 'unidad', 0.14, 140.00);

-- Productos finales vendibles. Cada producto base tiene una version por topping.
-- Todos los productos se venden a Q8.00.
INSERT INTO `productos` (`idProducto`, `producto`, `descripcion`, `imagen`, `precio_costo`, `precio_venta`, `fecha_ingreso`) VALUES
(1, 'CorazonDeMelon Anicillo', 'Corazon de melon con chocolate y anicillo', 'assets/CorazonDeMelon.png', 2.87, 8.00, '2026-05-13 00:00:00'),
(2, 'CorazonDeMelon Mania', 'Corazon de melon con chocolate y mania molida', 'assets/CorazonDeMelon.png', 2.87, 8.00, '2026-05-13 00:00:00'),
(3, 'CorazonDeMelon Chococrispis', 'Corazon de melon con chocolate y chococrispis', 'assets/CorazonDeMelon.png', 2.87, 8.00, '2026-05-13 00:00:00'),
(4, 'EstrellaDePina Anicillo', 'Estrella de pina con chocolate y anicillo', 'assets/EstrellaDePina.JPG', 2.87, 8.00, '2026-05-13 00:00:00'),
(5, 'EstrellaDePina Mania', 'Estrella de pina con chocolate y mania molida', 'assets/EstrellaDePina.JPG', 2.87, 8.00, '2026-05-13 00:00:00'),
(6, 'EstrellaDePina Chococrispis', 'Estrella de pina con chocolate y chococrispis', 'assets/EstrellaDePina.JPG', 2.87, 8.00, '2026-05-13 00:00:00'),
(7, 'Fresa Anicillo', 'Fresa con chocolate y anicillo', 'assets/Fresa.png', 2.29, 8.00, '2026-05-13 00:00:00'),
(8, 'Fresa Mania', 'Fresa con chocolate y mania molida', 'assets/Fresa.png', 2.29, 8.00, '2026-05-13 00:00:00'),
(9, 'Fresa Chococrispis', 'Fresa con chocolate y chococrispis', 'assets/Fresa.png', 2.29, 8.00, '2026-05-13 00:00:00'),
(10, 'ChocoPinaPino Anicillo', 'Pina con chocolate y anicillo', 'assets/ChocoPinaPino.png', 2.87, 8.00, '2026-05-13 00:00:00'),
(11, 'ChocoPinaPino Mania', 'Pina con chocolate y mania molida', 'assets/ChocoPinaPino.png', 2.87, 8.00, '2026-05-13 00:00:00'),
(12, 'ChocoPinaPino Chococrispis', 'Pina con chocolate y chococrispis', 'assets/ChocoPinaPino.png', 2.87, 8.00, '2026-05-13 00:00:00');

-- Recetas por unidad vendida.
-- Base comun: fruta + chocolate + bandeja + topping + sticker + palillo.
INSERT INTO `recetas` (`idReceta`, `idProducto`, `idInsumo`, `cantidad`) VALUES
(1, 1, 2, 1.00),(2, 1, 4, 1.00),(3, 1, 5, 1.00),(4, 1, 8, 1.00),(5, 1, 9, 1.00),(6, 1, 10, 1.00),
(7, 2, 2, 1.00),(8, 2, 4, 1.00),(9, 2, 5, 1.00),(10, 2, 6, 1.00),(11, 2, 9, 1.00),(12, 2, 10, 1.00),
(13, 3, 2, 1.00),(14, 3, 4, 1.00),(15, 3, 5, 1.00),(16, 3, 7, 1.00),(17, 3, 9, 1.00),(18, 3, 10, 1.00),
(19, 4, 1, 1.00),(20, 4, 4, 1.00),(21, 4, 5, 1.00),(22, 4, 8, 1.00),(23, 4, 9, 1.00),(24, 4, 10, 1.00),
(25, 5, 1, 1.00),(26, 5, 4, 1.00),(27, 5, 5, 1.00),(28, 5, 6, 1.00),(29, 5, 9, 1.00),(30, 5, 10, 1.00),
(31, 6, 1, 1.00),(32, 6, 4, 1.00),(33, 6, 5, 1.00),(34, 6, 7, 1.00),(35, 6, 9, 1.00),(36, 6, 10, 1.00),
(37, 7, 3, 1.00),(38, 7, 4, 1.00),(39, 7, 5, 1.00),(40, 7, 8, 1.00),(41, 7, 9, 1.00),(42, 7, 10, 1.00),
(43, 8, 3, 1.00),(44, 8, 4, 1.00),(45, 8, 5, 1.00),(46, 8, 6, 1.00),(47, 8, 9, 1.00),(48, 8, 10, 1.00),
(49, 9, 3, 1.00),(50, 9, 4, 1.00),(51, 9, 5, 1.00),(52, 9, 7, 1.00),(53, 9, 9, 1.00),(54, 9, 10, 1.00),
(55, 10, 1, 1.00),(56, 10, 4, 1.00),(57, 10, 5, 1.00),(58, 10, 8, 1.00),(59, 10, 9, 1.00),(60, 10, 10, 1.00),
(61, 11, 1, 1.00),(62, 11, 4, 1.00),(63, 11, 5, 1.00),(64, 11, 6, 1.00),(65, 11, 9, 1.00),(66, 11, 10, 1.00),
(67, 12, 1, 1.00),(68, 12, 4, 1.00),(69, 12, 5, 1.00),(70, 12, 7, 1.00),(71, 12, 9, 1.00),(72, 12, 10, 1.00);

-- Compra inicial de materia prima. Las existencias ya reflejan esta compra menos las ventas de ejemplo.
INSERT INTO `compras` (`idCompra`, `no_orden_compra`, `fecha_orden`, `fechaingreso`) VALUES
(1, 801, '2026-05-13', '2026-05-13 08:00:00');

INSERT INTO `compras_detalle` (`idCompra_detalle`, `idCompra`, `idInsumo`, `cantidad`, `precio_costo_unitario`) VALUES
(1, 1, 1, 50, 1.33),
(2, 1, 2, 30, 1.33),
(3, 1, 3, 40, 0.75),
(4, 1, 4, 150, 0.34),
(5, 1, 5, 150, 0.40),
(6, 1, 6, 60, 0.25),
(7, 1, 7, 60, 0.25),
(8, 1, 8, 60, 0.25),
(9, 1, 9, 150, 0.41),
(10, 1, 10, 150, 0.14);

-- Ventas de ejemplo, todas con precio unitario Q8.00.
INSERT INTO `ventas` (`idVenta`, `fechaFactura`, `idCliente`, `fechaingreso`) VALUES
(1, '2026-05-13', 1, '2026-05-13 10:15:00'),
(2, '2026-05-13', 2, '2026-05-13 14:30:00'),
(3, '2026-05-13', 4, '2026-05-13 17:45:00');

INSERT INTO `ventas_detalle` (`idVenta_detalle`, `idVenta`, `idProducto`, `cantidad`, `precio_unitario`) VALUES
(1, 1, 1, 1, 8.00),
(2, 1, 5, 2, 8.00),
(3, 1, 7, 3, 8.00),
(4, 2, 12, 1, 8.00),
(5, 2, 2, 1, 8.00),
(6, 3, 10, 2, 8.00);

-- Validacion rapida de costos por receta:
-- SELECT p.producto, p.precio_costo, ROUND(SUM(r.cantidad * i.costo_unitario), 2) AS costo_receta, p.precio_venta
-- FROM productos p
-- JOIN recetas r ON r.idProducto = p.idProducto
-- JOIN insumos i ON i.idInsumo = r.idInsumo
-- GROUP BY p.idProducto, p.producto, p.precio_costo, p.precio_venta
-- ORDER BY p.idProducto;
