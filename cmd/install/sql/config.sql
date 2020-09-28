# MARS 4.1 CONFIG SQL FILE
# (C) 2018 Juraj Brabec, DXC.technology
# DON`T MODIFY ANYTHING BELOW THIS LINE______________________________________________________________________________

USE `mars40`;

CREATE OR REPLACE TABLE `config_customers` (
  `name` varchar(64) NOT NULL DEFAULT 'Default',
  `policyname` varchar(64) NOT NULL DEFAULT '^.+',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `obsoleted` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='List of customers';

CREATE OR REPLACE TABLE `config_schedules` (
  `date` varchar(32) DEFAULT NULL,
  `time` varchar(32) NOT NULL,
  `name` varchar(64) NOT NULL,
  `title` varchar(64) NOT NULL,
  `sources` text NOT NULL,
  `tower` varchar(32) DEFAULT NULL,
  `customer` varchar(64) DEFAULT NULL,
  `timeperiod` varchar(32) NOT NULL,
  `mode` enum('HTML','CSV') NOT NULL DEFAULT 'HTML',
  `to` varchar(128) NOT NULL,
  `cc` varchar(128) DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `obsoleted` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='List of scheduled reports';

CREATE OR REPLACE TABLE `config_settings` (
	`name` VARCHAR(32) NOT NULL DEFAULT 'region',
	`value` VARCHAR(32) NOT NULL DEFAULT 'Default',
	`created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`obsoleted` TIMESTAMP NULL DEFAULT NULL,
	PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Settings';
GRANT SELECT, INSERT, UPDATE, DELETE ON mars40.config_settings TO 'operator'@'%';

CREATE OR REPLACE TABLE `config_timeperiods` (
  `ord` int(10) unsigned NOT NULL DEFAULT '1',
  `name` varchar(32) NOT NULL DEFAULT 'Default',
  `value` varchar(8) NOT NULL DEFAULT 'D-7::D',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `obsoleted` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='List o time periods';

CREATE OR REPLACE TABLE `config_towers` (
  `name` varchar(32) NOT NULL DEFAULT 'Default',
  `policyname` varchar(32) NOT NULL DEFAULT '^.+',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `obsoleted` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='List of towers';

CREATE OR REPLACE TABLE `config_reports` (
  `name` varchar(64) NOT NULL,
  `title` varchar(64) NOT NULL,
  `sources` text NOT NULL,
  `tower` varchar(32) DEFAULT NULL,
  `customer` varchar(64) DEFAULT NULL,
  `timeperiod` varchar(32) DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `obsoleted` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='List of user reports';

CREATE OR REPLACE ALGORITHM=MERGE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `v_schedules` AS 
SELECT cs.*
	FROM config_schedules cs 
	WHERE ISNULL(cs.obsoleted) 
	AND DATE_FORMAT(DATE_ADD(NOW(), INTERVAL 5 SECOND),'%a %d. %b %Y') REGEXP IFNULL(cs.date,'.*')
	ORDER BY cs.date,cs.time,cs.name
;

INSERT INTO `config_timeperiods` (`ord`, `name`, `value`) VALUES
	(3, 'Last 12 hours', 'H-12::H'),
	(23, 'Last 12 months', 'M-12::M'),
#	(24, 'Last 12 months (15.)', 'N-12::N'),
	(3, 'Last 18 hours', 'H-18::H'),
	(13, 'Last 2 weeks', 'W-2::W'),
	(4, 'Last 24 hours', 'H-24::H'),
	(8, 'Last 3 days', 'D-3::D'),
	(19, 'Last 3 months', 'M-3::M'),
#	(20, 'Last 3 months (15.)', 'N-3::N'),
	(10, 'Last 30 days', 'D-30::D'),
	(14, 'Last 4 weeks', 'W-4::W'),
	(5, 'Last 48 hours', 'H-48::H'),
	(21, 'Last 6 months', 'M-6::M'),
#	(22, 'Last 6 months (15.)', 'N-6::N'),
	(9, 'Last 7 days', 'D-7::D'),
	(2, 'Last hour', 'H-1::H'),
	(17, 'Last month', 'M-1::M'),
#	(18, 'Last month (15.)', 'N-1::N'),
	(12, 'Last week', 'W-1::W'),
	(26, 'Last year', 'Y-1::Y'),
	(1, 'This hour', 'H::H+1'),
	(15, 'This month', 'M::M+1'),
#	(16, 'This month (15.)', 'N::N+1'),
	(11, 'This week', 'W::W+1'),
	(25, 'This year', 'Y::Y+1'),
	(6, 'Today', 'D::D+1'),
	(7, 'Yesterday', 'D-1::D');

INSERT INTO `config_settings` (`name`,`value`) VALUES
	( 'region', 'Default' ),
	( 'bw_start', 'midnight' );

#INSERT INTO `config_towers` (`name`, `policyname`) VALUES
#	('Default', '.+');

#INSERT INTO `config_customers` (`name`, `policyname`) VALUES
#	('Default', '.+');
