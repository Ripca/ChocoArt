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
-- Table structure for table `insumos`
--

DROP TABLE IF EXISTS `insumos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `insumos` (
  `idInsumo` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `costo_unitario` decimal(8,2) DEFAULT '0.00',
  `existencia` decimal(10,2) DEFAULT '0.00',
  `unidad_compra` varchar(20) NOT NULL DEFAULT 'unidad',
  `unidad_receta` varchar(20) NOT NULL DEFAULT 'unidad',
  `rendimiento_por_compra` decimal(10,2) NOT NULL DEFAULT '1.00',
  PRIMARY KEY (`idInsumo`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `insumos`
--

LOCK TABLES `insumos` WRITE;
/*!40000 ALTER TABLE `insumos` DISABLE KEYS */;
INSERT INTO `insumos` VALUES (1,'Pina',1.50,21.00,'porcion','porcion',1.00),(2,'Melon',1.50,4.00,'porcion','porcion',1.00),(3,'Fresa',1.50,26.00,'porcion','porcion',1.00),(4,'Chocolate 350g',0.34,85.00,'porcion','porcion',1.00),(5,'Bandeja de carton',0.40,85.00,'unidad','unidad',1.00),(6,'Mania molida',0.25,35.00,'porcion','porcion',1.00),(7,'Chococrispis',0.25,54.00,'porcion','porcion',1.00),(8,'Anicillo',0.25,54.00,'porcion','porcion',1.00),(9,'Sticker con logo',0.41,85.00,'unidad','unidad',1.00),(10,'Palillo',0.14,85.00,'unidad','unidad',1.00);
/*!40000 ALTER TABLE `insumos` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-14 21:58:29
