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
-- Table structure for table `compras_detalle`
--

DROP TABLE IF EXISTS `compras_detalle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `compras_detalle` (
  `idCompra_detalle` bigint NOT NULL AUTO_INCREMENT,
  `idCompra` int DEFAULT NULL,
  `idProducto` int DEFAULT NULL,
  `cantidad` int DEFAULT NULL,
  `precio_costo_unitario` decimal(8,2) DEFAULT NULL,
  PRIMARY KEY (`idCompra_detalle`),
  KEY `idCompra` (`idCompra`),
  KEY `idProducto` (`idProducto`),
  CONSTRAINT `compras_detalle_ibfk_1` FOREIGN KEY (`idCompra`) REFERENCES `compras` (`idCompra`),
  CONSTRAINT `compras_detalle_ibfk_2` FOREIGN KEY (`idProducto`) REFERENCES `productos` (`idProducto`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `compras_detalle`
--

LOCK TABLES `compras_detalle` WRITE;
/*!40000 ALTER TABLE `compras_detalle` DISABLE KEYS */;
INSERT INTO `compras_detalle` VALUES (1,1,1,1,500.00),(2,2,2,15,800.00),(3,3,2,2,800.00),(4,3,2,4,800.00),(6,5,20,2,2.00),(7,6,26,3,50.00),(8,7,23,6,400.00);
/*!40000 ALTER TABLE `compras_detalle` ENABLE KEYS */;
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
