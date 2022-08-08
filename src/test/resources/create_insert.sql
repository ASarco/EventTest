-- ================
-- INSERTS (previously on create.sql)
-- ================


SET foreign_key_checks = 0;


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
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `geoListField` varchar(2048) NOT NULL DEFAULT '[]',
  `isWhiteList` tinyint(1) NOT NULL DEFAULT 0,
  `maxConcurrentViewers` int(11) DEFAULT -1,
  `isSLAFailure` TINYINT(1) DEFAULT 0,
  `slaFailureComment` varchar(1020) DEFAULT NULL,
  `isDeleted` int(1) DEFAULT 0,
  `court` varchar(255) DEFAULT NULL,
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

#CREATE INDEX Event_deleted_endDate_startDate_index ON Event(isDeleted,endDate,startDate);
#CREATE INDEX Event_deleted_startDate_endDate_index ON Event(isDeleted,startDate,endDate);


-- ================
-- INSERTS (previously on db_insert.sql)
-- ================


INSERT INTO Event (id,contacts,createdAt, startDate, endDate, commentary,location, posterLocation, title, updatedAt)
    VALUES(1,'{"contacts":[{"name":"David Salmon", "title":"IMG Manager", "number":"01234567890"},{"name":"second contact", "title":"IMG Manager", "number":"01234567890"}]}',
       STR_TO_DATE('02.7.2013','%d.%m.%Y'),
       UTC_TIMESTAMP() - interval 2 day,
       UTC_TIMESTAMP() - interval 1 day,
       'EN',
       "",
       "https://img.dge-dev.dicelaboratory.com/original/2018/11/30/IMG-Stripes-poster-dge.png",
       "E1",
       STR_TO_DATE('01.8.2013','%d.%m.%Y')
      );

INSERT INTO Event (id,contacts,createdAt, startDate, endDate, commentary,location,posterLocation, title, updatedAt)
    VALUES(2,'{"contacts":[{"name":"David Salmon", "title":"IMG Manager", "number":"01234567890"},{"name":"second contact", "title":"IMG Manager", "number":"01234567890"}]}',
       STR_TO_DATE('02.7.2013','%d.%m.%Y'),
       UTC_TIMESTAMP() - interval 1 day,
       UTC_TIMESTAMP() + interval 1 day,
       'EN',
       "",
       "https://img.dge-dev.dicelaboratory.com/original/2018/11/30/IMG-Stripes-poster-dge.png",
       "E2",
       STR_TO_DATE('01.8.2013','%d.%m.%Y')
      );


SET foreign_key_checks = 1;
