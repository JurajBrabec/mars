# MARS 4.1 CREATE SQL FILE
# DON`T MODIFY ANYTHING BELOW THIS LINE ███████████████████████████████████████████████████████████████████████████████
# © 2018 Juraj Brabec, DXC.technology

USE `mysql`;
DROP DATABASE IF EXISTS `mars40`;
CREATE DATABASE IF NOT EXISTS `mars40` /*!40100 DEFAULT CHARACTER SET utf8 */;

UPDATE mysql.user SET Host = '%',Password = PASSWORD('r00t123') WHERE User = 'root' AND Host = 'localhost';
DELETE FROM mysql.user WHERE ( User <>'root' ) OR ( User = 'root' AND Host <> '%' );
#DROP USER IF EXISTS 'operator','script','administrator';
CREATE USER 'operator';
CREATE USER 'script' IDENTIFIED BY 'omniback';
CREATE USER 'administrator' IDENTIFIED BY 'admin';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'operator'@'%','script'@'%','administrator'@'%';

GRANT SELECT, INSERT, UPDATE, EXECUTE, EVENT ON mars40.* TO 'operator'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON mars40.* TO 'script'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE, EVENT ON mars40.* TO 'administrator'@'%';
FLUSH PRIVILEGES;

USE `mars40`;

DELIMITER //
DROP FUNCTION IF EXISTS `f_customer`//
CREATE DEFINER=`root`@`%` FUNCTION `f_customer`() RETURNS varchar(64) CHARSET utf8
    NO SQL
    DETERMINISTIC
    COMMENT 'Customer filter function'
BEGIN
RETURN NULLIF(@customer,'');
END//

DROP FUNCTION IF EXISTS `f_from`//
CREATE DEFINER=`root`@`%` FUNCTION `f_from`() RETURNS int(11)
    NO SQL
    DETERMINISTIC
    COMMENT 'Datetime from filter function'
BEGIN
RETURN UNIX_TIMESTAMP(IFNULL(NULLIF(@datetime_from,''),DATE(SUBDATE(NOW(), interval 1 MONTH))));
END//

DROP FUNCTION IF EXISTS `f_to`//
CREATE DEFINER=`root`@`%` FUNCTION `f_to`() RETURNS int(11)
    NO SQL
    DETERMINISTIC
    COMMENT 'Datetime to filter function'
BEGIN
RETURN UNIX_TIMESTAMP(IFNULL(NULLIF(@datetime_to,''),DATE(ADDDATE(NOW(), interval 1 DAY))) - INTERVAL 1 SECOND);
END//

DROP FUNCTION IF EXISTS `f_tower`//
CREATE DEFINER=`root`@`%` FUNCTION `f_tower`() RETURNS varchar(32) CHARSET utf8
    NO SQL
    DETERMINISTIC
    COMMENT 'Tower filter function'
BEGIN
RETURN NULLIF(@tower,'');
END//
DELIMITER ;

