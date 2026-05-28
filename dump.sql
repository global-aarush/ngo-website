<<<<<<< HEAD
-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: ngo_db
-- ------------------------------------------------------
-- Server version	8.0.45

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
-- Table structure for table `donations`
--

DROP TABLE IF EXISTS `donations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `donations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `payment_screenshot` varchar(255) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'pending',
  `razorpay_order_id` varchar(100) DEFAULT NULL,
  `razorpay_payment_id` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `donations_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `donations`
--

LOCK TABLES `donations` WRITE;
/*!40000 ALTER TABLE `donations` DISABLE KEYS */;
INSERT INTO `donations` VALUES (16,11,1.00,'2026-05-18 18:59:49',NULL,'paid','order_Sqw0U0hCCMl5PK','pay_Sqw4bIaHEOjCZo'),(17,11,1000.00,'2026-05-18 19:04:57',NULL,'paid','order_Sqw5tInDOHpjWp','pay_Sqw6OMepB79iyR'),(19,11,500.00,'2026-05-18 21:10:47',NULL,'paid','order_SqyE7cmotHjWLu','pay_SqyEWzLyRCjYJp'),(20,12,1.00,'2026-05-19 07:10:03',NULL,'paid','order_Sr8QcNtm5VDxOi','pay_Sr8RUMVlcLyuH7'),(21,12,10000.00,'2026-05-19 07:15:59',NULL,'paid','order_Sr8XUdtKP0tWBv','pay_Sr8XooCgFdDbG9'),(22,13,1000.00,'2026-05-19 14:53:59',NULL,'paid','order_SrGLOtgIsQMH4n','pay_SrGLdxFpFnJ5CO'),(23,11,1000.00,'2026-05-21 09:31:41',NULL,'paid','order_SrxuRtM2nJlWsM','pay_SrxvKUvJnbocPA');
/*!40000 ALTER TABLE `donations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `events` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `events`
--

