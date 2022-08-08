-- ================
-- INSERTS (previously on create.sql)
-- ================


SET foreign_key_checks = 0;

-- MySQL dump 10.13  Distrib 5.6.12, for osx10.7 (x86_64)
--
-- Host: localhost    Database: unit_test
-- ------------------------------------------------------
-- Server version	5.6.12

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
-- Table structure for table `AccessToken`
--

DROP TABLE IF EXISTS `AccessToken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `AccessToken` (
  `token` varchar(255) NOT NULL,
  `date` datetime DEFAULT NULL,
  `expiresAt` datetime DEFAULT NULL,
  `account_id` int(11) DEFAULT NULL,
  apiCredential_id int(11) DEFAULT NULL,
  PRIMARY KEY (`token`),
  CONSTRAINT FK_AccessToken_ApiCredential FOREIGN KEY (apiCredential_id) REFERENCES APICredential (id),
  CONSTRAINT FK_AccessToken_Account FOREIGN KEY (account_id) REFERENCES Account (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AccessToken`
--

LOCK TABLES `AccessToken` WRITE;
/*!40000 ALTER TABLE `AccessToken` DISABLE KEYS */;
/*!40000 ALTER TABLE `AccessToken` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Account`
--

DROP TABLE IF EXISTS `Account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Account`(
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `alternateNumber` varchar(255) DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `dateLocked` datetime DEFAULT NULL,
  `dateOfBirth` datetime DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `escalationNumber` varchar(255) DEFAULT NULL,
  `fullName` varchar(255) DEFAULT NULL,
  `isDeleted` tinyint(1) NOT NULL,
  `lastLogin` datetime DEFAULT NULL,
  `mainNumber` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `role` varchar(255) NOT NULL,
  `timezone` varchar(255) DEFAULT NULL,
  `operator_id` int(11) DEFAULT NULL,
  `passwordChangedAt` datetime DEFAULT NULL,
  `passwordExpiredAt` datetime DEFAULT NULL,
  `oneTimePassword` varchar(255) DEFAULT NULL,
  `oneTimePasswordExpiredAt` datetime DEFAULT NULL,
  `company` varchar(255) DEFAULT NULL,
  `version` INT(11) DEFAULT 0,
  `watchedMainTour` TINYINT(1) NOT NULL DEFAULT '0',
  `watchedRecentTour` TINYINT(1) NOT NULL DEFAULT '0',
  `useUTC` TINYINT(1) NOT NULL DEFAULT '0',
  `role_id` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_Account_email` (`email`),
  CONSTRAINT FK_Account_Operator FOREIGN KEY (operator_id) REFERENCES Operator (id) ON DELETE CASCADE,
  CONSTRAINT `FK_Account_Role` FOREIGN KEY (`role_id`) REFERENCES `Role` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Account`
--

LOCK TABLES `Account` WRITE;
/*!40000 ALTER TABLE `Account` DISABLE KEYS */;
/*!40000 ALTER TABLE `Account` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PublishingPoint`
--
DROP TABLE IF EXISTS `PublishingPoint`;

CREATE TABLE IF NOT EXISTS `PublishingPoint` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `backupPoint` varchar(255) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `deletedAt` datetime DEFAULT NULL,
  `isProvisioned` tinyint(1) NOT NULL,
  `playbackUrl` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `primaryPoint` varchar(255) NOT NULL,
  `provisioningIp` varchar(255) DEFAULT NULL,
  `streamId` varchar(255) DEFAULT NULL,
  `streamName` varchar(255) DEFAULT NULL,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `username` varchar(255) DEFAULT NULL,
  `isAvailable` tinyint(1) DEFAULT '1',
  `lastAssigned` datetime DEFAULT NULL,
  `ingestProtocol` varchar(5) NOT NULL DEFAULT '',
  `lastUnassigned` datetime DEFAULT NULL,
  `forceStreamName` varchar(255) DEFAULT NULL,
  `region` varchar(2) DEFAULT NULL,
  `isLive` tinyint(1) DEFAULT '0',
  `streamingConfig_id` int(11) DEFAULT NULL,
  `version` int(11) DEFAULT '0',
  `cdn` varchar(10) DEFAULT NULL,
  `playbackProtocol` varchar(5) NOT NULL DEFAULT '',
  `backupRegion` VARCHAR(2) NOT NULL,
  `mode` VARCHAR(32) NOT NULL DEFAULT 'PLAYBACK',
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_PublishingPoint_primaryPoint_streamName` (`primaryPoint`,`streamName`),
  KEY `FK_PublishingPoint_StreamingConfig` (`streamingConfig_id`),
  CONSTRAINT `publishingpoint_ibfk_3` FOREIGN KEY (`streamingConfig_id`) REFERENCES `StreamingConfig` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `EncodeDetails`
--

DROP TABLE IF EXISTS `EncodeDetails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EncodeDetails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `address` varchar(255) DEFAULT NULL,
  `contactInfo` varchar(255) DEFAULT NULL,
  `encodeTestEnd` datetime DEFAULT NULL,
  `encodeTestStart` datetime DEFAULT NULL,
  `encodingEngineer_id` int(11) DEFAULT NULL,
  `event_id` int(11) DEFAULT NULL,
  `version` INT(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_EncodeDetails_Event` FOREIGN KEY (`event_id`) REFERENCES `Event` (`id`),
  CONSTRAINT `FK_EncodeDetails_Account` FOREIGN KEY (`encodingEngineer_id`) REFERENCES `Account` (`id`),
  UNIQUE KEY `UK_EncodeDetails_Event` (`event_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EncodeDetails`
--

LOCK TABLES `EncodeDetails` WRITE;
/*!40000 ALTER TABLE `EncodeDetails` DISABLE KEYS */;
/*!40000 ALTER TABLE `EncodeDetails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Event`
--

DROP TABLE IF EXISTS `Event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Event` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contacts` varchar(255) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `endDate` datetime NOT NULL,
  `commentary` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `posterLocation` varchar(1024) DEFAULT NULL,
  `startDate` datetime NOT NULL,
  `title` varchar(255) NOT NULL,
  `tournament_id` int(11) DEFAULT NULL,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `streamingConfig_id` int(11) DEFAULT NULL,
  `geoListField` varchar(2048) NOT NULL DEFAULT '[]',
  `isWhiteList` tinyint(1) NOT NULL DEFAULT 0,
  `maxConcurrentViewers` int(11) DEFAULT -1,
  `isSLAFailure` TINYINT(1) DEFAULT 0,
  `slaFailureComment` varchar(1020) DEFAULT NULL,
  `isDeleted` int(1) DEFAULT 0,
  `court` varchar(255) DEFAULT NULL,
  `preferedZixiServer_id` int(11) DEFAULT NULL,
  `preferedBackupZixiServer_id` int(11) DEFAULT NULL,
  `version` INT(11) DEFAULT 0,
  `preferredCDN` VARCHAR(10) DEFAULT 'AUTO',
  `storeVods` int(1) DEFAULT 1,
  `useDRM` tinyint(1),
  `dvr` int(11) not null default -1,
  `audioLanguages` varchar(1024),
  `description` VARCHAR(2048) DEFAULT 'AUTO',
  `externalId` VARCHAR(191) DEFAULT NULL,
  `externalProviderId`  VARCHAR(32) DEFAULT NULL,
  `type`  VARCHAR(32) NOT NULL DEFAULT 'EVENT',
  `details` VARCHAR(2048) DEFAULT 'AUTO',
  `directConnect` varchar(24) DEFAULT NULL,
  `normalizeInputStream` varchar(32) NOT NULL DEFAULT 'FOLLOW_PARENT',
  `preferredPublishingPointRegion` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_Event_Tournament` FOREIGN KEY (`tournament_id`) REFERENCES `Tournament` (`id`),
  CONSTRAINT `FK_Event_StreamingConfig` FOREIGN KEY (`streamingConfig_id`) REFERENCES `StreamingConfig` (`id`),
  CONSTRAINT `FK_Event_ZixiServer` FOREIGN KEY (`preferedZixiServer_id`) REFERENCES `ZixiServer` (`id`),
  CONSTRAINT `FK_Event_BackupZixiServer` FOREIGN KEY (`preferedBackupZixiServer_id`) REFERENCES `ZixiServer` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

CREATE INDEX Event_deleted_endDate_startDate_index ON Event(isDeleted,endDate,startDate);
CREATE INDEX Event_deleted_startDate_endDate_index ON Event(isDeleted,startDate,endDate);

DROP TABLE IF EXISTS `SubEvent`;
CREATE TABLE `SubEvent` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `event_id` int(11) NOT NULL,
  `orderIndex` int(11) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `startDate` datetime DEFAULT NULL,
  `endDate` datetime DEFAULT NULL,
  `thumbnailUrl` varchar(255) DEFAULT NULL,
  `externalId` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `details` varchar(2048) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_SubEvent_Event` (`event_id`),
  CONSTRAINT `FK_SubEvent_Event` FOREIGN KEY (`event_id`) REFERENCES `Event` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `EventAttributes`;
CREATE TABLE `EventAttributes` (
  `event_id` int(11) NOT NULL,
  `is4k` int(11) DEFAULT 0,
  `trailerId` varchar(120) DEFAULT NULL,
  `epgId` varchar(128) DEFAULT NULL,
  `epgProvider` varchar(255) DEFAULT NULL,
  `epgProviderId` varchar(255) DEFAULT NULL,
  `captionType` varchar(16) DEFAULT NULL,
  `captionLanguages` varchar(255) DEFAULT NULL,
  `isCombiner` INT(1) DEFAULT 0,
  `transcoderRedundancy` varchar(24) DEFAULT NULL,
  `audioOnly` varchar(32) NOT NULL DEFAULT 'FOLLOW_PARENT',
  `useSSAI` varchar(32) NOT NULL DEFAULT 'FOLLOW_PARENT',
  `drmContentId` varchar(255) DEFAULT NULL,
  `audioTracks` varchar(1024) NOT NULL DEFAULT '{"type":"NONE","tracks":[]}',
  PRIMARY KEY (`event_id`),
  KEY `Key_Epg` (`epgProvider`,`epgProviderId`),
  CONSTRAINT `FK_EventAttributes_Event` FOREIGN KEY (`event_id`) REFERENCES `Event` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `EventRendition`
--
DROP TABLE IF EXISTS `EventRendition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EventRendition` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`isDefaultRendition` tinyint(1) DEFAULT 0,
	`isLive` tinyint(1) DEFAULT 0,
	`height` int(11) NOT NULL,
	`videoBitrate` int(11) NOT NULL,
	`audioBitrate` int(11) NOT NULL,
	`audioChannelsCount` int(11) NOT NULL,
	`sampleRate` int(11) DEFAULT 44100,
	`label` varchar(255) DEFAULT NULL,
	`isPullRendition` tinyint(1) NOT NULL DEFAULT 0,
	`frameRate` FLOAT NOT NULL DEFAULT 25,
	`keyFrameInterval` int(11) NOT NULL DEFAULT 50,
	`isActive` tinyint(1) NOT NULL default 0,
	`event_id` int(11),
	`tournament_id` int(11),
	`version` INT(11) DEFAULT 0,
	`profile` VARCHAR(191) DEFAULT 'main',
	PRIMARY KEY (id),
	CONSTRAINT `FK_EventRendition_Event` FOREIGN KEY (event_id) REFERENCES Event (id),
	CONSTRAINT `FK_EventRendition_Tournament` FOREIGN KEY (tournament_id) REFERENCES Tournament (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
--
-- Dumping data for table `Event`
--

LOCK TABLES `Event` WRITE;
/*!40000 ALTER TABLE `Event` DISABLE KEYS */;
/*!40000 ALTER TABLE `Event` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `License`
--

DROP TABLE IF EXISTS `License`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `License` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `operator_id` int(11) DEFAULT NULL,
  `property_id` int(11) DEFAULT NULL,
  `maxEvents` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime default null,
  `geoListField` varchar(2048) NOT NULL DEFAULT '[]',
  `isWhiteList` tinyint(1) NOT NULL,
  `overflowEmailSent` varchar(255) DEFAULT NULL,
  `isDeleted` TINYINT(1) DEFAULT 0,
  `version` INT(11) DEFAULT 0,
  `maxBitRateAllowed` int(11) NOT NULL default 728,
  `allowLLP` int(1) DEFAULT 0,
  `storeVod` int(1) DEFAULT 0,
  `storePermanentVod` int(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_License_Property` FOREIGN KEY (property_id) REFERENCES Property (id),
  CONSTRAINT `FK_License_Operator` FOREIGN KEY (operator_id) REFERENCES Operator (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `LicensingPeriod`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `LicensingPeriod` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `license_id` int(11) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `start` datetime NOT NULL,
  `end` datetime NOT NULL,
  `purchasedEvents` INT(11) DEFAULT NULL,
  `version` INT(11) DEFAULT 0,
  `maxEvents` INT(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_LicensingPeriod_License` FOREIGN KEY (`license_id`) REFERENCES `License` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Notification`
--

DROP TABLE IF EXISTS `Notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Notification` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `body` text NOT NULL,
  `subject` text DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `sport_id` int(11) DEFAULT NULL,
  `property_id` int(11) DEFAULT NULL,
  `tournament_id` INT DEFAULT NULL,
  `attachment_id` int(11) DEFAULT NULL,
  `TYPE` varchar(255) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `subjectType` varchar(255) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_Notification_Sport` FOREIGN KEY (`sport_id`) REFERENCES `Sport` (`id`),
  CONSTRAINT `FK_Notification_Property` FOREIGN KEY (`property_id`) REFERENCES `Property` (`id`),
  CONSTRAINT `FK_Notification_Tournament` FOREIGN KEY (`tournament_id`) REFERENCES `Tournament`(`id`),
  CONSTRAINT `FK_Notification_AttachmentFileInfo` FOREIGN KEY (`attachment_id`) REFERENCES `AttachmentFileInfo` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Notification`
--

LOCK TABLES `Notification` WRITE;
/*!40000 ALTER TABLE `Notification` DISABLE KEYS */;
/*!40000 ALTER TABLE `Notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Operator`
--

DROP TABLE IF EXISTS `Operator`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Operator` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime DEFAULT NULL,
  `logoUrl` varchar(1024) DEFAULT NULL,
  `mainContactEmail` varchar(255) DEFAULT NULL,
  `mainContactName` varchar(255) DEFAULT NULL,
  `mainContactTel` varchar(255) DEFAULT NULL,
  `maxTraders` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `secret` varchar(255) NOT NULL,
  `notificationEmails` varchar(1020) DEFAULT NULL,
  `isDeleted` int(1) DEFAULT 0,
  `pricePerGB` FLOAT NOT NULL DEFAULT 0.1,
  `version` INT(11) DEFAULT 0,
  `isPush` int(1) DEFAULT 0,
  `mailingEmails` VARCHAR(191) DEFAULT NULL,
  `licenseLimitEmails` VARCHAR(191) DEFAULT NULL,
  `supplementarySecret` VARCHAR(191) NOT NULL,
  `groupValue` VARCHAR(191) NOT NULL DEFAULT 'ARENA',
  `shieldClientId` VARCHAR(191) DEFAULT NULL,
  `shieldClientAccessKey` VARCHAR(191) DEFAULT NULL,
  `shieldClientSecretKey` VARCHAR(191) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Operator`
--

LOCK TABLES `Operator` WRITE;
/*!40000 ALTER TABLE `Operator` DISABLE KEYS */;
/*!40000 ALTER TABLE `Operator` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `OperatorEvent`
--

DROP TABLE IF EXISTS `OperatorEvent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OperatorEvent` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime NOT NULL,
  `event_id` int(11) NOT NULL,
  `license_id` int(11) NOT NULL,
  `operator_id` int(11) NOT NULL,
  `deletedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_OperatorEvent_Operator` FOREIGN KEY (`operator_id`) REFERENCES `Operator` (`id`),
  CONSTRAINT `FK_OperatorEvent_License` FOREIGN KEY (`license_id`) REFERENCES `License` (`id`),
  CONSTRAINT `FK_OperatorEvent_Event` FOREIGN KEY (`event_id`) REFERENCES `Event` (`id`),
  CONSTRAINT `UK_OperatorEvent_License_Event` UNIQUE (event_id, license_id, operator_id, deletedAt)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `OperatorEvent`
--

LOCK TABLES `OperatorEvent` WRITE;
/*!40000 ALTER TABLE `OperatorEvent` DISABLE KEYS */;
/*!40000 ALTER TABLE `OperatorEvent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Property`
--

DROP TABLE IF EXISTS `Property`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Property` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `logoUrl` varchar(1024) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `sport_id` int(11) NOT NULL,
  `isDeleted` int(1) DEFAULT 0,
  `version` INT(11) DEFAULT 0,
  `useHLSv2` int(1) DEFAULT 1,
  `useDASH` int(1) DEFAULT 1,
  `useDRM` tinyint(1),
  `multiCDN` tinyint(1) DEFAULT 0,
  `createdAt` DATETIME DEFAULT NULL,
  `updatedAt` DATETIME DEFAULT NULL,
  `normalizeInputStream` varchar(32) NOT NULL DEFAULT 'OFF',
  `useSSAI` varchar(32) NOT NULL DEFAULT 'OFF',
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_Property_Sport` FOREIGN KEY (`sport_id`) REFERENCES `Sport` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Property`
--

LOCK TABLES `Property` WRITE;
/*!40000 ALTER TABLE `Property` DISABLE KEYS */;
/*!40000 ALTER TABLE `Property` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Sport`
--

DROP TABLE IF EXISTS `Sport`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Sport` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `color` varchar(255) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `name` varchar(255) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `isDeleted` int(1) DEFAULT 0,
  `version` INT(11) DEFAULT 0,
  `createdAt` DATETIME DEFAULT NULL,
  `updatedAt` DATETIME DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `ServiceNotification`
--

DROP TABLE IF EXISTS `ServiceNotification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ServiceNotification` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime NOT NULL,
  `message` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `TYPE_ID` int(11) DEFAULT NULL,
  CONSTRAINT `FK_ServiceNotification_Type` FOREIGN KEY (`TYPE_ID`) REFERENCES `ServiceNotificationType` (`id`),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ServiceNotification`
--

LOCK TABLES `ServiceNotification` WRITE;
/*!40000 ALTER TABLE `ServiceNotification` DISABLE KEYS */;
/*!40000 ALTER TABLE `ServiceNotification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ServiceNotificationType`
--

DROP TABLE IF EXISTS `ServiceNotificationType`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ServiceNotificationType` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `shortName` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_4usl4xm4wcnlqo69x7f93fyw4` (`shortName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ServiceNotificationType`
--

LOCK TABLES `ServiceNotificationType` WRITE;
/*!40000 ALTER TABLE `ServiceNotificationType` DISABLE KEYS */;
/*!40000 ALTER TABLE `ServiceNotificationType` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `StreamingConfig`
--

DROP TABLE IF EXISTS `StreamingConfig`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `StreamingConfig` (
                                   `id`                    int(11) NOT NULL AUTO_INCREMENT,
                                   `isLive`                tinyint(1) NOT NULL DEFAULT 0,
                                   `viewers`               int(11) DEFAULT -1,
                                   `zixiStreamId`          varchar(255) DEFAULT NULL,
                                   `zixiOutputPrefix`      varchar(255) DEFAULT NULL,
                                   `zixiServer_id`         int(11) DEFAULT NULL,
                                   `backupZixiServer_id`   int(11) DEFAULT NULL,
                                   `version`               INT(11) DEFAULT 0,
                                   `cdn`                   VARCHAR(10)  DEFAULT NULL,
                                   `deleted`               TINYINT(1) DEFAULT 0,
                                   `backupProvisionFailed` tinyint      DEFAULT 0,
                                   `streamStarted`         DATETIME     DEFAULT NULL,
                                   `lowLatencyPlayerUrl`   VARCHAR(191) DEFAULT NULL,
                                   `event_id`              INT(11) DEFAULT NULL,
                                   `streamingOrder`        INT(11) DEFAULT NULL,
                                   `ratio`                 INT(11) DEFAULT NULL,
                                   `transcoderType`        VARCHAR(255) NOT NULL DEFAULT 'CPU',
                                   PRIMARY KEY (`id`),
                                   KEY                     `UK_StreamingConfig_Event` (`event_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `StreamingConfig`
--

LOCK TABLES `StreamingConfig` WRITE;
/*!40000 ALTER TABLE `StreamingConfig` DISABLE KEYS */;
/*!40000 ALTER TABLE `StreamingConfig` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Tournament`
--

DROP TABLE IF EXISTS `Tournament`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Tournament` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `posterLocation` varchar(1024) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `property_id` int(11) NOT NULL,
  `geoListField` varchar(2048) NOT NULL DEFAULT '[]',
  `isWhiteList` tinyint(1) NOT NULL DEFAULT 0,
  `commentary` varchar(255) DEFAULT NULL,
  `startDate` datetime NOT NULL,
  `endDate` datetime NOT NULL,
  `isDeleted` int(1) DEFAULT 0,
  `preferedZixiServer_id` int(11) DEFAULT NULL,
  `useTranscoderRedundancy` tinyint(1) DEFAULT 0,
  `preferedBackupZixiServer_id` int(11) DEFAULT NULL,
  `zixiInputType` varchar(255) DEFAULT 'ZIXI_PUSH',
  `version` INT(11) DEFAULT 0,
  `preferredCDN` VARCHAR(10) DEFAULT 'AKAMAI',
  `useDRM` tinyint(1),
  `dvr` int(11) not null default 0,
  `createdAt` DATETIME DEFAULT NULL,
  `updatedAt` DATETIME DEFAULT NULL,
  `directConnect` varchar(24) DEFAULT NULL,
  `normalizeInputStream` varchar(32) NOT NULL DEFAULT 'FOLLOW_PARENT',
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_Tournament_Property` FOREIGN KEY (`property_id`) REFERENCES `Property` (`id`),
  CONSTRAINT `FK_Tournament_ZixiServer` FOREIGN KEY (`preferedZixiServer_id`) REFERENCES `ZixiServer` (`id`),
  CONSTRAINT `FK_Tournament_BackupZixiServer` FOREIGN KEY (`preferedBackupZixiServer_id`) REFERENCES `ZixiServer` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `TournamentAttributes`;
CREATE TABLE `TournamentAttributes` (
  `tournament_id` int(11) NOT NULL,
  `audioOnly` varchar(32) NOT NULL DEFAULT 'OFF',
  `captionType` varchar(8) DEFAULT NULL,
  `captionLanguages` varchar(255) DEFAULT NULL,
  `useSSAI` varchar(32) NOT NULL DEFAULT 'FOLLOW_PARENT',
  PRIMARY KEY (`tournament_id`),
  CONSTRAINT `FK_TournamentAttributes_Tournament` FOREIGN KEY (`tournament_id`) REFERENCES `Tournament` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Tournament`
--

LOCK TABLES `Tournament` WRITE;
/*!40000 ALTER TABLE `Tournament` DISABLE KEYS */;
/*!40000 ALTER TABLE `Tournament` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ZixiServer`
--

DROP TABLE IF EXISTS `ZixiServer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ZixiServer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ip` varchar(255) NOT NULL,
  `lastHeartBeat` datetime DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `region` varchar(2) NOT NULL,
  `username` varchar(255) NOT NULL,
  `isAvailable` tinyint(1) DEFAULT 1,
  `isDisabled` tinyint(1) DEFAULT 0,
  `version` INT(11) DEFAULT 0,
  `ec2InstanceId` varchar(255) DEFAULT NULL,
  `ec2Region` varchar(255) DEFAULT NULL,
  `useWowzaPush` tinyint(1) DEFAULT 0,
  `useWowzaInput` tinyint(1) DEFAULT 0,
  `isReserved` tinyint(1) DEFAULT 0,
  `isDeleted` tinyint(1) NOT NULL DEFAULT 0,
  `hostname` varchar(255) DEFAULT NULL,
  `transcoderVersion` varchar(255) DEFAULT NULL,
  `instanceType` VARCHAR(16) DEFAULT 'GPU' NOT NULL,
  `privateIp` VARCHAR(24) DEFAULT NULL,
  `account_id` INT DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_ZixiServer_ip` (`ip`),
  UNIQUE KEY `UK_ZixiServer_hostname` (`hostname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ZixiServer`
--

LOCK TABLES `ZixiServer` WRITE;
/*!40000 ALTER TABLE `ZixiServer` DISABLE KEYS */;
/*!40000 ALTER TABLE `ZixiServer` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

--
-- Table structure for table `StreamingLog`
--

DROP TABLE IF EXISTS `StreamingLog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `StreamingLog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `eventId` int(11) NOT NULL,
  `date` datetime DEFAULT NULL,
  `value` TEXT DEFAULT NULL,
  `appVersion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_StreamingLog_Event` FOREIGN KEY (`eventId`) REFERENCES `Event` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `StreamingLog` WRITE;
/*!40000 ALTER TABLE `StreamingLog` DISABLE KEYS */;
/*!40000 ALTER TABLE `StreamingLog` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;


DROP TABLE IF EXISTS `ProductionReport`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ProductionReport` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `account_id` INT(11) NOT NULL,
  `createdAt` DATETIME DEFAULT NULL,
  `event_id` INT(11) NOT NULL,
  `startDate` DATETIME DEFAULT NULL,
  `endDate` DATETIME DEFAULT NULL,
  `state` VARCHAR(20) NOT NULL DEFAULT 'Failed',
  `version` INT(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_ProductionReport_Account` FOREIGN KEY (`account_id`) REFERENCES `Account` (`id`),
  CONSTRAINT `FK_ProductionReport_Event` FOREIGN KEY (`event_id`) REFERENCES `Event` (`id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `ProductionReportNote`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ProductionReportNote` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `productionReport_id` INT(11) NOT NULL,
  `message` TEXT,
  `attachment_id` int(11) DEFAULT NULL,
  `version` INT(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_ReportNote_Report` FOREIGN KEY (`productionReport_id`) REFERENCES `ProductionReport` (`id`),
  CONSTRAINT `FK_ReportNote_AttachmentFileInfo` FOREIGN KEY (`attachment_id`) REFERENCES `AttachmentFileInfo` (`id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `ProductionReportIssue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ProductionReportIssue` (
	`id` INT( 11 ) AUTO_INCREMENT NOT NULL,
	`cause` VARCHAR( 1020 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL,
	`attachment_id` int(11) DEFAULT NULL,
	`impact` VARCHAR( 1020 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL,
	`problemDescription` VARCHAR( 1020 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL,
	`responsibility` VARCHAR( 255 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL,
	`startDate` DATETIME NULL,
	`lossOfGamePlay` float DEFAULT NULL,
	`productionReport_id` INT( 11 ) NOT NULL,
	`version` INT(11) DEFAULT 0,
	 PRIMARY KEY ( `id` ),
	 CONSTRAINT `FK_ReportIssue_Report` FOREIGN KEY (`productionReport_id`) REFERENCES `ProductionReport` (`id`),
	 CONSTRAINT `FK_ReportIssue_AttachmentFileInfo` FOREIGN KEY (`attachment_id`) REFERENCES `AttachmentFileInfo` (`id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `ProductionReportIssueCase`;
CREATE TABLE `ProductionReportIssueCase` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`description` varchar(255) DEFAULT NULL,
	`duration` varchar(255) DEFAULT NULL,
	`name` varchar(255) DEFAULT NULL,
	`issue_id` int(11) DEFAULT NULL,
	 PRIMARY KEY (`id`),
	 KEY `FK_ProductionReportIssueCase` (`issue_id`),
	 CONSTRAINT `FK_ProductionReportIssueCase_ProductionReportIssue` FOREIGN KEY (`issue_id`) REFERENCES `ProductionReportIssue` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

--
-- Table structure for table `ZixiServer`
--

DROP TABLE IF EXISTS `GFXConfig`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `GFXConfig` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `externalEventId` VARCHAR(191) NULL,
  `spreadsheetUrl` varchar(255),
  `event_id` int(11) NOT NULL,
  `version` INT(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_GFXConfig_EVENT` FOREIGN KEY (`event_id`) REFERENCES `Event` (`id`) ON DELETE CASCADE,
  UNIQUE KEY `UK_GFXConfig_EVENT` (`event_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `AttachmentFileInfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `AttachmentFileInfo` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`blobKey` VARCHAR(191) NOT NULL,
	`contentType` VARCHAR(191),
	`fileName` VARCHAR(191) NOT NULL,
	`size` INT(11),
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `EventAnalytics_v2`;
CREATE TABLE `EventAnalytics_v2` (
  `event_id` int(11) NOT NULL default 0,
  `operatorId` int(11) NOT NULL default -1,
  `date` DATE NOT NULL,
  `countryCode` VARCHAR(2) NOT NULL,
  `totalViews` int(11) NOT NULL default 0,
  `totalSeconds` int(11) NOT NULL default 0,
  `bandwidth` bigint(20) DEFAULT 0,
  `desktopViews` int(11) NOT NULL default 0,
  `mobileViews` int(11) NOT NULL default 0,
  `mobileSeconds` int(11) NOT NULL default 0,
  `mobileBandwidth` bigint(20) NOT NULL default 0,
  `chromeDesktopViews` int(11) NOT NULL default 0,
  `firefoxDesktopViews` int(11) NOT NULL default 0,
  `safariDesktopViews` int(11) NOT NULL default 0,
  `ieDesktopViews` int(11) NOT NULL default 0,
  `otherDesktopViews` int(11) NOT NULL default 0,
  `androidViews` int(11) NOT NULL default 0,
  `iosViews` int(11) NOT NULL default 0,
  `otherMobileViews` int(11) NOT NULL default 0,
  PRIMARY KEY (`event_id`, `operatorId`, `countryCode`, `date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE INDEX eventAnalytics_operatorId_index ON EventAnalytics_v2(operatorId);
CREATE INDEX eventAnalytics_eventId_index ON EventAnalytics_v2(event_id);
CREATE INDEX eventAnalytics_date_index ON EventAnalytics_v2(date);
CREATE INDEX eventAnalytics_cc_index ON EventAnalytics_v2(countryCode);

DROP TABLE IF EXISTS `SpreadsheetReportSettings`;
CREATE TABLE `SpreadsheetReportSettings` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`spreadsheetUrl` VARCHAR(191) NOT NULL,
	`spreadsheetKey` VARCHAR(191) NOT NULL,
	`createdAt` DATETIME DEFAULT NULL,
	`quarter` INT(11),
	`year` INT(11),
	`version` INT(11) DEFAULT 0,
	PRIMARY KEY (`id`),
	CONSTRAINT `UNQ_IDX_DATE` UNIQUE( `quarter`, `year` )
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `EventReportInfo`;
CREATE TABLE `EventReportInfo`(
	`id` INT(11) NOT NULL auto_increment,
	`event_id` INT(11) NOT NULL,
	`updatedAt` TIMESTAMP NULL DEFAULT NULL,
	`createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`gameNotes` TEXT(1024),
	`version` INT(11) DEFAULT 0,
	PRIMARY KEY(`id`),
  CONSTRAINT `FK_EventReportInfo_Event` FOREIGN KEY (`event_id`) REFERENCES `Event` (`id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `AppSettings`;
CREATE TABLE `AppSettings` (
	`name` VARCHAR(191) NOT NULL,
	`value` VARCHAR(191) NOT NULL,
	`defValue` VARCHAR(191) DEFAULT NULL,
	`context` VARCHAR(32) DEFAULT NULL,
	`lastUpdate` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`type` VARCHAR(10) NOT NULL,
	PRIMARY KEY(`name`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `Player`;
CREATE TABLE `Player` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`fileName` varchar(255) NOT NULL,
	`description` varchar(255) NOT NULL,
	`url` varchar(255) NOT NULL,
	`md5sum` varchar(255) NOT NULL,
	`operator_id` int(11) NOT NULL,
	`disabled` tinyint(1) not null default 0,
	`externalId` int(11) default null,
	`uploaded` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`version` INT(11) DEFAULT 0,
	PRIMARY KEY (id),
	CONSTRAINT FK_Player_Operator FOREIGN KEY (operator_id) REFERENCES Operator (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `Channel`;
CREATE TABLE `Channel` (
  `channelEvent_id` int(11),
  `nextEvent_id` int(11),
  `liveEvent_id` int(11),
  `laterEvent_id` int(11),
  PRIMARY KEY (`channelEvent_id`),
  CONSTRAINT `FK_Channel_Event_Channel` FOREIGN KEY (`channelEvent_id`) REFERENCES `Event` (`id`),
  CONSTRAINT `FK_Channel_Event_Next` FOREIGN KEY (`nextEvent_id`) REFERENCES `Event` (`id`),
  CONSTRAINT `FK_Channel_Event_Live` FOREIGN KEY (`liveEvent_id`) REFERENCES `Event` (`id`),
  CONSTRAINT `FK_Channel_Event_Later` FOREIGN KEY (`laterEvent_id`) REFERENCES `Event` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `ChannelSchedule`;
CREATE TABLE `ChannelSchedule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_id` int(11) NOT NULL,
  `channelId` int(11) NOT NULL,
  `version` int(11) NOT NULL,
  `priority` int(11) NOT NULL DEFAULT 1,
  `hidden` int(1) NOT NULL DEFAULT 0,
  `operatorEvents` text DEFAULT NULL,
  `goLiveStartDate` DATETIME DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_ChannelSchedule_Event` (`event_id`, channelId),
  CONSTRAINT `FK_ChannelSchedule_Event` FOREIGN KEY (`event_id`) REFERENCES `Event` (`id`),
  CONSTRAINT `FK_ChannelSchedule_Channel` FOREIGN KEY (`channelId`) REFERENCES `Event` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `IPList`;
CREATE TABLE `IPList` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cidrRange` varchar(18) NOT NULL,
  `type` varchar(20) NOT NULL,
  `comment` varchar(1024) NOT NULL,
  `classification` varchar(20) NOT NULL,
  `version` int NOT NULL,
  `createdAt` datetime NOT NULL,
  `createdBy_id` int(11) NOT NULL,
  `lastUpdatedAt` datetime,
  `lastUpdatedBy_id` int(11),
  `deletedAt` datetime,
  `deletedBy_id` int(11),
  `deleted` tinyint(1) NOT NULL default 0,
   primary key (id),
   constraint FK_IpList_Account_CreatedBy foreign key (createdBy_id) references `Account` (id),
   constraint FK_IpList_Account_UpdatedBy foreign key (deletedBy_id) references `Account` (id),
   constraint FK_IpList_Account_DeletedBy foreign key (lastUpdatedBy_id) references `Account` (id)
);

DROP TABLE IF EXISTS `PlayerCustomization`;
CREATE TABLE `PlayerCustomization` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bufferIcon` varchar(255) DEFAULT NULL,
  `primaryColour` varchar(255) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `secondaryColour` varchar(255) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `backgroundColour` varchar(255) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `operator_id` int(11) DEFAULT NULL,
  `popupDelay` bigint(20) DEFAULT NULL,
  `popupLocation` varchar(1020) DEFAULT NULL,
  `popupUrl` varchar(1020) DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_PlayerCustomization_Operator` FOREIGN KEY (`operator_id`) REFERENCES `Operator` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `ExtendedTournament`;
CREATE TABLE `ExtendedTournament` (
	`id` int(11) NOT NULL,
	`tournamentDataId` VARCHAR(191) NOT NULL,
	PRIMARY KEY (`tournamentDataId`),
	CONSTRAINT `FK_ExtendedTournament_Tournament` FOREIGN KEY (`id`) REFERENCES `Tournament` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `ExternalServices`;
CREATE TABLE `ExternalServices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `uri` varchar(512) NOT NULL,
  primary key (id),
  unique key (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS APICredential;
create table APICredential(
    id int(11) NOT NULL AUTO_INCREMENT,
	name varchar(255) NOT NULL,
	appKey varchar(255) NOT NULL,
    secret varchar(255) NOT NULL,
    `version` int NOT NULL,
    `createdAt` datetime NOT NULL,
    `createdBy_id` int(11) NOT NULL,
    `lastUpdatedAt` datetime,
    `lastUpdatedBy_id` int(11),
    `deletedAt` datetime,
    `deletedBy_id` int(11),
    `revoked` tinyint(1) NOT NULL default 0,
    PRIMARY KEY (id),
    UNIQUE KEY ApiAuthentication_Name (name),
    constraint FK_ApiCredential_Account_CreatedBy foreign key (createdBy_id) references `Account` (id),
    constraint FK_ApiCredential_Account_UpdatedBy foreign key (deletedBy_id) references `Account` (id),
    constraint FK_ApiCredential_Account_DeletedBy foreign key (lastUpdatedBy_id) references `Account` (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS  TaskStatus;
CREATE TABLE TaskStatus(
  id INT(11) AUTO_INCREMENT PRIMARY KEY ,
  title VARCHAR(191) NOT NULL,
  status VARCHAR(191) NOT NULL,
  parent_id INT(11),
   CONSTRAINT `FK_TaskStatus_parentId_id`  FOREIGN KEY (`parent_id`) REFERENCES `TaskStatus` (`id`)
);

DROP TABLE IF EXISTS VideoTask;
CREATE TABLE VideoTask (
  id          INT(11)      NOT NULL AUTO_INCREMENT,
  event_id    INT(11)      NOT NULL,
  eventVod_id INT(11)      NOT NULL,
  status      VARCHAR(191) NOT NULL DEFAULT 'QUEUED',
  attempt     TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (id),
  CONSTRAINT FK_VideoTask_Event FOREIGN KEY (event_id) REFERENCES Event (id),
  CONSTRAINT FK_VideoTask_EventVod FOREIGN KEY (eventVod_id) REFERENCES EventVod (id)
)
  ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

DROP TABLE IF EXISTS LocalBroadcaster;
CREATE TABLE `LocalBroadcaster` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(248) DEFAULT NULL,
  `image` varchar(248) DEFAULT NULL,
  `url` varchar(248) DEFAULT NULL,
  `countryCode` varchar(5) DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT NULL,
  `updatedAt` timestamp NULL DEFAULT NULL,
  `isDeleted` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS EventLocalBroadcaster;
CREATE TABLE `EventLocalBroadcaster` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `event_id` int(11) DEFAULT NULL,
  `local_broadcaster_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `EventLocalBroadcaster_Event` (`event_id`),
  KEY `EventLocalBroadcaster_LocalBroadcaster` (`local_broadcaster_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS PropertyLocalBroadcaster;
CREATE TABLE `PropertyLocalBroadcaster` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `property_id` int(11) DEFAULT NULL,
  `local_broadcaster_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `PropertyLocalBroadcaster_Property` (`property_id`),
  KEY `PropertyLocalBroadcaster_LocalBroadcaster` (`local_broadcaster_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS TournamentLocalBroadcaster;
CREATE TABLE `TournamentLocalBroadcaster` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `tournament_id` int(11) DEFAULT NULL,
  `local_broadcaster_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `TournamentLocalBroadcaster_Tournament` (`tournament_id`),
  KEY `TournamentLocalBroadcaster_LocalBroadcaster` (`local_broadcaster_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS GeoTemplate;
CREATE TABLE `GeoTemplate` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `geoListField` varchar(2048) NOT NULL DEFAULT '[]',
  `isWhiteList` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `Role`;

CREATE TABLE `Role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `UK_Role_name` UNIQUE (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `Epg`;
CREATE TABLE `Epg` (
    `provider` VARCHAR(191) NOT NULL,
    `providerId` VARCHAR(191) NOT NULL,
    `url` TEXT NOT NULL,
    `languageCode` VARCHAR(64) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    KEY `Key_Epg_Provider` (`provider`),
    KEY `Key_Epg_ProviderId` (`providerId`),
    CONSTRAINT `UC_EpgKey` UNIQUE (`provider`, `providerId`, `languageCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ================
-- INSERTS (previously on db_insert.sql)
-- ================

INSERT INTO `Role` (`id`, `name`)
    VALUES
    (1, 'TRADER'),
    (2, 'SUPER_ADMIN'),
    (3, 'OPERATOR'),
    (4, 'ENGINEER'),
    (5, 'IMG'),
    (6, 'ADMIN');

insert into Operator(id, createdat,logoUrl,maincontactemail,maincontactname,maincontacttel,maxtraders,name, secret, supplementarySecret, notificationEmails)
    values(1, STR_TO_DATE('01.5.2013','%d.%m.%Y'),'/assets/bet365.png',null,null,null,10,'operator2', 'secretkey', 'suppSecret','img-dev@livestream.com');

insert into Operator(id, createdat,logoUrl,maincontactemail,maincontactname,maincontacttel,maxtraders,name, secret, supplementarySecret, notificationEmails)
    values(2, STR_TO_DATE('01.5.2013','%d.%m.%Y'),'/assets/bet365.png',null,null,null,10,'operator1', 'othersecretkey', 'otherSuppSecret' ,'img-dev@livestream.com');

INSERT INTO Account (alternateNumber,createdAt,dateLocked,dateOfBirth,email,escalationNumber,fullName,id,isDeleted,lastLogin,mainNumber,operator_id,password,role,timezone, role_id)
    VALUES(NULL, STR_TO_DATE('01.5.2013','%d.%m.%Y'), NULL, NULL, "admin@mail.com", NULL, "User", 1, FALSE, NULL, NULL, null, md5("1234"), "SUPER_ADMIN", "+2", 2);

INSERT INTO Account (alternateNumber,createdAt,dateLocked,dateOfBirth,email,escalationNumber,fullName,id,isDeleted,lastLogin,mainNumber,operator_id,password,role,timezone, role_id)
    VALUES(NULL, STR_TO_DATE('01.5.2013','%d.%m.%Y'), NULL, NULL, "operator@mail.com", NULL, "Tom Sower", 2, FALSE, NULL, NULL, 1, md5("1234"), "OPERATOR", "+2", 3);

INSERT INTO Account (alternateNumber,createdAt,dateLocked,dateOfBirth,email,escalationNumber,fullName,id,isDeleted,lastLogin,mainNumber,operator_id,password,role,timezone, role_id)
    VALUES(NULL, STR_TO_DATE('01.5.2013','%d.%m.%Y'), NULL, NULL, "user-4@mail.com", NULL, "Jack London", 3, FALSE, NULL, NULL, 1, md5("1234"), "TRADER", "+2", 1);

INSERT INTO Account (alternateNumber,createdAt,dateLocked,dateOfBirth,email,escalationNumber,fullName,id,isDeleted,lastLogin,mainNumber,operator_id,password,role,timezone, role_id)
    VALUES(NULL, STR_TO_DATE('01.5.2013','%d.%m.%Y'), NULL, NULL, "root@mail.com", NULL, "ROOT", 14, FALSE, NULL, NULL, null, md5("1234"), "SUPER_ADMIN", "+2", 2);

INSERT INTO Account (alternateNumber,createdAt,dateLocked,dateOfBirth,email,escalationNumber,fullName,id,isDeleted,lastLogin,mainNumber,operator_id,password,role,timezone, role_id)
    VALUES(NULL, STR_TO_DATE('01.5.2013','%d.%m.%Y'), NULL, NULL, "imguser@mail.com", NULL, "IMG User", 15, FALSE, NULL, NULL, null, md5("1234"), "IMG", "+2", 5);

INSERT INTO ZixiServer(id, ip, region, username, password, createdAt) VALUES (1, '34.254.31.148', 'EU', 'admin', 'lszixitrans', current_timestamp());

INSERT INTO Sport (id, name, color, createdAt) VALUES(1, "Sport1", "#e28925", current_timestamp());
INSERT INTO Property (id, logoUrl, name, sport_id, multiCDN, createdAt) VALUES(1, "/images/nba.png", "Property1", 1, 0, current_timestamp());
INSERT INTO Tournament (id, posterLocation, name, property_id, startDate, endDate, createdAt)
    VALUES(1, "", "Tournamnet1", 1, UTC_TIMESTAMP() - interval 4 day, UTC_TIMESTAMP() + interval 10 day, current_timestamp());
INSERT INTO Tournament (id,  posterLocation,name, property_id, startDate, endDate, geoListField, isWhiteList, createdAt)
    VALUES(2, "", "Tournamnet2", 1, UTC_TIMESTAMP() - interval 4 day, UTC_TIMESTAMP() + interval 10 day, '["GB"]', 0, current_timestamp());

INSERT INTO `License` ( `createdAt`, `geoListField`, `id`, `isWhiteList`, `operator_id`, `property_id`, `maxEvents`)
    VALUES (STR_TO_DATE('01.5.2013','%d.%m.%Y'), '["GB", "US", "NL"]', 1, TRUE, 1, 1, 300);

INSERT INTO `LicensingPeriod` (`createdAt`, `start`, `end`, `purchasedEvents`, `license_id`) VALUES (now(), STR_TO_DATE('01.5.2013','%d.%m.%Y'), STR_TO_DATE('01.5.2015','%d.%m.%Y'), 100, 1);


INSERT INTO Property (id, logoUrl, name, sport_id, multiCDN, createdAt) VALUES(2, "/images/nba.png", "Property2", 1, 1, current_timestamp());
INSERT INTO Tournament (id,  name, property_id, startDate, endDate, createdAt)
    VALUES(3, "Tournamnet3", 2, UTC_TIMESTAMP() - interval 4 day, UTC_TIMESTAMP() + interval 10 day, current_timestamp());

INSERT INTO `License` ( `createdAt`, `geoListField`, `id`, `isWhiteList`, `operator_id`, `property_id`, `maxEvents`)
    VALUES (STR_TO_DATE('01.5.2013','%d.%m.%Y'), '["IN", "US"]', 2, TRUE, 2, 2, 300);

INSERT INTO `LicensingPeriod` (`createdAt`, `start`, `end`, `purchasedEvents`, `license_id`) VALUES (now(), STR_TO_DATE('01.5.2013','%d.%m.%Y'), STR_TO_DATE('01.5.2015','%d.%m.%Y'), 100, 2);

INSERT INTO `License` ( `createdAt`, `geoListField`, `id`, `isWhiteList`, `operator_id`, `property_id`, `maxEvents`)
    VALUES (STR_TO_DATE('01.5.2013','%d.%m.%Y'), '["GB", "US", "NL"]', 3, TRUE, 1, 2, 300);

INSERT INTO `LicensingPeriod` (`createdAt`, `start`, `end`, `purchasedEvents`, `license_id`) VALUES (now(), STR_TO_DATE('01.5.2013','%d.%m.%Y'), STR_TO_DATE('01.5.2015','%d.%m.%Y'), 100, 3);

INSERT INTO Event (id,contacts,createdAt, startDate, endDate, commentary,location, posterLocation, title,streamingConfig_id, tournament_id,updatedAt)
    VALUES(1,'{"contacts":[{"name":"David Salmon", "title":"IMG Manager", "number":"01234567890"},{"name":"second contact", "title":"IMG Manager", "number":"01234567890"}]}',
       STR_TO_DATE('02.7.2013','%d.%m.%Y'),
       UTC_TIMESTAMP() - interval 2 day,
       UTC_TIMESTAMP() - interval 1 day,
       'EN',
       "",
       "https://img.dge-dev.dicelaboratory.com/original/2018/11/30/IMG-Stripes-poster-dge.png",
       "E1",
       NULL,
       1,
       STR_TO_DATE('01.8.2013','%d.%m.%Y')
      );

INSERT INTO Event (id,contacts,createdAt, startDate, endDate, commentary,location,posterLocation, title,streamingConfig_id, tournament_id,updatedAt)
    VALUES(2,'{"contacts":[{"name":"David Salmon", "title":"IMG Manager", "number":"01234567890"},{"name":"second contact", "title":"IMG Manager", "number":"01234567890"}]}',
       STR_TO_DATE('02.7.2013','%d.%m.%Y'),
       UTC_TIMESTAMP() - interval 1 day,
       UTC_TIMESTAMP() + interval 1 day,
       'EN',
       "",
       "https://img.dge-dev.dicelaboratory.com/original/2018/11/30/IMG-Stripes-poster-dge.png",
       "E2",
       NULL,
       1,
       STR_TO_DATE('01.8.2013','%d.%m.%Y')
      );

INSERT INTO `StreamingConfig` (`id`, `zixiServer_id`,`zixiStreamId`, `zixiOutputPrefix`, `isLive`)
    VALUES (3,1,'exchange_3', 'exchange_3', 1);
INSERT INTO Event (id,contacts,createdAt, startDate, endDate, commentary,location,posterLocation, title,streamingConfig_id, tournament_id,updatedAt)
    VALUES(3,'{"contacts":[{"name":"David Salmon", "title":"IMG Manager", "number":"01234567890"},{"name":"second contact", "title":"IMG Manager", "number":"01234567890"}]}',
       STR_TO_DATE('02.7.2013','%d.%m.%Y'),
       UTC_TIMESTAMP() - interval 2 day,
       UTC_TIMESTAMP() - interval 1 day,
       'EN',
       "",
       "https://img.dge-dev.dicelaboratory.com/original/2018/11/30/IMG-Stripes-poster-dge.png",
       "E3",
       3,
       1,
       STR_TO_DATE('01.8.2013','%d.%m.%Y')
      );

INSERT INTO `StreamingConfig` (`id`, `zixiServer_id`,`zixiStreamId`, `zixiOutputPrefix`, `isLive`)
    VALUES (4,1,'exchange_4', 'exchange_4', 1);
INSERT INTO Event (id,contacts,createdAt, startDate, endDate, commentary,location,posterLocation, title,streamingConfig_id, tournament_id,updatedAt, geoListField, isWhiteList)
    VALUES(4,'{"contacts":[{"name":"David Salmon", "title":"IMG Manager", "number":"01234567890"},{"name":"second contact", "title":"IMG Manager", "number":"01234567890"}]}',
       STR_TO_DATE('02.7.2013','%d.%m.%Y'),
       UTC_TIMESTAMP() + interval 1 day,
       UTC_TIMESTAMP() + interval 1 day,
       'EN',
       "",
       "https://img.dge-dev.dicelaboratory.com/original/2018/11/30/IMG-Stripes-poster-dge.png",
       "E4",
       NULL,
       1,
       STR_TO_DATE('01.8.2013','%d.%m.%Y'),
       "[IN]",
       0
      );

INSERT INTO `StreamingConfig` (`id`, `zixiServer_id`,`zixiStreamId`, `zixiOutputPrefix`, `isLive`)
    VALUES (5,1,'exchange_5', 'exchange_5', 1);
INSERT INTO Event (id,contacts,createdAt, startDate, endDate, commentary,location,posterLocation, title,streamingConfig_id, tournament_id,updatedAt)
    VALUES(5,'{"contacts":[{"name":"David Salmon", "title":"IMG Manager", "number":"01234567890"},{"name":"second contact", "title":"IMG Manager", "number":"01234567890"}]}',
       STR_TO_DATE('02.7.2013','%d.%m.%Y'),
       UTC_TIMESTAMP() + interval 1 day,
       UTC_TIMESTAMP() + interval 1 day,
       'EN',
       "",
       "https://img.dge-dev.dicelaboratory.com/original/2018/11/30/IMG-Stripes-poster-dge.png",
       "E5",
       NULL,
       1,
       STR_TO_DATE('01.8.2013','%d.%m.%Y')
      );

INSERT INTO `StreamingConfig` (`id`, `zixiServer_id`,`zixiStreamId`, `zixiOutputPrefix`, `isLive`)
    VALUES (6,1,'exchange_6', 'exchange_6', 1);
INSERT INTO Event (id,contacts,createdAt, startDate, endDate, commentary,location,posterLocation, title,streamingConfig_id, tournament_id,updatedAt)
    VALUES(6,'{"contacts":[{"name":"David Salmon", "title":"IMG Manager", "number":"01234567890"},{"name":"second contact", "title":"IMG Manager", "number":"01234567890"}]}',
       STR_TO_DATE('02.7.2013','%d.%m.%Y'),
       UTC_TIMESTAMP() + interval 1 day,
       UTC_TIMESTAMP() + interval 1 day,
       'EN',
       "",
       "https://img.dge-dev.dicelaboratory.com/original/2018/11/30/IMG-Stripes-poster-dge.png",
       "E6",
       6,
       2,
       STR_TO_DATE('01.8.2013','%d.%m.%Y')
      );

INSERT INTO Event (id,contacts,createdAt, startDate, endDate, commentary,location,posterLocation, title,streamingConfig_id, tournament_id,updatedAt)
    VALUES(7,'{"contacts":[{"name":"David Salmon", "title":"IMG Manager", "number":"01234567890"},{"name":"second contact", "title":"IMG Manager", "number":"01234567890"}]}',
       STR_TO_DATE('02.7.2013','%d.%m.%Y'),
       UTC_TIMESTAMP() + interval 1 day,
       UTC_TIMESTAMP() + interval 1 day,
       'EN',
       "",
       "https://img.dge-dev.dicelaboratory.com/original/2018/11/30/IMG-Stripes-poster-dge.png",
       "E7",
       NULL,
       2,
       STR_TO_DATE('01.8.2013','%d.%m.%Y')
      );

INSERT INTO `StreamingConfig` (`id`, `zixiServer_id`,`zixiStreamId`, `zixiOutputPrefix`, `isLive`)
    VALUES (8,1,'exchange_8', 'exchange_8', 1);
INSERT INTO Event (id,contacts,createdAt, startDate, endDate, commentary,location,posterLocation, title,streamingConfig_id, tournament_id,updatedAt)
    VALUES(8,'{"contacts":[{"name":"David Salmon", "title":"IMG Manager", "number":"01234567890"},{"name":"second contact", "title":"IMG Manager", "number":"01234567890"}]}',
       STR_TO_DATE('02.7.2013','%d.%m.%Y'),
       UTC_TIMESTAMP() + interval 1 day,
       UTC_TIMESTAMP() + interval 1 day,
       'EN',
       "",
       "https://img.dge-dev.dicelaboratory.com/original/2018/11/30/IMG-Stripes-poster-dge.png",
       "E8",
       8,
       3,
       STR_TO_DATE('01.8.2013','%d.%m.%Y')
      );

-- A deleted event
INSERT INTO Event (id,contacts,createdAt, startDate, endDate, commentary,location,posterLocation, title,streamingConfig_id, tournament_id,updatedAt, isDeleted)
    VALUES(9,'{"contacts":[{"name":"David Salmon", "title":"IMG Manager", "number":"01234567890"},{"name":"second contact", "title":"IMG Manager", "number":"01234567890"}]}',
       STR_TO_DATE('02.7.2013','%d.%m.%Y'),
       UTC_TIMESTAMP() + interval 1 day,
       UTC_TIMESTAMP() + interval 1 day,
       'EN',
       "",
       "https://img.dge-dev.dicelaboratory.com/original/2018/11/30/IMG-Stripes-poster-dge.png",
       "E9",
       null,
       3,
       STR_TO_DATE('01.8.2013','%d.%m.%Y'),
       1
      );

-- A deleted event in the future
INSERT INTO Event (id,contacts,createdAt, startDate, endDate, commentary,location,posterLocation, title,streamingConfig_id, tournament_id,updatedAt, isDeleted)
    VALUES(10,'{"contacts":[{"name":"David Salmon", "title":"IMG Manager", "number":"01234567890"},{"name":"second contact", "title":"IMG Manager", "number":"01234567890"}]}',
       STR_TO_DATE('02.7.2023','%d.%m.%Y'),
       UTC_TIMESTAMP() + interval 1 day,
       UTC_TIMESTAMP() + interval 1 day,
       'EN',
       "",
       "https://img.dge-dev.dicelaboratory.com/original/2018/11/30/IMG-Stripes-poster-dge.png",
       "E10",
       null,
       3,
       STR_TO_DATE('01.8.2013','%d.%m.%Y'),
       1
      );

-- A deleted event in the future
INSERT INTO Event (id,contacts,createdAt, startDate, endDate, commentary,location, title,streamingConfig_id, tournament_id,updatedAt, isDeleted)
    VALUES(11,'{"contacts":[{"name":"David Salmon", "title":"IMG Manager", "number":"01234567890"},{"name":"second contact", "title":"IMG Manager", "number":"01234567890"}]}',
       STR_TO_DATE('02.7.2023','%d.%m.%Y'),
       UTC_TIMESTAMP() + interval 1 day,
       UTC_TIMESTAMP() + interval 1 day,
       'EN',
       "",
       "E10",
       null,
       3,
       STR_TO_DATE('01.8.2013','%d.%m.%Y'),
       1
      );
INSERT INTO `OperatorEvent` ( `createdAt`, `event_id`, `operator_id`, `license_id`) VALUES ( STR_TO_DATE('01.5.2013','%d.%m.%Y'), 1, 1, 1);
INSERT INTO `OperatorEvent` ( `createdAt`, `event_id`, `operator_id`, `license_id`) VALUES ( STR_TO_DATE('01.5.2013','%d.%m.%Y'), 2, 1, 1);
INSERT INTO `OperatorEvent` ( `createdAt`, `event_id`, `operator_id`, `license_id`) VALUES ( STR_TO_DATE('01.5.2013','%d.%m.%Y'), 3, 1, 1);
INSERT INTO `OperatorEvent` ( `createdAt`, `event_id`, `operator_id`, `license_id`) VALUES ( STR_TO_DATE('01.5.2013','%d.%m.%Y'), 4, 1, 1);
INSERT INTO `OperatorEvent` ( `createdAt`, `event_id`, `operator_id`, `license_id`) VALUES ( STR_TO_DATE('01.5.2013','%d.%m.%Y'), 5, 1, 1);
INSERT INTO `OperatorEvent` ( `createdAt`, `event_id`, `operator_id`, `license_id`) VALUES ( STR_TO_DATE('01.5.2013','%d.%m.%Y'), 6, 1, 1);
INSERT INTO `OperatorEvent` ( `createdAt`, `event_id`, `operator_id`, `license_id`) VALUES ( STR_TO_DATE('01.5.2013','%d.%m.%Y'), 7, 1, 1);
INSERT INTO `OperatorEvent` ( `createdAt`, `event_id`, `operator_id`, `license_id`) VALUES ( STR_TO_DATE('01.5.2013','%d.%m.%Y'), 8, 2, 2);


insert into PublishingPoint(id, createdAt, backupPoint, isProvisioned, playbackUrl, password, primaryPoint, provisioningIp, streamId, streamName, username, isAvailable, ingestProtocol, playbackProtocol, isLive, streamingConfig_id, region, backupRegion)
    values
    (1,  current_timestamp(), 'rtmp://b.ep170325.i.akamaientrypoint.net/EntryPoint', 1, 'rtmp://cp231373.live.edgefcs.net/live/',                                    '5vJF5d','rtmp://p.ep170325.i.akamaientrypoint.net/EntryPoint','204.77.212.143', 's1703251','exchangedev_5@s1703251', '231373',1, 'RTMP', 'RTMP', 0, 3, 'EU', 'EU'),
    (2,  current_timestamp(), 'rtmp://b.ep154077.i.akamaientrypoint.net/EntryPoint', 1,'http://exchange_hls_tes-lh.akamaized.net/i/[EVENT_ANGLE]@154077/master.m3u8', 'de6wGm','rtmp://p.ep154077.i.akamaientrypoint.net/EntryPoint','204.77.212.143', '15407732','exchangeback-hls_123a', '257523',1, 'RTMP', 'HLS', 0, 3, 'EU', 'EU'),
    (14,  current_timestamp(), 'rtmp://b.ep154077.i.akamaientrypoint.net/EntryPoint', 1,'http://exchange_hls_tes-lh.akamaized.net/i/[EVENT_ANGLE]@154077/master.m3u8', 'de6wGm','rtmp://p.ep154077.i.akamaientrypoint.net/EntryPoint','204.77.212.143', '15407732','exchangeback-hls_123321', '257523',1, 'HLS', 'HLSV2', 0, 3, 'EU', 'EU'),
    (3,  current_timestamp(), 'rtmp://b.ep170325.i.akamaientrypoint.net/EntryPoint', 1, 'rtmp://cp231373.live.edgefcs.net/live/',                                    '5vJF5d','rtmp://p.ep170325.i.akamaientrypoint.net/EntryPoint','204.77.212.143', 's1703252','exchangedev_5@s1703252', '231373',1, 'RTMP', 'RTMP', 0, 4, 'EU', 'EU'),
    (4,  current_timestamp(), 'rtmp://b.ep154077.i.akamaientrypoint.net/EntryPoint', 1,'http://exchange_hls_tes-lh.akamaized.net/i/[EVENT_ANGLE]@154077/master.m3u8', 'de6wGm','rtmp://p.ep154077.i.akamaientrypoint.net/EntryPoint','204.77.212.143', '154077234','exchangeback-hls_12423aaa', '257523',1, 'RTMP', 'HLS', 0, 4, 'EU', 'EU'),
    (16,  current_timestamp(), 'rtmp://b.ep154077.i.akamaientrypoint.net/EntryPoint', 1,'http://exchange_hls_tes-lh.akamaized.net/i/[EVENT_ANGLE]@154077/master.m3u8', 'de6wGm','rtmp://p.ep154077.i.akamaientrypoint.net/EntryPoint','204.77.212.143', '154077234','exchangeback-hls_12423', '257523',1, 'HLS', 'HLSV2', 0, 4, 'EU', 'EU'),
    (5,  current_timestamp(), 'rtmp://b.ep170325.i.akamaientrypoint.net/EntryPoint', 1, 'rtmp://cp231373.live.edgefcs.net/live/',                                    '5vJF5d','rtmp://p.ep170325.i.akamaientrypoint.net/EntryPoint','204.77.212.143', 's1703253231','exchangedev_5@s1703253311123', '231373',1, 'RTMP', 'RTMP', 0, 5, 'EU', 'EU'),
    (6,  current_timestamp(), 'rtmp://b.ep154077.i.akamaientrypoint.net/EntryPoint', 1, 'http://exchange_hls_tes-lh.akamaized.net/i/[EVENT_ANGLE]@154077/master.m3u8','de6wGm','rtmp://p.ep154077.i.akamaientrypoint.net/EntryPoint','204.77.212.143', '154077dsd','exchangeback-hls_1sdfa', '257523',1, 'RTMP', 'HLS', 0, 5, 'EU', 'EU'),
    (15,  current_timestamp(), 'rtmp://b.ep154077.i.akamaientrypoint.net/EntryPoint', 1, 'http://exchange_hls_tes-lh.akamaized.net/i/[EVENT_ANGLE]@154077/master.m3u8','de6wGm','rtmp://p.ep154077.i.akamaientrypoint.net/EntryPoint','204.77.212.143', '154077dsd','exchangeback-hls_1sdf', '257523',1, 'HLS', 'HLSV2', 0, 5, 'EU', 'EU'),
    (7,  current_timestamp(), 'rtmp://b.ep170325.i.akamaientrypoint.net/EntryPoint', 1, 'rtmp://cp231373.live.edgefcs.net/live/',                                    '5vJF5d','rtmp://p.ep170325.i.akamaientrypoint.net/EntryPoint','204.77.212.143', 's170325wer','exchangedev_5@s170325wer', '231373', 1, 'RTMP', 'RTMP', 0, 8, 'EU', 'EU'),
    (8,  current_timestamp(), 'rtmp://b.ep154077.i.akamaientrypoint.net/EntryPoint', 1, 'http://exchange_hls_tes-lh.akamaized.net/i/[EVENT_ANGLE]@154077/master.m3u8','de6wGm','rtmp://p.ep154077.i.akamaientrypoint.net/EntryPoint','204.77.212.143', '154077juy','exchangeback-hls_1jy33u1ff', '257523',1 , 'RTMP', 'HLS', 0, 8, 'EU', 'EU'),
    (9,  current_timestamp(), 'rtmp://b.ep170325.i.akamaientrypoint.net/EntryPoint', 1, 'rtmp://cp231373.live.edgefcs.net/live/',                                    '5vJF5d','rtmp://p.ep170325.i.akamaientrypoint.net/EntryPoint','204.77.212.143', 's170325we3r','exchangedev_5@s1703325wer', '231373',1, 'RTMP', 'RTMPE', 0, 3, 'EU', 'EU'),
    (10, current_timestamp(), 'rtmp://b.ep154077.i.akamaientrypoint.net/EntryPoint', 1, 'http://exchange_hls_tes-lh.akamaized.net/i/[EVENT_ANGLE]@154077/master.m3u8','de6wGm','rtmp://p.ep154077.i.akamaientrypoint.net/EntryPoint','204.77.212.143', '154077j3uy','exchangeback-hls_1jyu1df', '257523',1, 'RTMP', 'HLS', 0, 3, 'EU', 'EU'),
    (11, current_timestamp(), 'rtmp://b.ep170325.i.akamaientrypoint.net/EntryPoint', 1, 'rtmp://cp231373.live.edgefcs.net/live/',                                    '5vJF5d','rtmp://p.ep170325.i.akamaientrypoint.net/EntryPoint','204.77.212.143', 's170325w33er','exchangedev_5@s17032533wer','231373',1, 'RTMP', 'RTMPE', 0, 8, 'EU', 'EU'),
    (13, current_timestamp(), 'rtmp://b.ep154077.i.akamaientrypoint.net/EntryPoint', 1, 'http://exchange_hls_tes-lh.akamaized.net/i/[EVENT_ANGLE]@154077/master.m3u8','de6wGm','rtmp://p.ep154077.i.akamaientrypoint.net/EntryPoint','204.77.212.143', '154077juy33','exchangeback-hls_1jyu667','257523',1, 'HLS', 'HLSV2', 0, 8, 'EU', 'EU');

INSERT INTO `ExternalServices` (`id`, `name`, `uri`)
    VALUES (1, 'STREAMING_API', 'https://localhost:8181'),
       (2, 'SHIELD_API', 'https://localhost:8282');

INSERT INTO `AppSettings`(`name`, `value`, `defValue`, `lastUpdate`, `type`, `context`)
    VALUES ('MCDN_PROVIDERS', 'AKAMAI,FASTLY,LIMELIGHT', 'AKAMAI,FASTLY,LIMELIGHT', now(), 'STRING', 'EXCHANGE'),
       ('AKAMAI_DISABLED', 'true', 'true', now(), 'BOOLEAN', 'EXCHANGE');


SET foreign_key_checks = 1;