DROP TABLE IF EXISTS `core_admin_fields`;
CREATE TABLE `core_admin_fields` (
	`source` VARCHAR(32) NOT NULL,
	`ord` TINYINT(3) UNSIGNED NOT NULL,
	`name` VARCHAR(32) NOT NULL,
	`title` VARCHAR(32) NULL DEFAULT NULL,
	`created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`obsoleted` TIMESTAMP NULL DEFAULT NULL,
	PRIMARY KEY (`source`, `ord`, `name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='List of predefined Admin report fields';

DROP TABLE IF EXISTS `core_admin_sources`;
CREATE TABLE `core_admin_sources` (
	`ord` TINYINT(3) UNSIGNED NOT NULL,
	`name` VARCHAR(32) NOT NULL,
	`title` VARCHAR(32) NOT NULL,
	`description` VARCHAR(64) NULL DEFAULT NULL,
	`created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`obsoleted` TIMESTAMP NULL DEFAULT NULL,
	PRIMARY KEY (`ord`, `name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='List of predefined Admin report sources';

DROP TABLE IF EXISTS `core_fields`;
CREATE TABLE IF NOT EXISTS `core_fields` (
  `source` varchar(32) NOT NULL,
  `ord` tinyint(3) unsigned NOT NULL,
  `name` varchar(32) NOT NULL,
  `title` varchar(32) DEFAULT NULL,
  `type` enum('FLOAT','NUMBER','STRING','DATE','TIME') NOT NULL,
  `link` varchar(32) DEFAULT NULL,
  `description` varchar(64) DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `obsoleted` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`source`,`ord`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='List of predefined report fields';

DROP TABLE IF EXISTS `core_filters`;
CREATE TABLE IF NOT EXISTS `core_filters` (
  `report` varchar(32) NOT NULL,
  `ord` tinyint(3) unsigned NOT NULL,
  `source` varchar(32) NOT NULL,
  `field` varchar(32) NOT NULL,
  `operator` varchar(32) NOT NULL,
  `value` varchar(32) DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `obsoleted` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`report`,`ord`,`source`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='List of predefined report filters';

DROP TABLE IF EXISTS `core_formats`;
CREATE TABLE IF NOT EXISTS `core_formats` (
  `report` varchar(64) NOT NULL,
  `ord` tinyint(3) unsigned NOT NULL,
  `source` varchar(64) NOT NULL,
  `field` varchar(32) NOT NULL,
  `operator` varchar(32) NOT NULL,
  `value` varchar(32) DEFAULT NULL,
  `style` varchar(64) NOT NULL,
  `description` varchar(64) NOT NULL,
  `fields` varchar(64) DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `obsoleted` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`report`,`ord`,`source`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='List of predefined report formats';

DROP TABLE IF EXISTS `core_links`;
CREATE TABLE IF NOT EXISTS `core_links` (
  `source` varchar(32) NOT NULL,
  `field` varchar(32) NOT NULL,
  `ord` tinyint(3) unsigned NOT NULL,
  `target` varchar(32) NOT NULL,
  `filter` varchar(32) NOT NULL,
  `operator` varchar(32) NOT NULL,
  `value` varchar(32) DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `obsoleted` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`source`,`field`,`ord`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='List of predefined report links';

DROP TABLE IF EXISTS `core_reports`;
CREATE TABLE IF NOT EXISTS `core_reports` (
  `ord` tinyint(3) unsigned NOT NULL,
  `name` varchar(32) NOT NULL,
  `category` varchar(32) DEFAULT NULL,
  `title` varchar(32) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `obsoleted` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`ord`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='List of predefined reports';

DROP TABLE IF EXISTS `core_sorts`;
CREATE TABLE IF NOT EXISTS `core_sorts` (
  `report` varchar(32) NOT NULL,
  `ord` tinyint(3) unsigned NOT NULL,
  `source` varchar(32) NOT NULL,
  `field` varchar(32) NOT NULL,
  `sort` enum('ASC','DESC') NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `obsoleted` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`report`,`ord`,`source`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='List of predefined report sorts';

DROP TABLE IF EXISTS `core_sources`;
CREATE TABLE IF NOT EXISTS `core_sources` (
  `report` varchar(32) NOT NULL,
  `ord` tinyint(3) unsigned NOT NULL,
  `name` varchar(32) NOT NULL,
  `title` varchar(32) NOT NULL,
  `description` varchar(64) NOT NULL,
  `fields` text,
  `link` varchar(32) DEFAULT NULL,
  `pivot` varchar(32) DEFAULT NULL,
  `tower` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `customer` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `timeperiod` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `limit` tinyint(3) unsigned NOT NULL DEFAULT '10',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `obsoleted` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`report`,`ord`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='List of predefined report sources';

INSERT INTO `core_admin_fields` (`source`, `ord`, `name`, `title`, `created`, `updated`, `obsoleted`) VALUES
	('customers', 1, 'name', 'Customer name', '2017-05-15 13:08:12', '2017-05-15 13:08:12', NULL),
	('customers', 2, 'policyname', 'Policy name pattern', '2017-05-15 13:08:33', '2017-05-15 13:08:33', NULL),
	('customers', 3, 'created', 'Created', '2017-05-15 13:08:53', '2017-05-15 13:08:53', NULL),
	('customers', 4, 'updated', 'Updated', '2017-05-15 13:09:07', '2017-05-15 13:09:07', NULL),
	('customers', 5, 'obsoleted', 'Obsoleted', '2017-05-15 13:09:21', '2017-05-15 13:09:28', NULL),
	('scheduledreports', 1, 'date', 'Date pattern', '2017-05-15 13:24:21', '2017-05-15 13:25:45', NULL),
	('scheduledreports', 2, 'time', 'Time pattern', '2017-05-15 13:24:35', '2017-05-15 13:25:47', NULL),
	('scheduledreports', 4, 'title', 'Title', '2017-05-15 13:17:44', '2017-05-15 13:25:51', NULL),
	('scheduledreports', 5, 'tower', 'Tower', '2017-05-15 13:18:05', '2017-05-15 13:50:58', NULL),
	('scheduledreports', 6, 'customer', 'Customer', '2017-05-15 13:18:14', '2017-05-15 13:50:59', NULL),
	('scheduledreports', 7, 'timeperiod', 'Time period', '2017-05-15 13:18:24', '2017-05-15 13:51:01', NULL),
	('scheduledreports', 8, 'mode', 'Mode', '2017-05-15 13:24:55', '2017-05-15 13:51:04', NULL),
	('scheduledreports', 9, 'to', 'To recipient list', '2017-05-15 13:25:17', '2017-05-15 13:51:06', NULL),
	('scheduledreports', 10, 'cc', 'Cc recipient list', '2017-05-15 13:25:37', '2017-05-15 13:51:08', NULL),
	('scheduledreports', 11, 'created', 'Created', '2017-05-15 13:18:40', '2017-05-15 13:51:09', NULL),
	('scheduledreports', 12, 'updated', 'Updated', '2017-05-15 13:18:48', '2017-05-15 13:51:11', NULL),
	('scheduledreports', 13, 'obsoleted', 'Obsoleted', '2017-05-15 13:18:59', '2017-05-15 13:51:13', NULL),
	('timeperiods', 1, 'ord', 'Order', '2017-05-15 13:12:35', '2017-05-15 13:12:35', NULL),
	('timeperiods', 2, 'name', 'Name', '2017-05-15 13:12:58', '2017-05-18 11:16:00', NULL),
	('timeperiods', 3, 'value', 'Code', '2017-05-15 13:13:14', '2017-05-15 13:13:14', NULL),
	('timeperiods', 4, 'created', 'Created', '2017-05-15 13:13:23', '2017-05-15 13:13:23', NULL),
	('timeperiods', 5, 'updated', 'Updated', '2017-05-15 13:13:33', '2017-05-15 13:13:33', NULL),
	('timeperiods', 6, 'obsoleted', 'Obsoleted', '2017-05-15 13:13:44', '2017-05-15 13:13:44', NULL),
	('towers', 1, 'name', 'Tower name', '2017-05-12 14:44:21', '2017-05-12 14:44:21', NULL),
	('towers', 2, 'policyname', 'Policy name pattern', '2017-05-12 14:44:40', '2017-05-15 13:08:37', NULL),
	('towers', 3, 'created', 'Created', '2017-05-12 14:45:06', '2017-05-12 14:45:27', NULL),
	('towers', 4, 'updated', 'Updated', '2017-05-12 14:45:24', '2017-05-12 14:45:24', NULL),
	('towers', 5, 'obsoleted', 'Obsoleted', '2017-05-12 14:45:44', '2017-05-12 14:45:44', NULL),
	('userreports', 2, 'title', 'Title', '2017-05-15 13:17:44', '2017-05-15 13:17:44', NULL),
	('userreports', 3, 'tower', 'Tower', '2017-05-15 13:18:05', '2017-05-15 13:51:24', NULL),
	('userreports', 4, 'customer', 'Customer', '2017-05-15 13:18:14', '2017-05-15 13:51:25', NULL),
	('userreports', 5, 'timeperiod', 'Time period', '2017-05-15 13:18:24', '2017-05-15 13:51:26', NULL),
	('userreports', 6, 'created', 'Created', '2017-05-15 13:18:40', '2017-05-15 13:51:28', NULL),
	('userreports', 7, 'updated', 'Updated', '2017-05-15 13:18:48', '2017-05-15 13:51:29', NULL),
	('userreports', 8, 'obsoleted', 'Obsoleted', '2017-05-15 13:18:59', '2017-05-15 13:51:32', NULL);

INSERT INTO `core_admin_sources` (`ord`, `name`, `title`, `description`, `created`, `updated`, `obsoleted`) VALUES
	(1, 'towers', 'Towers', 'List of towers', '2017-05-12 14:42:49', '2017-05-19 13:24:06', NULL),
	(2, 'customers', 'Customers', 'List of customers', '2017-05-12 14:43:25', '2017-05-19 13:24:12', NULL),
	(3, 'timeperiods', 'Time periods', 'List of time priods', '2017-05-15 13:07:06', '2017-05-19 13:24:20', NULL),
	(4, 'userreports', 'User reports', 'List of user reports', '2017-05-15 13:07:24', '2017-05-19 13:24:24', NULL),
	(5, 'scheduledreports', 'Scheduled reports', 'List of scheduled reports', '2017-05-15 13:07:44', '2017-05-19 13:24:31', NULL);