LOCK TABLES `events` WRITE;
/*!40000 ALTER TABLE `events` DISABLE KEYS */;
/*!40000 ALTER TABLE `events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `projects`
--

DROP TABLE IF EXISTS `projects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `projects` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(200) DEFAULT NULL,
  `description` text,
  `status` enum('ongoing','completed') DEFAULT 'ongoing',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projects`
--

LOCK TABLES `projects` WRITE;
/*!40000 ALTER TABLE `projects` DISABLE KEYS */;
/*!40000 ALTER TABLE `projects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password_hash` varchar(255) DEFAULT NULL,
  `role` enum('user','admin') DEFAULT 'user',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Aarush','globalaarush04@gmail.com','scrypt:32768:8:1$YA78hehtHCL42x9z$34529e6efa84f65332c2fe90618d5cf3219c1e4a6e9a6df964d6f3544a45faa0a4b70e0a39e99e1b319a41d750b6f709741a0ec6f3fdabd97148ad42fb4ca968','user'),(2,'Jack','jack123@gmail.com','scrypt:32768:8:1$YBKuVGKNO771oeHy$a20bd28172268eee6c14963c68087393254967f8c3540fc479cd80b9f50f1104029b299ace4ac50613dac862b14cf0eddaafe12332cb27da0020f544af5432a8','user'),(3,'Admin Person','admin@ngo.org','<hashed_password>','admin'),(4,'rk','rk12@gmail.com','scrypt:32768:8:1$zm9jTiKmPOSAA4cl$94384146cf4ca676f23bdb4923ec0ffc395d06f269e0e2e07825abdd2ed1f79c0d443e8f5f3297091c04efa2c1ce9f443c1fbb7ef6da57539f9fba06b9be0b2f','user'),(5,'Aarush Vishwakarma','aarusheyes04@gmail.com','scrypt:32768:8:1$kwgYFTXsKtfNNWSx$edb97881ab30c4a08bc503a91c48a70b2d244bded0098c6b65c37b6102d8739791e0510f19ff6d7a62a1cb5c266c9807b8dbddf85f0599ae2555021048ba7301','user'),(6,'Kunal Dixit','kunaldixit2126@gmail.com','scrypt:32768:8:1$XnTded4JG3spGcbm$646416dfd864f860df4cf22c50dac062f4f913b0291a930a5ed4ea99086b55562bee630cb2c9ccc547e92c5d7c8d6c4a4a504cfc2b1d41efd6762747eded4cd8','user'),(7,'admin','admin12@gmail.com','scrypt:32768:8:1$Lfth7Ul21pzLgyJ4$4017003dc9b8e79175ef61b620ef7379e31ce07de1485ffb77df74238e6f1c0be4b023dbc1a2d57204b94ff37fddc47af06c2d2ff572be872a42d8522b46f348','admin'),(8,'admin2','admin21@gmail.com','scrypt:32768:8:1$AJsjlDLu4caGYwXw$925db16396b57a5514fc4bfaea3bbe54794810cf2533872dffba22b6820d5ecf6e193f60515a0e93e93ebaf1da775b0749be7d93e2ae5fae4ff6a09f2574a3af','admin'),(9,'suryansh tiwari','tiwarisuryansh12345@gmail.com','scrypt:32768:8:1$OGiWTIjnoRdMXhqr$44bfdac6e968d9b8e250c1d18f217118a85d140b0290f02493b62675d5fa4e7b79b85c8849112e5f9b9d20c4459ac2516a8577ecd7cab31f622e62605cc35a84','user'),(10,'Anjali Singh','anjali123@gmail.com','scrypt:32768:8:1$P3VS2LWcC0mM9FQR$6ae171901a23c38eca2c90dd24386d5e6c9cdebfdbdc78ee055a459adeb5d48b7726aedc783f87700a34ee1b25f44fda0cf415721ae8a950b8c523ab1b2b5682','user'),(11,'Sushant','sushant12@gmail.com','scrypt:32768:8:1$t00FUuJdGzQo22gz$7b2e0921c3347ee7431abd3300f2e4e07d73e81bf6c56237fb4835127ea156a8e53dd902edb9bf1f6b512ba0d34ef8fdec747383952e26e856ea35f7ef0ee2d4','user'),(12,'Kunal','kunaldixit264@gmail.com','scrypt:32768:8:1$x0elSiAKZX8DfTgf$76ca7ddf5b77d6c42f83e36e057ecc3116b906c6577e9600899ed98c05de531f3871b8a90fe56a20a036db327e7b0a27eeadf3f0f34dd7da4a9ddd74608e77c9','user'),(13,'Mahfooz','mohammadjunaid3858@gmail.com','scrypt:32768:8:1$YwYHDMLDd7GkrtbA$a1c55556609b097c47839bdee755e62ba803ca9162751b3e2c7ab6fb379255733aeb6cc5cb915c1d90f837480b626070a61d9cae3cde8c0b9f187f486f89cbf6','user');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `volunteers`
--

DROP TABLE IF EXISTS `volunteers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `volunteers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `interest` varchar(200) DEFAULT NULL,
  `event_name` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `availability` varchar(100) DEFAULT NULL,
  `message` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `volunteers_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `volunteers`
--

LOCK TABLES `volunteers` WRITE;
/*!40000 ALTER TABLE `volunteers` DISABLE KEYS */;
INSERT INTO `volunteers` VALUES (4,6,'Food relief','Food Relief Packing Drive','Kunal Dixit','9675432541','Weekend','helping each other.','2026-05-18 20:57:38'),(5,11,'Food relief','Food Relief Packing Drive','Sushant','9876543211','Weekend','help to others','2026-05-18 20:59:18'),(6,12,'Food relief','Food Relief Packing Drive','Kunal','9675432541','Weekend','thank you','2026-05-19 07:13:41'),(7,13,'Skill support','Food Relief Packing Drive','Mahfooz','9675432541','Weekend','thank you','2026-05-19 14:55:47');
/*!40000 ALTER TABLE `volunteers` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-22 14:08:25
=======
-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: ngo_db
-- ------------------------------------------------------
-- Server version	8.0.45

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
-- Table structure for table `donations`
--

DROP TABLE IF EXISTS `donations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `donations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `payment_screenshot` varchar(255) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'pending',
  `razorpay_order_id` varchar(100) DEFAULT NULL,
  `razorpay_payment_id` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `donations_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `donations`
--

LOCK TABLES `donations` WRITE;
/*!40000 ALTER TABLE `donations` DISABLE KEYS */;
INSERT INTO `donations` VALUES (16,11,1.00,'2026-05-18 18:59:49',NULL,'paid','order_Sqw0U0hCCMl5PK','pay_Sqw4bIaHEOjCZo'),(17,11,1000.00,'2026-05-18 19:04:57',NULL,'paid','order_Sqw5tInDOHpjWp','pay_Sqw6OMepB79iyR'),(19,11,500.00,'2026-05-18 21:10:47',NULL,'paid','order_SqyE7cmotHjWLu','pay_SqyEWzLyRCjYJp'),(20,12,1.00,'2026-05-19 07:10:03',NULL,'paid','order_Sr8QcNtm5VDxOi','pay_Sr8RUMVlcLyuH7'),(21,12,10000.00,'2026-05-19 07:15:59',NULL,'paid','order_Sr8XUdtKP0tWBv','pay_Sr8XooCgFdDbG9'),(22,13,1000.00,'2026-05-19 14:53:59',NULL,'paid','order_SrGLOtgIsQMH4n','pay_SrGLdxFpFnJ5CO'),(23,11,1000.00,'2026-05-21 09:31:41',NULL,'paid','order_SrxuRtM2nJlWsM','pay_SrxvKUvJnbocPA');
/*!40000 ALTER TABLE `donations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `events` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `events`
--

LOCK TABLES `events` WRITE;
/*!40000 ALTER TABLE `events` DISABLE KEYS */;
/*!40000 ALTER TABLE `events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `projects`
--

DROP TABLE IF EXISTS `projects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `projects` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(200) DEFAULT NULL,
  `description` text,
  `status` enum('ongoing','completed') DEFAULT 'ongoing',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projects`
--

LOCK TABLES `projects` WRITE;
/*!40000 ALTER TABLE `projects` DISABLE KEYS */;
/*!40000 ALTER TABLE `projects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password_hash` varchar(255) DEFAULT NULL,
  `role` enum('user','admin') DEFAULT 'user',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Aarush','globalaarush04@gmail.com','scrypt:32768:8:1$YA78hehtHCL42x9z$34529e6efa84f65332c2fe90618d5cf3219c1e4a6e9a6df964d6f3544a45faa0a4b70e0a39e99e1b319a41d750b6f709741a0ec6f3fdabd97148ad42fb4ca968','user'),(2,'Jack','jack123@gmail.com','scrypt:32768:8:1$YBKuVGKNO771oeHy$a20bd28172268eee6c14963c68087393254967f8c3540fc479cd80b9f50f1104029b299ace4ac50613dac862b14cf0eddaafe12332cb27da0020f544af5432a8','user'),(3,'Admin Person','admin@ngo.org','<hashed_password>','admin'),(4,'rk','rk12@gmail.com','scrypt:32768:8:1$zm9jTiKmPOSAA4cl$94384146cf4ca676f23bdb4923ec0ffc395d06f269e0e2e07825abdd2ed1f79c0d443e8f5f3297091c04efa2c1ce9f443c1fbb7ef6da57539f9fba06b9be0b2f','user'),(5,'Aarush Vishwakarma','aarusheyes04@gmail.com','scrypt:32768:8:1$kwgYFTXsKtfNNWSx$edb97881ab30c4a08bc503a91c48a70b2d244bded0098c6b65c37b6102d8739791e0510f19ff6d7a62a1cb5c266c9807b8dbddf85f0599ae2555021048ba7301','user'),(6,'Kunal Dixit','kunaldixit2126@gmail.com','scrypt:32768:8:1$XnTded4JG3spGcbm$646416dfd864f860df4cf22c50dac062f4f913b0291a930a5ed4ea99086b55562bee630cb2c9ccc547e92c5d7c8d6c4a4a504cfc2b1d41efd6762747eded4cd8','user'),(7,'admin','admin12@gmail.com','scrypt:32768:8:1$Lfth7Ul21pzLgyJ4$4017003dc9b8e79175ef61b620ef7379e31ce07de1485ffb77df74238e6f1c0be4b023dbc1a2d57204b94ff37fddc47af06c2d2ff572be872a42d8522b46f348','admin'),(8,'admin2','admin21@gmail.com','scrypt:32768:8:1$AJsjlDLu4caGYwXw$925db16396b57a5514fc4bfaea3bbe54794810cf2533872dffba22b6820d5ecf6e193f60515a0e93e93ebaf1da775b0749be7d93e2ae5fae4ff6a09f2574a3af','admin'),(9,'suryansh tiwari','tiwarisuryansh12345@gmail.com','scrypt:32768:8:1$OGiWTIjnoRdMXhqr$44bfdac6e968d9b8e250c1d18f217118a85d140b0290f02493b62675d5fa4e7b79b85c8849112e5f9b9d20c4459ac2516a8577ecd7cab31f622e62605cc35a84','user'),(10,'Anjali Singh','anjali123@gmail.com','scrypt:32768:8:1$P3VS2LWcC0mM9FQR$6ae171901a23c38eca2c90dd24386d5e6c9cdebfdbdc78ee055a459adeb5d48b7726aedc783f87700a34ee1b25f44fda0cf415721ae8a950b8c523ab1b2b5682','user'),(11,'Sushant','sushant12@gmail.com','scrypt:32768:8:1$t00FUuJdGzQo22gz$7b2e0921c3347ee7431abd3300f2e4e07d73e81bf6c56237fb4835127ea156a8e53dd902edb9bf1f6b512ba0d34ef8fdec747383952e26e856ea35f7ef0ee2d4','user'),(12,'Kunal','kunaldixit264@gmail.com','scrypt:32768:8:1$x0elSiAKZX8DfTgf$76ca7ddf5b77d6c42f83e36e057ecc3116b906c6577e9600899ed98c05de531f3871b8a90fe56a20a036db327e7b0a27eeadf3f0f34dd7da4a9ddd74608e77c9','user'),(13,'Mahfooz','mohammadjunaid3858@gmail.com','scrypt:32768:8:1$YwYHDMLDd7GkrtbA$a1c55556609b097c47839bdee755e62ba803ca9162751b3e2c7ab6fb379255733aeb6cc5cb915c1d90f837480b626070a61d9cae3cde8c0b9f187f486f89cbf6','user');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `volunteers`
--

DROP TABLE IF EXISTS `volunteers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `volunteers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `interest` varchar(200) DEFAULT NULL,
  `event_name` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `availability` varchar(100) DEFAULT NULL,
  `message` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `volunteers_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `volunteers`
--

LOCK TABLES `volunteers` WRITE;
/*!40000 ALTER TABLE `volunteers` DISABLE KEYS */;
INSERT INTO `volunteers` VALUES (4,6,'Food relief','Food Relief Packing Drive','Kunal Dixit','9675432541','Weekend','helping each other.','2026-05-18 20:57:38'),(5,11,'Food relief','Food Relief Packing Drive','Sushant','9876543211','Weekend','help to others','2026-05-18 20:59:18'),(6,12,'Food relief','Food Relief Packing Drive','Kunal','9675432541','Weekend','thank you','2026-05-19 07:13:41'),(7,13,'Skill support','Food Relief Packing Drive','Mahfooz','9675432541','Weekend','thank you','2026-05-19 14:55:47');
/*!40000 ALTER TABLE `volunteers` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-22 14:08:25
>>>>>>> f8714dd (Initial commit by mac)
