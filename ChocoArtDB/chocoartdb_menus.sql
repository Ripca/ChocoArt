CREATE DATABASE  IF NOT EXISTS `chocoartdb` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `chocoartdb`;
-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: localhost    Database: chocoartdb
-- ------------------------------------------------------
-- Server version	8.0.41

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `menus`
--

DROP TABLE IF EXISTS `menus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menus` (
  `id_menu` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(200) DEFAULT NULL COMMENT 'Descripción del menú',
  `icono` varchar(50) NOT NULL COMMENT 'Clase de Font Awesome (ej: fas fa-users)',
  `url` varchar(100) NOT NULL COMMENT 'Ruta relativa (ej: ClienteServlet)',
  `orden` int NOT NULL DEFAULT '0' COMMENT 'Orden de visualización',
  `estado` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1=Activo, 0=Inactivo',
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_menu`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menus`
--

LOCK TABLES `menus` WRITE;
/*!40000 ALTER TABLE `menus` DISABLE KEYS */;
INSERT INTO `menus` VALUES (1,'Usuarios','Control de usuarios, roles y accesos al sistema.','fas fa-users','Usuarios.aspx',1,1,'2026-04-17 22:46:15'),(2,'Productos','Gestión de productos, precios e imágenes.','fas fa-box','Productos.aspx',2,1,'2026-04-17 22:46:15'),(3,'Insumos','Control de insumos, costos y existencias.','fas fa-boxes','Insumos.aspx',3,1,'2026-04-17 22:46:15'),(4,'Recetas','Relación entre productos e insumos necesarios.','fas fa-book','Recetas.aspx',4,1,'2026-04-17 22:46:15'),(5,'Compras','Registro de compras de insumos y actualización de inventario.','fas fa-truck','Compras.aspx',5,1,'2026-04-17 22:46:15'),(6,'Ventas','Registro de ventas, clientes, productos y totales.','fas fa-shopping-cart','Ventas.aspx',6,1,'2026-04-17 22:46:15');
/*!40000 ALTER TABLE `menus` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-14 21:58:31
