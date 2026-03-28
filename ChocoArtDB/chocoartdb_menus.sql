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
  `icono` varchar(50) NOT NULL COMMENT 'Clase de Font Awesome (ej: fas fa-users)',
  `url` varchar(100) NOT NULL COMMENT 'Ruta relativa (ej: ClienteServlet)',
  `id_padre` int DEFAULT NULL COMMENT 'ID del menú padre para submenús',
  `orden` int NOT NULL DEFAULT '0' COMMENT 'Orden de visualización',
  `estado` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1=Activo, 0=Inactivo',
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_menu`),
  KEY `id_padre` (`id_padre`),
  CONSTRAINT `menus_ibfk_1` FOREIGN KEY (`id_padre`) REFERENCES `menus` (`id_menu`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menus`
--

LOCK TABLES `menus` WRITE;
/*!40000 ALTER TABLE `menus` DISABLE KEYS */;
INSERT INTO `menus` VALUES (1,'Dashboard','fas fa-tachometer-alt','DashboardServlet',NULL,1,1,'2025-10-08 21:54:10'),(2,'Clientes','fas fa-users','ClienteServlet',8,1,1,'2025-10-08 21:54:10'),(3,'Empleados','fas fa-user-tie','EmpleadoServlet',8,2,1,'2025-10-08 21:54:10'),(4,'Puestos','fas fa-briefcase','PuestoServlet',3,1,1,'2025-10-08 21:54:10'),(5,'Productos','fas fa-box','ProductoServlet',NULL,2,1,'2025-10-08 21:54:10'),(6,'Marcas','fas fa-tags','MarcaServlet',5,1,1,'2025-10-08 21:54:10'),(7,'Proveedores','fas fa-truck','ProveedorServlet',9,1,1,'2025-10-08 21:54:10'),(8,'Ventas','fas fa-shopping-cart','VentaServlet',NULL,3,1,'2025-10-08 21:54:10'),(9,'Compras','fas fa-shopping-bag','CompraServlet',NULL,4,1,'2025-10-08 21:54:10'),(14,'Reportes','fas fa-file','reportes',NULL,5,1,'2025-10-23 22:30:57'),(15,'Dashboard','fas fa-home','DashboardServlet',NULL,1,1,'2026-03-20 08:00:00'),(16,'Seguridad','fas fa-shield-alt','#',NULL,2,1,'2026-03-20 08:05:00'),(17,'Ventas','fas fa-cash-register','#',NULL,3,1,'2026-03-20 08:10:00'),(18,'Compras','fas fa-shopping-cart','#',NULL,4,1,'2026-03-20 08:15:00'),(19,'Inventario','fas fa-boxes','#',NULL,5,1,'2026-03-20 08:20:00'),(20,'Reportes','fas fa-chart-bar','#',NULL,6,1,'2026-03-20 08:25:00'),(21,'Usuarios','fas fa-users','UsuarioServlet',2,1,1,'2026-03-20 08:30:00'),(22,'Roles','fas fa-user-tag','RolServlet',2,2,1,'2026-03-20 08:35:00'),(23,'Clientes','fas fa-address-book','ClienteServlet',3,1,1,'2026-03-20 08:40:00'),(24,'Facturación','fas fa-file-invoice-dollar','VentaServlet',3,2,1,'2026-03-20 08:45:00'),(25,'Productos','fas fa-apple-alt','ProductoServlet',5,1,1,'2026-03-20 08:50:00'),(26,'Compras Detalle','fas fa-list','CompraDetalleServlet',4,1,1,'2026-03-20 08:55:00');
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

-- Dump completed on 2026-03-27 22:34:54
