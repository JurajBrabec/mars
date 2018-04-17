# MARS 4.1 CONFIG SQL FILE
# (C) 2018 Juraj Brabec, DXC.technology
# DON`T MODIFY ANYTHING BELOW THIS LINE______________________________________________________________________________

USE `mars40`;

DROP TABLE IF EXISTS `config_customers`;
CREATE TABLE IF NOT EXISTS `config_customers` (
  `name` varchar(64) NOT NULL DEFAULT 'Default',
  `policyname` varchar(64) NOT NULL DEFAULT '^.+',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `obsoleted` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='List of customers';

DROP TABLE IF EXISTS `config_schedules`;
CREATE TABLE IF NOT EXISTS `config_schedules` (
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

DROP TABLE IF EXISTS `config_settings`;
CREATE TABLE `config_settings` (
	`name` VARCHAR(32) NOT NULL DEFAULT 'region',
	`value` VARCHAR(32) NOT NULL DEFAULT 'Default',
	`created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`obsoleted` TIMESTAMP NULL DEFAULT NULL,
	PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Settings';

DROP TABLE IF EXISTS `config_timeperiods`;
CREATE TABLE IF NOT EXISTS `config_timeperiods` (
  `ord` int(10) unsigned NOT NULL DEFAULT '1',
  `name` varchar(32) NOT NULL DEFAULT 'Default',
  `value` varchar(8) NOT NULL DEFAULT 'D-7::D',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `obsoleted` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='List o time periods';

DROP TABLE IF EXISTS `config_towers`;
CREATE TABLE IF NOT EXISTS `config_towers` (
  `name` varchar(32) NOT NULL DEFAULT 'Default',
  `policyname` varchar(32) NOT NULL DEFAULT '^.+',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `obsoleted` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='List of towers';

DROP TABLE IF EXISTS `config_reports`;
CREATE TABLE IF NOT EXISTS `config_reports` (
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

DROP VIEW IF EXISTS `view_scheduled_now`;
CREATE ALGORITHM=MERGE DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `view_scheduled_now` AS 
select * from config_schedules
where date_format(date_sub(now()+interval 30 second,interval mod(minute(now()+interval 30 second),5) minute),"%a %d. %b %Y %H:%i") regexp concat(ifnull(`date`,""),".+",`time`) 
and obsoleted is null 
order by name ;

INSERT INTO `config_timeperiods` (`ord`, `name`, `value`, `created`, `updated`, `obsoleted`) VALUES
	(3, 'Last 12 hours', 'H-12::H', '2013-01-01 00:00:00', '2013-01-01 00:00:00', NULL),
	(23, 'Last 12 months', 'M-12::M', '2013-01-01 00:00:00', '2017-09-08 10:52:13', NULL),
	(24, 'Last 12 months (15.)', 'N-12::N', '2013-01-01 00:00:00', '2017-09-08 10:52:15', '2017-04-27 13:04:27'),
	(13, 'Last 2 weeks', 'W-2::W', '2013-01-01 00:00:00', '2017-09-08 10:51:49', NULL),
	(4, 'Last 24 hours', 'H-24::H', '2013-01-01 00:00:00', '2013-01-01 00:00:00', NULL),
	(8, 'Last 3 days', 'D-3::D', '2013-01-01 00:00:00', '2013-01-01 00:00:00', NULL),
	(19, 'Last 3 months', 'M-3::M', '2013-01-01 00:00:00', '2017-09-08 10:52:06', NULL),
	(20, 'Last 3 months (15.)', 'N-3::N', '2013-01-01 00:00:00', '2017-09-08 10:52:08', '2017-04-27 13:04:30'),
	(10, 'Last 30 days', 'D-30::D', '2013-01-01 00:00:00', '2013-01-01 00:00:00', NULL),
	(14, 'Last 4 weeks', 'W-4::W', '2013-01-01 00:00:00', '2017-09-08 10:51:50', NULL),
	(5, 'Last 48 hours', 'H-48::H', '2013-01-01 00:00:00', '2013-01-01 00:00:00', NULL),
	(21, 'Last 6 months', 'M-6::M', '2013-01-01 00:00:00', '2017-09-08 10:52:10', NULL),
	(22, 'Last 6 months (15.)', 'N-6::N', '2013-01-01 00:00:00', '2017-09-08 10:52:11', '2017-04-27 13:04:32'),
	(9, 'Last 7 days', 'D-7::D', '2013-01-01 00:00:00', '2013-01-01 00:00:00', NULL),
	(2, 'Last hour', 'H-1::H', '2013-01-01 00:00:00', '2013-01-01 00:00:00', NULL),
	(17, 'Last month', 'M-1::M', '2013-01-01 00:00:00', '2017-09-08 10:52:02', NULL),
	(18, 'Last month (15.)', 'N-1::N', '2013-01-01 00:00:00', '2017-09-08 10:52:04', '2017-04-27 13:04:34'),
	(12, 'Last week', 'W-1::W', '2013-01-01 00:00:00', '2017-09-08 10:51:47', NULL),
	(26, 'Last year', 'Y-1::Y', '2013-01-01 00:00:00', '2017-09-08 10:52:19', NULL),
	(1, 'This hour', 'H::H+1', '2013-01-01 00:00:00', '2013-01-01 00:00:00', NULL),
	(15, 'This month', 'M::M+1', '2013-01-01 00:00:00', '2017-09-08 10:51:53', NULL),
	(16, 'This month (15.)', 'N::N+1', '2013-01-01 00:00:00', '2017-09-08 10:52:01', '2017-04-27 13:04:35'),
	(11, 'This week', 'W::W+1', '2013-01-01 00:00:00', '2017-09-08 10:51:45', NULL),
	(25, 'This year', 'Y::Y+1', '2013-01-01 00:00:00', '2017-09-08 10:52:17', NULL),
	(6, 'Today', 'D::D+1', '2013-01-01 00:00:00', '2013-01-01 00:00:00', NULL),
	(7, 'Yesterday', 'D-1::D', '2013-01-01 00:00:00', '2013-01-01 00:00:00', NULL);

INSERT INTO `config_towers` (`name`, `policyname`, `created`, `updated`, `obsoleted`) VALUES
	('Default', '.+', '2017-05-03 10:39:27', '2017-05-03 10:39:37', NULL);

INSERT INTO `config_customers` (`name`, `policyname`, `created`, `updated`, `obsoleted`) VALUES
	('Default', '.+', '2016-12-14 15:06:46', '2017-04-19 15:31:24', NULL);

GRANT SELECT, INSERT, UPDATE, DELETE ON mars40.config_settings TO 'operator'@'%';
