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
-- Table structure for table `productos`
--

DROP TABLE IF EXISTS `productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `productos` (
  `idProducto` int NOT NULL AUTO_INCREMENT,
  `producto` varchar(50) NOT NULL,
  `descripcion` varchar(100) DEFAULT NULL,
  `imagen` varchar(300) DEFAULT NULL,
  `precio_costo` decimal(8,2) DEFAULT NULL,
  `precio_venta` decimal(8,2) DEFAULT NULL,
  `fecha_ingreso` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idProducto`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productos`
--

LOCK TABLES `productos` WRITE;
/*!40000 ALTER TABLE `productos` DISABLE KEYS */;
INSERT INTO `productos` VALUES (1,'CorazonDeMelon Anicillo','Corazon de melon con chocolate y anicillo','assets/CorazonDeMelon.png',2.87,8.00,'2026-05-14 02:41:21'),(2,'CorazonDeMelon Mania','Corazon de melon con chocolate y mania molida','assets/CorazonDeMelon.png',2.87,8.00,'2026-05-14 02:41:21'),(3,'CorazonDeMelon Chococrispis','Corazon de melon con chocolate y chococrispis','assets/CorazonDeMelon.png',2.87,8.00,'2026-05-14 02:41:21'),(4,'EstrellaDePina Anicillo','Estrella de pina con chocolate y anicillo','assets/EstrellaDePina.JPG',2.87,8.00,'2026-05-14 02:41:21'),(5,'EstrellaDePina Mania','Estrella de pina con chocolate y mania molida','assets/EstrellaDePina.JPG',2.87,8.00,'2026-05-14 02:41:21'),(6,'EstrellaDePina Chococrispis','Estrella de pina con chocolate y chococrispis','assets/EstrellaDePina.JPG',2.87,8.00,'2026-05-14 02:41:21'),(7,'Fresa Anicillo','Fresa con chocolate y anicillo','assets/Fresa.png',2.29,8.00,'2026-05-14 02:41:21'),(8,'Fresa Mania','Fresa con chocolate y mania molida','assets/Fresa.png',2.29,8.00,'2026-05-14 02:41:21'),(9,'Fresa Chococrispis','Fresa con chocolate y chococrispis','assets/Fresa.png',2.29,8.00,'2026-05-14 02:41:21'),(10,'ChocoPinaPino Anicillo','Pina con chocolate y anicillo','assets/ChocoPinaPino.png',2.87,8.00,'2026-05-14 02:41:21'),(11,'ChocoPinaPino Mania','Pina con chocolate y mania molida','assets/ChocoPinaPino.png',2.87,8.00,'2026-05-14 02:41:21'),(12,'ChocoPinaPino Chococrispis','Pina con chocolate y chococrispis','assets/ChocoPinaPino.png',2.87,8.00,'2026-05-14 02:41:21'),(13,'PinaAngelito','Pina con angelitos',NULL,3.29,8.00,'2026-05-14 21:13:04');
/*!40000 ALTER TABLE `productos` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-14 21:58:30
