DROP DATABASE IF EXISTS `audit`;
CREATE DATABASE IF NOT EXISTS `audit`;

USE `audit`;

DROP TABLE IF EXISTS `audit`;
CREATE TABLE `audit` (
	`DATA_CENTER` VARCHAR(32) NULL DEFAULT NULL,
	`CUSTOMER_NAME` VARCHAR(64) NULL DEFAULT NULL,
	`DEVICE_ID` VARCHAR(32) NULL DEFAULT NULL,
	`HOST_NAME` VARCHAR(32) NULL DEFAULT NULL,
	`RLIs` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`BACKUP_RLI_ID` VARCHAR(32) NULL DEFAULT NULL,
	`BACKUP_RLI_MRT` VARCHAR(64) NULL DEFAULT NULL,
	`STORAGE` VARCHAR(8) NULL DEFAULT NULL,
	`TYPE` VARCHAR(8) NULL DEFAULT NULL,
	`PROTECTION_DP` VARCHAR(64) NULL DEFAULT NULL,
	`PROTECTION_NBU` VARCHAR(64) NULL DEFAULT NULL,
	`SOURCE` VARCHAR(64) NULL DEFAULT NULL,
	`STATUS` VARCHAR(64) NULL DEFAULT NULL,
	`COMMENT` VARCHAR(256) NULL DEFAULT NULL,
	`LISTS` INT(10) UNSIGNED NULL DEFAULT NULL,
	`OWNER` VARCHAR(256) NULL DEFAULT NULL,
	`HOST` VARCHAR(256) NULL DEFAULT NULL,
	`LIST` VARCHAR(256) NULL DEFAULT NULL,
	`CUSTOMER` VARCHAR(64) NULL DEFAULT NULL,
	`RETENTION` VARCHAR(64) NULL DEFAULT NULL,
	`PROTECTION` VARCHAR(64) NULL DEFAULT NULL,
	UNIQUE INDEX `DATA_CENTER_DEVICE_ID_BACKUP_RLI_ID` (`DATA_CENTER`, `DEVICE_ID`, `BACKUP_RLI_ID`),
	INDEX `DEVICE_ID` (`DEVICE_ID`),
	INDEX `HOST_NAME` (`HOST_NAME`),
	INDEX `BACKUP_RLI_ID` (`BACKUP_RLI_ID`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

DROP TABLE IF EXISTS `datacenters`;
CREATE TABLE `datacenters` (
	`DATA_CENTER` VARCHAR(32) NOT NULL,
	`INSTANCE` VARCHAR(32) NULL DEFAULT NULL,
	PRIMARY KEY (`DATA_CENTER`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

INSERT INTO `datacenters` (`DATA_CENTER`,`INSTANCE`) VALUES
	('ATC01', 'VPC USA Atlanta'),
	('BLX01', 'VPC UK'),
	('CA001', 'VPC Canada'),
	('EBM01', 'VPC Germany'),
	('IDA01-03', 'VPC France'),
	('IT100', 'VPC Italy'),
	('LL139', 'VPC India'),
	('NL195', 'VPC NL/BE'),
	('SG181', 'VPC Singapore'),
	('SP102', 'VPC Spain'),
	('SPH01', 'VPC Brasil'),
	('SYZ01', 'VPC Australia'),
	('TLJ02', 'VPC Japan'),
	('TUBCDC1', 'VPC USA Tulsa');

DROP TABLE IF EXISTS `comments`;
CREATE TABLE `comments` (
	`EXCEPTION` TINYINT(3) UNSIGNED NOT NULL DEFAULT '0',
	`DATA_CENTER` VARCHAR(32) NOT NULL,
	`DEVICE_ID` VARCHAR(32) NOT NULL,
	`BACKUP_RLI_ID` VARCHAR(32) NOT NULL,
	`COMMENT` VARCHAR(256) NOT NULL,
	`CREATED` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`OWNER` VARCHAR(16) NULL DEFAULT NULL,
	`UPDATED` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (`DATA_CENTER`, `DEVICE_ID`, `BACKUP_RLI_ID`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

DROP TABLE IF EXISTS `qrs`;
CREATE TABLE `qrs` (
	`DATA_CENTER` VARCHAR(32) NULL DEFAULT NULL,
	`CUSTOMER_NAME` VARCHAR(64) NULL DEFAULT NULL,
	`RESERVATION_ID` VARCHAR(32) NULL DEFAULT NULL,
	`RESERVATION_STATUS` VARCHAR(64) NULL DEFAULT NULL,
	`BACKUP_RLI_ID` VARCHAR(32) NULL DEFAULT NULL,
	`BACKUP_RLI_STATUS` VARCHAR(32) NULL DEFAULT NULL,
	`BACKUP_RLI_STATE` VARCHAR(64) NULL DEFAULT NULL,
	`BACKUP_RLI_MRT` VARCHAR(64) NULL DEFAULT NULL,
	`SERVER_RLI_ID` VARCHAR(32) NULL DEFAULT NULL,
	`SERVER_RLI_STATUS` VARCHAR(32) NULL DEFAULT NULL,
	`SERVER_RLI_STATE` VARCHAR(96) NULL DEFAULT NULL,
	`SERVER_RLI_MRT` VARCHAR(64) NULL DEFAULT NULL,
	`DEVICE_ID` VARCHAR(32) NULL DEFAULT NULL,
	`DEVICE_PHYSICAL_NAME` VARCHAR(32) NULL DEFAULT NULL,
	`HOST_NAME` VARCHAR(32) NULL DEFAULT NULL,
	`DEVICE_STATUS` VARCHAR(32) NULL DEFAULT NULL,
	`DEVICE_STATE` VARCHAR(64) NULL DEFAULT NULL,
	`SERVER_TYPE` VARCHAR(32) NULL DEFAULT NULL,
	`OS` VARCHAR(64) NULL DEFAULT NULL,
	`OS_TYPE` VARCHAR(64) NULL DEFAULT NULL,
	`OS_VERSION` VARCHAR(64) NULL DEFAULT NULL,
	`DEVICE_MRT` VARCHAR(64) NULL DEFAULT NULL,
	`VLAN_ID` VARCHAR(32) NULL DEFAULT NULL,
	`VLAN_STATUS` VARCHAR(32) NULL DEFAULT NULL,
	`VLAN_ASSIGNED_CUSTOMER` VARCHAR(64) NULL DEFAULT NULL,
	INDEX `DATA_CENTER` (`DATA_CENTER`),
	INDEX `DEVICE_ID` (`DEVICE_ID`),
	INDEX `BACKUP_RLI_ID` (`BACKUP_RLI_ID`),
	INDEX `BACKUP_RLI_MRT` (`BACKUP_RLI_MRT`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

DROP TABLE IF EXISTS `rlis`;
CREATE TABLE `rlis` (
	`NAME` VARCHAR(64) NOT NULL,
	`STORAGE` ENUM('On-site','Off-site') NULL DEFAULT NULL,
	`TYPE` ENUM('FS','ON') NULL DEFAULT NULL,
	`PROTECTION_DP` VARCHAR(128) NULL DEFAULT NULL,
	`PROTECTION_NBU` VARCHAR(128) NULL DEFAULT NULL,
	PRIMARY KEY (`NAME`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

INSERT INTO `rlis` (`NAME`, `STORAGE`, `TYPE`, `PROTECTION_DP`, `PROTECTION_NBU`) VALUES
	('1 Year Database Compliance Archive', 'Off-site', 'ON', 'years 1|months 12|weeks 5(2|3)', '1 year|12 months|5(2|3) weeks|5 years'),
	('1 Year Filesystem Compliance Archive', 'Off-site', 'FS', 'years 1|months 12|weeks 5(2|3)', '1 year|12 months|5(2|3) weeks|5 years'),
	('10 Years Database Compliance Archive', 'Off-site', 'FS', 'years 10', '10 years'),
	('10 Years Filesystem Compliance Archive', 'Off-site', 'FS', 'years 10', '10 years'),
	('12 Months Database Off-site Copy', 'Off-site', 'ON', 'months 12|weeks 5(2|3)|years 1', '12 months|5(2|3) weeks|1 year'),
	('12 Months Filesystem Off-site Copy', 'Off-site', 'FS', 'months 12|weeks 5(2|3)|years 1', '12 months|5(2|3) weeks|1 year'),
	('12 Weeks Database Off-site Copy', 'Off-site', 'ON', 'weeks 12|days 9(0|7)|months 3', '12 weeks|9(0|7) days|3 months|6(0|7) days'),
	('12 Weeks Filesystem Off-site Copy', 'Off-site', 'FS', 'weeks 12|days 9(0|7)|months 3', '12 weeks|9(0|7) days|3 months|6(0|7) days'),
	('15 days Database Off-site Copy', 'Off-site', 'ON', 'days 15', '15 days|3(0|7) days'),
	('15 days Database On-site', 'On-site', 'ON', 'days 15', '15 days|3(0|7) days'),
	('18 Months Database Off-site Copy', 'Off-site', 'FS', 'months 18|weeks 78', '18 months|78 weeks|2 years|24 months'),
	('18 Months Filesystem Off-site Copy', 'Off-site', 'FS', 'months 18|weeks 78', '18 months|78 weeks|2 years|24 months'),
	('2 Years Database Compliance Archive', 'Off-site', 'ON', 'years 2|months 24', '2 years|24 months|5 years'),
	('2 Years Filesystem Compliance Archive', 'Off-site', 'FS', 'years 2|months 24', '2 years|24 months|5 years'),
	('24 Months Database Off-site Copy', 'Off-site', 'ON', 'months 24|years 2', '24 months|2 years'),
	('24 Months Filesystem Off-site Copy', 'Off-site', 'FS', 'months 24|years 2', '24 months|2 years'),
	('3 Years Database Compliance Archive', 'Off-site', 'FS', 'years 3|months 36', '3 years|36 months|5 years'),
	('3 Years Filesystem Compliance Archive', 'Off-site', 'FS', 'years 3|months 36', '3 years|36 months|5 years'),
	('30 days Database Off-site Copy', 'Off-site', 'ON', 'days 3(0|7)', '3(0|7) days'),
	('30 days Database On-site', 'On-site', 'ON', 'days 3(0|7)', '3(0|7) days'),
	('30 days Filesystem Off-site Copy', 'Off-site', 'FS', 'days 3(0|7)', '3(0|7) days'),
	('30 days Filesystem On-site VTL', 'On-site', 'FS', 'days 3(0|7)', '3(0|7) days'),
	('4 Years Database Compliance Archive', 'Off-site', 'FS', 'years 4', '4 years|5 years'),
	('4 Years Filesystem Compliance Archive', 'Off-site', 'FS', 'years 4', '4 years|5 years'),
	('5 Years Database Compliance Archive', 'Off-site', 'ON', 'years 5', '5 years'),
	('5 Years Filesystem Compliance Archive', 'Off-site', 'FS', 'years 5', '5 years'),
	('6 Months Database Off-site Copy', 'Off-site', 'ON', 'months 6|weeks 26', '6 months|26 weeks|1 year|12 months'),
	('6 Months Filesystem Off-site Copy', 'Off-site', 'FS', 'months 6|weeks 26', '6 months|26 weeks|1 year|12 months'),
	('6 Weeks Database Off-site Copy', 'Off-site', 'ON', 'weeks 6|days 42', '6 weeks|42 days|6(0|7) days'),
	('6 Weeks Filesystem Off-site Copy', 'Off-site', 'FS', 'weeks 6|days 42', '6 weeks|42 days|6(0|7) days'),
	('6 Years Database Compliance Archive', 'Off-site', 'FS', 'years 6', '6 years|7 years'),
	('6 Years Filesystem Compliance Archive', 'Off-site', 'FS', 'years 6', '6 years|7 years'),
	('60 days Database Off-site Copy', 'Off-site', 'ON', 'days 6(0|7)', '6(0|7) days'),
	('60 days Filesystem Off-site Copy', 'Off-site', 'FS', 'days 6(0|7)', '6(0|7) days'),
	('7 Years Database Compliance Archive', 'Off-site', 'ON', 'years 7', '7 years'),
	('7 Years Filesystem Compliance Archive', 'Off-site', 'FS', 'years 7', '7 years'),
	('9 Weeks Database Off-site Copy', 'Off-site', 'ON', 'weeks 9|days 6(0|7)|months 2', '9 weeks|6(0|7) days|2 months'),
	('9 Weeks Filesystem Off-site Copy', 'Off-site', 'FS', 'weeks 9|days 6(0|7)|months 2', '9 weeks|6(0|7) days|2 months'),
	('90 days Database Off-site Copy', 'Off-site', 'ON', 'days 9(0|7)', '9(0|7) days|6(0|7) days'),
	('90 days DB Onsite Retention', 'On-site', 'ON', 'days 9(0|7)', '9(0|7) days|6(0|7) days'),
	('90 days Filesystem Off-site Copy', 'Off-site', 'FS', 'days 9(0|7)', '9(0|7) days|6(0|7) days'),
	('Add Backup Resource', NULL, NULL, NULL, NULL),
	('Backup Service Management', NULL, NULL, NULL, NULL),
	('DB Backup-32 bit IBM DB2 9.1', NULL, NULL, NULL, NULL),
	('DB Backup-32 bit MS-SQL 2005', NULL, NULL, NULL, NULL),
	('DB Backup-32 bit MS-SQL 2008', NULL, NULL, NULL, NULL),
	('DB Backup-32 bit MS-SQL 2008R2', NULL, NULL, NULL, NULL),
	('DB Backup-32 bit MS-SQL 2012', NULL, NULL, NULL, NULL),
	('DB Backup-32 bit Oracle 11g', NULL, NULL, NULL, NULL),
	('DB Backup-32 bit Oracle 11g R2', NULL, NULL, NULL, NULL),
	('DB Backup-32 bit SAP Sybase ASE 15.5', NULL, NULL, NULL, NULL),
	('DB Backup-32 bit Sybase ASE 15.5', NULL, NULL, NULL, NULL),
	('DB Backup-64 bit IBM DB2 9.7', NULL, NULL, NULL, NULL),
	('DB Backup-64 bit MS Exchange 2010', NULL, NULL, NULL, NULL),
	('DB Backup-64 bit MS Exchange 2013', NULL, NULL, NULL, NULL),
	('DB Backup-64 bit MS SharePoint 2013', NULL, NULL, NULL, NULL),
	('DB Backup-64 bit MS-SQL 2008', NULL, NULL, NULL, NULL),
	('DB Backup-64 bit MS-SQL 2008R2', NULL, NULL, NULL, NULL),
	('DB Backup-64 bit MS-SQL 2012', NULL, NULL, NULL, NULL),
	('DB Backup-64 bit MS-SQL 2014', NULL, NULL, NULL, NULL),
	('DB Backup-64 bit Oracle 10g R2', NULL, NULL, NULL, NULL),
	('DB Backup-64 bit Oracle 11g', NULL, NULL, NULL, NULL),
	('DB Backup-64 bit Oracle 11g R2', NULL, NULL, NULL, NULL),
	('DB Backup-64 bit Oracle 12c', NULL, NULL, NULL, NULL),
	('DB Backup-64 bit SAP Sybase ASE 15.7', NULL, NULL, NULL, NULL),
	('DB Backup-64 bit SQL Server 2012 Enterprise Ed', NULL, NULL, NULL, NULL),
	('DB Backup-64 bit SQL Server 2012 Standard Ed', NULL, NULL, NULL, NULL),
	('DB Backup-64 bit Sybase ASE 15.5', NULL, NULL, NULL, NULL),
	('DB Backup-64 bit Sybase ASE 15.7', NULL, NULL, NULL, NULL),
	('DB Backup-Oracle Enterprise Edition', NULL, NULL, NULL, NULL),
	('Enable Backup Service', NULL, NULL, NULL, NULL),
	('WORM Cartridge', NULL, NULL, NULL, NULL);

DELIMITER ;;
DROP FUNCTION IF EXISTS `table_exists`;;
CREATE DEFINER=`root`@`%` FUNCTION `table_exists`(`tablename` VARCHAR(50)) RETURNS tinyint(4)
	LANGUAGE SQL
	DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN
select count(*) into @cnt from information_schema.tables where concat(table_schema,'.',table_name) regexp tablename;
return @cnt>0;
END;;

DROP FUNCTION IF EXISTS `datacenter`;;
CREATE DEFINER=`root`@`%` FUNCTION `datacenter`() RETURNS varchar(32) CHARSET utf8
	LANGUAGE SQL
	DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN
set @datacenter=NULL;
if (table_exists('mars40.config_settings')) then
	select distinct d.data_center into @datacenter from datacenters d,mars40.config_settings m where m.name='region' and d.instance=m.value limit 1;
elseif (table_exists('mars30.config_settings')) then
	select distinct d.data_center into @datacenter from datacenters d,mars30.config_settings m where m.name='region' and d.instance=m.value limit 1;
end if;
return @datacenter;
END;;

DROP PROCEDURE IF EXISTS procedure_audit;;
CREATE DEFINER=root@'%' PROCEDURE procedure_audit()
BEGIN
ALTER EVENT event_audit DISABLE;
set @@group_concat_max_len=4096;

truncate table audit;
insert into audit (
		DATA_CENTER,CUSTOMER_NAME,DEVICE_ID,HOST_NAME,RLIs,BACKUP_RLI_ID,BACKUP_RLI_MRT,
		STORAGE,TYPE,PROTECTION_DP,PROTECTION_NBU,SOURCE,STATUS,COMMENT)
	select
		d.DATA_CENTER,d.CUSTOMER_NAME,d.DEVICE_ID,d.HOST_NAME,d.RLIs,q.BACKUP_RLI_ID,q.BACKUP_RLI_MRT,
		r.storage as STORAGE,r.type as TYPE,r.protection_dp as PROTECTION_DP,r.protection_nbu as PROTECTION_NBU,
		'NONE' as SOURCE,if(c.EXCEPTION=1,'EXCEPTION','MISSING') as STATUS,
		c.COMMENT as COMMENT
		from qrs_devices d
			left join qrs q on(q.DEVICE_ID=d.DEVICE_ID)
			left join comments c on(c.DEVICE_ID=q.DEVICE_ID and c.BACKUP_RLI_ID=q.BACKUP_RLI_ID)
			left join rlis r on(r.name=q.BACKUP_RLI_MRT)
		where r.STORAGE is not null
		group by d.DEVICE_ID,q.BACKUP_RLI_ID
		order by d.DEVICE_ID,q.BACKUP_RLI_ID;

drop table if exists audit_nbu;
create table audit_nbu like audit;
#UPDATE for NBU enabled sites
if (table_exists('mars40')) then
	insert into audit_nbu (
			DATA_CENTER,CUSTOMER_NAME,DEVICE_ID,HOST_NAME,RLIs,BACKUP_RLI_ID,BACKUP_RLI_MRT,
			STORAGE,TYPE,PROTECTION_NBU,STATUS,COMMENT,
			LISTS,SOURCE,OWNER,CUSTOMER,HOST,RETENTION,LIST,PROTECTION) 
		select
			a.DATA_CENTER,a.CUSTOMER_NAME,a.DEVICE_ID,a.HOST_NAME,a.RLIs,a.BACKUP_RLI_ID,a.BACKUP_RLI_MRT,
			a.STORAGE,a.TYPE,a.PROTECTION_NBU,a.STATUS,a.COMMENT,
			count(distinct if(a.STORAGE='Off-site',n.vault,n.policy)) as LISTS,
			'NBU' as SOURCE,
			left(group_concat(distinct n.masterserver),256) as OWNER,
			n.customer as CUSTOMER,
			left(group_concat(distinct cast(n.client as char(256) character set utf8)),256) as HOST,
			left(group_concat(distinct if(a.STORAGE='Off-site',null,n.schedule)),64) as RETENTION,
			left(group_concat(distinct if(a.STORAGE='Off-site',n.vault,n.policy)),256) as LIST,
			left(group_concat(distinct if(a.STORAGE='Off-site',n.vault_ret,n.schedule_ret)),64) as PROTECTION
			from audit a
				left join mars40.nbu_audit n on (n.client regexp concat( '^',a.HOST_NAME,'(\.|$)'))
				where if(a.STORAGE='Off-site',n.vault,n.policy) is not null
				and if(a.TYPE='FS',n.pt in (0,13,40,41),n.pt in (4,6,7,8,15,16,17,18,19,25,35))
#FS={0:UX,13:Windows,40:VMWare,41:Hyper-V);INTEG={4:Oracle,6:Informix,7:Sybase,8:MS-SharePoint,11:DT-SQL,15:MS-SQL,16:MS-Exchange,17:SAP,18:DB2,19:SVM,25:Lotus,35:NBU Catalog};
			group by a.DEVICE_ID,a.BACKUP_RLI_ID
			order by a.DEVICE_ID,a.BACKUP_RLI_ID;
	update audit_nbu set STATUS=if(PROTECTION regexp PROTECTION_NBU,'OK','WRONG') where STATUS<>'EXCEPTION';
end if;

drop table if exists audit_dp;
create table audit_dp like audit;
#UPDATE for DP enabled sites
if (table_exists('mars30')) then 
	insert into audit_dp (
			DATA_CENTER,CUSTOMER_NAME,DEVICE_ID,HOST_NAME,RLIs,BACKUP_RLI_ID,BACKUP_RLI_MRT,
			STORAGE,TYPE,PROTECTION_DP,STATUS,COMMENT,
			LISTS,SOURCE,OWNER,CUSTOMER,HOST,RETENTION,LIST,PROTECTION) 
		select
			a.DATA_CENTER,a.CUSTOMER_NAME,a.DEVICE_ID,a.HOST_NAME,a.RLIs,a.BACKUP_RLI_ID,a.BACKUP_RLI_MRT,
			a.STORAGE,a.TYPE,a.PROTECTION_DP,a.STATUS,a.COMMENT,
			count(distinct if(a.STORAGE='Off-site',m.copylist,m.specification)) as LISTS,
			'DP' as SOURCE,
			left(group_concat(distinct m.cellserver),256) as OWNER,
			left(group_concat(distinct if(a.STORAGE='Off-site',m.clcustomer,m.customer)),64) as CUSTOMER,
			left(group_concat(distinct cast(m.hostnames as char(256) character set utf8)),256) as HOST,
			left(group_concat(distinct if(a.STORAGE='Off-site',null,m.retention)),64) as RETENTION,
			left(group_concat(distinct if(a.STORAGE='Off-site',m.copylist,m.specification)),256) as LIST,
			left(group_concat(distinct if(a.STORAGE='Off-site',m.clprotection,m.protection)),64) as PROTECTION
			from audit a
				left join mars30._specification_copylist m on (
					(m.hostnames regexp concat('(^|,)',a.HOST_NAME)) 
					and (m.specification regexp concat('_',a.TYPE,'(_|$)')) 
				)
			where if(a.STORAGE='Off-site',m.copylist,m.specification) is not null
			group by a.DEVICE_ID,a.BACKUP_RLI_ID
			order by a.DEVICE_ID,a.BACKUP_RLI_ID;
	update audit_dp set STATUS=if(PROTECTION regexp PROTECTION_DP,'OK','WRONG') where status<>'EXCEPTION';
end if;

drop table if exists audit_final;
create table audit_final like audit;

insert into audit_final (
	DATA_CENTER,CUSTOMER_NAME,DEVICE_ID,HOST_NAME,RLIs,BACKUP_RLI_ID,BACKUP_RLI_MRT,
	STORAGE,TYPE,PROTECTION_DP,PROTECTION_NBU,SOURCE,STATUS,COMMENT,
	LISTS,OWNER,HOST,LIST,CUSTOMER,RETENTION,PROTECTION) 
select 
	a.DATA_CENTER,a.CUSTOMER_NAME,a.DEVICE_ID,a.HOST_NAME,a.RLIs,a.BACKUP_RLI_ID,a.BACKUP_RLI_MRT,
	a.STORAGE,a.TYPE,a.PROTECTION_DP,a.PROTECTION_NBU,
	if(d.SOURCE is null,if(n.SOURCE is null,a.SOURCE,n.SOURCE),if(n.SOURCE is null,d.SOURCE,'BOTH')) as SOURCE,
	if(d.STATUS is null,if(n.STATUS is null,a.STATUS,n.STATUS),if(n.STATUS is null,d.STATUS,if(d.STATUS=n.STATUS,d.STATUS,concat(d.SOURCE,':',d.STATUS,',',n.SOURCE,':',n.STATUS)))) as STATUS,
	a.COMMENT,
	if(d.LISTS is null,n.LISTS,if(n.LISTS is null,d.LISTS,if(d.LISTS=n.LISTS,d.LISTS,d.LISTS+n.LISTS))) as LISTS,
	left(if(d.OWNER is null,n.OWNER,if(n.OWNER is null,d.OWNER,if(d.OWNER=n.OWNER,d.OWNER,concat(d.OWNER,',',n.OWNER)))),256) as OWNER,
	left(if(d.HOST is null,n.HOST,if(n.HOST is null,d.HOST,if(d.HOST=n.HOST,d.HOST,concat(d.HOST,',',n.HOST)))),256) as HOST,
	left(if(d.LIST is null,n.LIST,if(n.LIST is null,d.LIST,if(d.LIST=n.LIST,d.LIST,concat(d.LIST,',',n.LIST)))),256) as LIST,
	left(if(d.CUSTOMER is null,n.CUSTOMER,if(n.CUSTOMER is null,d.CUSTOMER,if(d.CUSTOMER=n.CUSTOMER,d.CUSTOMER,concat(d.CUSTOMER,',',n.CUSTOMER)))),64) as CUSTOMER,
	left(if(d.RETENTION is null,n.RETENTION,if(n.RETENTION is null,d.RETENTION,if(d.RETENTION=n.RETENTION,d.RETENTION,concat(d.RETENTION,',',n.RETENTION)))),64) as RETENTION,
	left(if(d.PROTECTION is null,n.PROTECTION,if(n.PROTECTION is null,d.PROTECTION,if(d.PROTECTION=n.PROTECTION,d.PROTECTION,concat(d.PROTECTION,',',n.PROTECTION)))),64) as PROTECTION
	from audit a
		left join audit_dp d on (d.DEVICE_ID=a.DEVICE_ID and d.BACKUP_RLI_ID=a.BACKUP_RLI_ID)
		left join audit_nbu n on (n.DEVICE_ID=a.DEVICE_ID and n.BACKUP_RLI_ID=a.BACKUP_RLI_ID)
	order by a.DEVICE_ID,a.BACKUP_RLI_ID;

drop table audit_dp;
drop table audit_nbu;
drop table audit;
rename table audit_final to audit;

ALTER EVENT event_audit ENABLE;

select concat(datacenter(),' Audit') as NAME,NULL AS HOSTS, NULL as RLIs from dual
   union all select 'Missing RLIs' as NAME,NULL AS HOSTS,COUNT(DISTINCT BACKUP_RLI_MRT) AS RLIs FROM rlis_missing
   union all select 'Audited RLIs' as NAME,COUNT(DISTINCT HOST_NAME) AS HOSTS,COUNT(DISTINCT BACKUP_RLI_ID) AS RLIs FROM audit
   union all select 'Entirely completed' as NAME,COUNT(DISTINCT HOST_NAME) AS HOSTS,COUNT(DISTINCT BACKUP_RLI_ID) AS RLIs FROM audit_complete
   union all select 'Partially completed' as NAME,COUNT(DISTINCT HOST_NAME) AS HOSTS,COUNT(DISTINCT BACKUP_RLI_ID) AS RLIs FROM audit_partial where owner is not null
   union all select 'Partially missing' as NAME,COUNT(DISTINCT HOST_NAME) AS HOSTS,COUNT(DISTINCT BACKUP_RLI_ID) AS RLIs FROM audit_partial where owner is null
   union all select 'Entirely missing' as NAME,COUNT(DISTINCT HOST_NAME) AS HOSTS,COUNT(DISTINCT BACKUP_RLI_ID) AS RLIs FROM audit_missing;

#SELECT * FROM audit_complete INTO OUTFILE 'M:/MARS/docs/VPC QRS Audit/csv/qrs_audit_complete.csv' FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';
#SELECT * FROM audit_partial INTO OUTFILE 'M:/MARS/docs/VPC QRS Audit/csv/qrs_audit_partial.csv' FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';
#SELECT * FROM audit_missing INTO OUTFILE 'M:/MARS/docs/VPC QRS Audit/csv/qrs_audit_missing.csv' FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';
END ;;

DROP PROCEDURE IF EXISTS import_comments;;
CREATE PROCEDURE import_comments(
	IN owner VARCHAR(50)
)
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
BEGIN
INSERT INTO comments (EXCEPTION,DATA_CENTER,DEVICE_ID,BACKUP_RLI_ID,COMMENT,OWNER) 
   SELECT IF(COMMENT REGEXP '^EXCEPTION',1,0) as EXCEPTION,TRIM(DATA_CENTER) AS DATACENTER,TRIM(DEVICE_ID) AS DEVICE_ID,
      TRIM(BACKUP_RLI_ID) AS BACKUP_RLI_ID,TRIM(TRIM( '\r' FROM COMMENT)) AS COMMENT, owner AS OWNER
      FROM c 
      WHERE NULLIF(TRIM(TRIM('\r' FROM COMMENT)),'') IS NOT NULL
   ON DUPLICATE KEY UPDATE EXCEPTION=VALUES(EXCEPTION),COMMENT=VALUES(COMMENT),OWNER=VALUES(OWNER);
DROP TABLE c;
END ;;

DROP EVENT IF EXISTS event_audit;;
CREATE DEFINER=root@`%` EVENT event_audit
	ON SCHEDULE
		EVERY 1 DAY STARTS '2015-01-01 00:05:00'
	ON COMPLETION PRESERVE
	ENABLE
	COMMENT ''
	DO 
begin
call procedure_audit();
end ;;

DROP PROCEDURE IF EXISTS procedure_execute;;
CREATE PROCEDURE procedure_execute()
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
BEGIN
if (ifnull(datacenter(),'')<>'') then 
	delete from qrs where DATA_CENTER<>datacenter();
	delete from comments where DATA_CENTER<>datacenter();
end if;
call procedure_audit();
if (table_exists('mars40')) then
	DROP VIEW IF EXISTS mars40.audit_qrs;
	CREATE ALGORITHM=MERGE DEFINER=root@'%' SQL SECURITY DEFINER VIEW mars40.audit_qrs AS SELECT * from audit.qrs;
	DROP VIEW IF EXISTS mars40.audit_partial;
	CREATE ALGORITHM=MERGE DEFINER=root@'%' SQL SECURITY DEFINER VIEW mars40.audit_partial AS SELECT * from audit.audit_partial;
	DROP VIEW IF EXISTS mars40.audit_missing;
	CREATE ALGORITHM=MERGE DEFINER=root@'%' SQL SECURITY DEFINER VIEW mars40.audit_missing AS SELECT * from audit.audit_missing;
	DROP VIEW IF EXISTS mars40.audit_complete;
	CREATE ALGORITHM=MERGE DEFINER=root@'%' SQL SECURITY DEFINER VIEW mars40.audit_complete AS SELECT * from audit.audit_complete;
	REPLACE INTO mars40.core_reports (`ord`, `name`, `category`, `title`, `created`, `updated`, `obsoleted`) VALUES
		(90, '---', 'Audits', '', '2018-01-18 13:01:58', '2018-01-18 13:08:03', NULL),
		(91, 'audit_qrs', 'Audits', 'QRS', '2018-01-18 13:01:58', '2018-01-18 13:08:03', NULL),
		(92, 'audit_missing', 'Audits', 'Missing hosts', '2018-01-18 13:01:58', '2018-01-18 13:08:03', NULL),
		(93, 'audit_partial', 'Audits', 'Partial hosts', '2018-01-18 13:01:58', '2018-01-18 13:08:03', NULL),
		(94, 'audit_complete', 'Audits', 'Complete hosts', '2018-01-18 13:01:58', '2018-01-18 13:08:03', NULL);
	REPLACE INTO mars40.core_sources (`report`, `ord`, `name`, `title`, `description`, `fields`, `link`, `pivot`, `tower`, `customer`, `timeperiod`, `limit`, `created`, `updated`, `obsoleted`) VALUES
		('audit_qrs', 1, 'audit_qrs', 'QRS', 'QRS servers/RLIs', NULL, NULL, NULL, 0, 0, 0, 10, '2018-01-18 13:04:22', '2018-01-18 13:08:19', NULL),
		('audit_missing', 1, 'audit_missing', 'Missing hosts', 'QRS completely missing servers/RLIs', NULL, NULL, NULL, 0, 0, 0, 10, '2018-01-18 13:04:22', '2018-01-18 13:08:19', NULL),
		('audit_partial', 1, 'audit_partial', 'Complete hosts', 'QRS partially completed servers/RLIs', NULL, NULL, NULL, 0, 0, 0, 10, '2018-01-18 13:04:22', '2018-01-18 13:08:19', NULL),
		('audit_complete', 1, 'audit_complete', 'Complete hosts', 'QRS fully complete servers/RLIs', NULL, NULL, NULL, 0, 0, 0, 10, '2018-01-18 13:04:22', '2018-01-18 13:08:19', NULL);
	REPLACE INTO mars40.core_fields (`source`, `ord`, `name`, `title`, `type`, `link`, `description`, `created`, `updated`, `obsoleted`) VALUES
		('audit_qrs', 1, 'DATA_CENTER', 'DATA_CENTER', 'STRING', NULL, NULL, '2018-01-18 13:04:47', '2018-01-18 13:08:54', NULL),
		('audit_qrs', 2, 'CUSTOMER_NAME', 'CUSTOMER_NAME', 'STRING', NULL, NULL, '2018-01-18 13:04:47', '2018-01-18 13:09:41', NULL),
		('audit_qrs', 3, 'RESERVATION_ID', 'RESERVATION_ID', 'STRING', NULL, NULL, '2018-01-18 13:04:47', '2018-01-18 13:09:41', NULL),
		('audit_qrs', 4, 'RESERVATION_STATUS', 'RESERVATION_STATUS', 'STRING', NULL, NULL, '2018-01-18 13:04:47', '2018-01-18 13:09:41', NULL),
		('audit_qrs', 5, 'BACKUP_RLI_ID', 'BACKUP_RLI_ID', 'STRING', NULL, NULL, '2018-01-18 13:04:47', '2018-01-18 13:18:26', NULL),
		('audit_qrs', 6, 'BACKUP_RLI_STATUS', 'BACKUP_RLI_STATUS', 'STRING', NULL, NULL, '2018-01-18 13:13:32', '2018-01-18 13:18:26', NULL),
		('audit_qrs', 7, 'BACKUP_RLI_STATE', 'BACKUP_RLI_STATE', 'STRING', NULL, NULL, '2018-01-18 13:13:49', '2018-01-18 13:18:26', NULL),
		('audit_qrs', 8, 'BACKUP_RLI_MRT', 'BACKUP_RLI_MRT', 'STRING', NULL, NULL, '2018-01-18 13:14:10', '2018-01-18 13:18:26', NULL),
		('audit_qrs', 9, 'SERVER_RLI_ID', 'SERVER_RLI_ID', 'STRING', NULL, NULL, '2018-01-18 13:14:28', '2018-01-18 13:18:26', NULL),
		('audit_qrs', 10, 'SERVER_RLI_STATUS', 'SERVER_RLI_STATUS', 'STRING', NULL, NULL, '2018-01-18 13:14:49', '2018-01-18 13:18:26', NULL),
		('audit_qrs', 11, 'SERVER_RLI_STATE', 'SERVER_RLI_STATE', 'STRING', NULL, NULL, '2018-01-18 13:15:01', '2018-01-18 13:18:26', NULL),
		('audit_qrs', 12, 'SERVER_RLI_MRT', 'SERVER_RLI_MRT', 'STRING', NULL, NULL, '2018-01-18 13:15:13', '2018-01-18 13:18:26', NULL),
		('audit_qrs', 13, 'DEVICE_ID', 'DEVICE_ID', 'STRING', NULL, NULL, '2018-01-18 13:15:25', '2018-01-18 13:18:26', NULL),
		('audit_qrs', 14, 'DEVICE_PHYSICAL_NAME', 'DEVICE_PHYSICAL_NAME', 'STRING', NULL, NULL, '2018-01-18 13:15:38', '2018-01-18 13:18:26', NULL),
		('audit_qrs', 15, 'HOST_NAME', 'HOST_NAME', 'STRING', NULL, NULL, '2018-01-18 13:15:59', '2018-01-18 13:18:26', NULL),
		('audit_qrs', 16, 'DEVICE_STATUS', 'DEVICE_STATUS', 'STRING', NULL, NULL, '2018-01-18 13:16:18', '2018-01-18 13:18:26', NULL),
		('audit_qrs', 17, 'DEVICE_STATE', 'DEVICE_STATE', 'STRING', NULL, NULL, '2018-01-18 13:16:28', '2018-01-18 13:18:26', NULL),
		('audit_qrs', 18, 'SERVER_TYPE', 'SERVER_TYPE', 'STRING', NULL, NULL, '2018-01-18 13:16:42', '2018-01-18 13:18:26', NULL),
		('audit_qrs', 19, 'OS', 'OS', 'STRING', NULL, NULL, '2018-01-18 13:16:51', '2018-01-18 13:18:26', NULL),
		('audit_qrs', 20, 'OS_TYPE', 'OS_TYPE', 'STRING', NULL, NULL, '2018-01-18 13:16:58', '2018-01-18 13:18:26', NULL),
		('audit_qrs', 21, 'OS_VERSION', 'OS_VERSION', 'STRING', NULL, NULL, '2018-01-18 13:17:09', '2018-01-18 13:18:26', NULL),
		('audit_qrs', 22, 'DEVICE_MRT', 'DEVICE_MRT', 'STRING', NULL, NULL, '2018-01-18 13:17:19', '2018-01-18 13:18:26', NULL),
		('audit_qrs', 23, 'VLAN_ID', 'VLAN_ID', 'STRING', NULL, NULL, '2018-01-18 13:17:28', '2018-01-18 13:18:26', NULL),
		('audit_qrs', 24, 'VLAN_STATUS', 'VLAN_STATUS', 'STRING', NULL, NULL, '2018-01-18 13:17:36', '2018-01-18 13:18:26', NULL),
		('audit_qrs', 25, 'VLAN_ASSIGNED_CUSTOMER', 'VLAN_ASSIGNED_CUSTOMER', 'STRING', NULL, NULL, '2018-01-18 13:17:51', '2018-01-18 13:18:26', NULL),
		('audit_missing', 1, 'DATA_CENTER', 'DATA_CENTER', 'STRING', NULL, NULL, '2018-01-18 13:04:47', '2018-01-18 13:08:54', NULL),
		('audit_missing', 2, 'CUSTOMER_NAME', 'CUSTOMER_NAME', 'STRING', NULL, NULL, '2018-01-18 13:04:47', '2018-01-18 13:09:41', NULL),
		('audit_missing', 3, 'DEVICE_ID', 'DEVICE_ID', 'STRING', NULL, NULL, '2018-01-18 13:15:25', '2018-01-18 13:18:26', NULL),
		('audit_missing', 4, 'HOST_NAME', 'HOST_NAME', 'STRING', NULL, NULL, '2018-01-18 13:15:59', '2018-01-18 13:18:26', NULL),
		('audit_missing', 5, 'RLIs', 'RLIs', 'NUMBER', NULL, NULL, '2018-01-18 13:15:59', '2018-01-18 13:18:26', NULL),
		('audit_missing', 6, 'BACKUP_RLI_ID', 'BACKUP_RLI_ID', 'STRING', NULL, NULL, '2018-01-18 13:04:47', '2018-01-18 13:18:26', NULL),
		('audit_missing', 7, 'BACKUP_RLI_MRT', 'BACKUP_RLI_MRT', 'STRING', NULL, NULL, '2018-01-18 13:14:10', '2018-01-18 13:18:26', NULL),
		('audit_missing', 8, 'SOURCE', 'SOURCE', 'STRING', NULL, NULL, '2018-01-18 13:14:10', '2018-01-18 13:18:26', NULL),
		('audit_missing', 9, 'STATUS', 'STATUS', 'STRING', NULL, NULL, '2018-01-18 13:14:10', '2018-01-18 13:18:26', NULL),
		('audit_missing', 10, 'COMMENT', 'COMMENT', 'STRING', NULL, NULL, '2018-01-18 13:14:10', '2018-01-18 13:18:26', NULL),
		('audit_partial', 1, 'DATA_CENTER', 'DATA_CENTER', 'STRING', NULL, NULL, '2018-01-18 13:04:47', '2018-01-18 13:08:54', NULL),
		('audit_partial', 2, 'CUSTOMER_NAME', 'CUSTOMER_NAME', 'STRING', NULL, NULL, '2018-01-18 13:04:47', '2018-01-18 13:09:41', NULL),
		('audit_partial', 3, 'DEVICE_ID', 'DEVICE_ID', 'STRING', NULL, NULL, '2018-01-18 13:15:25', '2018-01-18 13:18:26', NULL),
		('audit_partial', 4, 'HOST_NAME', 'HOST_NAME', 'STRING', NULL, NULL, '2018-01-18 13:15:59', '2018-01-18 13:18:26', NULL),
		('audit_partial', 5, 'RLIs', 'RLIs', 'NUMBER', NULL, NULL, '2018-01-18 13:15:59', '2018-01-18 13:18:26', NULL),
		('audit_partial', 6, 'BACKUP_RLI_ID', 'BACKUP_RLI_ID', 'STRING', NULL, NULL, '2018-01-18 13:04:47', '2018-01-18 13:18:26', NULL),
		('audit_partial', 7, 'BACKUP_RLI_MRT', 'BACKUP_RLI_MRT', 'STRING', NULL, NULL, '2018-01-18 13:14:10', '2018-01-18 13:18:26', NULL),
		('audit_partial', 8, 'SOURCE', 'SOURCE', 'STRING', NULL, NULL, '2018-01-18 13:14:10', '2018-01-18 13:18:26', NULL),
		('audit_partial', 9, 'STATUS', 'STATUS', 'STRING', NULL, NULL, '2018-01-18 13:14:10', '2018-01-18 13:18:26', NULL),
		('audit_partial', 10, 'COMMENT', 'COMMENT', 'STRING', NULL, NULL, '2018-01-18 13:14:10', '2018-01-18 13:18:26', NULL),
		('audit_partial', 11, 'LISTS', 'LISTS', 'NUMBER', NULL, NULL, '2018-01-18 13:14:10', '2018-01-18 13:18:26', NULL),
		('audit_partial', 12, 'OWNER', 'OWNER', 'STRING', NULL, NULL, '2018-01-18 13:14:10', '2018-01-18 13:18:26', NULL),
		('audit_partial', 13, 'HOST', 'HOST', 'STRING', NULL, NULL, '2018-01-18 13:14:10', '2018-01-18 13:18:26', NULL),
		('audit_partial', 14, 'LIST', 'LIST', 'STRING', NULL, NULL, '2018-01-18 13:14:10', '2018-01-18 13:18:26', NULL),
		('audit_partial', 15, 'CUSTOMER', 'CUSTOMER', 'STRING', NULL, NULL, '2018-01-18 13:14:10', '2018-01-18 13:18:26', NULL),
		('audit_partial', 16, 'RETENTION', 'RETENTION', 'STRING', NULL, NULL, '2018-01-18 13:14:10', '2018-01-18 13:18:26', NULL),
		('audit_partial', 17, 'PROTECTION', 'PROTECTION', 'STRING', NULL, NULL, '2018-01-18 13:14:10', '2018-01-18 13:18:26', NULL),
		('audit_complete', 1, 'DATA_CENTER', 'DATA_CENTER', 'STRING', NULL, NULL, '2018-01-18 13:04:47', '2018-01-18 13:08:54', NULL),
		('audit_complete', 2, 'CUSTOMER_NAME', 'CUSTOMER_NAME', 'STRING', NULL, NULL, '2018-01-18 13:04:47', '2018-01-18 13:09:41', NULL),
		('audit_complete', 3, 'DEVICE_ID', 'DEVICE_ID', 'STRING', NULL, NULL, '2018-01-18 13:15:25', '2018-01-18 13:18:26', NULL),
		('audit_complete', 4, 'HOST_NAME', 'HOST_NAME', 'STRING', NULL, NULL, '2018-01-18 13:15:59', '2018-01-18 13:18:26', NULL),
		('audit_complete', 5, 'RLIs', 'RLIs', 'NUMBER', NULL, NULL, '2018-01-18 13:15:59', '2018-01-18 13:18:26', NULL),
		('audit_complete', 6, 'BACKUP_RLI_ID', 'BACKUP_RLI_ID', 'STRING', NULL, NULL, '2018-01-18 13:04:47', '2018-01-18 13:18:26', NULL),
		('audit_complete', 7, 'BACKUP_RLI_MRT', 'BACKUP_RLI_MRT', 'STRING', NULL, NULL, '2018-01-18 13:14:10', '2018-01-18 13:18:26', NULL),
		('audit_complete', 8, 'SOURCE', 'SOURCE', 'STRING', NULL, NULL, '2018-01-18 13:14:10', '2018-01-18 13:18:26', NULL),
		('audit_complete', 9, 'STATUS', 'STATUS', 'STRING', NULL, NULL, '2018-01-18 13:14:10', '2018-01-18 13:18:26', NULL),
		('audit_complete', 10, 'COMMENT', 'COMMENT', 'STRING', NULL, NULL, '2018-01-18 13:14:10', '2018-01-18 13:18:26', NULL),
		('audit_complete', 11, 'LISTS', 'LISTS', 'NUMBER', NULL, NULL, '2018-01-18 13:14:10', '2018-01-18 13:18:26', NULL),
		('audit_complete', 12, 'OWNER', 'OWNER', 'STRING', NULL, NULL, '2018-01-18 13:14:10', '2018-01-18 13:18:26', NULL),
		('audit_complete', 13, 'HOST', 'HOST', 'STRING', NULL, NULL, '2018-01-18 13:14:10', '2018-01-18 13:18:26', NULL),
		('audit_complete', 14, 'LIST', 'LIST', 'STRING', NULL, NULL, '2018-01-18 13:14:10', '2018-01-18 13:18:26', NULL),
		('audit_complete', 15, 'CUSTOMER', 'CUSTOMER', 'STRING', NULL, NULL, '2018-01-18 13:14:10', '2018-01-18 13:18:26', NULL),
		('audit_complete', 16, 'RETENTION', 'RETENTION', 'STRING', NULL, NULL, '2018-01-18 13:14:10', '2018-01-18 13:18:26', NULL),
		('audit_complete', 17, 'PROTECTION', 'PROTECTION', 'STRING', NULL, NULL, '2018-01-18 13:14:10', '2018-01-18 13:18:26', NULL);
	REPLACE INTO mars40.core_formats (`report`, `ord`, `source`, `field`, `operator`, `value`, `style`, `description`, `fields`, `created`, `updated`, `obsoleted`) VALUES
		('audit_(partial|missing|complete)', 1, 'audit_(partial|missing|complete)', 'status', '=', 'OK', 'background-color: palegreen; color: green;', 'OK', NULL, '2018-01-18 14:18:56', '2018-01-18 14:19:36', NULL),
		('audit_(partial|missing|complete)', 2, 'audit_(partial|missing|complete)', 'status', '=', 'EXCEPTION', 'background-color: greenyellow; color: green;', 'Exception', NULL, '2018-01-18 14:20:23', '2018-01-18 14:21:13', NULL),
		('audit_(partial|missing|complete)', 3, 'audit_(partial|missing|complete)', 'status', '=', 'WRONG', 'background-color: gold; color: brown;', 'Wrong protection', NULL, '2018-01-18 14:20:23', '2018-01-18 14:24:49', NULL),
		('audit_(partial|missing|complete)', 4, 'audit_(partial|missing|complete)', 'status', '=', 'MISSING', 'background-color: lightpink; color: red;', 'Missing', NULL, '2018-01-18 14:20:23', '2018-01-18 14:22:12', NULL),
		('audit_qrs', 1, 'audit_qrs', 'data_center', '!=', NULL, 'background-color: palegreen; color: green;', 'QRS', NULL, '2018-01-18 14:23:54', '2018-01-18 14:32:55', NULL);
end if;
if (table_exists('mars30')) then
	REPLACE INTO mars30.config_reports (`id`, `sort`, `name`, `submenu`, `title`, `description`, `sql`, `pivot`, `timeperiod`, `customer`, `fields`, `styles`, `datapage_limit`) VALUES
		(100, 1000, 'q0', 'Auditing', 'QRS', 'QRS servers/RLI\'s', 'select * from audit.qrs', NULL, 0, 0, NULL, '#field(s)_affected		#condition		#CSS						#description\r\n#---------------------		#---------------------		#------------------------------------------------		#------------------------------------------\r\n*			HOST_NAME >= \'\'		color:green;background:palegreen;			Server in QRS\r\n*			HOST_NAME == \'\'		color:red;background:lightpink;			Server missing in QRS\r\n', 25),
		(101, 1001, 'q1', 'Auditing', 'QRS audit partial', 'QRS partially completed servers/RLI\'s', 'select * from audit.audit_partial', NULL, 0, 0, NULL, '#field(s)_affected		#condition		#CSS						#description\r\n#---------------------		#---------------------		#------------------------------------------------		#------------------------------------------\r\n*			STATUS == \'MISSING\'	color:red;background:lightpink;			Missing\r\n*			STATUS REGEXP \'WRONG\'	color:salmon;background:gold;			Wrong protection\r\n*			STATUS == \'EXCEPTION\'	color:green;background:greenyellow;			Exception\r\n*			STATUS REGEXP \'OK\'	color:green;background:palegreen;			All OK\r\n', 25),
		(102, 1002, 'q2', 'Auditing', 'QRS audit missing', 'QRS completely missing servers/RLI\'s', 'select * from audit.audit_missing', NULL, 0, 0, NULL, '#field(s)_affected		#condition		#CSS						#description\r\n#---------------------		#---------------------		#------------------------------------------------		#------------------------------------------\r\n*			STATUS == \'MISSING\'	color:red;background:lightpink;			Missing\r\n*			STATUS REGEXP \'WRONG\'	color:salmon;background:gold;			Wrong protection\r\n*			STATUS == \'EXCEPTION\'	color:green;background:greenyellow;			Exception\r\n*			STATUS REGEXP \'OK\'	color:green;background:palegreen;			All OK\r\n', 25),
		(103, 1003, 'q3', 'Auditing', 'QRS audit complete', 'QRS fully completed servers/RLI\'s', 'select * from audit.audit_complete', NULL, 0, 0, NULL, '#field(s)_affected		#condition		#CSS						#description\r\n#---------------------		#---------------------		#------------------------------------------------		#------------------------------------------\r\n*			STATUS == \'MISSING\'	color:red;background:lightpink;			Missing\r\n*			STATUS REGEXP \'WRONG\'	color:salmon;background:gold;			Wrong protection\r\n*			STATUS == \'EXCEPTION\'	color:green;background:greenyellow;			Exception\r\n*			STATUS REGEXP \'OK\'	color:green;background:palegreen;			All OK\r\n', 25);
end if;
	
if (table_exists('mars40')) then
	replace into mars40.config_schedules (date,time,name,title,timeperiod,`to`,mode,sources) values (
		date_format(now(),'%a %d. %b %Y'),date_format(date_add(now(),interval (15-minute(now())%15)*60-second(now()) second),'%H:%i'),
#		date_format(now(),'%a %d. %b %Y'),date_format(now()-interval 5 second,'%H:%i'),
		'qrs_audit','QRS audit','Last month','juraj.brabec@dxc.com','CSV',
		'[{"name":"audit_missing","source":"audit_missing","filters":[],"sorts":[]},{"name":"audit_partial","source":"audit_partial","filters":[],"sorts":[]},{"name":"audit_complete","source":"audit_complete","filters":[],"sorts":[]}]');
elseif (table_exists('mars30')) then
	replace into mars30.config_scheduler (date,time,name,param1,param4,param6) values (
		date_format(now(),'%a %d. %b %Y'),date_format(date_add(now(),interval (15-minute(now())%15)*60-second(now()) second),'%H:%i'),
#		date_format(now(),'%a %d. %b %Y'),date_format(now()-interval 5 second,'%H:%i'),
		'QRS audit','q1|q2|q3','juraj.brabec@dxc.com','CSV');
end if;
end ;;

DELIMITER ;

DROP VIEW IF EXISTS `rlis_missing`;
CREATE ALGORITHM=UNDEFINED DEFINER=root@'%' SQL SECURITY DEFINER VIEW `rlis_missing` AS
select distinct q.BACKUP_RLI_MRT AS BACKUP_RLI_MRT
from qrs q
where (not(exists(select * from rlis r where (r.name=q.BACKUP_RLI_MRT)))) 
order by 1
;

DROP VIEW IF EXISTS `qrs_devices`;
CREATE ALGORITHM=UNDEFINED DEFINER=root@'%' SQL SECURITY DEFINER VIEW `qrs_devices` AS
select q.DATA_CENTER as DATA_CENTER,
q.CUSTOMER_NAME as CUSTOMER_NAME,
q.DEVICE_ID as DEVICE_ID,
q.HOST_NAME as HOST_NAME,
count(distinct q.BACKUP_RLI_ID) as RLIs,
group_concat(distinct q.BACKUP_RLI_ID order by q.BACKUP_RLI_ID) as RLI_IDs
from (qrs q left join rlis r on((r.name=q.BACKUP_RLI_MRT)))
where q.DATA_CENTER=datacenter()
and q.DEVICE_ID<>''
and r.STORAGE is not null
group by q.DATA_CENTER,q.DEVICE_ID
order by q.DATA_CENTER,q.DEVICE_ID
;

DROP VIEW IF EXISTS `audit_complete`;
CREATE ALGORITHM=UNDEFINED DEFINER=root@'%' SQL SECURITY DEFINER VIEW `audit_complete` AS
select a.DATA_CENTER AS DATA_CENTER,
a.CUSTOMER_NAME AS CUSTOMER_NAME,
a.DEVICE_ID AS DEVICE_ID,
a.HOST_NAME AS HOST_NAME,
a.RLIs AS RLIs,
a.BACKUP_RLI_ID AS BACKUP_RLI_ID,
a.BACKUP_RLI_MRT AS BACKUP_RLI_MRT,
a.SOURCE AS SOURCE,
a.STATUS AS STATUS,
a.COMMENT AS COMMENT,
a.LISTS as LISTS,
a.OWNER AS OWNER,
a.HOST AS HOST,
a.LIST AS LIST,
a.CUSTOMER AS CUSTOMER,
a.RETENTION AS RETENTION,
a.PROTECTION AS PROTECTION
from qrs_devices d 
left join audit a on (d.DATA_CENTER=a.DATA_CENTER and d.DEVICE_ID=a.DEVICE_ID)
where not exists (select 1 from audit b where d.DATA_CENTER=b.DATA_CENTER and d.DEVICE_ID=b.DEVICE_ID and b.STATUS not regexp 'OK|EXCEPTION')
and exists (select 1 from audit c where d.DATA_CENTER=c.DATA_CENTER and d.DEVICE_ID=c.DEVICE_ID and c.STATUS regexp 'OK|EXCEPTION')
order by a.HOST_NAME,a.BACKUP_RLI_ID
;

DROP VIEW IF EXISTS `audit_missing`;
CREATE ALGORITHM=UNDEFINED DEFINER=root@'%' SQL SECURITY DEFINER VIEW `audit_missing` AS
select a.DATA_CENTER AS DATA_CENTER,
a.CUSTOMER_NAME AS CUSTOMER_NAME,
a.DEVICE_ID AS DEVICE_ID,
a.HOST_NAME AS HOST_NAME,
a.RLIs AS RLIs,
a.BACKUP_RLI_ID AS BACKUP_RLI_ID,
a.BACKUP_RLI_MRT AS BACKUP_RLI_MRT,
a.SOURCE AS SOURCE,
a.STATUS AS STATUS,
a.COMMENT AS COMMENT
from qrs_devices d 
left join audit a on (d.DATA_CENTER=a.DATA_CENTER and d.DEVICE_ID=a.DEVICE_ID)
where not exists (select 1 from audit b where d.DATA_CENTER=b.DATA_CENTER and d.DEVICE_ID=b.DEVICE_ID and b.STATUS not regexp 'MISSING')
and exists (select 1 from audit c where d.DATA_CENTER=c.DATA_CENTER and d.DEVICE_ID=c.DEVICE_ID and c.STATUS regexp 'MISSING')
order by a.HOST_NAME,a.BACKUP_RLI_ID
;

DROP VIEW IF EXISTS `audit_partial`;
CREATE ALGORITHM=UNDEFINED DEFINER=root@'%' SQL SECURITY DEFINER VIEW `audit_partial` AS
select a.DATA_CENTER AS DATA_CENTER,
a.CUSTOMER_NAME AS CUSTOMER_NAME,
a.DEVICE_ID AS DEVICE_ID,
a.HOST_NAME AS HOST_NAME,
a.RLIs AS RLIs,
a.BACKUP_RLI_ID AS BACKUP_RLI_ID,
a.BACKUP_RLI_MRT AS BACKUP_RLI_MRT,
a.SOURCE AS SOURCE,
a.STATUS AS STATUS,
a.COMMENT AS COMMENT,
a.LISTS as LISTS,
a.OWNER AS OWNER,
a.HOST AS HOST,
a.LIST AS LIST,
a.CUSTOMER AS CUSTOMER,
a.RETENTION AS RETENTION,
a.PROTECTION AS PROTECTION
from qrs_devices d 
left join audit a on (d.DATA_CENTER=a.DATA_CENTER and d.DEVICE_ID= a.DEVICE_ID)
where exists (select 1 from audit b where d.DATA_CENTER=b.DATA_CENTER and d.DEVICE_ID=b.DEVICE_ID and b.STATUS not regexp 'MISSING')
and exists (select 1 from audit c where d.DATA_CENTER=c.DATA_CENTER and d.DEVICE_ID=c.DEVICE_ID and c.STATUS not regexp 'OK|EXCEPTION')
order by a.HOST_NAME,a.SOURCE
;

GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE, EVENT ON audit.* TO 'operator'@'%';
flush privileges;
