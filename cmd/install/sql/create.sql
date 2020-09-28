# MARS 4.1 CREATE SQL FILE
# (C) 2018 Juraj Brabec, DXC.technology
# DON`T MODIFY ANYTHING BELOW THIS LINE______________________________________________________________________________

USE `mysql`;
UPDATE mysql.user SET Host = '%',Password = PASSWORD('r00t123') WHERE User = 'root' AND Host = 'localhost';
DELETE FROM mysql.user WHERE ( User <>'root' ) OR ( User = 'root' AND Host <> '%' );
DROP USER IF EXISTS 'operator','script','administrator';
CREATE USER 'operator';
CREATE USER 'script' IDENTIFIED BY 'm@r5';
CREATE USER 'administrator' IDENTIFIED BY 'admin';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'operator'@'%','script'@'%','administrator'@'%';
GRANT PROCESS ON *.* TO 'operator'@'%';
GRANT PROCESS ON *.* TO 'administrator'@'%';

DROP DATABASE IF EXISTS `mars40`;
CREATE DATABASE `mars40` DEFAULT CHARACTER SET utf8 DEFAULT COLLATE=utf8_general_ci;
GRANT SELECT, INSERT, UPDATE, EXECUTE, EVENT ON mars40.* TO 'operator'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON mars40.* TO 'script'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE, EVENT ON mars40.* TO 'administrator'@'%';

DROP DATABASE IF EXISTS `mars30`;
CREATE DATABASE `mars30` DEFAULT CHARACTER SET utf8 DEFAULT COLLATE=utf8_general_ci;
GRANT SELECT, INSERT, UPDATE, EVENT ON mars30.* TO 'operator'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON mars30.* TO 'script'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE, EVENT ON mars30.* TO 'administrator'@'%';
FLUSH PRIVILEGES;

USE `mars40`;

DELIMITER //
CREATE OR REPLACE DEFINER=CURRENT_USER FUNCTION `f_customer`() RETURNS varchar(64) CHARSET utf8
    NO SQL
    DETERMINISTIC
    COMMENT 'Customer filter function'
BEGIN
RETURN NULLIF(@customer,'');
END//

CREATE OR REPLACE DEFINER=CURRENT_USER FUNCTION `f_from`() RETURNS int(11)
    NO SQL
    DETERMINISTIC
    COMMENT 'Datetime from filter function'
BEGIN
RETURN UNIX_TIMESTAMP(IFNULL(NULLIF(@datetime_from,''),DATE(SUBDATE(NOW(), interval 1 MONTH))));
END//

CREATE OR REPLACE DEFINER=CURRENT_USER FUNCTION `f_to`() RETURNS int(11)
    NO SQL
    DETERMINISTIC
    COMMENT 'Datetime to filter function'
BEGIN
RETURN UNIX_TIMESTAMP(IFNULL(NULLIF(@datetime_to,''),DATE(ADDDATE(NOW(), interval 1 DAY))) - INTERVAL 1 SECOND);
END//

CREATE OR REPLACE DEFINER=CURRENT_USER FUNCTION `f_tower`() RETURNS varchar(32) CHARSET utf8
    NO SQL
    DETERMINISTIC
    COMMENT 'Tower filter function'
BEGIN
RETURN NULLIF(@tower,'');
END//
DELIMITER ;

CREATE OR REPLACE TABLE `core_admin_fields` (
	`source` VARCHAR(32) NOT NULL,
	`ord` TINYINT(3) UNSIGNED NOT NULL,
	`name` VARCHAR(32) NOT NULL,
	`title` VARCHAR(32) NULL DEFAULT NULL,
	`created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`obsoleted` TIMESTAMP NULL DEFAULT NULL,
	PRIMARY KEY (`source`, `ord`, `name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='List of predefined Admin report fields';

CREATE OR REPLACE TABLE `core_admin_sources` (
	`ord` TINYINT(3) UNSIGNED NOT NULL,
	`name` VARCHAR(32) NOT NULL,
	`title` VARCHAR(32) NOT NULL,
	`description` VARCHAR(64) NULL DEFAULT NULL,
	`created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`obsoleted` TIMESTAMP NULL DEFAULT NULL,
	PRIMARY KEY (`ord`, `name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='List of predefined Admin report sources';

CREATE OR REPLACE TABLE `core_fields` (
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

CREATE OR REPLACE TABLE `core_filters` (
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

CREATE OR REPLACE TABLE `core_formats` (
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

CREATE OR REPLACE TABLE `core_links` (
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

CREATE OR REPLACE TABLE `core_reports` (
  `ord` tinyint(3) unsigned NOT NULL,
  `name` varchar(32) NOT NULL,
  `category` varchar(32) DEFAULT NULL,
  `title` varchar(32) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `obsoleted` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`ord`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='List of predefined reports';

CREATE OR REPLACE TABLE `core_sorts` (
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

CREATE OR REPLACE TABLE `core_sources` (
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

INSERT INTO `core_admin_fields` (`source`, `ord`, `name`, `title`) VALUES
	('customers', 1, 'name', 'Customer name'),
	('customers', 2, 'policyname', 'Policy name pattern'),
	('customers', 3, 'created', 'Created'),
	('customers', 4, 'updated', 'Updated'),
	('customers', 5, 'obsoleted', 'Obsoleted'),
	('scheduledreports', 1, 'date', 'Date pattern'),
	('scheduledreports', 2, 'time', 'Time pattern'),
	('scheduledreports', 4, 'title', 'Title'),
	('scheduledreports', 5, 'tower', 'Tower'),
	('scheduledreports', 6, 'customer', 'Customer'),
	('scheduledreports', 7, 'timeperiod', 'Time period'),
	('scheduledreports', 8, 'mode', 'Mode'),
	('scheduledreports', 9, 'to', 'To recipient list'),
	('scheduledreports', 10, 'cc', 'Cc recipient list'),
	('scheduledreports', 11, 'created', 'Created'),
	('scheduledreports', 12, 'updated', 'Updated'),
	('scheduledreports', 13, 'obsoleted', 'Obsoleted'),
	('timeperiods', 1, 'ord', 'Order'),
	('timeperiods', 2, 'name', 'Name'),
	('timeperiods', 3, 'value', 'Code'),
	('timeperiods', 4, 'created', 'Created'),
	('timeperiods', 5, 'updated', 'Updated'),
	('timeperiods', 6, 'obsoleted', 'Obsoleted'),
	('towers', 1, 'name', 'Tower name'),
	('towers', 2, 'policyname', 'Policy name pattern'),
	('towers', 3, 'created', 'Created'),
	('towers', 4, 'updated', 'Updated'),
	('towers', 5, 'obsoleted', 'Obsoleted'),
	('userreports', 2, 'title', 'Title'),
	('userreports', 3, 'tower', 'Tower'),
	('userreports', 4, 'customer', 'Customer'),
	('userreports', 5, 'timeperiod', 'Time period'),
	('userreports', 6, 'created', 'Created'),
	('userreports', 7, 'updated', 'Updated'),
	('userreports', 8, 'obsoleted', 'Obsoleted');

INSERT INTO `core_admin_sources` (`ord`, `name`, `title`, `description`) VALUES
	(1, 'towers', 'Towers', 'List of towers'),
	(2, 'customers', 'Customers', 'List of customers'),
	(3, 'timeperiods', 'Time periods', 'List of time priods'),
	(4, 'userreports', 'User reports', 'List of user reports'),
	(5, 'scheduledreports', 'Scheduled reports', 'List of scheduled reports');
