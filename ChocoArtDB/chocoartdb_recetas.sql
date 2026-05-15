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
-- Table structure for table `recetas`
--

DROP TABLE IF EXISTS `recetas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recetas` (
  `idReceta` int NOT NULL AUTO_INCREMENT,
  `idProducto` int NOT NULL,
  `idInsumo` int NOT NULL,
  `cantidad` decimal(10,2) NOT NULL COMMENT 'Cantidad de insumo requerida para 1 unidad de este producto',
  PRIMARY KEY (`idReceta`),
  KEY `idProducto` (`idProducto`),
  KEY `idInsumo` (`idInsumo`),
  CONSTRAINT `fk_receta_insumo` FOREIGN KEY (`idInsumo`) REFERENCES `insumos` (`idInsumo`),
  CONSTRAINT `fk_receta_producto` FOREIGN KEY (`idProducto`) REFERENCES `productos` (`idProducto`)
) ENGINE=InnoDB AUTO_INCREMENT=79 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recetas`
--

LOCK TABLES `recetas` WRITE;
/*!40000 ALTER TABLE `recetas` DISABLE KEYS */;
INSERT INTO `recetas` VALUES (1,1,2,1.00),(2,1,4,1.00),(3,1,5,1.00),(4,1,8,1.00),(5,1,9,1.00),(6,1,10,1.00),(7,2,2,1.00),(8,2,4,1.00),(9,2,5,1.00),(10,2,6,1.00),(11,2,9,1.00),(12,2,10,1.00),(13,3,2,1.00),(14,3,4,1.00),(15,3,5,1.00),(16,3,7,1.00),(17,3,9,1.00),(18,3,10,1.00),(19,4,1,1.00),(20,4,4,1.00),(21,4,5,1.00),(22,4,8,1.00),(23,4,9,1.00),(24,4,10,1.00),(25,5,1,1.00),(26,5,4,1.00),(27,5,5,1.00),(28,5,6,1.00),(29,5,9,1.00),(30,5,10,1.00),(31,6,1,1.00),(32,6,4,1.00),(33,6,5,1.00),(34,6,7,1.00),(35,6,9,1.00),(36,6,10,1.00),(37,7,3,1.00),(38,7,4,1.00),(39,7,5,1.00),(40,7,8,1.00),(41,7,9,1.00),(42,7,10,1.00),(43,8,3,1.00),(44,8,4,1.00),(45,8,5,1.00),(46,8,6,1.00),(47,8,9,1.00),(48,8,10,1.00),(49,9,3,1.00),(50,9,4,1.00),(51,9,5,1.00),(52,9,7,1.00),(53,9,9,1.00),(54,9,10,1.00),(55,10,1,1.00),(56,10,4,1.00),(57,10,5,1.00),(58,10,8,1.00),(59,10,9,1.00),(60,10,10,1.00),(61,11,1,1.00),(62,11,4,1.00),(63,11,5,1.00),(64,11,6,1.00),(65,11,9,1.00),(66,11,10,1.00),(67,12,1,1.00),(68,12,4,1.00),(69,12,5,1.00),(70,12,7,1.00),(71,12,9,1.00),(72,12,10,1.00),(73,13,1,1.00),(75,13,4,1.00),(76,13,10,1.00),(77,13,9,1.00),(78,13,5,1.00);
/*!40000 ALTER TABLE `recetas` ENABLE KEYS */;
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
