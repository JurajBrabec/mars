-- MySQL dump 10.16  Distrib 10.2.14-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: audit
-- ------------------------------------------------------
-- Server version	10.2.14-MariaDB-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `qrs`
--

DROP TABLE IF EXISTS `qrs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qrs` (
  `DATA_CENTER` varchar(32) DEFAULT NULL,
  `CUSTOMER_NAME` varchar(64) DEFAULT NULL,
  `RESERVATION_ID` varchar(32) DEFAULT NULL,
  `RESERVATION_STATUS` varchar(64) DEFAULT NULL,
  `BACKUP_RLI_ID` varchar(32) DEFAULT NULL,
  `BACKUP_RLI_STATUS` varchar(32) DEFAULT NULL,
  `BACKUP_RLI_STATE` varchar(64) DEFAULT NULL,
  `BACKUP_RLI_MRT` varchar(64) DEFAULT NULL,
  `SERVER_RLI_ID` varchar(32) DEFAULT NULL,
  `SERVER_RLI_STATUS` varchar(32) DEFAULT NULL,
  `SERVER_RLI_STATE` varchar(96) DEFAULT NULL,
  `SERVER_RLI_MRT` varchar(64) DEFAULT NULL,
  `DEVICE_ID` varchar(32) DEFAULT NULL,
  `DEVICE_PHYSICAL_NAME` varchar(32) DEFAULT NULL,
  `HOST_NAME` varchar(32) DEFAULT NULL,
  `DEVICE_STATUS` varchar(32) DEFAULT NULL,
  `DEVICE_STATE` varchar(64) DEFAULT NULL,
  `SERVER_TYPE` varchar(32) DEFAULT NULL,
  `OS` varchar(64) DEFAULT NULL,
  `OS_TYPE` varchar(64) DEFAULT NULL,
  `OS_VERSION` varchar(64) DEFAULT NULL,
  `DEVICE_MRT` varchar(64) DEFAULT NULL,
  `VLAN_ID` varchar(32) DEFAULT NULL,
  `VLAN_STATUS` varchar(32) DEFAULT NULL,
  `VLAN_ASSIGNED_CUSTOMER` varchar(64) DEFAULT NULL,
  KEY `DATA_CENTER` (`DATA_CENTER`),
  KEY `DEVICE_ID` (`DEVICE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
 
 /*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-04-18  9:24:11 
