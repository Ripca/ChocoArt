USE `chocoartdb`;

-- Repara catalogo de productos y recetas para venta a Q8.00.
-- Chocolate y toppings quedan solo como insumos.
-- Ejecutar completo si en Ventas aparece "No tiene receta".

SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS;
SET @OLD_SQL_SAFE_UPDATES=@@SQL_SAFE_UPDATES;
SET FOREIGN_KEY_CHECKS=0;
SET SQL_SAFE_UPDATES=0;

DELETE FROM `ventas_detalle` WHERE `idVenta_detalle` >= 0;
DELETE FROM `ventas` WHERE `idVenta` >= 0;
DELETE FROM `recetas` WHERE `idReceta` >= 0;
DELETE FROM `productos` WHERE `idProducto` >= 0;

ALTER TABLE `ventas_detalle` AUTO_INCREMENT = 1;
ALTER TABLE `ventas` AUTO_INCREMENT = 1;
ALTER TABLE `recetas` AUTO_INCREMENT = 1;
ALTER TABLE `productos` AUTO_INCREMENT = 1;

SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET SQL_SAFE_UPDATES=@OLD_SQL_SAFE_UPDATES;

-- Asegura que existan los insumos requeridos por las recetas.
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
(10, 'Palillo', 'unidad', 0.14, 140.00)
ON DUPLICATE KEY UPDATE
  `nombre` = VALUES(`nombre`),
  `unidad_medida` = VALUES(`unidad_medida`),
  `costo_unitario` = VALUES(`costo_unitario`);

INSERT INTO `productos` (`idProducto`, `producto`, `descripcion`, `imagen`, `precio_costo`, `precio_venta`, `fecha_ingreso`) VALUES
(1, 'CorazonDeMelon Anicillo', 'Corazon de melon con chocolate y anicillo', 'assets/CorazonDeMelon.png', 2.87, 8.00, NOW()),
(2, 'CorazonDeMelon Mania', 'Corazon de melon con chocolate y mania molida', 'assets/CorazonDeMelon.png', 2.87, 8.00, NOW()),
(3, 'CorazonDeMelon Chococrispis', 'Corazon de melon con chocolate y chococrispis', 'assets/CorazonDeMelon.png', 2.87, 8.00, NOW()),
(4, 'EstrellaDePina Anicillo', 'Estrella de pina con chocolate y anicillo', 'assets/EstrellaDePina.JPG', 2.87, 8.00, NOW()),
(5, 'EstrellaDePina Mania', 'Estrella de pina con chocolate y mania molida', 'assets/EstrellaDePina.JPG', 2.87, 8.00, NOW()),
(6, 'EstrellaDePina Chococrispis', 'Estrella de pina con chocolate y chococrispis', 'assets/EstrellaDePina.JPG', 2.87, 8.00, NOW()),
(7, 'Fresa Anicillo', 'Fresa con chocolate y anicillo', 'assets/Fresa.png', 2.29, 8.00, NOW()),
(8, 'Fresa Mania', 'Fresa con chocolate y mania molida', 'assets/Fresa.png', 2.29, 8.00, NOW()),
(9, 'Fresa Chococrispis', 'Fresa con chocolate y chococrispis', 'assets/Fresa.png', 2.29, 8.00, NOW()),
(10, 'ChocoPinaPino Anicillo', 'Pina con chocolate y anicillo', 'assets/ChocoPinaPino.png', 2.87, 8.00, NOW()),
(11, 'ChocoPinaPino Mania', 'Pina con chocolate y mania molida', 'assets/ChocoPinaPino.png', 2.87, 8.00, NOW()),
(12, 'ChocoPinaPino Chococrispis', 'Pina con chocolate y chococrispis', 'assets/ChocoPinaPino.png', 2.87, 8.00, NOW());

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

-- Verificacion: todos los productos deben mostrar 6 insumos y precio_venta Q8.00.
SELECT p.idProducto, p.producto, COUNT(r.idReceta) AS insumos_receta, p.precio_venta
FROM productos p
LEFT JOIN recetas r ON r.idProducto = p.idProducto
GROUP BY p.idProducto, p.producto, p.precio_venta
ORDER BY p.idProducto;
