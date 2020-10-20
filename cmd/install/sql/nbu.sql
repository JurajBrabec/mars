# MARS 4.1 NBU SQL FILE
# (C) 2018 Juraj Brabec, DXC.technology
# DON`T MODIFY ANYTHING BELOW THIS LINE______________________________________________________________________________

USE `mars40`;

CREATE OR REPLACE TABLE `bpdbjobs_report` (
	`masterserver` VARCHAR(64) NOT NULL,
	`jobid` INT(10) UNSIGNED NULL DEFAULT NULL,
	`jobtype` TINYINT(3) UNSIGNED NOT NULL,
	`state` TINYINT(3) UNSIGNED NOT NULL,
	`status` SMALLINT(5) UNSIGNED NULL DEFAULT NULL,
	`policy` VARCHAR(96) NULL DEFAULT NULL,
	`schedule` VARCHAR(64) NULL DEFAULT NULL,
	`client` VARCHAR(64) NULL DEFAULT NULL,
	`server` VARCHAR(64) NULL DEFAULT NULL,
	`started` INT(11) UNSIGNED NULL DEFAULT NULL,
	`elapsed` INT(11) UNSIGNED NULL DEFAULT NULL,
	`ended` INT(11) UNSIGNED NULL DEFAULT NULL,
	`stunit` VARCHAR(64) NULL DEFAULT NULL,
	`tries` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`operation` VARCHAR(64) NULL DEFAULT NULL,
	`kbytes` BIGINT(20) UNSIGNED NULL DEFAULT NULL,
	`files` INT(10) UNSIGNED NULL DEFAULT NULL,
	`pathlastwritten` VARCHAR(256) NULL DEFAULT NULL,
	`percent` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`jobpid` MEDIUMINT(8) UNSIGNED NULL DEFAULT NULL,
	`owner` VARCHAR(32) NULL DEFAULT NULL,
	`subtype` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`policytype` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`scheduletype` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`priority` MEDIUMINT(8) UNSIGNED NULL DEFAULT NULL,
	`group` VARCHAR(32) NULL DEFAULT NULL,
	`retentionlevel` TINYINT(3) NULL DEFAULT NULL,
	`retentionperiod` TINYINT(3) NULL DEFAULT NULL,
	`compression` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`kbytestobewritten` BIGINT(20) UNSIGNED NULL DEFAULT NULL,
	`filestobewritten` MEDIUMINT(8) UNSIGNED NULL DEFAULT NULL,
	`filelistcount` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`trycount` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`parentjob` INT(10) UNSIGNED NULL DEFAULT NULL,
	`kbpersec` INT(10) UNSIGNED NULL DEFAULT NULL,
	`copy` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`robot` VARCHAR(32) NULL DEFAULT NULL,
	`vault` VARCHAR(32) NULL DEFAULT NULL,
	`profile` VARCHAR(32) NULL DEFAULT NULL,
	`session` VARCHAR(32) NULL DEFAULT NULL,
	`ejecttapes` VARCHAR(32) NULL DEFAULT NULL,
	`srcstunit` VARCHAR(32) NULL DEFAULT NULL,
	`srcserver` VARCHAR(64) NULL DEFAULT NULL,
	`srcmedia` VARCHAR(32) NULL DEFAULT NULL,
	`dstmedia` VARCHAR(32) NULL DEFAULT NULL,
	`stream` TINYINT(4) NULL DEFAULT NULL,
	`suspendable` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`resumable` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`restartable` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`datamovement` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`snapshot` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`backupid` VARCHAR(64) NULL DEFAULT NULL,
	`killable` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`controllinghost` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`offhosttype` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`ftusage` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`queuereason` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`reasonstring` VARCHAR(128) NULL DEFAULT NULL,
	`dedupratio` FLOAT UNSIGNED NULL DEFAULT NULL,
	`accelerator` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`instancedbname` VARCHAR(32) NULL DEFAULT NULL,
	`rest1` VARCHAR(32) NULL DEFAULT NULL,
	`rest2` VARCHAR(32) NULL DEFAULT NULL,
	PRIMARY KEY (`masterserver`, `jobid`),
	INDEX `masterserver_policy_schedule_client` (`masterserver`,`policy`,`schedule`,`client`),
	INDEX `started` (`started`),
	INDEX `ended` (`ended`),
	INDEX `client` (`client`),
	INDEX `policy` (`policy`),
	INDEX `policy_schedule` (`policy`, `schedule`),
	INDEX `masterserver_parentjob` (`masterserver`,`parentjob`),
	INDEX `jobtype` (`jobtype`),
	INDEX `backupid` (`backupid`),
	INDEX `state` (`state`),
	INDEX `subtype` (`subtype`)
)
COMMENT='bpdbjobs -report'
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

CREATE OR REPLACE TABLE `bpdbjobs_summary` (
	`masterserver` VARCHAR(64) NOT NULL,
	`queued` MEDIUMINT(8) UNSIGNED NOT NULL,
	`waiting` MEDIUMINT(8) UNSIGNED NOT NULL,
	`active` MEDIUMINT(8) UNSIGNED NOT NULL,
	`successful` MEDIUMINT(8) UNSIGNED NOT NULL,
	`partial` MEDIUMINT(8) UNSIGNED NOT NULL,
	`failed` MEDIUMINT(8) UNSIGNED NOT NULL,
	`incomplete` MEDIUMINT(8) UNSIGNED NOT NULL,
	`suspended` MEDIUMINT(8) UNSIGNED NOT NULL,
	`total` INT(10) UNSIGNED NOT NULL,
	PRIMARY KEY (`masterserver`)
)
COMMENT='bpdbjobs -summary'
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

CREATE OR REPLACE TABLE `bpflist_backupid` (
	`masterserver` VARCHAR(64) NOT NULL,
	`image_version` TINYINT(3) UNSIGNED NOT NULL,
	`client_type` TINYINT(3) UNSIGNED NOT NULL,
	`start_time` INT(10) UNSIGNED NOT NULL,
	`timestamp` INT(10) UNSIGNED NOT NULL,
	`schedule_type` TINYINT(3) UNSIGNED NOT NULL,
	`client` VARCHAR(64) NOT NULL,
	`policy_name` VARCHAR(64) NOT NULL,
	`backupid` VARCHAR(64) NOT NULL,
	`peer_name` VARCHAR(8) NULL,
	`lines` TINYINT(3) UNSIGNED NOT NULL,
	`options` TINYINT(3) UNSIGNED NOT NULL,
	`user_name` VARCHAR(8) NOT NULL,
	`group_name` VARCHAR(8) NOT NULL,
	`raw_partition_id` TINYINT(3) UNSIGNED NOT NULL,
	`jobid` INT(10) UNSIGNED NULL,
	`file_number` MEDIUMINT(8) UNSIGNED NOT NULL,
	`compressed_size` MEDIUMINT(8) UNSIGNED NOT NULL,
	`path_length` TINYINT(3) UNSIGNED NOT NULL,
	`data_length` TINYINT(3) UNSIGNED NOT NULL,
	`block` MEDIUMINT(8) UNSIGNED NOT NULL,
	`in_image` TINYINT(3) UNSIGNED NOT NULL,
	`raw_size` INT(10) UNSIGNED NOT NULL,
	`gb` INT(10) UNSIGNED NOT NULL,
	`device_number` MEDIUMINT(8) NOT NULL,
	`path` VARCHAR(64) NOT NULL,
	`directory_bits` MEDIUMINT(8) UNSIGNED NOT NULL,
	`owner` VARCHAR(32) NOT NULL,
	`group` VARCHAR(32) NOT NULL,
	`bytes` INT(10) UNSIGNED NOT NULL,
	`access_time` INT(10) UNSIGNED NOT NULL,
	`modification_time` INT(10) UNSIGNED NOT NULL,
	`inode_time` INT(10) UNSIGNED NOT NULL,
	PRIMARY KEY (`masterserver`, `backupid`, `file_number`)
)
COMMENT='bpflist -l -backupid'
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

CREATE OR REPLACE TABLE `bpimmedia` (
	`masterserver` VARCHAR(64) NOT NULL,
	`name` VARCHAR(64) NOT NULL,
	`version` TINYINT(3) UNSIGNED NOT NULL,
	`backupid` VARCHAR(64) NOT NULL,
	`policy_name` VARCHAR(64) NULL DEFAULT NULL,
	`policy_type` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`sched_label` VARCHAR(64) NULL DEFAULT NULL,
	`sched_type` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`retention` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`num_files` INT(10) UNSIGNED NULL DEFAULT NULL,
	`expiration` INT(10) UNSIGNED NULL DEFAULT NULL,
	`compression` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`encryption` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`hold` TINYINT(4) NULL DEFAULT NULL,
	PRIMARY KEY (`masterserver`, `backupid`),
	INDEX `name` (`name`),
	INDEX `expiration` (`expiration`)
)
COMMENT='bpimmedia -l'
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

CREATE OR REPLACE TABLE `bpimmedia_frags` (
	`masterserver` VARCHAR(64) NOT NULL,
	`backupid` VARCHAR(64) NOT NULL,
	`copy_number` TINYINT(3) UNSIGNED NOT NULL,
	`fragment_number` TINYINT(4) NOT NULL,
	`kilobytes` INT(10) UNSIGNED NOT NULL,
	`remainder` INT(10) UNSIGNED NULL DEFAULT NULL,
	`media_type` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`density` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`file_number` INT(10) UNSIGNED NULL DEFAULT NULL,
	`id_path` VARCHAR(64) NULL DEFAULT NULL,
	`host` VARCHAR(64) NULL DEFAULT NULL,
	`block_size` INT(10) UNSIGNED NULL DEFAULT NULL,
	`offset` INT(10) UNSIGNED NULL DEFAULT NULL,
	`media_date` INT(10) UNSIGNED NULL DEFAULT NULL,
	`device_written_on` TINYINT(4) NULL DEFAULT NULL,
	`f_flags` SMALLINT(5) UNSIGNED NULL DEFAULT NULL,
	`media_descriptor` VARCHAR(128) NULL DEFAULT NULL,
	`expiration` INT(10) UNSIGNED NULL DEFAULT NULL,
	`mpx` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`retention_level` INT(10) UNSIGNED NULL DEFAULT NULL,
	`checkpoint` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`copy_on_hold` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	PRIMARY KEY (`masterserver`, `backupid`, `copy_number`, `fragment_number`),
	INDEX `host` (`host`),
	INDEX `expiration` (`expiration`)
)
COMMENT='bpimmedia -l (FRAG parts)'
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

CREATE OR REPLACE TABLE `bpplclients` (
	`masterserver` VARCHAR(64) NOT NULL,
	`name` VARCHAR(64) NOT NULL,
	`architecture` VARCHAR(64) NOT NULL,
	`os` VARCHAR(64) NULL DEFAULT NULL,
	`priority` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`u1` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`u2` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`u3` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`obsoleted` TIMESTAMP NULL DEFAULT NULL,
	PRIMARY KEY (`masterserver`, `name`)
)
COMMENT='bpplclients -allunique -l'
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

CREATE OR REPLACE TABLE `bppllist_clients` (
	`masterserver` VARCHAR(64) NOT NULL,
	`policyname` VARCHAR(96) NOT NULL,
	`name` VARCHAR(64) NOT NULL,
	`architecture` VARCHAR(64) NOT NULL,
	`os` VARCHAR(64) NOT NULL,
	`field1` INT(10) UNSIGNED NULL DEFAULT NULL,
	`field2` INT(10) UNSIGNED NULL DEFAULT NULL,
	`field3` INT(10) UNSIGNED NULL DEFAULT NULL,
	`field4` VARCHAR(64) NULL DEFAULT NULL,
	`created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`obsoleted` TIMESTAMP NULL DEFAULT NULL,
	PRIMARY KEY (`masterserver`, `policyname`, `name`)
)
COMMENT='bppllist -clients'
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

CREATE OR REPLACE TABLE `bppllist_policies` (
	`masterserver` VARCHAR(64) NOT NULL,
	`name` VARCHAR(96) NOT NULL,
	`internalname` VARCHAR(32) NULL DEFAULT NULL,
	`options` INT(10) UNSIGNED NULL DEFAULT NULL,
	`protocolversion` INT(10) UNSIGNED NULL DEFAULT NULL,
	`timezoneoffset` INT(10) UNSIGNED NULL DEFAULT NULL,
	`auditreason` VARCHAR(64) NULL DEFAULT NULL,
	`policytype` INT(10) UNSIGNED NULL DEFAULT NULL,
	`follownfsmount` INT(10) UNSIGNED NULL DEFAULT NULL,
	`clientcompress` INT(10) UNSIGNED NULL DEFAULT NULL,
	`jobpriority` INT(10) UNSIGNED NULL DEFAULT NULL,
	`proxyclient` VARCHAR(64) NULL DEFAULT NULL,
	`clientencrypt` INT(10) UNSIGNED NULL DEFAULT NULL,
	`dr` INT(10) UNSIGNED NULL DEFAULT NULL,
	`maxjobsperclient` INT(10) NULL DEFAULT NULL,
	`crossmountpoints` INT(10) UNSIGNED NULL DEFAULT NULL,
	`maxfragsize` INT(10) UNSIGNED NULL DEFAULT NULL,
	`active` INT(10) UNSIGNED NULL DEFAULT NULL,
	`tir` INT(10) UNSIGNED NULL DEFAULT NULL,
	`blocklevelincrementals` INT(10) UNSIGNED NULL DEFAULT NULL,
	`extsecinfo` INT(10) UNSIGNED NULL DEFAULT NULL,
	`individualfilerestore` INT(10) UNSIGNED NULL DEFAULT NULL,
	`streaming` INT(10) UNSIGNED NULL DEFAULT NULL,
	`frozenimage` INT(10) UNSIGNED NULL DEFAULT NULL,
	`backupcopy` INT(10) UNSIGNED NULL DEFAULT NULL,
	`effectivedate` INT(10) UNSIGNED NULL DEFAULT NULL,
	`classid` VARCHAR(64) NULL DEFAULT NULL,
	`backupcopies` INT(10) UNSIGNED NULL DEFAULT NULL,
	`checkpoints` INT(10) UNSIGNED NULL DEFAULT NULL,
	`checkpointinterval` INT(10) UNSIGNED NULL DEFAULT NULL,
	`unused` INT(10) UNSIGNED NULL DEFAULT NULL,
	`instantrecovery` INT(10) UNSIGNED NULL DEFAULT NULL,
	`offhostbackup` INT(10) UNSIGNED NULL DEFAULT NULL,
	`alternateclient` INT(10) UNSIGNED NULL DEFAULT NULL,
	`datamover` INT(10) UNSIGNED NULL DEFAULT NULL,
	`datamovertype` INT(10) NULL DEFAULT NULL,
	`bmr` INT(10) UNSIGNED NULL DEFAULT NULL,
	`lifecycle` INT(10) UNSIGNED NULL DEFAULT NULL,
	`granularrestore` INT(10) UNSIGNED NULL DEFAULT NULL,
	`jobsubtype` INT(10) UNSIGNED NULL DEFAULT NULL,
	`vm` INT(10) UNSIGNED NULL DEFAULT NULL,
	`ignorecsdedup` INT(10) UNSIGNED NULL DEFAULT NULL,
	`exchangedbsource` INT(10) UNSIGNED NULL DEFAULT NULL,
	`generation` INT(10) UNSIGNED NULL DEFAULT NULL,
	`applicationdiscovery` INT(10) UNSIGNED NULL DEFAULT NULL,
	`accelerator` INT(10) UNSIGNED NULL DEFAULT NULL,
	`granularrestore1` INT(10) UNSIGNED NULL DEFAULT NULL,
	`discoverylifetime` INT(10) UNSIGNED NULL DEFAULT NULL,
	`fastbackup` INT(10) UNSIGNED NULL DEFAULT NULL,
	`optimizedbackup` INT(10) UNSIGNED NULL DEFAULT NULL,
	`clientlisttype` INT(10) UNSIGNED NULL DEFAULT NULL,
	`selectlisttype` INT(10) UNSIGNED NULL DEFAULT NULL,
	`appconsistent` INT(10) UNSIGNED NULL DEFAULT NULL,
	`key` VARCHAR(64) NULL DEFAULT NULL,
	`res` VARCHAR(128) NULL DEFAULT NULL,
	`pool` VARCHAR(128) NULL DEFAULT NULL,
	`foe` VARCHAR(64) NULL DEFAULT NULL,
	`sharegroup` VARCHAR(64) NULL DEFAULT NULL,
	`dataclassification` VARCHAR(64) NULL DEFAULT NULL,
	`hypervserver` VARCHAR(64) NULL DEFAULT NULL,
	`names` VARCHAR(64) NULL DEFAULT NULL,
	`bcmd` VARCHAR(64) NULL DEFAULT NULL,
	`rcmd` VARCHAR(64) NULL DEFAULT NULL,
	`applicationdefined` TEXT NULL DEFAULT NULL,
	`orabkupdatafileargs` VARCHAR(128) NULL DEFAULT NULL,
	`orabkuparchlogargs` VARCHAR(128) NULL DEFAULT NULL,
	`include` TEXT NULL DEFAULT NULL,
	`created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`obsoleted` TIMESTAMP NULL DEFAULT NULL,
	PRIMARY KEY (`masterserver`, `name`),
	INDEX `policytype` (`policytype`)
)
COMMENT='bppllist -policies'
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

CREATE OR REPLACE TABLE `bppllist_schedules` (
	`masterserver` VARCHAR(64) NOT NULL,
	`policyname` VARCHAR(96) NOT NULL,
	`name` VARCHAR(64) NOT NULL,
	`backuptype` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`multiplexingcopies` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`frequency` INT(10) UNSIGNED NULL DEFAULT NULL,
	`retentionlevel` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`reserved1` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`reserved2` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`reserved3` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`alternatereadserver` VARCHAR(64) NULL DEFAULT NULL,
	`maxfragmentsize` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`calendar` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`copies` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`foe` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`synthetic` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`pfifastrecover` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`priority` TINYINT(4) NULL DEFAULT NULL,
	`storageservice` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`checksumdetection` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`caldates` VARCHAR(64) NULL DEFAULT NULL,
	`calretries` VARCHAR(64) NULL DEFAULT NULL,
	`caldayofweek` VARCHAR(64) NULL DEFAULT NULL,
	`win_sun_start` INT(10) UNSIGNED NULL DEFAULT NULL,
	`win_sun_duration` INT(10) UNSIGNED NULL DEFAULT NULL,
	`win_mon_start` INT(10) UNSIGNED NULL DEFAULT NULL,
	`win_mon_duration` INT(10) UNSIGNED NULL DEFAULT NULL,
	`win_tue_start` INT(10) UNSIGNED NULL DEFAULT NULL,
	`win_tue_duration` INT(10) UNSIGNED NULL DEFAULT NULL,
	`win_wed_start` INT(10) UNSIGNED NULL DEFAULT NULL,
	`win_wed_duration` INT(10) UNSIGNED NULL DEFAULT NULL,
	`win_thu_start` INT(10) UNSIGNED NULL DEFAULT NULL,
	`win_thu_duration` INT(10) UNSIGNED NULL DEFAULT NULL,
	`win_fri_start` INT(10) UNSIGNED NULL DEFAULT NULL,
	`win_fri_duration` INT(10) UNSIGNED NULL DEFAULT NULL,
	`win_sat_start` INT(10) UNSIGNED NULL DEFAULT NULL,
	`win_sat_duration` INT(10) UNSIGNED NULL DEFAULT NULL,
	`schedres` VARCHAR(64) NULL DEFAULT NULL,
	`schedpool` VARCHAR(64) NULL DEFAULT NULL,
	`schedrl` VARCHAR(64) NULL DEFAULT NULL,
	`schedfoe` VARCHAR(64) NULL DEFAULT NULL,
	`schedsg` VARCHAR(64) NULL DEFAULT NULL,
	`created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`obsoleted` TIMESTAMP NULL DEFAULT NULL,
	PRIMARY KEY (`masterserver`, `policyname`, `name`)
)
COMMENT='bppllist -schedules'
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

CREATE OR REPLACE TABLE `bpretlevel` (
	`masterserver` VARCHAR(64) NOT NULL,
	`level` SMALLINT(3) NOT NULL,
	`days` SMALLINT(6) NOT NULL,
	`seconds` INT(11) NOT NULL,
	`period` VARCHAR(64) NOT NULL,
	PRIMARY KEY (`masterserver`, `level`)
)
COMMENT='List of NBU retention levels'
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

CREATE OR REPLACE TABLE `mars_bw_jobs` (
	`masterserver` VARCHAR(64) NOT NULL COLLATE 'utf8_general_ci',
	`policy` VARCHAR(64) NOT NULL COLLATE 'utf8_general_ci',
	`schedule` VARCHAR(64) NOT NULL COLLATE 'utf8_general_ci',
	`client` VARCHAR(64) NOT NULL COLLATE 'utf8_general_ci',
	`bw_day` DATE NOT NULL,
	`jobs` INT(11) NOT NULL,
	`mb` FLOAT(12) NULL DEFAULT NULL,
	`in_bsr` INT(11) NULL DEFAULT NULL,
	`mb_in_bsr` FLOAT(12) NULL DEFAULT NULL,
	`bsr` FLOAT(12) NULL DEFAULT NULL,
	`created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`obsoleted` TIMESTAMP NULL DEFAULT NULL,
	PRIMARY KEY (`masterserver`, `policy`, `schedule`, `client`, `bw_day`) USING BTREE
)
COMMENT='Backup day jobs'
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

CREATE OR REPLACE TABLE `nbstl` (
	`masterserver` VARCHAR(64) NOT NULL,
	`slpname` VARCHAR(64) NOT NULL,
	`dataclassification` VARCHAR(64) NULL DEFAULT NULL,
	`duplicationpriority` INT(10) UNSIGNED NULL DEFAULT NULL,
	`state` VARCHAR(8) NULL DEFAULT NULL,
	`version` INT(10) UNSIGNED NULL DEFAULT NULL,
	`operationindex` INT(10) UNSIGNED NULL DEFAULT NULL,
	`usefor` INT(10) UNSIGNED NULL DEFAULT NULL,
	`storageunit` VARCHAR(64) NULL DEFAULT NULL,
	`volumepool` VARCHAR(64) NULL DEFAULT NULL,
	`mediaowner` VARCHAR(64) NULL DEFAULT NULL,
	`retentiontype` INT(10) UNSIGNED NULL DEFAULT NULL,
	`retentionlevel` INT(10) UNSIGNED NULL DEFAULT NULL,
	`alternatereadserver` VARCHAR(64) NULL DEFAULT NULL,
	`preservempx` INT(10) NULL DEFAULT NULL,
	`ddostate` VARCHAR(8) NULL DEFAULT NULL,
	`source` INT(10) UNSIGNED NULL DEFAULT NULL,
	`unused` INT(10) UNSIGNED NULL DEFAULT NULL,
	`operationid` INT(10) UNSIGNED NULL DEFAULT NULL,
	`slpwindow` VARCHAR(64) NULL DEFAULT NULL,
	`targetmaster` VARCHAR(64) NULL DEFAULT NULL,
	`targetmasterslp` VARCHAR(64) NULL DEFAULT NULL,
	`created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`obsoleted` TIMESTAMP NULL DEFAULT NULL,
	PRIMARY KEY (`masterserver`, `slpname`,`operationindex`)
)
COMMENT='nbstl'
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

CREATE OR REPLACE TABLE `nbu_codes` (
	`field` VARCHAR(32) NOT NULL,
	`code` SMALLINT(6) NOT NULL,
	`description` VARCHAR(128) NOT NULL,
	PRIMARY KEY (`field`, `code`)
)
COMMENT='List of NBU codes and descriptions'
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

CREATE OR REPLACE TABLE `nbu_policy_tower_customer` (
	`masterserver` VARCHAR(64) NOT NULL,
	`policy` VARCHAR(64) NOT NULL,
	`tower` VARCHAR(32) NULL DEFAULT NULL,
	`customer` VARCHAR(64) NULL DEFAULT NULL,
	`created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`obsoleted` TIMESTAMP NULL DEFAULT NULL,
	PRIMARY KEY (`masterserver`,`policy`)
)
COMMENT='Policy-Tower-Customer inter-table'
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

CREATE OR REPLACE TABLE `nbdevquery_listdv_puredisk` (
	`masterserver` VARCHAR(64) NOT NULL,
	`version` VARCHAR(32) NULL DEFAULT NULL,
	`diskpool` VARCHAR(64) NULL DEFAULT NULL,
	`stype` VARCHAR(32) NULL DEFAULT NULL,
	`name` VARCHAR(32) NULL DEFAULT NULL,
	`disk_media_id` VARCHAR(32) NULL DEFAULT NULL,
	`total_capacity` FLOAT UNSIGNED NULL DEFAULT NULL,
	`free_space` FLOAT UNSIGNED NULL DEFAULT NULL,
	`used` FLOAT UNSIGNED NULL DEFAULT NULL,
	`nbu_state` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`sts_state` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`num_write_mounts` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`active_read_streams` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`active_write_streams` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`flags` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`num_read_mounts` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`obsoleted` TIMESTAMP NULL DEFAULT NULL,
	PRIMARY KEY (`masterserver`, `diskpool`)
)
COMMENT='nbdevquery -listdv -dtype puredisk'
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

CREATE OR REPLACE TABLE `vault_item_xml` (
	`masterserver` VARCHAR(64) NOT NULL,
	`profile` VARCHAR(32) NOT NULL,
	`type` VARCHAR(32) NOT NULL,
	`value` VARCHAR(64) NOT NULL,
	`created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`obsoleted` TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (`masterserver`, `profile`, `type`, `value`)
)
COMMENT='Contents of \'vault.xml\' file'
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

CREATE OR REPLACE TABLE `vault_xml` (
	`masterserver` VARCHAR(64) NOT NULL,
	`robot_id` TINYINT(3) UNSIGNED NOT NULL,
	`robot_lastmod` BIGINT(20) UNSIGNED NOT NULL,
	`robot_name` VARCHAR(64) NOT NULL,
	`robotnumber` TINYINT(4) NOT NULL,
	`robottype` VARCHAR(32) NOT NULL,
	`roboticcontrolhost` VARCHAR(64) NOT NULL,
	`usevaultprefene` ENUM('YES','NO') NOT NULL DEFAULT 'YES',
	`robot_ene` VARCHAR(256) NULL DEFAULT NULL,
	`customerid` VARCHAR(64) NOT NULL,
	`vault_id` TINYINT(3) UNSIGNED NOT NULL,
	`vault_lastmod` BIGINT(20) UNSIGNED NOT NULL,
	`vault_name` VARCHAR(32) NOT NULL,
	`offsitevolumegroup` VARCHAR(64) NOT NULL,
	`robotvolumegroup` VARCHAR(64) NOT NULL,
	`vaultcontainers` ENUM('YES','NO') NOT NULL,
	`vaultseed` TINYINT(3) UNSIGNED NOT NULL,
	`vendor` VARCHAR(64) NOT NULL,
	`profile_id` TINYINT(3) UNSIGNED NOT NULL,
	`profile_lastmod` BIGINT(20) UNSIGNED NOT NULL,
	`profile_name` VARCHAR(64) NOT NULL,
	`endday` TINYINT(3) UNSIGNED NOT NULL,
	`endhour` TINYINT(3) UNSIGNED NOT NULL,
	`startday` TINYINT(3) UNSIGNED NOT NULL,
	`starthour` TINYINT(3) UNSIGNED NOT NULL,
	`ipf_enabled` ENUM('YES','NO') NOT NULL DEFAULT 'NO',
	`clientfilter` SET('INCLUDE','INCLUDE_ALL') NULL DEFAULT NULL,
	`backuptypefilter` SET('INCLUDE','INCLUDE_ALL') NULL DEFAULT NULL,
	`mediaserverfilter` SET('INCLUDE','INCLUDE_ALL') NULL DEFAULT NULL,
	`classfilter` SET('INCLUDE','INCLUDE_ALL') NULL DEFAULT NULL,
	`schedulefilter` SET('INCLUDE','INCLUDE_ALL') NULL DEFAULT NULL,
	`retentionlevelfilter` SET('INCLUDE','INCLUDE_ALL') NULL DEFAULT NULL,
	`ilf_enabled` ENUM('YES','NO') NOT NULL DEFAULT 'NO',
	`sourcevolgroupfilter` SET('INCLUDE','INCLUDE_ALL') NULL DEFAULT NULL,
	`volumepoolfilter` SET('INCLUDE','INCLUDE_ALL') NULL DEFAULT NULL,
	`basicdiskfilter` SET('INCLUDE','INCLUDE_ALL') NULL DEFAULT NULL,
	`diskgroupfilter` SET('INCLUDE','INCLUDE_ALL') NULL DEFAULT NULL,
	`duplication_skip` ENUM('YES','NO') NOT NULL DEFAULT 'YES',
	`duppriority` TINYINT(4) NULL DEFAULT NULL,
	`multiplex` ENUM('YES','NO') NULL DEFAULT NULL,
	`sharedrobots` ENUM('YES','NO') NULL DEFAULT NULL,
	`sortorder` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`altreadhost` VARCHAR(64) NULL DEFAULT NULL,
	`backupserver` VARCHAR(64) NULL DEFAULT NULL,
	`readdrives` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`writedrives` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`fail` ENUM('YES','NO') NULL DEFAULT NULL,
	`primary` ENUM('YES','NO') NULL DEFAULT NULL,
	`retention` TINYINT(3) NULL DEFAULT NULL,
	`sharegroup` VARCHAR(32) NULL DEFAULT NULL,
	`stgunit` VARCHAR(64) NULL DEFAULT NULL,
	`volpool` VARCHAR(64) NULL DEFAULT NULL,
	`catalogbackup_skip` ENUM('YES','NO') NULL DEFAULT 'YES',
	`eject_skip` ENUM('YES','NO') NULL DEFAULT 'YES',
	`ejectmode` SET('AUTO','MANUAL') NULL DEFAULT NULL,
	`eject_ene` VARCHAR(256) NULL DEFAULT NULL,
	`suspend` SET('YES','NO') NULL DEFAULT NULL,
	`userbtorvaultprefene` SET('YES','NO') NULL DEFAULT NULL,
	`suspendmode` SET('NOW','LATER') NULL DEFAULT NULL,
	`imfile` VARCHAR(32) NULL DEFAULT NULL,
	`mode` SET('AUTO','MANUAL') NULL DEFAULT 'MANUAL',
	`useglobalrptsdist` SET('YES','NO') NULL DEFAULT 'YES',
	`created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`obsoleted` TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (`masterserver`, `profile_id`),
	INDEX `masterserver_robot_id` (`masterserver`, `robot_id`),
	INDEX `masterserver_vault_id` (`masterserver`, `vault_id`)
)
COMMENT='Contents of \'vault.xml\' file'
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

DELIMITER //

CREATE OR REPLACE DEFINER=CURRENT_USER EVENT nbu_event
ON SCHEDULE EVERY 5 MINUTE STARTS '2017-01-01' ON COMPLETION PRESERVE DISABLE COMMENT '' DO
BEGIN
	CALL nbu_routine();
END //

CREATE OR REPLACE DEFINER=CURRENT_USER FUNCTION `nbu_code`(
	`_field` VARCHAR(32),
	`_code` INT
)
RETURNS varchar(128) CHARSET utf8
LANGUAGE SQL
DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT 'NBU code to description function'
BEGIN
SET @description=NULL;
SELECT description INTO @description FROM nbu_codes WHERE field=_field and code=_code;
RETURN IFNULL(@description,_code);
END //

CREATE OR REPLACE DEFINER=CURRENT_USER FUNCTION `nbu_inbsr`(
	`_jobtype` INT,
	`_state` INT,
    `_childjobs` INT
)
RETURNS INT
LANGUAGE SQL
DETERMINISTIC
NO SQL
COMMENT 'NBU BSR detection function'
BEGIN
RETURN IF(IFNULL(_jobtype,0) IN (0,6,22,28) AND IFNULL(_state,0)=3 AND IFNULL(_childjobs,0)=0,1,0);
END //

CREATE OR REPLACE DEFINER=CURRENT_USER FUNCTION `nbu_bsr`(
	`_jobtype` INT,
	`_state` INT,
    `_childjobs` INT,
	`_policytype` INT,
	`_status` INT
)
RETURNS INT
LANGUAGE SQL
DETERMINISTIC
NO SQL
COMMENT 'NBU BSR calculation function'
BEGIN
RETURN IF(nbu_inbsr(_jobtype,_state,_childjobs),IF((_status=0) OR (_policytype IN (0,13) AND _status=1),100,0),NULL);
END //

CREATE OR REPLACE DEFINER=CURRENT_USER PROCEDURE `nbu_collect_bw_jobs`(
	IN `daysback` INT
)
LANGUAGE SQL
NOT DETERMINISTIC
MODIFIES SQL DATA
SQL SECURITY DEFINER
COMMENT 'BW Jobs collection routine'
BEGIN
INSERT INTO mars_bw_jobs (masterserver,policy,schedule,client,bw_day,jobs,mb,in_bsr,mb_in_bsr,bsr) (
	SELECT 
		j.masterserver,j.policy,j.schedule,j.client,j.bw_day,
		COUNT(j.jobid) AS jobs,
		ROUND(SUM(j.kbytes/1000),1) AS mb,
        SUM(nbu_inbsr(j.jobtype,j.state,j.childjobs)) AS in_bsr,
		ROUND(SUM(IF(nbu_inbsr(j.jobtype,j.state,j.childjobs),j.kbytes/1000,0)),1) as mb_in_bsr,
		IF(SUM(nbu_inbsr(j.jobtype,j.state,j.childjobs)),
			ROUND(SUM(nbu_bsr(j.jobtype,j.state,j.childjobs,j.policytype,j.status))/SUM(nbu_inbsr(j.jobtype,j.state,j.childjobs)),1)
            ,NULL) AS bsr
		FROM (
			SELECT 
				j.masterserver,j.policy,j.policytype,j.schedule,j.client,j.jobid,j.jobtype,j.state,j.status,j.kbytes,
				DATE(FROM_UNIXTIME(j.started-TIME_TO_SEC(s.value))) AS bw_day,
				IF(j.jobid=j.parentjob,(SELECT COUNT(r.jobid) FROM bpdbjobs_report r WHERE r.masterserver=j.masterserver AND r.parentjob=j.jobid)-1,NULL) AS childjobs
				FROM bpdbjobs_report j
					LEFT JOIN config_settings s ON (s.name='bw_start')
				WHERE j.masterserver IS NOT NULL AND j.policy IS NOT NULL AND j.schedule IS NOT NULL AND j.client IS NOT NULL
				AND j.started>UNIX_TIMESTAMP(ADDTIME(DATE(NOW()-INTERVAL daysback DAY-INTERVAL TIME_TO_SEC(s.value) SECOND),TIME(s.value)))
		) j
		GROUP BY j.masterserver,j.policy,j.schedule,j.client,j.bw_day
) ON DUPLICATE KEY UPDATE jobs=VALUES(jobs), mb=values(mb), in_bsr=VALUES(in_bsr), mb_in_bsr=VALUES(mb_in_bsr), bsr=VALUES(bsr),obsoleted=NULL;
END //

CREATE OR REPLACE DEFINER=CURRENT_USER PROCEDURE `nbu_routine`()
LANGUAGE SQL NOT DETERMINISTIC MODIFIES SQL DATA SQL SECURITY DEFINER
COMMENT 'NBU Routine'
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ALTER EVENT nbu_event ENABLE;
		RESIGNAL;
	END;
	SET @start=NOW();
	ALTER EVENT nbu_event DISABLE;
	INSERT INTO nbu_policy_tower_customer (masterserver,policy,tower,customer)
		SELECT p.masterserver,p.name,t.name,c.name FROM bppllist_policies p
			LEFT JOIN config_towers t ON (p.name REGEXP t.policyname AND t.obsoleted IS NULL)
			LEFT JOIN config_customers c ON (p.name REGEXP c.policyname AND c.obsoleted IS NULL)
	ON DUPLICATE KEY UPDATE tower=VALUES(tower),customer=VALUES(customer),updated=NOW(),obsoleted=NULL;
	INSERT INTO nbu_policy_tower_customer (masterserver,policy,tower,customer)
		SELECT j.masterserver,j.policy,t.name,c.name FROM (SELECT DISTINCT j.masterserver,j.policy FROM bpdbjobs_report j WHERE j.policy IS NOT NULL) j
			LEFT JOIN config_towers t ON (j.policy REGEXP t.policyname AND t.obsoleted IS NULL)
			LEFT JOIN config_customers c ON (j.policy REGEXP c.policyname AND c.obsoleted IS NULL)
		ON DUPLICATE KEY UPDATE tower=VALUES(tower),customer=VALUES(customer),updated=NOW(),obsoleted=NULL;
	UPDATE nbu_policy_tower_customer SET obsoleted=NOW() WHERE updated<NOW()-INTERVAL 1 DAY;
	SET @daysback=1;
	IF UNIX_TIMESTAMP(NOW())%(60*15) BETWEEN 540 AND 660 THEN 
		SET @daysback=2;
	END IF;
	IF UNIX_TIMESTAMP(NOW())%(60*60) BETWEEN 540 AND 660 THEN 
		SET @daysback=3;
	END IF;
	IF UNIX_TIMESTAMP(NOW())%(60*60*24) BETWEEN 540 AND 660 THEN 
		SET @daysback=7;
	END IF;
	SELECT COUNT(*) INTO @count FROM mars_bw_jobs;
	IF @count=0 THEN 
		SET @daysback=100;
	END IF;
	CALL nbu_collect_bw_jobs(@daysback);
	ALTER EVENT nbu_event ENABLE;
	REPLACE INTO config_settings (name,value) VALUES ('routine',TIMESTAMPDIFF(SECOND,@start,NOW()));
END //

CREATE OR REPLACE DEFINER=CURRENT_USER PROCEDURE `nbu_maintenance`()
LANGUAGE SQL NOT DETERMINISTIC MODIFIES SQL DATA SQL SECURITY DEFINER
COMMENT 'NBU Maintenance'
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ALTER EVENT nbu_event ENABLE;
		RESIGNAL;
	END;
	SET @start=NOW();
	ALTER EVENT nbu_event DISABLE;
	SET @backup_jobs=0;
	DROP TABLE IF EXISTS drop_table;
	DROP TABLE IF EXISTS temp_table;
	CREATE TABLE temp_table LIKE config_customers;
	INSERT INTO temp_table SELECT * FROM config_customers WHERE obsoleted IS NULL ORDER BY name;
	RENAME TABLE config_customers TO drop_table,temp_table TO config_customers;
	DROP TABLE drop_table;
	CREATE TABLE temp_table LIKE config_reports;
	INSERT INTO temp_table SELECT * FROM config_reports WHERE obsoleted IS NULL ORDER BY name;
	RENAME TABLE config_reports TO drop_table,temp_table TO config_reports;
	DROP TABLE drop_table;
	CREATE TABLE temp_table LIKE config_schedules;
	INSERT INTO temp_table SELECT * FROM config_schedules WHERE obsoleted IS NULL ORDER BY name;
	RENAME TABLE config_schedules TO drop_table,temp_table TO config_schedules;
	DROP TABLE drop_table;
	CREATE TABLE temp_table LIKE config_towers;
	INSERT INTO temp_table SELECT * FROM config_towers WHERE obsoleted IS NULL ORDER BY name;
	RENAME TABLE config_towers TO drop_table,temp_table TO config_towers;
	DROP TABLE drop_table;

	CREATE TABLE temp_table LIKE bpplclients;
	INSERT INTO temp_table SELECT * FROM bpplclients WHERE obsoleted IS NULL ORDER BY masterserver,name;
	RENAME TABLE bpplclients TO drop_table,temp_table TO bpplclients;
	DROP TABLE drop_table;
	CREATE TABLE temp_table LIKE bpimmedia_frags;
	INSERT INTO temp_table SELECT * FROM bpimmedia_frags WHERE expiration>UNIX_TIMESTAMP(NOW()) ORDER BY masterserver,backupid;
	RENAME TABLE bpimmedia_frags TO drop_table,temp_table TO bpimmedia_frags;
	DROP TABLE drop_table;
	CREATE TABLE temp_table LIKE bpimmedia;
	INSERT INTO temp_table SELECT i.* FROM bpimmedia i WHERE EXISTS (SELECT * FROM bpplclients c WHERE c.masterserver=i.masterserver AND c.name=i.name)
		AND EXISTS (SELECT * FROM bpimmedia_frags f WHERE f.masterserver=i.masterserver AND f.backupid=i.backupid AND f.fragment_number>0);
	RENAME TABLE bpimmedia TO drop_table,temp_table TO bpimmedia;
	DROP TABLE drop_table;
	CREATE TABLE temp_table LIKE bppllist_clients;
	INSERT INTO temp_table SELECT * FROM bppllist_clients WHERE obsoleted IS NULL ORDER BY masterserver,policyname,name;
	RENAME TABLE bppllist_clients TO drop_table,temp_table TO bppllist_clients;
	DROP TABLE drop_table;
	CREATE TABLE temp_table LIKE bppllist_policies;
	INSERT INTO temp_table SELECT * FROM bppllist_policies WHERE obsoleted IS NULL ORDER BY masterserver,name;
	RENAME TABLE bppllist_policies TO drop_table,temp_table TO bppllist_policies;
	DROP TABLE drop_table;
	CREATE TABLE temp_table LIKE bppllist_schedules;
	INSERT INTO temp_table SELECT * FROM bppllist_schedules WHERE obsoleted IS NULL ORDER BY masterserver,policyname,name;
	RENAME TABLE bppllist_schedules TO drop_table,temp_table TO bppllist_schedules;
	DROP TABLE drop_table;
	CREATE TABLE temp_table LIKE bpretlevel;
	INSERT INTO temp_table SELECT * FROM bpretlevel ORDER BY masterserver,level;
	RENAME TABLE bpretlevel TO drop_table,temp_table TO bpretlevel;
	DROP TABLE drop_table;
	CREATE TABLE temp_table LIKE nbstl;
	INSERT INTO temp_table SELECT * FROM nbstl WHERE obsoleted IS NULL ORDER BY masterserver,slpname;
	RENAME TABLE nbstl TO drop_table,temp_table TO nbstl;
	DROP TABLE drop_table;
	CREATE TABLE temp_table LIKE nbu_policy_tower_customer;
	INSERT INTO temp_table SELECT * FROM nbu_policy_tower_customer WHERE obsoleted IS NULL ORDER BY masterserver,policy;
	RENAME TABLE nbu_policy_tower_customer TO drop_table,temp_table TO nbu_policy_tower_customer;
	DROP TABLE drop_table;
	CREATE TABLE temp_table LIKE nbdevquery_listdv_puredisk;
	INSERT INTO temp_table SELECT * FROM nbdevquery_listdv_puredisk WHERE obsoleted IS NULL ORDER BY masterserver,diskpool;
	RENAME TABLE nbdevquery_listdv_puredisk TO drop_table,temp_table TO nbdevquery_listdv_puredisk;
	DROP TABLE drop_table;
	CREATE TABLE temp_table LIKE mars_bw_jobs;
	INSERT INTO temp_table SELECT * FROM mars_bw_jobs WHERE obsoleted IS NULL ORDER BY bw_day,masterserver,client;
	RENAME TABLE mars_bw_jobs TO drop_table,temp_table TO mars_bw_jobs;
	DROP TABLE drop_table;
	CREATE TABLE temp_table LIKE vault_xml;
	INSERT INTO temp_table SELECT * FROM vault_xml WHERE obsoleted IS NULL ORDER BY masterserver,profile_id;
	RENAME TABLE vault_xml TO drop_table,temp_table TO vault_xml;
	DROP TABLE drop_table;
	CREATE TABLE temp_table LIKE vault_item_xml;
	INSERT INTO temp_table SELECT * FROM vault_item_xml WHERE obsoleted IS NULL ORDER BY masterserver,profile,type,value;
	RENAME TABLE vault_item_xml TO drop_table,temp_table TO vault_item_xml;
	DROP TABLE drop_table;
	IF @backup_jobs=1 THEN
		CREATE DATABASE IF NOT EXISTS mars_backup;
		CREATE TABLE IF NOT EXISTS mars_backup.bpdbjobs_report LIKE bpdbjobs_report;
		REPLACE INTO mars_backup.bpdbjobs_report SELECT * FROM bpdbjobs_report WHERE started<UNIX_TIMESTAMP(NOW()-INTERVAL IFNULL(retentionperiod,0) DAY) ORDER BY masterserver,jobid;
	END IF;
	CREATE TABLE temp_table LIKE bpdbjobs_report;
	INSERT INTO temp_table SELECT * FROM bpdbjobs_report WHERE started>=UNIX_TIMESTAMP(NOW()-INTERVAL IFNULL(retentionperiod,0) DAY) ORDER BY masterserver,jobid;
	RENAME TABLE bpdbjobs_report TO drop_table,temp_table TO bpdbjobs_report;
	DROP TABLE drop_table;
	CREATE OR REPLACE TEMPORARY TABLE backupids (backupid VARCHAR(64) NOT NULL PRIMARY KEY);
	REPLACE INTO backupids (backupid) SELECT backupid FROM bpdbjobs_report WHERE backupid IS NOT NULL;
	REPLACE INTO backupids (backupid) SELECT backupid FROM bpimmedia WHERE backupid IS NOT NULL;
	CREATE TABLE temp_table LIKE bpflist_backupid;
	INSERT INTO temp_table SELECT f.* FROM bpflist_backupid f 
		WHERE EXISTS (SELECT j.backupid FROM backupids j WHERE j.backupid=f.backupid) 
		ORDER BY f.masterserver,f.backupid;
	RENAME TABLE bpflist_backupid TO drop_table,temp_table TO bpflist_backupid;
	DROP TABLE backupids;
	DROP TABLE drop_table;
	ALTER EVENT nbu_event ENABLE;
	REPLACE INTO config_settings (name,value) VALUES ('maintenance',TIMESTAMPDIFF(SECOND,@start,NOW()));
END //

DELIMITER ;

CREATE OR REPLACE ALGORITHM=TEMPTABLE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_bw_jobs` AS 
SELECT j.bw_day,
COUNT(DISTINCT ptc.tower) AS towers,
COUNT(DISTINCT ptc.customer) AS customers,
COUNT(DISTINCT ptc.masterserver) AS masterservers,
COUNT(DISTINCT c1.description) AS policytypes,
COUNT(DISTINCT ptc.policy) AS policies,
COUNT(DISTINCT c2.description) AS scheduletypes,
COUNT(DISTINCT j.schedule) AS schedules,
COUNT(DISTINCT j.client) AS clients,
SUM(j.jobs) AS jobs,
ROUND(SUM(j.mb/1000),1) AS gb,
SUM(j.in_bsr) AS in_bsr,
ROUND(SUM(j.mb_in_bsr)/100,1) AS gb_in_bsr,
ROUND(SUM(j.in_bsr*j.bsr)/SUM(j.in_bsr),1) AS bsr
FROM mars_bw_jobs j
	LEFT JOIN nbu_policy_tower_customer ptc ON (j.masterserver=ptc.masterserver AND j.policy=ptc.policy)
	LEFT JOIN bppllist_policies p ON (p.masterserver=ptc.masterserver AND p.name=ptc.policy)
	LEFT JOIN bppllist_schedules s ON (s.masterserver=ptc.masterserver AND s.policyname=ptc.policy AND s.name=j.schedule)
	LEFT JOIN nbu_codes c1 ON (c1.field='policytype' AND c1.code=p.policytype)
	LEFT JOIN nbu_codes c2 ON (c2.field='scheduletype' AND c2.code=s.backuptype)
	LEFT JOIN config_settings cs ON (cs.name='bw_start')
	WHERE IFNULL(ptc.tower,'')=IFNULL(f_tower(),IFNULL(ptc.tower,''))
	AND IFNULL (ptc.customer,'')=IFNULL(f_customer(),IFNULL(ptc.customer,''))
	AND UNIX_TIMESTAMP(j.bw_day)+TIME_TO_SEC(cs.value) BETWEEN f_from() AND f_to()
	GROUP BY j.bw_day
	ORDER BY j.bw_day DESC
;

CREATE OR REPLACE ALGORITHM=TEMPTABLE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_bw_jobs_detail` AS 
SELECT j.bw_day,
ptc.tower,ptc.customer,ptc.masterserver,
c1.description as policytype,ptc.policy,
c2.description AS scheduletype,j.schedule,
j.client,j.jobs,j.mb,j.in_bsr,j.mb_in_bsr,j.bsr
FROM mars_bw_jobs j
	LEFT JOIN nbu_policy_tower_customer ptc ON (j.masterserver=ptc.masterserver AND j.policy=ptc.policy)
	LEFT JOIN bppllist_policies p ON (p.masterserver=ptc.masterserver AND p.name=ptc.policy)
	LEFT JOIN bppllist_schedules s ON (s.masterserver=ptc.masterserver AND s.policyname=ptc.policy AND s.name=j.schedule)
	LEFT JOIN nbu_codes c1 ON (c1.field='policytype' AND c1.code=p.policytype)
	LEFT JOIN nbu_codes c2 ON (c2.field='scheduletype' AND c2.code=s.backuptype)
	LEFT JOIN config_settings cs ON (cs.name='bw_start')
	WHERE IFNULL(ptc.tower,'')=IFNULL(f_tower(),IFNULL(ptc.tower,''))
	AND IFNULL (ptc.customer,'')=IFNULL(f_customer(),IFNULL(ptc.customer,''))
	AND UNIX_TIMESTAMP(j.bw_day)+TIME_TO_SEC(cs.value) BETWEEN f_from() AND f_to()
	ORDER BY j.bw_day DESC,ptc.tower,ptc.customer,ptc.masterserver,ptc.policy,j.schedule,j.client 
;

CREATE OR REPLACE ALGORITHM=TEMPTABLE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_bw_jobs_towers` AS 
SELECT j.bw_day,
ptc.tower,
COUNT(DISTINCT ptc.customer) AS customers,
COUNT(DISTINCT ptc.masterserver) AS masterservers,
COUNT(DISTINCT c1.description) AS policytypes,
COUNT(DISTINCT ptc.policy) AS policies,
COUNT(DISTINCT c2.description) AS scheduletypes,
COUNT(DISTINCT j.schedule) AS schedules,
COUNT(DISTINCT j.client) AS clients,
SUM(j.jobs) AS jobs,
ROUND(SUM(j.mb/1000),1) AS gb,
SUM(j.in_bsr) AS in_bsr,
ROUND(SUM(j.mb_in_bsr)/100,1) AS gb_in_bsr,
ROUND(SUM(j.in_bsr*j.bsr)/SUM(j.in_bsr),1) AS bsr
FROM mars_bw_jobs j
	LEFT JOIN nbu_policy_tower_customer ptc ON (j.masterserver=ptc.masterserver AND j.policy=ptc.policy)
	LEFT JOIN bppllist_policies p ON (p.masterserver=ptc.masterserver AND p.name=ptc.policy)
	LEFT JOIN bppllist_schedules s ON (s.masterserver=ptc.masterserver AND s.policyname=ptc.policy AND s.name=j.schedule)
	LEFT JOIN nbu_codes c1 ON (c1.field='policytype' AND c1.code=p.policytype)
	LEFT JOIN nbu_codes c2 ON (c2.field='scheduletype' AND c2.code=s.backuptype)
	LEFT JOIN config_settings cs ON (cs.name='bw_start')
	WHERE IFNULL(ptc.tower,'')=IFNULL(f_tower(),IFNULL(ptc.tower,''))
	AND IFNULL (ptc.customer,'')=IFNULL(f_customer(),IFNULL(ptc.customer,''))
	AND UNIX_TIMESTAMP(j.bw_day)+TIME_TO_SEC(cs.value) BETWEEN f_from() AND f_to()
	GROUP BY j.bw_day,ptc.tower
	ORDER BY j.bw_day DESC,ptc.tower
;

CREATE OR REPLACE ALGORITHM=TEMPTABLE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_bw_jobs_customers` AS 
SELECT j.bw_day,
COUNT(DISTINCT ptc.tower) AS towers,
ptc.customer,
COUNT(DISTINCT ptc.masterserver) AS masterservers,
COUNT(DISTINCT c1.description) AS policytypes,
COUNT(DISTINCT ptc.policy) AS policies,
COUNT(DISTINCT c2.description) AS scheduletypes,
COUNT(DISTINCT j.schedule) AS schedules,
COUNT(DISTINCT j.client) AS clients,
SUM(j.jobs) AS jobs,
ROUND(SUM(j.mb/1000),1) AS gb,
SUM(j.in_bsr) AS in_bsr,
ROUND(SUM(j.mb_in_bsr)/100,1) AS gb_in_bsr,
ROUND(SUM(j.in_bsr*j.bsr)/SUM(j.in_bsr),1) AS bsr
FROM mars_bw_jobs j
	LEFT JOIN nbu_policy_tower_customer ptc ON (j.masterserver=ptc.masterserver AND j.policy=ptc.policy)
	LEFT JOIN bppllist_policies p ON (p.masterserver=ptc.masterserver AND p.name=ptc.policy)
	LEFT JOIN bppllist_schedules s ON (s.masterserver=ptc.masterserver AND s.policyname=ptc.policy AND s.name=j.schedule)
	LEFT JOIN nbu_codes c1 ON (c1.field='policytype' AND c1.code=p.policytype)
	LEFT JOIN nbu_codes c2 ON (c2.field='scheduletype' AND c2.code=s.backuptype)
	LEFT JOIN config_settings cs ON (cs.name='bw_start')
	WHERE IFNULL(ptc.tower,'')=IFNULL(f_tower(),IFNULL(ptc.tower,''))
	AND IFNULL (ptc.customer,'')=IFNULL(f_customer(),IFNULL(ptc.customer,''))
	AND UNIX_TIMESTAMP(j.bw_day)+TIME_TO_SEC(cs.value) BETWEEN f_from() AND f_to()
	GROUP BY j.bw_day,ptc.customer
	ORDER BY j.bw_day DESC,ptc.customer
;

CREATE OR REPLACE ALGORITHM=TEMPTABLE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_bw_jobs_masterservers` AS 
SELECT j.bw_day,
COUNT(DISTINCT ptc.tower) AS towers,
COUNT(DISTINCT ptc.customer) AS customers,
ptc.masterserver,
COUNT(DISTINCT c1.description) AS policytypes,
COUNT(DISTINCT ptc.policy) AS policies,
COUNT(DISTINCT c2.description) AS scheduletypes,
COUNT(DISTINCT j.schedule) AS schedules,
COUNT(DISTINCT j.client) AS clients,
SUM(j.jobs) AS jobs,
ROUND(SUM(j.mb/1000),1) AS gb,
SUM(j.in_bsr) AS in_bsr,
ROUND(SUM(j.mb_in_bsr)/100,1) AS gb_in_bsr,
ROUND(SUM(j.in_bsr*j.bsr)/SUM(j.in_bsr),1) AS bsr
FROM mars_bw_jobs j
	LEFT JOIN nbu_policy_tower_customer ptc ON (j.masterserver=ptc.masterserver AND j.policy=ptc.policy)
	LEFT JOIN bppllist_policies p ON (p.masterserver=ptc.masterserver AND p.name=ptc.policy)
	LEFT JOIN bppllist_schedules s ON (s.masterserver=ptc.masterserver AND s.policyname=ptc.policy AND s.name=j.schedule)
	LEFT JOIN nbu_codes c1 ON (c1.field='policytype' AND c1.code=p.policytype)
	LEFT JOIN nbu_codes c2 ON (c2.field='scheduletype' AND c2.code=s.backuptype)
	LEFT JOIN config_settings cs ON (cs.name='bw_start')
	WHERE IFNULL(ptc.tower,'')=IFNULL(f_tower(),IFNULL(ptc.tower,''))
	AND IFNULL (ptc.customer,'')=IFNULL(f_customer(),IFNULL(ptc.customer,''))
	AND UNIX_TIMESTAMP(j.bw_day)+TIME_TO_SEC(cs.value) BETWEEN f_from() AND f_to()
	GROUP BY j.bw_day,ptc.masterserver
	ORDER BY j.bw_day DESC,ptc.masterserver
;

CREATE OR REPLACE ALGORITHM=TEMPTABLE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_bw_jobs_policytypes` AS 
SELECT j.bw_day,
COUNT(DISTINCT ptc.tower) AS towers,
COUNT(DISTINCT ptc.customer) AS customers,
COUNT(DISTINCT ptc.masterserver) AS masterservers,
c1.description AS policytype,
COUNT(DISTINCT ptc.policy) AS policies,
COUNT(DISTINCT c2.description) AS scheduletypes,
COUNT(DISTINCT j.schedule) AS schedules,
COUNT(DISTINCT j.client) AS clients,
SUM(j.jobs) AS jobs,
ROUND(SUM(j.mb/1000),1) AS gb,
SUM(j.in_bsr) AS in_bsr,
ROUND(SUM(j.mb_in_bsr)/100,1) AS gb_in_bsr,
ROUND(SUM(j.in_bsr*j.bsr)/SUM(j.in_bsr),1) AS bsr
FROM mars_bw_jobs j
	LEFT JOIN nbu_policy_tower_customer ptc ON (j.masterserver=ptc.masterserver AND j.policy=ptc.policy)
	LEFT JOIN bppllist_policies p ON (p.masterserver=ptc.masterserver AND p.name=ptc.policy)
	LEFT JOIN bppllist_schedules s ON (s.masterserver=ptc.masterserver AND s.policyname=ptc.policy AND s.name=j.schedule)
	LEFT JOIN nbu_codes c1 ON (c1.field='policytype' AND c1.code=p.policytype)
	LEFT JOIN nbu_codes c2 ON (c2.field='scheduletype' AND c2.code=s.backuptype)
	LEFT JOIN config_settings cs ON (cs.name='bw_start')
	WHERE IFNULL(ptc.tower,'')=IFNULL(f_tower(),IFNULL(ptc.tower,''))
	AND IFNULL (ptc.customer,'')=IFNULL(f_customer(),IFNULL(ptc.customer,''))
	AND UNIX_TIMESTAMP(j.bw_day)+TIME_TO_SEC(cs.value) BETWEEN f_from() AND f_to()
	GROUP BY j.bw_day,c1.description
	ORDER BY j.bw_day DESC,c1.description
;

CREATE OR REPLACE ALGORITHM=TEMPTABLE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_bw_jobs_policies` AS 
SELECT j.bw_day,
COUNT(DISTINCT ptc.tower) AS towers,
COUNT(DISTINCT ptc.customer) AS customers,
COUNT(DISTINCT ptc.masterserver) AS masterservers,
COUNT(DISTINCT c1.description) AS policytypes,
ptc.policy,
COUNT(DISTINCT c2.description) AS scheduletypes,
COUNT(DISTINCT j.schedule) AS schedules,
COUNT(DISTINCT j.client) AS clients,
SUM(j.jobs) AS jobs,
ROUND(SUM(j.mb/1000),1) AS gb,
SUM(j.in_bsr) AS in_bsr,
ROUND(SUM(j.mb_in_bsr)/100,1) AS gb_in_bsr,
ROUND(SUM(j.in_bsr*j.bsr)/SUM(j.in_bsr),1) AS bsr
FROM mars_bw_jobs j
	LEFT JOIN nbu_policy_tower_customer ptc ON (j.masterserver=ptc.masterserver AND j.policy=ptc.policy)
	LEFT JOIN bppllist_policies p ON (p.masterserver=ptc.masterserver AND p.name=ptc.policy)
	LEFT JOIN bppllist_schedules s ON (s.masterserver=ptc.masterserver AND s.policyname=ptc.policy AND s.name=j.schedule)
	LEFT JOIN nbu_codes c1 ON (c1.field='policytype' AND c1.code=p.policytype)
	LEFT JOIN nbu_codes c2 ON (c2.field='scheduletype' AND c2.code=s.backuptype)
	LEFT JOIN config_settings cs ON (cs.name='bw_start')
	WHERE IFNULL(ptc.tower,'')=IFNULL(f_tower(),IFNULL(ptc.tower,''))
	AND IFNULL (ptc.customer,'')=IFNULL(f_customer(),IFNULL(ptc.customer,''))
	AND UNIX_TIMESTAMP(j.bw_day)+TIME_TO_SEC(cs.value) BETWEEN f_from() AND f_to()
	GROUP BY j.bw_day,ptc.policy
	ORDER BY j.bw_day DESC,ptc.policy
;

CREATE OR REPLACE ALGORITHM=TEMPTABLE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_bw_jobs_scheduletypes` AS 
SELECT j.bw_day,
COUNT(DISTINCT ptc.tower) AS towers,
COUNT(DISTINCT ptc.customer) AS customers,
COUNT(DISTINCT ptc.masterserver) AS masterservers,
COUNT(DISTINCT c1.description) AS policytypes,
COUNT(DISTINCT ptc.policy) AS policies,
c2.description AS scheduletype,
COUNT(DISTINCT j.schedule) AS schedules,
COUNT(DISTINCT j.client) AS clients,
SUM(j.jobs) AS jobs,
ROUND(SUM(j.mb/1000),1) AS gb,
SUM(j.in_bsr) AS in_bsr,
ROUND(SUM(j.mb_in_bsr)/100,1) AS gb_in_bsr,
ROUND(SUM(j.in_bsr*j.bsr)/SUM(j.in_bsr),1) AS bsr
FROM mars_bw_jobs j
	LEFT JOIN nbu_policy_tower_customer ptc ON (j.masterserver=ptc.masterserver AND j.policy=ptc.policy)
	LEFT JOIN bppllist_policies p ON (p.masterserver=ptc.masterserver AND p.name=ptc.policy)
	LEFT JOIN bppllist_schedules s ON (s.masterserver=ptc.masterserver AND s.policyname=ptc.policy AND s.name=j.schedule)
	LEFT JOIN nbu_codes c1 ON (c1.field='policytype' AND c1.code=p.policytype)
	LEFT JOIN nbu_codes c2 ON (c2.field='scheduletype' AND c2.code=s.backuptype)
	LEFT JOIN config_settings cs ON (cs.name='bw_start')
	WHERE IFNULL(ptc.tower,'')=IFNULL(f_tower(),IFNULL(ptc.tower,''))
	AND IFNULL (ptc.customer,'')=IFNULL(f_customer(),IFNULL(ptc.customer,''))
	AND UNIX_TIMESTAMP(j.bw_day)+TIME_TO_SEC(cs.value) BETWEEN f_from() AND f_to()
	GROUP BY j.bw_day,c2.description
	ORDER BY j.bw_day DESC,c2.description
;

CREATE OR REPLACE ALGORITHM=TEMPTABLE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_bw_jobs_schedules` AS 
SELECT j.bw_day,
COUNT(DISTINCT ptc.tower) AS towers,
COUNT(DISTINCT ptc.customer) AS customers,
COUNT(DISTINCT ptc.masterserver) AS masterservers,
COUNT(DISTINCT c1.description) AS policytypes,
COUNT(DISTINCT ptc.policy) AS policies,
COUNT(DISTINCT c2.description) AS scheduletypes,
j.schedule,
COUNT(DISTINCT j.client) AS clients,
SUM(j.jobs) AS jobs,
ROUND(SUM(j.mb/1000),1) AS gb,
SUM(j.in_bsr) AS in_bsr,
ROUND(SUM(j.mb_in_bsr)/100,1) AS gb_in_bsr,
ROUND(SUM(j.in_bsr*j.bsr)/SUM(j.in_bsr),1) AS bsr
FROM mars_bw_jobs j
	LEFT JOIN nbu_policy_tower_customer ptc ON (j.masterserver=ptc.masterserver AND j.policy=ptc.policy)
	LEFT JOIN bppllist_policies p ON (p.masterserver=ptc.masterserver AND p.name=ptc.policy)
	LEFT JOIN bppllist_schedules s ON (s.masterserver=ptc.masterserver AND s.policyname=ptc.policy AND s.name=j.schedule)
	LEFT JOIN nbu_codes c1 ON (c1.field='policytype' AND c1.code=p.policytype)
	LEFT JOIN nbu_codes c2 ON (c2.field='scheduletype' AND c2.code=s.backuptype)
	LEFT JOIN config_settings cs ON (cs.name='bw_start')
	WHERE IFNULL(ptc.tower,'')=IFNULL(f_tower(),IFNULL(ptc.tower,''))
	AND IFNULL (ptc.customer,'')=IFNULL(f_customer(),IFNULL(ptc.customer,''))
	AND UNIX_TIMESTAMP(j.bw_day)+TIME_TO_SEC(cs.value) BETWEEN f_from() AND f_to()
	GROUP BY j.bw_day,j.schedule
	ORDER BY j.bw_day DESC,j.schedule
;

CREATE OR REPLACE ALGORITHM=TEMPTABLE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_bw_jobs_clients` AS 
SELECT j.bw_day,
COUNT(DISTINCT ptc.tower) AS towers,
COUNT(DISTINCT ptc.customer) AS customers,
COUNT(DISTINCT ptc.masterserver) AS masterservers,
COUNT(DISTINCT c1.description) AS policytypes,
COUNT(DISTINCT ptc.policy) AS policies,
COUNT(DISTINCT c2.description) AS scheduletypes,
COUNT(DISTINCT j.schedule) AS schedules,
j.client,
SUM(j.jobs) AS jobs,
ROUND(SUM(j.mb/1000),1) AS gb,
SUM(j.in_bsr) AS in_bsr,
ROUND(SUM(j.mb_in_bsr)/100,1) AS gb_in_bsr,
ROUND(SUM(j.in_bsr*j.bsr)/SUM(j.in_bsr),1) AS bsr
FROM mars_bw_jobs j
	LEFT JOIN nbu_policy_tower_customer ptc ON (j.masterserver=ptc.masterserver AND j.policy=ptc.policy)
	LEFT JOIN bppllist_policies p ON (p.masterserver=ptc.masterserver AND p.name=ptc.policy)
	LEFT JOIN bppllist_schedules s ON (s.masterserver=ptc.masterserver AND s.policyname=ptc.policy AND s.name=j.schedule)
	LEFT JOIN nbu_codes c1 ON (c1.field='policytype' AND c1.code=p.policytype)
	LEFT JOIN nbu_codes c2 ON (c2.field='scheduletype' AND c2.code=s.backuptype)
	LEFT JOIN config_settings cs ON (cs.name='bw_start')
	WHERE IFNULL(ptc.tower,'')=IFNULL(f_tower(),IFNULL(ptc.tower,''))
	AND IFNULL (ptc.customer,'')=IFNULL(f_customer(),IFNULL(ptc.customer,''))
	AND UNIX_TIMESTAMP(j.bw_day)+TIME_TO_SEC(cs.value) BETWEEN f_from() AND f_to()
	GROUP BY j.bw_day,j.client
	ORDER BY j.bw_day DESC,j.client
;

CREATE OR REPLACE ALGORITHM=MERGE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_filtered_jobs` AS 
SELECT 
	j.masterserver,j.jobid,j.parentjob,
	IF(j.jobid=j.parentjob,(SELECT COUNT(r.jobid) FROM bpdbjobs_report r WHERE r.masterserver=j.masterserver AND r.parentjob=j.jobid)-1,NULL) AS childjobs,
	j.jobtype,j.subtype,j.state,j.operation,
	j.status,j.percent,
	ptc.tower,ptc.customer,
	j.policy,j.policytype,j.schedule,j.scheduletype,
	j.client,j.server,
	j.started,j.elapsed,j.ended,
	j.backupid,j.stunit,j.priority,j.tries,j.kbytes,j.files,j.owner,j.group,
	j.retentionlevel,j.retentionperiod,j.restartable,j.kbpersec
	FROM bpdbjobs_report j FORCE KEY (started)
		LEFT JOIN nbu_policy_tower_customer ptc ON (ptc.masterserver=j.masterserver AND ptc.policy=j.policy)
	WHERE IFNULL(ptc.tower,'')=IFNULL(f_tower(),IFNULL(ptc.tower,''))
	AND IFNULL (ptc.customer,'')=IFNULL(f_customer(),IFNULL(ptc.customer,''))
	AND j.started BETWEEN f_from() AND f_to()
	ORDER BY j.jobid 
;

CREATE OR REPLACE ALGORITHM=MERGE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_jobs` AS 
SELECT 
	b.masterserver,b.jobid,b.parentjob,b.childjobs,
	nbu_code('jobtype',b.jobtype) AS jobtype,
	nbu_code('subtype',b.subtype) AS subtype,
	nbu_code('state',b.state) AS state,
	nbu_code('operation',b.operation) AS operation,
	b.status,b.percent,b.tower,b.customer,
	b.policy,
	nbu_code('policytype',b.policytype) AS policytype,
	b.schedule,
	nbu_code('scheduletype',b.scheduletype) AS scheduletype,
	b.client,
	b.server,
	DATE(FROM_UNIXTIME(b.started-TIME_TO_SEC(s.value))) AS bw_day,
	from_unixtime(b.started) AS started,sec_to_time(b.elapsed) AS elapsed,from_unixtime(b.ended) AS ended,
	b.backupid,b.stunit,b.priority,b.tries,b.kbytes,b.files,b.owner,b.group,
	b.retentionlevel,b.retentionperiod,b.restartable,b.kbpersec
	FROM nbu_filtered_jobs b
	LEFT JOIN config_settings s ON (s.name='bw_start')
;

CREATE OR REPLACE ALGORITHM=MERGE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_bsr_jobs` AS 
SELECT 
	b.masterserver,b.jobid,b.parentjob,b.childjobs,
	nbu_code('jobtype',b.jobtype) AS jobtype,
	nbu_code('subtype',b.subtype) AS subtype,
	nbu_code('state',b.state) AS state,
	nbu_code('operation',b.operation) AS operation,
    nbu_bsr(b.jobtype,b.state,b.childjobs,b.policytype,b.status) AS bsr,
	b.status,b.percent,b.tower,b.customer,
	b.policy,
	nbu_code('policytype',b.policytype) AS policytype,
	b.schedule,
	nbu_code('scheduletype',b.scheduletype) AS scheduletype,
	b.client,
	b.server,
	DATE(FROM_UNIXTIME(b.started-TIME_TO_SEC(s.value))) AS bw_day,
	FROM_UNIXTIME(b.started) AS started,SEC_TO_TIME(b.elapsed) AS elapsed,FROM_UNIXTIME(b.ended) AS ended,
	b.backupid,b.stunit,b.priority,b.tries,b.kbytes,b.files,b.owner,b.group,
	b.retentionlevel,b.retentionperiod,b.restartable,b.kbpersec
	FROM nbu_filtered_jobs b
	LEFT JOIN config_settings s ON (s.name='bw_start')
    WHERE nbu_inbsr(b.jobtype,b.state,b.childjobs)
;

CREATE OR REPLACE ALGORITHM=TEMPTABLE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_bsr` AS 
SELECT 
	j.bw_day AS DAY,
	SUM(j.in_bsr) AS jobs,
	ROUND(SUM(j.in_bsr*j.bsr)/SUM(j.in_bsr),1) AS bsr
	FROM nbu_bw_jobs j
	GROUP BY j.bw_day
	ORDER BY j.bw_day DESC 
;

CREATE OR REPLACE ALGORITHM=TEMPTABLE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_bsr_client` AS 
SELECT 
	j.bw_day AS DAY,
	j.client,
	SUM(j.in_bsr) AS jobs,
	ROUND(SUM(j.in_bsr*j.bsr)/SUM(j.in_bsr),1) AS bsr
	FROM nbu_bw_jobs_clients j
	GROUP BY j.bw_day,j.client
	ORDER BY j.bw_day DESC,j.client
;

CREATE OR REPLACE ALGORITHM=TEMPTABLE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_bsr_customer` AS 
SELECT 
	j.bw_day AS DAY,
	j.customer,
	SUM(j.in_bsr) AS jobs,
	ROUND(SUM(j.in_bsr*j.bsr)/SUM(j.in_bsr),1) AS bsr
	FROM nbu_bw_jobs_customers j
	GROUP BY j.bw_day,j.customer
	ORDER BY j.bw_day DESC,j.customer
;

CREATE OR REPLACE ALGORITHM=TEMPTABLE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_bsr_policy` AS 
SELECT 
	j.bw_day AS DAY,
	j.policytype AS policy,
	SUM(j.in_bsr) AS jobs,
	ROUND(SUM(j.in_bsr*j.bsr)/SUM(j.in_bsr),1) AS bsr
	FROM nbu_bw_jobs_policytypes j
	GROUP BY j.bw_day,j.policytype
	ORDER BY j.bw_day DESC,j.policytype
;

CREATE OR REPLACE ALGORITHM=TEMPTABLE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_bsr_schedule` AS 
SELECT 
	j.bw_day AS DAY,
	j.scheduletype AS schedule,
	SUM(j.in_bsr) AS jobs,
	ROUND(SUM(j.in_bsr*j.bsr)/SUM(j.in_bsr),1) AS bsr
	FROM nbu_bw_jobs_scheduletypes j
	GROUP BY j.bw_day,j.scheduletype
	ORDER BY j.bw_day DESC,j.scheduletype
;

CREATE OR REPLACE ALGORITHM=TEMPTABLE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_bsr_type` AS 
SELECT 
	j.bw_day AS DAY,
	CONCAT(j.policytype,'/',j.scheduletype) AS type,
	SUM(j.in_bsr) AS jobs,
	ROUND(SUM(j.in_bsr*j.bsr)/SUM(j.in_bsr),1) AS bsr
	FROM nbu_bw_jobs_detail j
	GROUP BY j.bw_day,j.policytype,j.scheduletype
	ORDER BY j.bw_day DESC,j.policytype,j.scheduletype
;

CREATE OR REPLACE ALGORITHM=TEMPTABLE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_gbsr` AS 
SELECT 
	MIN(j.bw_day) AS `from`,
	MAX(j.bw_day) AS `to`,
	SUM(j.in_bsr) AS jobs,
	ROUND(SUM(j.in_bsr*j.bsr)/SUM(j.in_bsr),1) AS bsr
	FROM nbu_bw_jobs j
;

CREATE OR REPLACE ALGORITHM=TEMPTABLE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_gbsr_client` AS 
SELECT 
	MIN(j.bw_day) AS `from`,
	MAX(j.bw_day) AS `to`,
	j.client,
	SUM(j.in_bsr) AS jobs,
	ROUND(SUM(j.in_bsr*j.bsr)/SUM(j.in_bsr),1) AS bsr
	FROM nbu_bw_jobs_clients j
	GROUP BY j.client
	ORDER BY j.client
;

CREATE OR REPLACE ALGORITHM=TEMPTABLE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_gbsr_customer` AS 
SELECT 
	MIN(j.bw_day) AS `from`,
	MAX(j.bw_day) AS `to`,
	j.customer,
	SUM(j.in_bsr) AS jobs,
	ROUND(SUM(j.in_bsr*j.bsr)/SUM(j.in_bsr),1) AS bsr
	FROM nbu_bw_jobs_customers j
	GROUP BY j.customer
	ORDER BY j.customer
;

CREATE OR REPLACE ALGORITHM=TEMPTABLE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_gbsr_policy` AS 
SELECT 
	MIN(j.bw_day) AS `from`,
	MAX(j.bw_day) AS `to`,
	j.policytype AS policy,
	SUM(j.in_bsr) AS jobs,
	ROUND(SUM(j.in_bsr*j.bsr)/SUM(j.in_bsr),1) AS bsr
	FROM nbu_bw_jobs_policytypes j
	GROUP BY j.policytype
	ORDER BY j.policytype
;

CREATE OR REPLACE ALGORITHM=TEMPTABLE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_gbsr_schedule` AS 
SELECT 
	MIN(j.bw_day) AS `from`,
	MAX(j.bw_day) AS `to`,
	j.scheduletype AS schedule,
	SUM(j.in_bsr) AS jobs,
	ROUND(SUM(j.in_bsr*j.bsr)/SUM(j.in_bsr),1) AS bsr
	FROM nbu_bw_jobs_scheduletypes j
	GROUP BY j.scheduletype
	ORDER BY j.scheduletype
;

CREATE OR REPLACE ALGORITHM=TEMPTABLE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_gbsr_type` AS 
SELECT 
	MIN(j.bw_day) AS `from`,
	MAX(j.bw_day) AS `to`,
	CONCAT(j.policytype,'/',j.scheduletype) AS type,
	SUM(j.in_bsr) AS jobs,
	ROUND(SUM(j.in_bsr*j.bsr)/SUM(j.in_bsr),1) AS bsr
	FROM nbu_bw_jobs_detail j
	GROUP BY j.policytype,j.scheduletype
	ORDER BY j.policytype,j.scheduletype
;

CREATE OR REPLACE ALGORITHM=TEMPTABLE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_clients` AS 
SELECT
	c.masterserver,
	ptc.tower,ptc.customer,
	(SELECT IF(p.policytype IN (4,6,7,8,11,15,16,17,18,19,25,35),'INTEG','FS') FROM bppllist_policies p WHERE p.masterserver=c.masterserver AND p.name=c.policyname) AS type,
	c.policyname,c.name,c.architecture,c.os,
	SUM(j.jobs) AS jobs,
	ROUND(SUM(j.mb)/1000,1) AS gbytes,
	ROUND(SUM(j.in_bsr*(100-j.bsr))/100,0) AS failures,
	ROUND(SUM(j.in_bsr*j.bsr)/SUM(j.in_bsr),1) AS bsr,
	MAX(j.bw_day) as last_day
	FROM bppllist_clients c
		LEFT JOIN nbu_policy_tower_customer ptc ON(ptc.masterserver=c.masterserver AND ptc.policy=c.policyname)
		LEFT JOIN nbu_bw_jobs_detail j ON (j.masterserver=c.masterserver AND j.policy=c.policyname AND j.client=c.name)
	WHERE c.obsoleted IS NULL 
	AND IFNULL(ptc.tower,'')=IFNULL(f_tower(),IFNULL(ptc.tower,''))
	AND IFNULL (ptc.customer,'')=IFNULL(f_customer(),IFNULL(ptc.customer,''))
	AND c.policyname NOT REGEXP 'dummy|template'
	GROUP BY c.masterserver,c.policyname,c.name
	ORDER BY c.masterserver,c.name,c.policyname 
;

CREATE OR REPLACE ALGORITHM=TEMPTABLE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_clients_distinct` AS 
SELECT 
	c.masterserver,
	MAX(ptc.tower) AS tower,MAX(ptc.customer) AS customer,
	(SELECT IF(p.policytype IN (4,6,7,8,11,15,16,17,18,19,25,35),'INTEG','FS') FROM bppllist_policies p WHERE p.masterserver=c.masterserver AND p.name=c.policyname) AS type,
	c.name,c.architecture,c.os,
	SUM(j.jobs) AS jobs,
	ROUND(SUM(j.mb)/1000,1) AS gbytes,
	ROUND(SUM(j.in_bsr*(100-j.bsr))/100,0) AS failures,
	ROUND(SUM(j.in_bsr*j.bsr)/SUM(j.in_bsr),1) AS bsr,
	MAX(j.bw_day) as last_day
	FROM bppllist_clients c
	LEFT JOIN nbu_policy_tower_customer ptc ON(ptc.masterserver=c.masterserver AND ptc.policy=c.policyname)
		LEFT JOIN nbu_bw_jobs_detail j ON (j.masterserver=c.masterserver AND j.policy=c.policyname AND j.client=c.name)
	WHERE c.obsoleted IS NULL 
	AND IFNULL(ptc.tower,'')=IFNULL(f_tower(),IFNULL(ptc.tower,''))
	AND IFNULL (ptc.customer,'')=IFNULL(f_customer(),IFNULL(ptc.customer,''))
	GROUP BY c.masterserver,c.name,type
	ORDER BY j.customer,c.name,type 
;

CREATE OR REPLACE ALGORITHM=MERGE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_flist` AS 
SELECT 
	b.`masterserver`,
	b.`tower`,b.`customer`,
	b.`policy`,b.`policytype`,b.`schedule`,b.`scheduletype`,
	b.`client`,f.`path`,
	b.`jobid`,b.`parentjob`,
	b.`jobtype`,b.`subtype`,b.`state`,b.`status`,
	b.`tries`,
    b.`bsr`,
	b.`bw_day`,b.`started`,b.`elapsed`,b.`ended`,
	ROUND(b.`kbytes`/(1024*1024),1) AS `gbytes`,
	FROM_UNIXTIME(f.`timestamp`) AS `timestamp`,
	b.`retentionperiod`,b.`backupid`
	FROM `nbu_bsr_jobs` b
	LEFT JOIN `bpflist_backupid` f ON (f.`masterserver`=b.`masterserver` AND f.`backupid`=b.`backupid` AND (f.`file_number`=1 OR f.`timestamp`=0)) 
;

CREATE OR REPLACE ALGORITHM=TEMPTABLE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_policies` AS 
SELECT 
	ptc.tower,ptc.customer,p.masterserver,p.name,
	IF(p.active=1,'NO','YES') AS active,
	nbu_code('policytype',p.policytype) AS policytype,
	(SELECT COUNT(c.name) FROM bppllist_clients c WHERE c.masterserver=p.masterserver AND c.policyname=p.name and c.obsoleted IS NULL) AS clients,
	(SELECT COUNT(s.name) FROM bppllist_schedules s WHERE s.masterserver=p.masterserver AND s.policyname=p.name and s.obsoleted IS NULL) AS schedules,
	IFNULL(j.bsrjobs,0) as bsrjobs,IFNULL(j.bsrgbytes,0) AS bsrgbytes,IFNULL(j.failures,0) AS failures,j.bsr,
	IFNULL(j.jobs,0) as jobs,IFNULL(j.gbytes,0) AS gbytes,
	p.include,
	NULLIF(SUBSTRING_INDEX(p.`res`,',',1),'NULL') AS res,
	p.maxjobsperclient,from_unixtime(p.classid) AS effectivedate,p.backupcopies AS classid,p.bmr,p.vm,p.pool
	FROM bppllist_policies p
	LEFT JOIN nbu_policy_tower_customer ptc ON (ptc.masterserver=p.masterserver AND ptc.policy=p.name)
		LEFT JOIN (SELECT 
			j.tower,j.customer,j.masterserver,j.policy,
			SUM(j.in_bsr) AS bsrjobs,
			ROUND(SUM(j.in_bsr*j.bsr)/SUM(j.in_bsr),1) AS bsr,
			SUM(j.jobs) AS jobs,
			ROUND(SUM(j.in_bsr*(100-j.bsr))/100,0) AS failures,
			ROUND(SUM(j.mb_in_bsr)/1000,1) AS bsrgbytes,
			ROUND(SUM(j.mb)/1000,1) AS gbytes
			FROM nbu_bw_jobs_detail j
			GROUP BY j.tower,j.customer,j.masterserver,j.policy
			ORDER BY j.tower,j.customer,j.masterserver,j.policy
		) j ON (p.masterserver=j.masterserver AND p.name=j.policy)
	WHERE p.name IS NOT NULL AND p.obsoleted IS NULL
	AND IFNULL(ptc.tower,'')=IFNULL(f_tower(),IFNULL(ptc.tower,''))
	AND IFNULL (ptc.customer,'')=IFNULL(f_customer(),IFNULL(ptc.customer,'')) 
;

CREATE OR REPLACE ALGORITHM=TEMPTABLE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_schedules` AS 
SELECT 
	ptc.tower,ptc.customer,s.masterserver,s.policyname,s.name,
	nbu_code('backuptype',s.backuptype) AS backuptype,
	IFNULL(j.bsrjobs,0) as bsrjobs,IFNULL(j.bsrgbytes,0) AS bsrgbytes,IFNULL(j.failures,0) AS failures,j.bsr,
	IFNULL(j.jobs,0) as jobs,IFNULL(j.gbytes,0) AS gbytes,
	FLOOR(s.frequency/60/60/24) as freq_days,
	(select rl.period from bpretlevel rl where rl.masterserver=s.masterserver and rl.level=s.retentionlevel) AS retentionlevel,
	NULLIF(SUBSTRING_INDEX(s.`schedres`,',',1),'NULL') AS res,
	s.calendar,s.caldayofweek,
	from_unixtime(nullif(s.win_sun_start,0),'%H:%i') AS sun_start,FLOOR(nullif(s.win_sun_duration,0)/60/60) AS sun_hours,
	from_unixtime(nullif(s.win_mon_start,0),'%H:%i') AS mon_start,FLOOR(nullif(s.win_sun_duration,0)/60/60) AS mon_hours,
	from_unixtime(nullif(s.win_tue_start,0),'%H:%i') AS tue_start,FLOOR(nullif(s.win_sun_duration,0)/60/60) AS tue_hours,
	from_unixtime(nullif(s.win_wed_start,0),'%H:%i') AS wed_start,FLOOR(nullif(s.win_sun_duration,0)/60/60) AS wed_hours,
	from_unixtime(nullif(s.win_thu_start,0),'%H:%i') AS thu_start,FLOOR(nullif(s.win_sun_duration,0)/60/60) AS thu_hours,
	from_unixtime(nullif(s.win_fri_start,0),'%H:%i') AS fri_start,FLOOR(nullif(s.win_sun_duration,0)/60/60) AS fri_hours,
	from_unixtime(nullif(s.win_sat_start,0),'%H:%i') AS sat_start,FLOOR(nullif(s.win_sun_duration,0)/60/60) AS sat_hours
	FROM bppllist_schedules s
	LEFT JOIN nbu_policy_tower_customer ptc ON (ptc.masterserver=s.masterserver AND ptc.policy=s.policyname)
		LEFT JOIN (SELECT 
			j.tower,j.customer,j.masterserver,j.policy,j.schedule,
			SUM(j.in_bsr) AS bsrjobs,
			ROUND(SUM(j.in_bsr*j.bsr)/SUM(j.in_bsr),1) AS bsr,
			SUM(j.jobs) AS jobs,
			ROUND(SUM(j.in_bsr*(100-j.bsr))/100,0) AS failures,
			ROUND(SUM(j.mb_in_bsr)/1000,1) AS bsrgbytes,
			ROUND(SUM(j.mb)/1000,1) AS gbytes
			FROM nbu_bw_jobs_detail j
			GROUP BY j.tower,j.customer,j.masterserver,j.policy,j.schedule
			ORDER BY j.tower,j.customer,j.masterserver,j.policy,j.schedule
		) j ON (s.masterserver=j.masterserver AND s.policyname=j.policy AND s.name=j.schedule)
	WHERE s.name IS NOT NULL  AND s.obsoleted IS NULL 
	AND IFNULL(ptc.tower,'')=IFNULL(f_tower(),IFNULL(ptc.tower,''))
	AND IFNULL (ptc.customer,'')=IFNULL(f_customer(),IFNULL(ptc.customer,'')) 
;

CREATE OR REPLACE ALGORITHM=MERGE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_images` AS 
SELECT 
	i.masterserver,ptc.tower,ptc.customer,i.name AS client,
	IF(i.policy_type IN (4,6,7,8,11,15,16,17,18,19,25,35),'INTEG','FS') as type,
	i.backupid,
#	(SELECT rl.period FROM bpretlevel rl WHERE rl.masterserver=i.masterserver AND rl.level=i.retention) AS retention,
#	FROM_UNIXTIME(NULLIF(i.expiration,0)) AS expiration,
	nbu_code('policytype',i.policy_type) AS policytype,
	i.policy_name AS policyname,
	nbu_code('scheduletype',i.sched_type) AS scheduletype,
	i.sched_label AS schedulename,i.num_files AS files,
	f.copy_number,f.fragment_number,f.id_path,f.media_type,
	FROM_UNIXTIME(NULLIF(f.media_date,0)) AS media_date,
	(SELECT rl.period FROM bpretlevel rl WHERE rl.masterserver=f.masterserver AND rl.level=retention_level) AS retention_level,
	FROM_UNIXTIME(NULLIF(f.expiration,0)) AS expiration,
	f.kilobytes,f.density,f.file_number,f.block_size,f.offset,
	f.host,f.device_written_on,f.f_flags,f.media_descriptor
		FROM bpimmedia i
		LEFT JOIN config_settings s ON (s.name='bw_start')
		LEFT JOIN nbu_policy_tower_customer ptc ON (ptc.masterserver=i.masterserver AND ptc.policy=i.policy_name)
		LEFT JOIN bpimmedia_frags f ON (f.masterserver=i.masterserver AND f.backupid=i.backupid) 
	WHERE IFNULL(ptc.tower,'')=IFNULL(f_tower(),IFNULL(ptc.tower,''))
	AND IFNULL (ptc.customer,'')=IFNULL(f_customer(),IFNULL(ptc.customer,''))
	AND f.`fragment_number`>0
ORDER BY i.backupid,f.copy_number;

CREATE OR REPLACE ALGORITHM=MERGE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_plclients` AS 
SELECT masterserver,name,architecture,os,priority
	FROM bpplclients
	WHERE obsoleted IS NULL
;

CREATE OR REPLACE ALGORITHM=UNDEFINED DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_summary` AS
SELECT 
	masterserver,queued,waiting,active,successful,partial,failed,incomplete,suspended,total
	FROM bpdbjobs_summary 
;

CREATE OR REPLACE ALGORITHM=MERGE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_esl` AS 
SELECT p.masterserver,p.name AS policy,s.backuptype,
	CONCAT(p.name,' (',s.name,')') AS name,
	TRIM(',' FROM p.res) AS res,
	s.freq_days,s.retentionlevel,
	s.sun_start,s.sun_hours,
	s.mon_start,s.mon_hours,
	s.tue_start,s.tue_hours,
	s.wed_start,s.wed_hours,
	s.thu_start,s.thu_hours,
	s.fri_start,s.fri_hours,
	s.sat_start,s.sat_hours
	FROM bppllist_policies p
		LEFT JOIN nbu_schedules s ON (s.masterserver=p.masterserver AND s.policyname=p.name AND s.freq_days<>84)
	WHERE p.name NOT regexp 'DUMMY|Template' AND p.active='YES' AND s.jobs>0
	ORDER BY 1,2 
;

CREATE OR REPLACE ALGORITHM=MERGE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_esl_client` AS 
SELECT e.masterserver,e.name,c.name as client 
	FROM nbu_esl e
		LEFT JOIN bppllist_clients c ON (c.masterserver=e.masterserver and c.policyname=e.policy AND c.obsoleted IS NULL)
	ORDER BY 1,2,3 
;

CREATE OR REPLACE ALGORITHM=TEMPTABLE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_overview_jobs` AS 
SELECT j.masterserver,
	nbu_code('jobtype',j.jobtype) AS jobtype,
	nbu_code('subtype',j.subtype) AS subtype,
	nbu_code('state',j.state) AS state,
	nbu_code('operation',j.operation) AS operation,
	COUNT(j.jobid) AS jobs,
	SUM(IF(j.status=0,1,0)) AS success,SUM(IF(j.status=0,0,1)) AS fail,
	ROUND(100*SUM(IF(j.status=0,1,0))/COUNT(j.jobid),1) AS bsr,
	ROUND(SUM(j.kbytes)/1048576,1) AS gbytes
	FROM nbu_filtered_jobs j
	GROUP BY j.masterserver,j.jobtype,j.subtype,j.state,j.operation
	ORDER BY masterserver,jobtype,subtype,state,operation 
;

CREATE OR REPLACE ALGORITHM=TEMPTABLE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_overview_clients` AS 
SELECT 
	j.tower,j.customer,j.masterserver,j.name,
	j.policies,j.architecture,j.os,
	j.bsrjobs,j.bsr,j.jobs,j.failures,j.gbytes,
	i.images,i.vmedia,i.pmedia,i.labels,i.gbretained
	FROM (SELECT 
		d.tower,d.customer,d.masterserver,d.client as name,
		COUNT(DISTINCT d.policy) AS policies,
		c.architecture,
		c.os,
		SUM(d.in_bsr) AS bsrjobs,
		ROUND(SUM(d.in_bsr*d.bsr)/SUM(d.in_bsr),1) AS bsr,
		SUM(d.jobs) AS jobs,
		ROUND(SUM(d.in_bsr*(100-d.bsr))/100,0) AS failures,
		ROUND(SUM(d.mb)/1000,1) AS gbytes
		FROM nbu_bw_jobs_detail d
		LEFT JOIN bpplclients c ON (c.masterserver=d.masterserver AND c.name=d.client AND c.obsoleted IS NULL)
		WHERE c.name IS NOT NULL
		GROUP BY d.tower,d.customer,d.masterserver,d.client
	) j
	LEFT JOIN (SELECT i.masterserver,i.name,COUNT(DISTINCT i.backupid) AS images,
		COUNT(DISTINCT IF(f.media_type=0,f.id_path,NULL)) AS vmedia,
		COUNT(DISTINCT IF(f.media_type>0,f.id_path,NULL)) AS pmedia,
		GROUP_CONCAT(DISTINCT IF(f.media_type>0,f.id_path,NULL) ORDER BY f.id_path) AS labels,
		ROUND(SUM(IF(f.media_type>0,f.kilobytes,0))/1048576,1) AS gbretained
		FROM bpimmedia i
		LEFT JOIN bpimmedia_frags f ON (f.masterserver=i.masterserver AND f.backupid=i.backupid) 
		WHERE f.`fragment_number`>0
		AND f.expiration>UNIX_TIMESTAMP(NOW())
		GROUP BY i.masterserver,i.name
	) i ON (i.masterserver=j.masterserver AND i.name=j.name)
ORDER BY j.customer,j.tower,j.masterserver,j.tower,j.name 
;

CREATE OR REPLACE ALGORITHM=TEMPTABLE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_overview_customers` AS 
SELECT
	j.customer,
	COUNT(DISTINCT j.client) AS clients,
	IFNULL(NULLIF(COUNT(DISTINCT IF(j.policytype NOT REGEXP 'WIN|UX|VM',j.client,NULL))-1,-1),0) AS integ_clients,
	COUNT(DISTINCT j.policy) AS policies,
	SUM(j.in_bsr) AS bsrjobs,
	ROUND(SUM(j.in_bsr*j.bsr)/SUM(j.in_bsr),1) AS bsr,
	SUM(j.jobs) AS jobs,
	ROUND(SUM(j.in_bsr*(100-j.bsr))/100,0) AS failures,
	ROUND(SUM(j.mb)/1000,1) AS gbytes,
	(SELECT ROUND(SUM(i.kilobytes/1048576),1) AS TB FROM nbu_images i
		WHERE i.customer=j.customer
		AND i.media_type>0
		AND i.expiration>NOW()
	) AS gbretained
	FROM nbu_bw_jobs_detail j
	WHERE j.client IS NOT NULL
	AND j.policy IS NOT NULL
	GROUP BY j.customer
	ORDER BY j.customer 
;

CREATE OR REPLACE ALGORITHM=TEMPTABLE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_consecutive_failures` AS 
SELECT masterserver,tower,customer,client,policy,
	IF(ISNULL((SELECT c.name FROM bppllist_clients c 
        WHERE c.masterserver=j1.masterserver AND c.name=j1.client AND c.policyname=j1.policy AND c.obsoleted IS NULL))
        ,'N','Y') AS existing,
	schedule,FROM_UNIXTIME(lastfailure) AS lastfailure,
	(SELECT COUNT(*) FROM bpdbjobs_report j2 
        WHERE j2.masterserver=j1.masterserver AND j2.started BETWEEN f_from() AND f_to() AND j2.client=j1.client 
        AND j2.status>0 AND j2.started>j1.lastsuccess AND j2.policy=j1.policy AND IFNULL(j2.schedule,'')=IFNULL(j1.schedule,'')
        ) AS failures
	FROM 
	(SELECT j.masterserver,j.tower,j.customer,j.client,j.policy,j.schedule,
		MAX(IF(j.status=0,j.started,0)) as lastsuccess,
		MAX(IF(j.status>0,j.started,0)) as lastfailure
		FROM nbu_filtered_jobs j
		WHERE IFNULL(j.schedule,'') NOT REGEXP 'NONE|NULL'
		GROUP BY j.masterserver,j.client,j.policy,j.schedule
		HAVING lastfailure>lastsuccess
	) j1
	ORDER BY failures DESC,customer,client,policy,schedule 
;

CREATE OR REPLACE ALGORITHM=MERGE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_puredisks` AS 
SELECT 
	masterserver,diskpool,disk_media_id,total_capacity,free_space,
	ROUND(100-100*free_space/total_capacity,2) as used 
	FROM nbdevquery_listdv_puredisk
	WHERE obsoleted IS NULL
	ORDER BY used DESC
;

CREATE OR REPLACE ALGORITHM=MERGE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_vault_classes` AS 
select vi.masterserver,vi.profile,vi.value as name 
from vault_item_xml vi
where vi.obsoleted is null
and vi.type='CLASS'
order by vi.value
;

CREATE OR REPLACE ALGORITHM=MERGE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_vault_clients` AS 
select vi.masterserver,vi.profile,vi.value as name 
from vault_item_xml vi
where vi.obsoleted is null
and vi.type='CLIENT'
order by vi.value
;

CREATE OR REPLACE ALGORITHM=MERGE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_vault_schedules` AS 
select vi.masterserver,vi.profile,vi.value as name 
from vault_item_xml vi
where vi.obsoleted is null
and vi.type='SCHEDULE'
order by vi.value
;

CREATE OR REPLACE ALGORITHM=TEMPTABLE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_vault_profiles` AS 
select p.masterserver,p.robot_name as robot,p.vault_name as vault,p.profile_name as name,p.startday,p.starthour,p.endday,p.endhour,p.ipf_enabled,p.clientfilter,
if(p.clientfilter='INCLUDE',(select count(c.value) from vault_item_xml c where c.masterserver=p.masterserver and c.profile=p.profile_name and c.`type`='CLIENT'),NULL) as clients,
p.backuptypefilter,p.mediaserverfilter,p.classfilter,
if(p.classfilter='INCLUDE',(select count(c.value) from vault_item_xml c where c.masterserver=p.masterserver and c.profile=p.profile_name and c.`type`='CLASS'),NULL) as classes,
p.schedulefilter,
if(p.schedulefilter='INCLUDE',(select count(c.value) from vault_item_xml c where c.masterserver=p.masterserver and c.profile=p.profile_name and c.`type`='SCHEDULE'),NULL) as schedules,
p.retentionlevelfilter,p.ilf_enabled,p.sourcevolgroupfilter,p.volumepoolfilter,p.basicdiskfilter,p.diskgroupfilter,
p.duplication_skip,p.duppriority,p.multiplex,p.sharedrobots,p.sortorder,p.altreadhost,p.backupserver,p.readdrives,p.writedrives,
p.fail,p.primary,
(SELECT rl.period FROM bpretlevel rl WHERE rl.masterserver=p.masterserver and rl.level=p.retention) AS retention,
p.sharegroup,p.stgunit,p.volpool,
p.catalogbackup_skip,p.eject_skip,p.ejectmode,p.eject_ene,p.suspend,p.suspendmode,p.userbtorvaultprefene,p.imfile,p.mode,p.useglobalrptsdist,
from_unixtime(round(p.profile_lastmod/10000000,0)) as lastmod
from vault_xml p
where p.obsoleted is null
group by p.masterserver,p.profile_id
order by p.profile_name 
;

CREATE OR REPLACE ALGORITHM=TEMPTABLE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_vault_robots` AS 
select r.masterserver,r.robot_name as name,r.robotnumber,r.robottype,r.roboticcontrolhost,r.usevaultprefene,r.robot_ene as ejectnotificationemail,
count(distinct r.vault_id) as vaults,from_unixtime(round(r.robot_lastmod/10000000,0)) as lastmod
from vault_xml r
where r.obsoleted is null
group by r.masterserver,r.robot_id
order by r.robot_name 
;

CREATE OR REPLACE ALGORITHM=TEMPTABLE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_vault_vaults` AS 
select v.masterserver,v.robot_name as robot,v.vault_name as name,v.customerid,v.offsitevolumegroup,v.robotvolumegroup,v.vaultcontainers,v.vaultseed,v.vendor,
count(distinct v.profile_id) as profiles,from_unixtime(round(v.vault_lastmod/10000000,0)) as lastmod
from vault_xml v
where v.obsoleted is null
group by v.masterserver,v.vault_id
order by v.vault_name 
;

CREATE OR REPLACE ALGORITHM=MERGE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_audit` AS 
SELECT DISTINCT 
	ptc.`tower`,ptc.`customer`,
	c.`masterserver`,
	c.`name` AS `client`,
	p.`policytype` AS `PT`,
	nbu_code('policytype',p.`policytype`) AS `policy_type`,
	p.`name` AS `policy`,
	s1.`backuptype` AS `ST`,
	nbu_code('backuptype',s1.`backuptype`) AS `schedule_type`,
	s1.`name` AS `schedule`,
	ROUND(s1.`frequency`/86400,0) AS `freq`,
	IF(SUBSTRING_INDEX(s1.`schedres`,',',1)='NULL',IF(s2.`slpname`=SUBSTRING_INDEX(p.`res`,',',1),'Policy',NULL),'Schedule') AS `SLP`,
	(SELECT rl.`period` FROM bpretlevel rl 
		WHERE rl.`masterserver`=s1.`masterserver` AND rl.`level`=IF(s2.`slpname` IS NULL,s1.`retentionlevel`,s2.`retentionlevel`)) AS `schedule_ret`,
	IF(s2.`slpname` IS NULL,SUBSTRING_INDEX(p.`res`,',',1),s2.`storageunit`) AS `schedule_stu`,
	s3.`slpname` AS `slp_name`,s3.`storageunit` AS `slp_stu`,
	(SELECT rl.`period` FROM bpretlevel rl 
		WHERE rl.`masterserver`=s3.`masterserver` AND rl.`level`=s3.`retentionlevel`) AS `slp_ret`,
	v.`profile_name` AS `vault`,v.`stgunit` AS `vault_stu`,
	(SELECT rl.`period` FROM bpretlevel rl 
		WHERE rl.`masterserver`=v.`masterserver` AND rl.`level`=v.`retention`) AS `vault_ret`
	FROM bppllist_clients c
		LEFT JOIN bppllist_policies p ON (c.`masterserver`=p.`masterserver` AND c.`policyname`=p.`name` AND p.`obsoleted` IS NULL)
		LEFT JOIN bppllist_schedules s1 ON (s1.`masterserver`=p.`masterserver` AND s1.`policyname`=p.`name` AND s1.`obsoleted` IS NULL)
		LEFT JOIN nbstl s2 ON (s2.`masterserver`=p.`masterserver` AND s2.`usefor` IN (0,5) AND s2.`obsoleted` IS NULL
			AND s2.`slpname`=IFNULL(NULLIF(SUBSTRING_INDEX(s1.`schedres`,',',1),'NULL'),NULLIF(SUBSTRING_INDEX(p.`res`,',',1),'NULL')))
		LEFT JOIN nbstl s3 ON (s3.`masterserver`=p.`masterserver` AND s3.`usefor` IN (1,3) AND s3.`obsoleted` IS NULL
			AND s3.`slpname`=IFNULL(NULLIF(SUBSTRING_INDEX(s1.`schedres`,',',1),'NULL'),NULLIF(SUBSTRING_INDEX(p.`res`,',',1),'NULL')))
		LEFT JOIN vault_item_xml vc ON (vc.`masterserver`=c.`masterserver` AND vc.`type`='CLIENT' AND vc.`value`=c.`name` AND vc.`obsoleted` IS NULL)
		LEFT JOIN vault_xml v  ON (v.`masterserver`=c.`masterserver` AND v.`profile_name`=vc.`profile` AND v.`obsoleted` IS NULL)
		LEFT JOIN vault_item_xml vs ON ( vs.`masterserver`=c.`masterserver` AND vs.`type`='SCHEDULE' AND vs.`profile`=v.`profile_name` AND vs.`value`=s1.`name` AND vs.`obsoleted` IS NULL)
		LEFT JOIN nbu_policy_tower_customer ptc ON (ptc.`masterserver`=c.`masterserver` AND ptc.`policy`=c.`policyname`)
	WHERE c.`obsoleted` IS NULL
	AND (IFNULL(v.`schedulefilter`,'')<>'INCLUDE' OR vs.`value` IS NOT NULL)
	AND p.`active`=0
	AND IFNULL(ptc.`tower`,'')=IFNULL(f_tower(),IFNULL(ptc.`tower`,''))
	AND IFNULL (ptc.`customer`,'')=IFNULL(f_customer(),IFNULL(ptc.`customer`,''))
	ORDER BY ptc.`tower`,ptc.`customer`,c.`name`,p.`name`,s1.`name`,s2.`slpname`,v.`profile_name` 
;

CREATE OR REPLACE ALGORITHM=MERGE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_slps` AS 
SELECT 
	s.`masterserver`,s.`slpname` AS `name`,s.`dataclassification`,s.`duplicationpriority`,s.`state`,s.`version`,
	(SELECT COUNT(DISTINCT p.`name`) FROM bppllist_policies p WHERE p.`masterserver`=s.`masterserver` AND SUBSTRING_INDEX(p.`res`,',',1)=s.`slpname` and p.`obsoleted` IS NULL) AS policies,
	(SELECT COUNT(DISTINCT s1.`name`) FROM bppllist_schedules s1 WHERE s1.`masterserver`=s.`masterserver` AND SUBSTRING_INDEX(s1.`schedres`,',',1)=s.`slpname` and s1.`obsoleted` IS NULL) AS schedules,
	s.`operationindex`,
	nbu_code('usefor',s.`usefor`) AS `usefor`,
	s.`storageunit`,s.`volumepool`,s.`mediaowner`,
	(SELECT rl.`period` FROM bpretlevel rl 
		WHERE rl.`masterserver`=s.`masterserver` AND rl.`level`=s.`retentionlevel`) AS `retention`,
	s.`alternatereadserver`,s.`preservempx`,s.`ddostate`,s.`source`,s.`slpwindow`
	FROM nbstl s
	WHERE s.`obsoleted` IS NULL 
	ORDER BY s.`masterserver`,s.`slpname`,s.`operationindex` 
;

CREATE OR REPLACE ALGORITHM=MERGE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_sm9` AS 
SELECT 
	FROM_UNIXTIME(j.ended) AS `date`,
	'MAJOR' AS `severity`,
	j.status AS `errorcode`,
	j.masterserver AS `eventnode`,
	'NBU' AS `eventtypeinstance`,
	nbu_code('policytype',j.policytype) AS policytype,
	nbu_code('jobtype',j.jobtype) AS jobtype,
	j.policy,
	IF(status=196,'Missed',CONCAT(tries,IF(tries=1,'st',IF(tries=2,'nd',IF(tries=3,'rd','th'))),' failure')) as statustext,
	nbu_code('state',j.state) AS state,
	j.jobid,
	j.schedule,
	j.client,
	j.status,
	nbu_code('status',status) as errortext,
	'' AS `corellationkey`
	FROM bpdbjobs_report j
	WHERE j.ended > UNIX_TIMESTAMP(NOW()- INTERVAL 1 HOUR)
	AND ((IFNULL(nbu_bsr(j.jobtype,j.state,NULL,j.policytype,j.status),IF(j.status=0,1,0))=0 AND j.tries>0) OR (j.status=196))
	ORDER BY j.masterserver,j.ended,j.jobid 
;

CREATE OR REPLACE ALGORITHM=TEMPTABLE DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `nbu_bsr_job_results` AS 
	SELECT
	j.customer,j.client,j.policy,j.schedule,
	COUNT(j.jobid) AS jobs,
	ROUND(SUM(j.bsr)/COUNT(j.jobid),1) AS bsr,
	RIGHT(GROUP_CONCAT(IF(j.bsr=100,'S','F') ORDER BY j.jobid),5) AS results
	FROM nbu_bsr_jobs j
	GROUP BY j.client,j.policy,j.schedule
	HAVING bsr<100
	ORDER BY bsr,j.client,j.policy,j.schedule 
;

INSERT INTO `nbu_codes` (`field`, `code`, `description`) VALUES
	('backuptype', 0, 'Full'),
	('backuptype', 1, 'Differential'),
	('backuptype', 2, 'Incremental'),
	('backuptype', 3, 'User backup'),
	('backuptype', 4, 'User archive'),
	('jobtype', 0, 'Backup'),
	('jobtype', 1, 'Archive'),
	('jobtype', 2, 'Restore'),
	('jobtype', 3, 'Verify'),
	('jobtype', 4, 'Duplicate'),
	('jobtype', 5, 'Import'),
	('jobtype', 6, 'Catalog backup'),
	('jobtype', 7, 'Vault duplicate'),
	('jobtype', 8, 'Label tape'),
	('jobtype', 9, 'Erase tape'),
	('jobtype', 10, 'Tape request'),
	('jobtype', 11, 'Clean tape'),
	('jobtype', 12, 'Format tape'),
	('jobtype', 13, 'Inventory'),
	('jobtype', 14, 'Test'),
	('jobtype', 15, 'Catalog Recovery'),
	('jobtype', 16, 'Media contents'),
	('jobtype', 17, 'Image cleanup'),
	('jobtype', 18, 'Live update'),
	('jobtype', 20, 'Replication (AIR)'),
	('jobtype', 21, 'Import (AIR)'),
	('jobtype', 22, 'Backup (Snap)'),
	('jobtype', 23, 'Replication (Snap)'),
	('jobtype', 24, 'Import (Snap)'),
	('jobtype', 25, 'ASC'),
	('jobtype', 26, 'Index'),
	('jobtype', 27, 'Index'),
	('jobtype', 28, 'Snapshot'),
	('jobtype', 29, 'Index (Snap)'),
	('jobtype', 30, 'Aactivate IR'),
	('jobtype', 31, 'Deactivate IR'),
	('jobtype', 32, 'Reactivate IR'),
	('jobtype', 33, 'Stop IR'),
	('jobtype', 34, 'IR'),
	('operation', 0, 'Tape mount'),
	('operation', 1, 'Tape position'),
	('operation', 2, 'Connect'),
	('operation', 3, 'Write'),
	('operation', 4, 'Choose image'),
	('operation', 5, 'Duplicate image'),
	('operation', 6, 'Choose media'),
	('operation', 7, 'Catalog'),
	('operation', 8, 'Tape eject'),
	('operation', 10, 'Read'),
	('operation', 11, 'Duplicate'),
	('operation', 12, 'Import'),
	('operation', 13, 'Verify'),
	('operation', 14, 'Restore'),
	('operation', 15, 'Catalog backup'),
	('operation', 16, 'Vault operation'),
	('operation', 17, 'Label tape'),
	('operation', 18, 'Erase tape'),
	('operation', 19, 'Query database'),
	('operation', 20, 'Process extents'),
	('operation', 21, 'Organize readers'),
	('operation', 22, 'Create snapshot'),
	('operation', 23, 'Delete snapshot'),
	('operation', 24, 'Recover DB'),
	('operation', 25, 'Media contents'),
	('operation', 26, 'Request job resources'),
	('operation', 27, 'Parent job'),
	('operation', 28, 'Indexing'),
	('operation', 29, 'Duplicate to RM'),
	('operation', 30, 'Running'),
	('policytype', 0, 'UX'),
	('policytype', 1, 'Proxy'),
	('policytype', 4, 'Oracle'),
	('policytype', 6, 'Informix'),
	('policytype', 7, 'Sybase'),
	('policytype', 8, 'MS-SharePoint'),
	('policytype', 11, 'DT-SQL'),
	('policytype', 13, 'MS-Windows'),
	('policytype', 15, 'MS-SQL'),
	('policytype', 16, 'MS-Exchange'),
	('policytype', 17, 'SAP'),
	('policytype', 18, 'DB2'),
	('policytype', 19, 'NDMP'),
	('policytype', 20, 'FlashBackup'),
	('policytype', 21, 'SplitMirror'),
	('policytype', 25, 'Lotus'),
	('policytype', 29, 'FlashBackup-Windows'),
	('policytype', 30, 'Vault'),
	('policytype', 35, 'NBU-Catalog'),
	('policytype', 36, 'Generic'),
	('policytype', 38, 'PureDisk'),
	('policytype', 39, 'EnterpriseVault'),
	('policytype', 40, 'VMWare'),
	('policytype', 41, 'Hyper-V'),
	('policytype', 44, 'BigData'),
	('policytype', 46, 'Deployment'),
	('scheduletype', 0, 'Full'),
	('scheduletype', 1, 'Incremental'),
	('scheduletype', 2, 'User backup'),
	('scheduletype', 3, 'User archive'),
	('scheduletype', 4, 'Cummulative'),
	('scheduletype', 5, 'Tlog'),
	('state', 0, 'Queued'),
	('state', 1, 'Active'),
	('state', 2, 'Requeued'),
	('state', 3, 'Done'),
	('state', 4, 'Suspended'),
	('state', 5, 'Incomplete'),
	('status', 0, 'the requested operation was successfully completed '),
	('status', 1, 'The requested operation was partially successful '),
	('status', 2, 'none of the requested files were backed up '),
	('status', 3, 'valid archive image produced, but no files deleted due to non-fatal problems '),
	('status', 4, 'archive file removal failed '),
	('status', 5, 'the restore failed to recover the requested files '),
	('status', 6, 'the backup failed to back up the requested files '),
	('status', 7, 'the archive failed to back up the requested files '),
	('status', 8, 'unable to determine the status of rbak '),
	('status', 9, 'a necessary extension package is not installed or not configured properly '),
	('status', 10, 'allocation failed '),
	('status', 11, 'system call failed '),
	('status', 12, 'file open failed '),
	('status', 13, 'file read failed '),
	('status', 14, 'file write failed '),
	('status', 15, 'file close failed '),
	('status', 16, 'unimplemented feature '),
	('status', 17, 'pipe open failed '),
	('status', 18, 'pipe close failed '),
	('status', 19, 'getservbyname failed '),
	('status', 20, 'invalid command parameter '),
	('status', 21, 'socket open failed '),
	('status', 22, 'socket close failed '),
	('status', 23, 'socket read failed '),
	('status', 24, 'socket write failed '),
	('status', 25, 'cannot connect on socket '),
	('status', 26, 'client/server handshaking failed '),
	('status', 27, 'child process killed by signal '),
	('status', 28, 'failed trying to fork a process '),
	('status', 29, 'failed trying to exec a command '),
	('status', 30, 'cannot get password information '),
	('status', 31, 'could not set user ID for process '),
	('status', 32, 'could not set group ID for process '),
	('status', 33, 'failed while trying to send mail '),
	('status', 34, 'failed waiting for child process '),
	('status', 35, 'cannot make required directory '),
	('status', 36, 'failed trying to allocate memory '),
	('status', 37, 'operation requested by an invalid server '),
	('status', 38, 'could not get group information '),
	('status', 39, 'client name mismatch '),
	('status', 40, 'network connection broken '),
	('status', 41, 'network connection timed out '),
	('status', 42, 'network read failed '),
	('status', 43, 'unexpected message received '),
	('status', 44, 'network write failed '),
	('status', 45, 'request attempted on a non-reserved port '),
	('status', 46, 'server not allowed access '),
	('status', 47, 'host is unreachable '),
	('status', 48, 'client hostname could not be found '),
	('status', 49, 'client did not start '),
	('status', 50, 'client process aborted '),
	('status', 51, 'timed out waiting for database information '),
	('status', 52, 'timed out waiting for media manager to mount volume '),
	('status', 53, 'backup restore manager failed to read the file list '),
	('status', 54, 'timed out connecting to client '),
	('status', 55, 'permission denied by client during rcmd '),
	('status', 56, 'client\'s network is unreachable '),
	('status', 57, 'client connection refused '),
	('status', 58, 'can\'t connect to client '),
	('status', 59, 'access to the client was not allowed '),
	('status', 60, 'client cannot read the mount table '),
	('status', 63, 'process was killed by a signal '),
	('status', 64, 'timed out waiting for the client backup to start '),
	('status', 65, 'client timed out waiting for the continue message from the media manager '),
	('status', 66, 'client backup failed to receive the CONTINUE BACKUP message '),
	('status', 67, 'client backup failed to read the file list '),
	('status', 68, 'client timed out waiting for the file list '),
	('status', 69, 'invalid filelist specification '),
	('status', 70, 'an entry in the filelist expanded to too many characters '),
	('status', 71, 'none of the files in the file list exist '),
	('status', 72, 'the client type is incorrect in the configuration database '),
	('status', 73, 'bpstart_notify failed '),
	('status', 74, 'client timed out waiting for bpstart_notify to complete '),
	('status', 75, 'client timed out waiting for bpend_notify to complete '),
	('status', 76, 'client timed out reading file '),
	('status', 77, 'execution of the specified system command returned a nonzero status '),
	('status', 78, 'afs/dfs command failed '),
	('status', 79, 'unsupported image format for the requested database query '),
	('status', 80, 'Media Manager device daemon (ltid) is not active '),
	('status', 81, 'Media Manager volume daemon (vmd) is not active '),
	('status', 82, 'media manager killed by signal '),
	('status', 83, 'media open error '),
	('status', 84, 'media write error '),
	('status', 85, 'media read error '),
	('status', 86, 'media position error '),
	('status', 87, 'media close error '),
	('status', 89, 'problems encountered during setup of shared memory '),
	('status', 90, 'media manager received no data for backup image '),
	('status', 91, 'fatal NB media database error '),
	('status', 92, 'media manager detected image that was not in tar format '),
	('status', 93, 'media manager found wrong tape in drive '),
	('status', 94, 'cannot position to correct image '),
	('status', 95, 'Media ID is not assigned to this host in the EMM database '),
	('status', 96, 'unable to allocate new media for backup, storage unit has none available '),
	('status', 97, 'requested media ID is in use, cannot process request '),
	('status', 98, 'error requesting media (tpreq) '),
	('status', 99, 'NDMP backup failure '),
	('status', 100, 'system error occurred while processing user command '),
	('status', 101, 'failed opening mail pipe '),
	('status', 102, 'failed closing mail pipe '),
	('status', 103, 'error occurred during initialization, check configuration file '),
	('status', 104, 'invalid file pathname '),
	('status', 105, 'file pathname exceeds the maximum length allowed '),
	('status', 106, 'invalid file pathname found, cannot process request '),
	('status', 108, 'Action succeeded but auditing failed '),
	('status', 109, 'invalid date specified '),
	('status', 110, 'Cannot find the NetBackup configuration information '),
	('status', 111, 'No entry was found in the server list '),
	('status', 112, 'no files specified in the file list '),
	('status', 114, 'unimplemented error code '),
	('status', 116, 'VxSS authentication failed '),
	('status', 117, 'VxSS access denied '),
	('status', 118, 'VxSS authorization failed '),
	('status', 120, 'cannot find configuration database record for requested NB database backup '),
	('status', 121, 'no media is defined for the requested NB database backup '),
	('status', 122, 'specified device path does not exist '),
	('status', 123, 'specified disk path is not a directory '),
	('status', 124, 'NB database backup failed, a path was not found or is inaccessible '),
	('status', 125, 'a NetBackup catalog backup is in progress '),
	('status', 126, 'NB database backup header is too large, too many paths specified '),
	('status', 127, 'specified media or path does not contain a valid NB database backup header '),
	('status', 128, 'NB database recovery failed, a process has encountered an exceptional condition '),
	('status', 129, 'Disk storage unit is full '),
	('status', 130, 'system error occurred '),
	('status', 131, 'client is not validated to use the server '),
	('status', 132, 'user is not validated to use the server from this client '),
	('status', 133, 'invalid request '),
	('status', 134, 'unable to process request because the server resources are busy '),
	('status', 135, 'client is not validated to perform the requested operation '),
	('status', 136, 'tir info was pruned from the image file '),
	('status', 140, 'User ID was not superuser '),
	('status', 141, 'file path specified is not absolute '),
	('status', 142, 'file does not exist '),
	('status', 143, 'invalid command protocol '),
	('status', 144, 'invalid command usage '),
	('status', 145, 'daemon is already running '),
	('status', 146, 'cannot get a bound socket '),
	('status', 147, 'required or specified copy was not found '),
	('status', 148, 'daemon fork failed '),
	('status', 149, 'master server request failed '),
	('status', 150, 'termination requested by administrator '),
	('status', 152, 'required value not set '),
	('status', 153, 'server is not the master server '),
	('status', 154, 'storage unit characteristics mismatched to request '),
	('status', 155, 'disk is full '),
	('status', 156, 'snapshot error encountered '),
	('status', 157, 'suspend requested by administrator '),
	('status', 158, 'failed accessing daemon lock file '),
	('status', 159, 'licensed use has been exceeded '),
	('status', 160, 'authentication failed '),
	('status', 161, 'Evaluation software has expired. '),
	('status', 162, 'incorrect server platform for license '),
	('status', 163, 'media block size changed prior resume '),
	('status', 164, 'unable to mount media because it is in a DOWN, or otherwise not available '),
	('status', 165, 'NB image database contains no image fragments for requested backup id/copy number '),
	('status', 166, 'backups are not allowed to span media '),
	('status', 167, 'cannot find requested volume pool in EMM database '),
	('status', 168, 'cannot overwrite media, data on it is protected '),
	('status', 169, 'Media ID is either expired or will exceed maximum mounts '),
	('status', 170, 'third party copy backup failure '),
	('status', 171, 'media id must be 6 or less characters '),
	('status', 172, 'cannot read media header, may not be NetBackup media or is corrupted '),
	('status', 173, 'cannot read backup header, media may be corrupted '),
	('status', 174, 'media manager - system error occurred '),
	('status', 175, 'not all requested files were restored '),
	('status', 176, 'cannot perform specified media import operation '),
	('status', 177, 'could not deassign media due to Media Manager error '),
	('status', 178, 'Media ID is not in NetBackup volume pool '),
	('status', 179, 'density is incorrect for the media ID '),
	('status', 180, 'tar was successful '),
	('status', 181, 'tar received an invalid argument '),
	('status', 182, 'tar received an invalid file name '),
	('status', 183, 'tar received an invalid archive '),
	('status', 184, 'tar had an unexpected error '),
	('status', 185, 'tar did not find all the files to be restored '),
	('status', 186, 'tar received no data '),
	('status', 189, 'the server is not allowed to write to the client\'s file systems '),
	('status', 190, 'found no images or media matching the selection criteria '),
	('status', 191, 'no images were successfully processed '),
	('status', 192, 'VxSS authentication is required but not available '),
	('status', 193, 'VxSS authentication is requested but not allowed '),
	('status', 194, 'the maximum number of jobs per client is set to 0 '),
	('status', 195, 'client backup was not attempted '),
	('status', 196, 'client backup was not attempted because backup window closed '),
	('status', 197, 'the specified schedule does not exist in the specified policy '),
	('status', 198, 'no active policies contain schedules of the requested type for this client '),
	('status', 199, 'operation not allowed during this time period '),
	('status', 200, 'scheduler found no backups due to run '),
	('status', 201, 'handshaking failed with server backup restore manager '),
	('status', 202, 'timed out connecting to server backup restore manager '),
	('status', 203, 'server backup restore manager\'s network is unreachable '),
	('status', 204, 'connection refused by server backup restore manager '),
	('status', 205, 'cannot connect to server backup restore manager '),
	('status', 206, 'access to server backup restore manager denied '),
	('status', 207, 'error obtaining date of last backup for client '),
	('status', 209, 'error creating or getting message queue '),
	('status', 210, 'error receiving information on message queue '),
	('status', 212, 'error sending information on message queue '),
	('status', 213, 'no storage units available for use '),
	('status', 215, 'failed reading global config database information '),
	('status', 216, 'failed reading retention database information '),
	('status', 217, 'failed reading storage unit database information '),
	('status', 218, 'failed reading policy database information '),
	('status', 219, 'the required storage unit is unavailable '),
	('status', 220, 'database system error '),
	('status', 221, 'continue '),
	('status', 222, 'done '),
	('status', 223, 'an invalid entry was encountered '),
	('status', 224, 'there was a conflicting specification '),
	('status', 225, 'text exceeded allowed length '),
	('status', 226, 'the entity already exists '),
	('status', 227, 'no entity was found '),
	('status', 228, 'unable to process request '),
	('status', 229, 'events out of sequence - image inconsistency '),
	('status', 230, 'the specified policy does not exist in the configuration database '),
	('status', 231, 'schedule windows overlap '),
	('status', 232, 'a protocol error has occurred '),
	('status', 233, 'premature eof encountered '),
	('status', 234, 'communication interrupted '),
	('status', 235, 'inadequate buffer space '),
	('status', 236, 'the specified client does not exist in an active policy within the configuration database '),
	('status', 237, 'the specified schedule does not exist in an active policy in the configuration database '),
	('status', 238, 'the database contains conflicting or erroneous entries '),
	('status', 239, 'the specified client does not exist in the specified policy '),
	('status', 240, 'no schedules of the correct type exist in this policy '),
	('status', 241, 'the specified schedule is the wrong type for this request '),
	('status', 242, 'operation would cause an illegal duplication '),
	('status', 243, 'the client is not in the configuration '),
	('status', 245, 'the specified policy is not of the correct client type '),
	('status', 246, 'no active policies in the configuration database are of the correct client type '),
	('status', 247, 'the specified policy is not active '),
	('status', 248, 'there are no active policies in the configuration database '),
	('status', 249, 'the file list is incomplete '),
	('status', 250, 'the image was not created with TIR information '),
	('status', 251, 'the tir information is zero length '),
	('status', 252, 'An extended error status has been encountered, check detailed status '),
	('status', 253, 'the catalog image .f file has been archived '),
	('status', 254, 'server name not found in the NetBackup configuration '),
	('status', 256, 'logic error encountered '),
	('status', 257, 'failed to get job data '),
	('status', 258, 'Vault duplication was aborted by administrator request '),
	('status', 259, 'vault configuration file not found '),
	('status', 260, 'failed to send signal '),
	('status', 261, 'vault internal error 261 '),
	('status', 262, 'vault internal error 262 '),
	('status', 263, 'session ID assignment failed '),
	('status', 265, 'session ID file is empty or corrupt '),
	('status', 266, 'cannot find robot, vault, or profile in the vault configuration '),
	('status', 267, 'cannot find the local host name '),
	('status', 268, 'the vault session directory is either missing or inaccessible '),
	('status', 269, 'no vault session id was found '),
	('status', 270, 'unable to obtain process id, getpid failed '),
	('status', 271, 'vault XML version mismatch '),
	('status', 272, 'execution of a vault notify script failed '),
	('status', 273, 'invalid job id '),
	('status', 274, 'no profile was specified '),
	('status', 275, 'a session is already running for this vault '),
	('status', 276, 'invalid session ID '),
	('status', 277, 'unable to print reports '),
	('status', 278, 'unable to collect pre eject information from the API '),
	('status', 279, 'eject process is complete '),
	('status', 280, 'there are no volumes to eject '),
	('status', 281, 'vault core error '),
	('status', 282, 'cannot connect to nbvault server '),
	('status', 283, 'error(s) occurred during vault report generation '),
	('status', 284, 'error(s) occurred during vault report distribution '),
	('status', 285, 'unable to locate vault directory '),
	('status', 286, 'vault internal error '),
	('status', 287, 'vault eject failed '),
	('status', 288, 'vault eject partially succeeded '),
	('status', 289, 'cannot consolidate reports of sessions from container and slot-based vaults '),
	('status', 290, 'one or more errors detected during eject processing '),
	('status', 291, 'number of media has exceeded capacity of MAP; must perform manual eject using vltopmenu or vlteject '),
	('status', 292, 'eject process failed to start '),
	('status', 293, 'eject process has been aborted '),
	('status', 294, 'vault catalog backup failed '),
	('status', 295, 'eject process could not obtain information about the robot '),
	('status', 296, 'process called but nothing to do '),
	('status', 297, 'all volumes are not available to eject '),
	('status', 298, 'the library is not ready to eject volumes '),
	('status', 299, 'there is no available MAP for ejecting '),
	('status', 300, 'vmchange eject verify not responding '),
	('status', 301, 'vmchange api_eject command failed '),
	('status', 302, 'error encountered trying backup of catalog (multiple tape catalog backup) '),
	('status', 303, 'error encountered executing Media Manager command '),
	('status', 304, 'specified profile not found '),
	('status', 305, 'multiple profiles exist '),
	('status', 306, 'vault duplication partially succeeded '),
	('status', 307, 'eject process has already been run for the requested Vault session '),
	('status', 308, 'no images duplicated '),
	('status', 309, 'report requested without eject being run '),
	('status', 310, 'Updating of Media Manager database failed '),
	('status', 311, 'Iron Mountain Report is already created for this session '),
	('status', 312, 'invalid container database entry '),
	('status', 313, 'container does not exist in container database '),
	('status', 314, 'container database truncate operation failed '),
	('status', 315, 'failed appending to container database '),
	('status', 316, 'container_id is not unique in container database '),
	('status', 317, 'container database close operation failed '),
	('status', 318, 'container database lock operation failed '),
	('status', 319, 'container database open operation failed '),
	('status', 320, 'the specified container is not empty '),
	('status', 321, 'container cannot hold any media from the specified robot '),
	('status', 322, 'cannot find vault in vault configuration file '),
	('status', 323, 'cannot find robot in vault configuration file '),
	('status', 324, 'invalid data found in retention map file for duplication '),
	('status', 325, 'unable to find policy/schedule for image using retention mapping '),
	('status', 326, 'specified file contains no valid entry '),
	('status', 327, 'no media ejected for the specified vault session '),
	('status', 328, 'invalid container ID '),
	('status', 329, 'invalid recall status '),
	('status', 330, 'invalid database host '),
	('status', 331, 'invalid container description '),
	('status', 332, 'error getting information from EMM database '),
	('status', 333, 'error getting information from media manager command line '),
	('status', 334, 'unable to receive response from robot; robot not ready. '),
	('status', 335, 'failure occurred while suspending media for eject '),
	('status', 336, 'failure occurred while updating session information '),
	('status', 337, 'failure occurred while updating the eject.mstr file '),
	('status', 338, 'vault eject timed out '),
	('status', 339, 'vault configuration file format error '),
	('status', 340, 'vault configuration tag not found '),
	('status', 341, 'vault configuration serialization failed '),
	('status', 342, 'cannot modify - stale view '),
	('status', 343, 'robot already exists '),
	('status', 344, 'vault already exists '),
	('status', 345, 'profile already exists '),
	('status', 346, 'duplicate MAP '),
	('status', 347, 'vault configuration cache not initialized '),
	('status', 348, 'specified report does not exist '),
	('status', 349, 'incorrect catalog backup policy '),
	('status', 350, 'incorrect vault catalog backup schedule '),
	('status', 351, 'all configured vault steps failed '),
	('status', 400, 'Server Group Type is Invalid '),
	('status', 401, 'Server Group Already Exists '),
	('status', 402, 'Server Group Already Exists with a different type '),
	('status', 403, 'Server Group Active State is not valid '),
	('status', 404, 'Server Group does not exist '),
	('status', 405, 'Member\'s server type not compatible with Server Group '),
	('status', 406, 'The computer specified is not a member of the server group specified '),
	('status', 407, 'Member\'s NetBackup version not compatible with Server Group '),
	('status', 408, 'Server Group is in use '),
	('status', 409, 'Member already exists in server group '),
	('status', 501, 'You are not authorized to use this application. '),
	('status', 502, 'No authorization entry exists in the auth.conf file for user name username.'),
	('status', 503, 'Invalid username. '),
	('status', 504, 'Incorrect password. '),
	('status', 505, 'Cannot connect to the NB-Java authentication service on host on the configured port.'),
	('status', 506, 'Cannot connect to the NB-Java user service on host on port port_number.'),
	('status', 507, 'Socket connection to the NB-Java user service has been broken.'),
	('status', 508, 'Cannot write file. '),
	('status', 509, 'Cannot execute program. '),
	('status', 510, 'File already exists: file_name '),
	('status', 511, 'NB-Java application server interface error. '),
	('status', 512, 'Internal error.'),
	('status', 513, 'bpjava-msvc: the client is not compatible with this server version (server_version). '),
	('status', 514, 'NB-Java: bpjava-msvc is not compatible with this application version.'),
	('status', 516, 'Could not recognize or initialize the requested locale - (locale_NB-Java_was_started_in). '),
	('status', 517, 'Cannot connect to the NB-Java user service via VNETD on host on port configured_port_number.'),
	('status', 518, 'No ports available in range (port_number) through (port_number) per the NBJAVA_CLIENT_PORT_WINDOW configuration option. '),
	('status', 519, 'Invalid NBJAVA_CLIENT_PORT_WINDOW configuration option value: (option_value). '),
	('status', 520, 'Invalid value for NB-Java configuration option (option_name): (option_value). '),
	('status', 521, 'NB-Java Configuration file (file_name) does not exist. '),
	('status', 522, 'NB-Java Configuration file (file_name) is not readable due to the following error: (message). '),
	('status', 523, 'NB-Java application server protocol error. '),
	('status', 525, 'Cannot connect to the NB-Java authentication service via VNETD on (host) on port (vnetd_configured_port_number).'),
	('status', 526, 'bpjava authentication service connection failed '),
	('status', 527, 'bpjava user service connection if connection to pbx on port 1556 fails '),
	('status', 538, 'unable to login '),
	('status', 600, 'an exception condition occurred '),
	('status', 601, 'unable to open listen socket '),
	('status', 602, 'cannot set non blocking mode on the listen socket '),
	('status', 603, 'cannot register handler for accepting new connections '),
	('status', 604, 'no target storage unit specified for the new job '),
	('status', 605, 'received error notification for the job '),
	('status', 606, 'no robot on which the media can be read '),
	('status', 607, 'no images were found to synthesize '),
	('status', 608, 'storage unit query failed '),
	('status', 609, 'reader failed '),
	('status', 610, 'end point terminated with an error '),
	('status', 611, 'no connection to reader '),
	('status', 612, 'cannot send extents to bpsynth '),
	('status', 613, 'cannot connect to read media server '),
	('status', 614, 'cannot start reader on the media server '),
	('status', 615, 'internal error 615 '),
	('status', 616, 'internal error 616 '),
	('status', 617, 'no drives available to start the reader process '),
	('status', 618, 'internal error 618 '),
	('status', 619, 'internal error 619 '),
	('status', 620, 'internal error 620 '),
	('status', 621, 'unable to connect to bpcoord '),
	('status', 622, 'connection to the peer process does not exist '),
	('status', 623, 'execution of a command in a forked process failed '),
	('status', 624, 'unable to send a start command to a reader or a writer process on media server '),
	('status', 625, 'data marshalling error '),
	('status', 626, 'data un-marshalling error '),
	('status', 627, 'unexpected message received from bpsynth '),
	('status', 628, 'insufficient data received '),
	('status', 629, 'no message was received from bptm '),
	('status', 630, 'unexpected message was received from bptm '),
	('status', 631, 'received an error from bptm request to suspend media '),
	('status', 632, 'received an error from bptm request to un-suspend media '),
	('status', 633, 'unable to listen and register service via vnetd '),
	('status', 634, 'no drives available to start the writer process '),
	('status', 635, 'unable to register handle with the reactor '),
	('status', 636, 'read from input socket failed '),
	('status', 637, 'write on output socket failed '),
	('status', 638, 'invalid arguments specified '),
	('status', 639, 'specified policy does not exist '),
	('status', 640, 'specified schedule was not found '),
	('status', 641, 'invalid media type specified in the storage unit '),
	('status', 642, 'duplicate backup images were found '),
	('status', 643, 'unexpected message received from bpcoord '),
	('status', 644, 'extent directive contained an unknown media ID '),
	('status', 645, 'unable to start the writer on the media server '),
	('status', 646, 'unable to get the address of the local listen socket '),
	('status', 647, 'validation of synthetic image failed '),
	('status', 648, 'unable to send extent message to BPXM '),
	('status', 649, 'unexpected message received from BPXM '),
	('status', 650, 'unable to send extent message to bpcoord '),
	('status', 651, 'unable to issue the database query for policy '),
	('status', 652, 'unable to issue the database query for policy information '),
	('status', 653, 'unable to send a message to bpccord '),
	('status', 654, 'internal error 654 '),
	('status', 655, 'no target storage unit was specified via command line '),
	('status', 656, 'unable to send start synth message to bpcoord '),
	('status', 657, 'unable to accept connection from the reader '),
	('status', 658, 'unable to accept connection from the writer '),
	('status', 659, 'unable to send a message to the writer child process '),
	('status', 660, 'a synthetic backup request for media resources failed '),
	('status', 661, 'unable to send exit message to the BPXM reader '),
	('status', 662, 'unknown image referenced in the synth context message from BPXM '),
	('status', 663, 'image does not have a fragment map '),
	('status', 664, 'zero extents in the synthetic image, cannot proceed '),
	('status', 665, 'termination requested by bpcoord '),
	('status', 667, 'unable to open pipe between bpsynth and bpcoord '),
	('status', 668, 'pipe fgets call from bpcoord failed '),
	('status', 669, 'bpcoord startup validation failure '),
	('status', 670, 'send buffer is full '),
	('status', 671, 'query for list of component images failed '),
	('status', 800, 'resource request failed '),
	('status', 801, 'JM internal error '),
	('status', 802, 'JM internal protocol error '),
	('status', 803, 'JM terminating '),
	('status', 805, 'Invalid jobid '),
	('status', 806, 'this mpx group is unjoinable '),
	('status', 807, 'not externalized '),
	('status', 811, 'failed to communicate with resource requester '),
	('status', 812, 'failed to communicate with resource broker '),
	('status', 813, 'duplicate reference string specified '),
	('status', 818, 'retention level mismatch '),
	('status', 819, 'unable to communicate with JM proxy '),
	('status', 823, 'no BRMComm to join '),
	('status', 830, 'drive(s) unavailable or down '),
	('status', 831, 'image has been validated '),
	('status', 832, 'failed to write discover data to a file '),
	('status', 833, 'error parsing discovered XML data '),
	('status', 900, 'retry nbrb request later '),
	('status', 901, 'RB internal error '),
	('status', 902, 'RB invalid argument '),
	('status', 903, 'RB communication error '),
	('status', 904, 'RB max reallocation tries exceeded '),
	('status', 905, 'RB media server mismatch '),
	('status', 906, 'RB operator denied mount request '),
	('status', 907, 'RB user canceled resource request '),
	('status', 908, 'RB was reset '),
	('status', 912, 'RB disk volume mount failed '),
	('status', 914, 'RB media reservation not found '),
	('status', 915, 'RB disk volume mount must retry '),
	('status', 916, 'Resource request timed out '),
	('status', 917, 'RB multiplexing group not found '),
	('status', 918, 'RB does not have a multiplexing group that uses this media ID or drive name '),
	('status', 1000, 'Client is offline '),
	('status', 1001, 'discovery document error '),
	('status', 1002, 'Discovery detected a failed client '),
	('status', 1057, 'A data corruption has been detected. '),
	('status', 1058, 'A data inconsistency has been detected and corrected automatically. '),
	('status', 1401, 'Invalid arguments received '),
	('status', 1402, 'Hold ID or Hold name argument is invalid '),
	('status', 1403, 'Backup ID argument is invalid '),
	('status', 1405, 'No images are found. '),
	('status', 1407, 'Invalid hold state '),
	('status', 1408, 'Database error '),
	('status', 1409, 'Unable to connect to database '),
	('status', 1410, 'No data found '),
	('status', 1411, 'Catalog error '),
	('status', 1412, 'Hold record is being updated '),
	('status', 1413, 'Requested hold is not found '),
	('status', 1414, 'Duplicate hold found '),
	('status', 1415, 'Duplicate image found '),
	('status', 1416, 'Partially failed due to duplicate image '),
	('status', 1417, 'Partially failed due to unhold image '),
	('status', 1418, 'Requested image is not found '),
	('status', 1419, 'Partially failed due to invalid image copy '),
	('status', 1420, 'Cannot expire on hold image copy. '),
	('status', 1421, 'Active holds cannot be changed '),
	('status', 1422, 'Cannot deassign media on hold '),
	('status', 1423, 'Unable to retrieve hold status of the image copies '),
	('status', 1425, 'Requested hold is not found '),
	('status', 1426, 'Retired holds cannot be changed '),
	('status', 1500, 'Storage unit does not exist or can\'t be used where specified '),
	('status', 1501, 'Source operation cannot be used where specified '),
	('status', 1502, 'Retention type cannot be used where specified '),
	('status', 1503, 'Volume pool does not exist or can\'t be used where specified '),
	('status', 1504, 'Server group does not exist or can\'t be used where specified '),
	('status', 1505, 'alternate read server does not exist or can\'t be used where specified '),
	('status', 1506, 'data classification does not exist '),
	('status', 1507, 'Invalid deferred operation flag '),
	('status', 1508, 'Storage lifecycle policy exceeds maximum copies '),
	('status', 1509, 'Storage lifecycle policy exceeds maximum backup operations '),
	('status', 1510, 'storage lifecycle policy cannot have more than one snapshot operation '),
	('status', 1511, 'storage lifecycle policy must have at least one fixed retention or snapshot rotation operation '),
	('status', 1512, 'storage lifecycle policy must have at least one backup, import, or snapshot operation '),
	('status', 1513, 'invalid priority '),
	('status', 1514, 'invalid operation type '),
	('status', 1515, 'Multiplexing value is not valid or cannot be used where specified '),
	('status', 1516, 'all storage units or groups must be on the same media server '),
	('status', 1517, 'Invalid retention level '),
	('status', 1518, 'backup image is not supported by storage lifecycle policy '),
	('status', 1519, 'Images are in process '),
	('status', 1521, 'Database not available '),
	('status', 1522, 'Error executing database query '),
	('status', 1523, 'Invalid fragment '),
	('status', 1524, 'Duplicate image record '),
	('status', 1525, 'Invalid lsu '),
	('status', 1526, 'Storage lifecycle policy exceeds maximum import operations '),
	('status', 1527, 'storage lifecycle policy can have only one of backup, import, and snapshot operations '),
	('status', 1528, 'The source copy for an Auto Image Replication is not capable of replication '),
	('status', 1529, 'The source copy for Auto Image Replication must specify a storage unit '),
	('status', 1530, 'Only one Auto Image Replication allowed per copy '),
	('status', 1531, 'An import storage lifecycle policy requires one copy with remote retention type '),
	('status', 1532, 'Import failed because the imported image specifies an SLP name which does not exist '),
	('status', 1533, 'Import failed because the imported image data class is different than the SLP data class '),
	('status', 1534, 'Import failed because the imported image specifies an SLP name with no import operation '),
	('status', 1535, 'Import failed because the imported image backup ID conflicts with an existing image '),
	('status', 1536, 'The storage unit or storage unit group cannot be deleted because an SLP references it '),
	('status', 1537, 'Backup policy and storage lifecycle policy have conflicting configurations '),
	('status', 1538, 'Data classification in the SLP conflicts with backup policy '),
	('status', 1539, 'Backup policy generates snapshots but storage lifecycle policy does not handle them '),
	('status', 1540, 'SLP expects snapshots but backup policy does not create them with SLP management enabled '),
	('status', 1541, 'Snapshot creation failed.'),
	('status', 1542, 'An existing snapshot is no longer valid and cannot be mounted for subsequent operations '),
	('status', 1543, 'Policy type is not compatible with SLP operations '),
	('status', 1545, 'Schedule type is not compatible with SLP operations '),
	('status', 1546, 'Capacity managed retention type is not compatible with SLP operations '),
	('status', 1547, 'Expire after copy retention requires a dependent copy '),
	('status', 1548, 'Retention type is not compatible with snapshot operation '),
	('status', 1549, 'TIR information selection is not compatible with SLP operations '),
	('status', 1552, 'The source and target storage units are not valid replication partners. '),
	('status', 1553, 'Checkpoints are not allowed with SLP operations '),
	('status', 1554, 'Storage unit snapshot capability is not compatible with operation characteristics '),
	('status', 1556, 'The SLP deletion failed because a backup policy refers to it. '),
	('status', 1557, 'Must specify mirror retention when target storage unit is mirror capable. '),
	('status', 1558, 'Mirror retention is not allowed when target storage unit is not mirror capable. '),
	('status', 1559, 'SLP referenced in policy or schedule not found '),
	('status', 1560, 'Fixed or rotation retention required without a replication operation '),
	('status', 1561, 'Policy using NDMP conflicts with multiple Backup From Snapshot operations in storage lifecycle policy '),
	('status', 1562, 'Backup schedule generates snapshots but storage lifecycle policy does not handle them '),
	('status', 1563, 'SLP expects snapshots but backup schedule does not create them '),
	('status', 1564, 'Storage lifecycle policy contains errors '),
	('status', 1565, 'Policy snapshot method is not compatible with SLP snapshot operations '),
	('status', 1566, 'Storage unit required for snapshot operation when no other operation present '),
	('status', 1567, 'Only one NDMP backup of a snapshot per backup ID is allowed '),
	('status', 1568, 'Only one Index From Snapshot operation is allowed per storage lifecycle policy '),
	('status', 1569, 'Snapshot storage unit is not configured for primary snapshots. It cannot be used in snapshot operation. '),
	('status', 1570, 'Policy type does not support Index from Snapshot '),
	('status', 1571, 'Data mover type specified in policy does not support Index from Snapshot '),
	('status', 1572, 'Storage unit must be specified for this operation '),
	('status', 1573, 'Backup image cannot be expired because its SLP processing is not yet complete '),
	('status', 1574, 'Data Classification name cannot be \'Any\' while creating new data classification '),
	('status', 1575, 'Data Classification auto creation failed '),
	('status', 1576, 'Topology validation failed '),
	('status', 1577, 'Storage unit in the SLP does not match the accelerator attribute in policy '),
	('status', 1578, 'Invalid window close options '),
	('status', 1579, 'One or more images were not processed because the window closed '),
	('status', 1580, 'VMware policy with PFI enabled requires an SLP '),
	('status', 1581, 'Non-application consistent VMware policy is not compatible with snapdupe operations '),
	('status', 1582, 'Application consistent VMware policy requires VM quiesce '),
	('status', 1583, 'VMware policy with PFI enabled requires VIP auto discovery '),
	('status', 1584, 'VMware policy with \'Persistent Frozen Image\' enabled requires schedule type of Full Backup '),
	('status', 1585, 'Backup image cannot be expired because not all dependent copies are expired '),
	('status', 1586, 'SLP operation was canceled '),
	('status', 1587, 'Storage lifecycle policy cannot have both target and untarget replication to remote master '),
	('status', 1588, 'Target master server is already used in one of the replications to remote master '),
	('status', 1589, 'Cannot connect to specified target master server '),
	('status', 1590, 'Cannot find specified target import SLP '),
	('status', 1591, 'No import SLP(s) found with compatible replication target device. '),
	('status', 1592, 'Trusted master servers are being referred by one or more Storage Lifecycle Policies on the source or target domain '),
	('status', 1593, 'Replication Director for VMware policy requires mapped backups '),
	('status', 1594, 'Failed to determine disk media ID '),
	('status', 1596, 'Select a storage lifecycle policy that has no snapshot operation as a policy\'s Storage Destination '),
	('status', 1597, 'Replication Director for Oracle policy requires an SLP '),
	('status', 1598, 'Oracle policy with PFI and FI enabled requires an SLP '),
	('status', 1599, 'Application schedule storage selection cannot be a snapshot SLP '),
	('status', 1600, 'The Policy storage is a snapshot SLP and the Application schedule does not override the policy storage selection.'),
	('status', 1601, 'Full schedule requires a snapshot SLP '),
	('status', 1602, 'The Policy storage is not a snapshot SLP and the Full schedule does not override the policy storage selection.'),
	('status', 1603, 'Failed to save target SLP volume information '),
	('status', 1604, 'No import SLP(s) found with compatible data class. '),
	('status', 1800, 'Invalid client list '),
	('status', 1915, 'Cannot delete instance group that contains instances (delete or move instances first) '),
	('status', 1916, 'Database error, cannot access the instance repository '),
	('status', 1917, 'Cannot add instance group, this group name is already in use '),
	('status', 1918, 'Cannot find a group by this name '),
	('status', 1919, 'This instance or instance group was modified by another process, refresh before editing '),
	('status', 1920, 'An instance with this name and client already exists '),
	('status', 1921, 'The specified instance cannot be found '),
	('status', 1924, 'Domain is a required field for Windows instances '),
	('status', 1925, 'The requested operation(s) failed '),
	('status', 1926, 'The entry specified already exists '),
	('status', 1927, 'The entry specified does not exist '),
	('status', 1928, 'The credentials for 1 or more instances could not be verified '),
	('status', 2000, 'Unable to allocate new media for backup, storage unit has none available. '),
	('status', 2001, 'No drives are available for this job '),
	('status', 2002, 'Invalid STU identifier type '),
	('status', 2003, 'Drive is not allocated. '),
	('status', 2004, 'Drive is already allocated '),
	('status', 2005, 'MDS has received an invalid message from a media server. '),
	('status', 2006, 'NDMP credentials are not defined in EMM. '),
	('status', 2007, 'Storage unit is not compatible with requesting job '),
	('status', 2008, 'All compatible drive paths are down '),
	('status', 2009, 'All compatible drive paths are down but media is available '),
	('status', 2010, 'Job type is invalid '),
	('status', 2011, 'The media server reported a system error '),
	('status', 2012, 'Media has conflicts in EMM '),
	('status', 2013, 'Error record insert failed '),
	('status', 2014, 'Media is not assigned '),
	('status', 2015, 'Media is expired '),
	('status', 2016, 'Media is assigned to another server '),
	('status', 2017, 'Media needs to be unmounted from a drive '),
	('status', 2018, 'Number of cleanings is invalid '),
	('status', 2019, 'Media is in a drive that is not configured on local system '),
	('status', 2020, 'Robotic library is down on server '),
	('status', 2021, 'Allocation record insert failed '),
	('status', 2022, 'Allocation status record insert failed '),
	('status', 2023, 'Allocation identifier is not known to EMM '),
	('status', 2024, 'Allocation request update failed '),
	('status', 2025, 'Allocation request delete failed '),
	('status', 2026, 'Allocation status request delete failed '),
	('status', 2027, 'Media server is not active '),
	('status', 2028, 'Media is reserved '),
	('status', 2029, 'EMM database is inconsistent '),
	('status', 2030, 'Insufficient disk space or high water mark would be exceeded '),
	('status', 2031, 'Media is not defined in EMM '),
	('status', 2032, 'Media is in use according to EMM '),
	('status', 2033, 'Media has been misplaced '),
	('status', 2034, 'Retry the allocation request later '),
	('status', 2035, 'Request needs to pend '),
	('status', 2036, 'Drive is in a robotic library that is up '),
	('status', 2037, 'Drive is not ready '),
	('status', 2038, 'Media loaded in drive is not write-enabled '),
	('status', 2039, 'SCSI reservation conflict detected '),
	('status', 2040, 'Maximum job count has been reached for the storage unit '),
	('status', 2041, 'Storage unit is down '),
	('status', 2042, 'Density mismatch detected '),
	('status', 2043, 'Requested slot is empty '),
	('status', 2044, 'Media is assigned to another application '),
	('status', 2045, 'Storage unit is disabled since max job count is less than 1 '),
	('status', 2046, 'Media is unmountable '),
	('status', 2047, 'Media is write protected '),
	('status', 2048, 'Media is in use by the ACS robotic library '),
	('status', 2049, 'Media not found in the ACS robotic library '),
	('status', 2050, 'ACS media has an unreadable external label '),
	('status', 2051, 'ACS media is not in the drive\'s domain '),
	('status', 2052, 'An ACS Library Storage Module (LSM) is offline '),
	('status', 2053, 'Media is in an inaccessible drive '),
	('status', 2054, 'Media is in a drive that is currently in a DOWN state '),
	('status', 2055, 'ACS physical drive is not available '),
	('status', 2056, 'The file name used for the mount request already exists '),
	('status', 2057, 'The scan host of the drive is not active '),
	('status', 2058, 'LTID needs to be restarted on media servers before the device can be used '),
	('status', 2059, 'The robotic library is not available '),
	('status', 2060, 'Media needs to be rewound or unmounted from a drive '),
	('status', 2061, 'The host is not an active node of a cluster '),
	('status', 2062, 'Throttled job count has been reached for the storage unit '),
	('status', 2063, 'Server is not licensed for the Remote Client Option '),
	('status', 2064, 'Job history indicates that no media is available '),
	('status', 2065, 'Job history indicates that no drive is available '),
	('status', 2066, 'Disk pool not found '),
	('status', 2067, 'Disk volume not found '),
	('status', 2068, 'Disk volume mount point not found '),
	('status', 2069, 'Disk volume mount point record insert failed '),
	('status', 2070, 'The specified mount path will not fit in the allocated space '),
	('status', 2071, 'Unable to find any storage servers for the request '),
	('status', 2072, 'Invalid operation on static mount point '),
	('status', 2073, 'Disk pool is down '),
	('status', 2074, 'Disk volume is down '),
	('status', 2075, 'Fibre Transport resources are not available '),
	('status', 2076, 'DSM returned an unexpected error '),
	('status', 2078, 'The maximum number of mounts for the disk volume have been exceeded '),
	('status', 2079, 'DSM has detected that an invalid file system is mounted on the volume '),
	('status', 2080, 'Disk volume has no max writers count '),
	('status', 2081, 'Disk volume has no max readers count '),
	('status', 2082, 'The drive needs to be marked as available '),
	('status', 2083, 'The media affinity group is not defined in EMM '),
	('status', 2084, 'Media affinity group record insert failed '),
	('status', 2085, 'Disk volume is not available '),
	('status', 2086, 'Disk volume cannot be used for more than one copy in the same job '),
	('status', 2087, 'Media allocation would exceed maximum partially full media limit '),
	('status', 2088, 'Cleaning media is not available '),
	('status', 2089, 'FT client is not running '),
	('status', 2090, 'FT client has no devices configured '),
	('status', 2091, 'FT client devices are offline '),
	('status', 2092, 'FT server devices for client are offline '),
	('status', 2093, 'No FT servers for this client are running '),
	('status', 2094, 'STU cannot run Lifecycle backups '),
	('status', 2095, 'STU cannot run VMWare backup '),
	('status', 2096, 'NDMP operation does not support multiple inline copies '),
	('status', 2097, 'Storage Unit group does not exist in EMM configuration '),
	('status', 2098, 'Media pool is not eligible for this job '),
	('status', 2099, 'Required drive or drive path is not configured '),
	('status', 2100, 'Maximum number of mounts has been exceeded for tape media '),
	('status', 2101, 'Media server not found in EMM database '),
	('status', 2102, 'Storage unit does not support spanning '),
	('status', 2103, 'Media server mismatch '),
	('status', 2104, 'Storage units are not available '),
	('status', 2105, 'Storage unit requested for replication job is not replication capable '),
	('status', 2106, 'Disk storage server is down '),
	('status', 2107, 'Requested media server does not have credentials or is not configured for the storage server '),
	('status', 2108, 'Requested NDMP machine does not have credentials or is not configured in NetBackup '),
	('status', 2109, 'Requested Fibre Transport client machine was not found in NetBackup configuration '),
	('status', 2110, 'Requested machine is not configured in NetBackup '),
	('status', 2111, 'All storage units are configured with On Demand Only and are not eligible for jobs requesting ANY storage unit '),
	('status', 2112, 'NetBackup media server version is too low for the operation '),
	('status', 2113, 'Invalid or no disk array credentials are added for vserver '),
	('status', 2504, 'Direct expiration of a mirror copy is not allowed '),
	('status', 2517, 'Backup set identifier may only contain a-z, A-Z, 0-9 and .-+_ '),
	('status', 2521, 'Datafile copy tag may only contain a-z, A-Z, 0-9 and .-+_ '),
	('status', 2522, 'Oracle policy cannot include a pluggable database with a FRA backup. '),
	('status', 2800, 'Standard policy restore error '),
	('status', 2801, 'Oracle policy restore error '),
	('status', 2802, 'Informix-On-BAR policy restore error '),
	('status', 2803, 'Sybase policy restore error '),
	('status', 2804, 'MS-SharePoint policy restore error '),
	('status', 2805, 'MS-Windows policy restore error '),
	('status', 2806, 'NetWare policy restore error '),
	('status', 2807, 'SQL-BackTrack policy restore error '),
	('status', 2808, 'Windows File System policy restore error '),
	('status', 2809, 'MS-SQL-Server policy restore error '),
	('status', 2810, 'MS-Exchange policy restore error '),
	('status', 2811, 'SAP policy restore error '),
	('status', 2812, 'DB2 policy restore error '),
	('status', 2813, 'NDMP policy restore error '),
	('status', 2814, 'FlashBackup policy restore error '),
	('status', 2815, 'AFS policy restore error '),
	('status', 2816, 'DataStore policy restore error '),
	('status', 2817, 'FlashBackup Windows policy restore error '),
	('status', 2818, 'NetBackup Catalog policy restore error '),
	('status', 2819, 'Enterprise Vault policy restore error '),
	('status', 2820, 'NetBackup VMware policy restore error '),
	('status', 2821, 'Hyper-V policy restore error '),
	('status', 2826, 'Master server failed to connect to backup restore manager on media server for restore '),
	('status', 2827, 'Client failed to connect to the media server for restore '),
	('status', 2828, 'Restore failed because the MS-SQL-Server services are down '),
	('status', 2829, 'Restore failed due to MS-SQL-Server database in use '),
	('status', 2830, 'Restore failed due to an incorrect path in the MS-SQL-Server MOVE script '),
	('status', 2831, 'Restore error '),
	('status', 2832, 'Restore failed due to rename file format error '),
	('status', 2833, 'Restore failed due to partition restore error '),
	('status', 2834, 'Restore failed due to failure to read change block bit map '),
	('status', 2835, 'Restore failed due to corrupt image '),
	('status', 2836, 'Restore failed because the bitmap size read from the image header differs from the expected size. '),
	('status', 2837, 'Restore failed due to invalid metadata '),
	('status', 2838, 'Restore failed because no raw partitions were found '),
	('status', 2839, 'Restore failed due to invalid raw partition id '),
	('status', 2840, 'Restore failed due to out of sequence raw partitions '),
	('status', 2841, 'Restore failed due to failure to read the header from the backup image '),
	('status', 2842, 'Restore failed due to failure to read the VMware bitmap '),
	('status', 2843, 'Restore failed due to failure to start VxMS '),
	('status', 2844, 'Restore failed due to failure to read the FIID file '),
	('status', 2845, 'Restore failed due to failure to retrieve the bitmap '),
	('status', 2846, 'Restore failed due to failure to retrieve the fsmap '),
	('status', 2847, 'Restore failed due to failure to start the bptm writer '),
	('status', 2848, 'Restore failed due to failure to create the virtual machine '),
	('status', 2849, 'Restore failed due to failure to delete the virtual machine snapshot '),
	('status', 2850, 'Restore error '),
	('status', 4200, 'Operation failed: Unable to acquire snapshot lock '),
	('status', 4201, 'Incorrect snapshot method configuration or snapshot method not compatible for protecting backup selection entries '),
	('status', 4202, 'Invalid or incompatible storage unit configured '),
	('status', 4203, 'Invalid or unsupported backup selection filelist '),
	('status', 4204, 'Incompatible client found '),
	('status', 4205, 'Incorrect or no credentials found '),
	('status', 4206, 'Authentication error occurred. NetBackup Client Service is running as Local System, this is likely incorrect. '),
	('status', 4207, 'Could not fetch snapshot metadata or state files '),
	('status', 4208, 'Could not send snapshot metadata or statefiles '),
	('status', 4209, 'Snapshot metadata or statefiles cannot be created '),
	('status', 4210, 'Incorrect or no content found in snapshot metadata '),
	('status', 4211, 'Snapshot not accessible or invalid snapshot '),
	('status', 4212, 'Recreation of snapshot failed '),
	('status', 4213, 'Snapshot import failed '),
	('status', 4214, 'Snapshot mount failed '),
	('status', 4215, 'Snapshot deletion failed '),
	('status', 4216, 'Snapshot cleanup failed '),
	('status', 4217, 'Snapshot restore failed '),
	('status', 4218, 'Snapshot deport failed '),
	('status', 4219, 'Command operation failed: Third-party command or API execution failed '),
	('status', 4220, 'Command operation failed: System command or API execution failed '),
	('status', 4221, 'Found an invalid or unsupported configuration '),
	('status', 4222, 'Operation failed: Unable to acquire policy lock to take snapshot '),
	('status', 4223, 'Operation not completed '),
	('status', 4224, 'STS Internal Error '),
	('status', 4225, 'Unauthorized operation attempted by client or media on storage server '),
	('status', 4226, 'Communication failure occurred with storage server '),
	('status', 4227, 'STS Plugin error occurred '),
	('status', 4228, 'Storage server or plugin version mismatch '),
	('status', 4229, 'Insufficient resources or capabilities found by storage server '),
	('status', 4230, 'Invalid storage topology or storage server configuration error '),
	('status', 4231, 'STS Unexpected Error '),
	('status', 4232, 'Invalid Discovery Query URI '),
	('status', 4233, 'BIOS uuid client reference not allowed for vCloud '),
	('status', 4234, 'VMware server login failure '),
	('status', 4235, 'vCloud keyword used when vCloud not enabled '),
	('status', 4236, 'vCloud policy includes multiple organizations '),
	('status', 4237, 'Client does not meet policy requirements '),
	('status', 4238, 'No server credentials configured for policy '),
	('status', 4239, 'Unable to find the virtual machine '),
	('status', 4240, 'Operation not supported '),
	('status', 4243, 'Unable to connect to the VirtualCenter server '),
	('status', 4245, 'Invalid pathname for backup selection '),
	('status', 4246, 'The requested operation was partially successful. '),
	('status', 4247, 'Index from snapshot for Replication Director NDMP Policy is not supported on AIX media server '),
	('status', 4248, 'Index from snapshot operation failed with an internal error '),
	('status', 4249, 'Index from snapshot operation failed, catalog already exists '),
	('status', 4250, 'Index from snapshot operation failed, unable to find child image or file information '),
	('status', 4251, 'Index from snapshot operation failed. Failed to write into index database. '),
	('status', 4252, 'Index from snapshot operation failed. Entry does not belong to any of the backup selection entries. '),
	('status', 4253, 'Index from snapshot operation failed. SLP version mismatch for current and previous backup image. '),
	('status', 4254, 'Invalid or no path found to create index database '),
	('status', 4255, 'Index from snapshot using snapdiff is disabled by the user '),
	('status', 4256, 'Index from snapshot is not supported for the filesystem associated with backup selection '),
	('status', 4257, 'Index from snapshot is not supported for the storage server '),
	('status', 4258, 'Transient error encountered while taking Hyper-V VM snapshot '),
	('status', 4259, 'Failed to find Virtual Center hostname in VMware Lookup Service '),
	('status', 4260, 'Encountered SSO login failure '),
	('status', 4261, 'Encountered VMware Internal Server Error '),
	('status', 4262, 'Encountered VMware vCloud Suite API failure '),
	('status', 4263, 'Encountered VMware SOAP API failure '),
	('status', 4264, 'Encountered unexpected error while processing TagView XML '),
	('status', 4265, 'Encountered a VMware Virtual Machine Server that does not support Tags '),
	('status', 4266, 'Encountered a VMware Virtual Machine Server that does not offer Tag APIs '),
	('status', 4267, 'Failed to initialize Java runtime environment '),
	('status', 4268, 'Failed to retrieve resource pool information '),
	('status', 4269, 'Found multiple virtual machines with same identity '),
	('status', 4270, 'A snapshot of the virtual machine exists and the policy option specifies aborting the backup '),
	('status', 4271, 'Maximum virtual machine snapshots exceeded '),
	('status', 4272, 'Maximum delta files exceeded '),
	('status', 4273, 'Unable to lock the backup or restore host for virtual machine snapshot operations '),
	('status', 4274, 'Failed to remove virtual machine snapshot '),
	('status', 4275, 'Unable to consolidate Virtual Machine Disks '),
	('status', 4276, 'Unable to retrieve Virtual Machine Disk information '),
	('status', 4277, 'Virtual machine path contains unsupported characters '),
	('status', 4278, 'Unable to retrieve virtual machine information '),
	('status', 4279, 'Unable to retrieve virtual machine vCloud information '),
	('status', 4280, 'Virtual machine contains independent and Raw Device Mapping disks only '),
	('status', 4281, 'Virtual machine contains independent disks only '),
	('status', 4282, 'Virtual machine contains Raw Device Mapping disks only '),
	('status', 4283, 'Error detected while processing disk identifiers '),
	('status', 4287, 'A NetBackup snapshot of the virtual machine exists and the policy option specifies aborting the backup '),
	('status', 5400, 'Backup error - None of the request objects were found in the database '),
	('status', 5401, 'Backup error - FRA (Fast Recovery Area) was requested, but it was not found in the database '),
	('status', 5402, 'OS Authentication error - Could not connect to the database. Please check the OS credentials '),
	('status', 5403, 'Oracle Authentication error - Could not connect to the database. Please check the Oracle credentials '),
	('status', 5404, 'ASM validation error - PROXY backup is not supported for ASM '),
	('status', 5405, 'Recovery Catalog Authentication error - Could not connect to the Recovery Catalog.'),
	('status', 5406, 'Archive log only backup requested, but database is not in ARCHIVELOG Mode '),
	('status', 5407, 'Database is in the wrong state (must be OPEN) for the requested action '),
	('status', 5408, 'OS Authentication error - Could not find credentials.'),
	('status', 5409, 'Cloning is NOT supported for this client platform '),
	('status', 5410, 'Oracle Intelligent Policy is NOT supported for this client platform '),
	('status', 5411, 'Cannot do a hot backup of a database in NOARCHIVELOG mode '),
	('status', 5412, 'Database is in the wrong state (must be OPEN or MOUNTED) for an Archive Log Backup '),
	('status', 5413, 'Database is in the wrong state (must be OPEN or MOUNTED) for an FRA backup '),
	('status', 5414, 'The request operation is not supported with this client version '),
	('status', 5415, 'Cannot shut down read-only standby database '),
	('status', 5416, 'Oracle could not resolve the TNS connection identifier '),
	('status', 5417, 'An error has occurred checking if the NFS server is an appliance. '),
	('status', 5418, 'The NFS server is not an appliance. '),
	('status', 5419, 'The database backup share directory is not available on the appliance. '),
	('status', 5420, 'Whole Database - Datafile Copy Share selection is not supported for this client platform. '),
	('status', 5421, 'None of the requested pluggable databases were found. '),
	('status', 5422, 'Partial success - one or more of the requested pluggable databases were not found. '),
	('status', 5423, 'None of the requested tablespaces were found in the requested pluggable databases. '),
	('status', 5424, 'Partial success - one or more of the requested pluggable databases did not contain any of the requested tablespaces. '),
	('status', 5425, 'None of the requested data files were found in the requested pluggable databases. '),
	('status', 5426, 'Partial success - one or more of the requested pluggable databases did not contain any of the requested data files. '),
	('status', 5427, 'Partial success - more than one error was encountered.'),
	('status', 5428, 'No database backup shares were found. '),
	('status', 5429, 'No files that are related to the instance or database were found in the database backup share. '),
	('status', 5430, 'Database must be in ARCHIVELOG mode to perform a cold backup of a pluggable database. '),
	('status', 5500, 'The NetBackup core web service service internal error '),
	('status', 5501, 'Supplied URI is too short '),
	('status', 5502, 'Supplied URI is not supported '),
	('status', 5503, 'NetBackup core web service is terminating '),
	('status', 5504, 'Query string in URI is bad '),
	('status', 5505, 'Client name is required '),
	('status', 5506, 'Failed to communicate with core web service proxy '),
	('status', 5507, 'Unknown jobid '),
	('status', 5508, 'Error in parsing XML document '),
	('status', 5761, 'Failed to initialize Windows Socket library '),
	('status', 5762, 'Peer is not a NetBackup Master or Media Server '),
	('status', 5763, 'Encountered error during socket communication '),
	('status', 5764, 'Command specified for execution is invalid or not allowed '),
	('status', 5765, 'Failed to execute specified command (CreateProcess or exec) '),
	('status', 5766, 'Failed to execute specified command (fork) '),
	('status', 5767, 'Failed to get exit code of child process '),
	('status', 5768, 'Failed to read complete output of executed command '),
	('status', 5769, 'Failed to reap exit code of child process '),
	('status', 5770, 'Failed to get cluster configuration '),
	('status', 5771, 'Failed to write output received from remote command '),
	('status', 5772, 'Failed to read unified logging configuration file '),
	('status', 5773, 'Failed to get virtual name of Master Server '),
	('status', 5774, 'Specified logs are not valid '),
	('status', 5775, 'Invalid option specified '),
	('status', 5776, 'Failed to spawn new process '),
	('status', 5777, 'Failed to create staging directory on Master Server '),
	('status', 5778, 'Failed to read Logging Assistant database '),
	('status', 5779, 'Failed to lock Logging Assistant database '),
	('status', 5780, 'Failed to set non-inherit flag on database file handle '),
	('status', 5781, 'Failed to prepare to save Logging Assistant database '),
	('status', 5782, 'Failed to start to write Logging Assistant database '),
	('status', 5783, 'Failed to save Logging Assistant database '),
	('status', 5784, 'Failed to access or write the readme or progress file '),
	('status', 5785, 'FTP connection failed '),
	('status', 5786, 'Logging Assistant record does not exist '),
	('status', 5787, 'Logging Assistant record already exists '),
	('status', 5788, 'Debug logging has not been set up for Logging Assistant record '),
	('status', 5789, 'Failed to interpret bpdbjobs output for job detail '),
	('status', 5790, 'Failed to fetch PureDisk configuration setting from Windows registry '),
	('status', 5794, 'Failed to calculate debug logs size for preview '),
	('status', 5795, 'Upload evidence directory does not exist '),
	('status', 5796, 'Logging Assistant agent encountered failure writing on socket to Master Server '),
	('status', 5797, 'Failed to upload file to FTP server '),
	('status', 5798, 'Failed to list disk volumes on Master Server using bpmount '),
	('status', 5799, 'Failed to get disk space information of volumes or mount points '),
	('status', 5800, 'Failed to execute bpdbjobs to fetch job details '),
	('status', 5801, 'Failed to fetch job details. Check if job exists. '),
	('status', 5802, 'Unknown ftp server location specified '),
	('status', 5803, 'Failed to modify PureDisk configuration file '),
	('status', 5804, 'Failed to modify Java GUI configuration file (Debug.properties) '),
	('status', 5805, 'Remote host NetBackup version not supported by Logging Assistant '),
	('status', 5806, 'Unexpected contents of PureDisk configuration file (pdregistry.cfg) '),
	('status', 5807, 'Failed to copy nbcplogs/nbsu output file from remote host '),
	('status', 5808, 'Failed to load PBX configuration to change log level '),
	('status', 5809, 'Invalid PBX Debug Log Level specified '),
	('status', 5810, 'No files to upload in specified directory '),
	('status', 5811, 'Temporary directory to use for logs collection does not exist '),
	('status', 5812, 'nbcplogs exited with error '),
	('status', 5813, 'nbcplogs did not collect any logs '),
	('status', 5814, 'nbsu exited with error '),
	('status', 5815, 'No activity for the Logging Assistant record is in progress '),
	('status', 5816, 'Collect and upload debug logs operation canceled '),
	('status', 5817, 'Collect and upload nbsu operation canceled '),
	('status', 5818, 'Upload evidence operation canceled '),
	('status', 5819, 'Cancel operation requested '),
	('status', 5820, 'Not a valid Logging Assistant temporary directory for clean-up '),
	('status', 5821, 'Failed to get policy details '),
	('status', 6000, 'The provided path is not whitelisted '),
	('subtype', 0, 'Immediate'),
	('subtype', 1, 'Scheduled'),
	('subtype', 2, 'User/Archive'),
	('subtype', 3, 'Quick erase'),
	('subtype', 4, 'Long erase'),
	('subtype', 5, 'DB staging'),
	('usefor', 0, 'Backup'),
	('usefor', 1, 'Duplication'),
	('usefor', 2, 'Snapshot'),
	('usefor', 3, 'Replication'),
	('usefor', 4, 'Import'),
	('usefor', 5, 'Backup from snapshot');

INSERT INTO `core_fields` (`source`, `ord`, `name`, `title`, `type`, `link`, `description`, `created`, `updated`, `obsoleted`) VALUES
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
	('audit_complete', 17, 'PROTECTION', 'PROTECTION', 'STRING', NULL, NULL, '2018-01-18 13:14:10', '2018-01-18 13:18:26', NULL),
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
	('nbu_audit', 1, 'tower', 'Tower', 'STRING', NULL, NULL, '2017-10-09 14:57:39', '2017-10-09 14:57:39', NULL),
	('nbu_audit', 2, 'customer', 'Customer', 'STRING', NULL, NULL, '2017-10-09 14:56:21', '2017-10-09 14:57:31', NULL),
	('nbu_audit', 3, 'masterserver', 'Master server', 'STRING', NULL, NULL, '2017-10-09 14:57:56', '2017-10-09 14:57:56', NULL),
	('nbu_audit', 4, 'client', 'Client name', 'STRING', NULL, NULL, '2017-10-09 14:58:17', '2018-08-30 14:23:48', NULL),
	('nbu_audit', 5, 'pt', 'PT', 'NUMBER', NULL, NULL, '2017-10-09 14:58:37', '2017-10-09 15:00:38', NULL),
	('nbu_audit', 6, 'policy_type', 'Policy type', 'STRING', NULL, NULL, '2017-10-09 14:59:09', '2019-04-18 13:27:36', NULL),
	('nbu_audit', 7, 'policy', 'Policy name', 'STRING', NULL, NULL, '2017-10-09 14:59:46', '2017-10-09 14:59:46', NULL),
	('nbu_audit', 8, 'st', 'ST', 'NUMBER', NULL, NULL, '2017-10-09 14:59:46', '2017-10-09 14:59:46', NULL),
	('nbu_audit', 9, 'schedule_type', 'Schedule type', 'STRING', NULL, NULL, '2017-10-09 14:59:46', '2017-10-09 14:59:46', NULL),
	('nbu_audit', 10, 'schedule', 'Schedule name', 'STRING', NULL, NULL, '2017-10-09 15:00:11', '2019-04-18 13:45:35', NULL),
	('nbu_audit', 11, 'freq', 'Freq.(days)', 'NUMBER', NULL, NULL, '2017-10-09 15:00:34', '2019-04-18 13:45:43', NULL),
	('nbu_audit', 12, 'schedule_ret', 'Retention', 'STRING', NULL, NULL, '2017-10-09 15:01:10', '2019-04-18 13:50:04', NULL),
	('nbu_audit', 13, 'schedule_stu', 'STU', 'STRING', NULL, NULL, '2017-10-09 15:01:10', '2019-04-18 13:50:07', NULL),
	('nbu_audit', 14, 'slp', 'SLP?', 'STRING', NULL, NULL, '2017-10-09 15:00:34', '2019-04-18 13:50:09', NULL),
	('nbu_audit', 15, 'slp_name', 'SLP name', 'STRING', NULL, NULL, '2017-10-09 15:01:10', '2019-04-18 13:46:11', NULL),
	('nbu_audit', 16, 'slp_stu', 'SLP STU', 'STRING', NULL, NULL, '2017-10-09 15:01:10', '2019-04-18 13:46:11', NULL),
	('nbu_audit', 17, 'slp_ret', 'SLP Retention', 'STRING', NULL, NULL, '2017-10-09 15:01:10', '2019-04-18 13:46:11', NULL),
	('nbu_audit', 18, 'vault', 'Vault profile', 'STRING', NULL, NULL, '2017-10-09 15:01:27', '2019-04-18 13:47:55', NULL),
	('nbu_audit', 19, 'vault_stu', 'Vault STU', 'STRING', NULL, NULL, '2017-10-09 15:01:27', '2019-04-18 13:47:55', NULL),
	('nbu_audit', 20, 'vault_ret', 'Retention', 'STRING', NULL, NULL, '2017-10-09 15:01:43', '2019-04-18 13:47:58', NULL),
	('nbu_bsr', 1, 'day', 'Backup day', 'DATE', NULL, NULL, '2017-03-22 12:21:08', '2018-08-13 10:53:41', NULL),
	('nbu_bsr', 2, 'jobs', 'Jobs', 'NUMBER', 'nbu_bsr_jobs', 'Show jobs for %day%', '2017-03-22 12:21:26', '2017-04-12 15:11:30', NULL),
	('nbu_bsr', 3, 'bsr', 'BSR', 'FLOAT', 'nbu_bsr_jobs', 'Show failed jobs for %day%', '2017-03-22 12:21:37', '2017-04-12 15:11:34', NULL),
	('nbu_bsr_client', 1, 'day', 'Backup day', 'DATE', NULL, NULL, '2017-03-22 15:08:20', '2018-08-13 10:53:45', NULL),
	('nbu_bsr_client', 2, 'client', 'Client name', 'STRING', NULL, NULL, '2017-03-22 15:08:37', '2017-03-22 15:17:53', NULL),
	('nbu_bsr_client', 3, 'jobs', 'Jobs', 'NUMBER', 'nbu_bsr_jobs', 'Show jobs for %client% and %day%', '2017-03-22 15:08:20', '2017-03-22 15:09:52', NULL),
	('nbu_bsr_client', 4, 'bsr', 'BSR', 'FLOAT', 'nbu_bsr_jobs', 'Show failed jobs for %client% and %day%', '2017-03-22 15:08:20', '2017-03-23 14:55:29', NULL),
	('nbu_bsr_customer', 1, 'day', 'Backup day', 'DATE', NULL, NULL, '2017-03-22 15:15:19', '2018-08-13 10:53:48', NULL),
	('nbu_bsr_customer', 2, 'customer', 'Customer', 'STRING', NULL, NULL, '2017-03-22 15:15:19', '2017-03-22 15:17:39', NULL),
	('nbu_bsr_customer', 3, 'jobs', 'Jobs', 'NUMBER', 'nbu_bsr_jobs', 'Show jobs for %customer% and %day%', '2017-03-22 15:15:19', '2017-03-22 15:18:08', NULL),
	('nbu_bsr_customer', 4, 'bsr', 'BSR', 'FLOAT', 'nbu_bsr_jobs', 'Show failed jobs for %customer% and %day%', '2017-03-22 15:15:19', '2017-03-23 14:55:32', NULL),
	('nbu_bsr_jobs', 1, 'masterserver', 'Master server', 'STRING', NULL, NULL, '2017-03-22 12:10:49', '2017-03-22 12:10:49', NULL),
	('nbu_bsr_jobs', 2, 'jobid', 'Job ID', 'NUMBER', NULL, NULL, '2017-03-22 12:10:49', '2017-03-22 12:10:49', NULL),
	('nbu_bsr_jobs', 3, 'childjobs', 'Childs', 'NUMBER', 'nbu_bsr_jobs', 'Show child jobs for %parentjob%', '2017-03-22 12:10:49', '2017-03-22 12:11:02', NULL),
	('nbu_bsr_jobs', 4, 'parentjob', 'Parent job', 'NUMBER', NULL, NULL, '2017-03-22 12:10:49', '2017-05-11 14:12:59', NULL),
	('nbu_bsr_jobs', 5, 'status', 'Status', 'STRING', 'nbu_codes', 'Show description for status \'%status%\'', '2017-03-22 12:10:49', '2017-05-12 13:17:47', NULL),
	('nbu_bsr_jobs', 6, 'tower', 'Tower', 'STRING', NULL, NULL, '2017-03-22 12:10:49', '2020-04-09 15:02:22', NULL),
	('nbu_bsr_jobs', 7, 'customer', 'Customer', 'STRING', NULL, NULL, '2017-03-22 12:10:49', '2017-05-11 14:26:46', NULL),
	('nbu_bsr_jobs', 8, 'policy', 'Policy name', 'STRING', 'nbu_policies', 'Show policy \'%policy%\'', '2017-03-22 12:10:49', '2017-05-11 14:21:12', NULL),
	('nbu_bsr_jobs', 9, 'policytype', 'P.type', 'STRING', NULL, NULL, '2017-03-22 12:10:49', '2017-05-11 14:27:23', NULL),
	('nbu_bsr_jobs', 10, 'schedule', 'Schedule', 'STRING', 'nbu_schedules', 'Show policy \'%policy%\' and \'%schedule%\'', '2017-03-22 12:10:49', '2017-05-11 14:21:18', NULL),
	('nbu_bsr_jobs', 11, 'scheduletype', 'S.type', 'STRING', NULL, NULL, '2017-03-22 12:10:49', '2017-05-11 14:27:26', NULL),
	('nbu_bsr_jobs', 12, 'client', 'Client name', 'STRING', NULL, NULL, '2017-03-22 12:10:49', '2018-08-30 14:23:56', NULL),
	('nbu_bsr_jobs', 13, 'server', 'Server', 'STRING', NULL, NULL, '2017-03-22 12:10:49', '2017-05-11 14:21:24', NULL),
	('nbu_bsr_jobs', 14, 'jobtype', 'Job type', 'STRING', NULL, NULL, '2017-03-22 12:10:49', '2017-05-11 14:21:26', NULL),
	('nbu_bsr_jobs', 15, 'subtype', 'Sub type', 'STRING', NULL, NULL, '2017-03-22 12:10:49', '2017-05-11 14:21:28', NULL),
	('nbu_bsr_jobs', 16, 'state', 'State', 'STRING', NULL, NULL, '2017-03-22 12:10:49', '2017-05-11 14:21:30', NULL),
	('nbu_bsr_jobs', 17, 'operation', 'Operation', 'STRING', NULL, NULL, '2017-03-22 12:10:49', '2017-05-11 14:21:32', NULL),
	('nbu_bsr_jobs', 18, 'percent', '%', 'NUMBER', NULL, NULL, '2017-03-22 12:10:49', '2017-05-11 14:21:37', NULL),
	('nbu_bsr_jobs', 19, 'bw_day', 'Backup day', 'DATE', NULL, NULL, '2017-03-22 12:10:49', '2018-08-13 10:53:55', NULL),
	('nbu_bsr_jobs', 19, 'started', 'Started', 'DATE', NULL, NULL, '2017-03-22 12:10:49', '2017-05-11 14:21:39', NULL),
	('nbu_bsr_jobs', 20, 'elapsed', 'Elapsed', 'STRING', NULL, NULL, '2017-03-22 12:10:49', '2017-10-18 11:12:24', NULL),
	('nbu_bsr_jobs', 21, 'ended', 'Ended', 'DATE', NULL, NULL, '2017-03-22 12:10:49', '2017-05-11 14:21:43', NULL),
	('nbu_bsr_jobs', 22, 'backupid', 'Backup ID', 'STRING', 'nbu_flist', 'Show objects for backup ID %backupid%', '2017-03-22 12:10:49', '2017-05-11 14:21:43', NULL),
	('nbu_bsr_jobs', 23, 'stunit', 'ST Unit', 'STRING', NULL, NULL, '2017-03-22 12:10:49', '2018-10-26 13:31:07', NULL),
	('nbu_bsr_jobs', 24, 'priority', 'Prio', 'NUMBER', NULL, NULL, '2017-03-22 12:10:49', '2018-10-26 13:31:09', NULL),
	('nbu_bsr_jobs', 25, 'tries', 'Tries', 'NUMBER', NULL, NULL, '2017-03-22 12:10:49', '2018-10-26 13:31:11', NULL),
	('nbu_bsr_jobs', 26, 'kbytes', 'kB', 'NUMBER', NULL, NULL, '2017-03-22 12:10:49', '2018-10-26 13:31:13', NULL),
	('nbu_bsr_jobs', 27, 'files', 'Files', 'NUMBER', NULL, NULL, '2017-03-22 12:10:49', '2018-10-26 13:31:15', NULL),
	('nbu_bsr_jobs', 28, 'owner', 'Owner', 'STRING', NULL, NULL, '2017-03-22 12:10:49', '2018-10-26 13:31:17', NULL),
	('nbu_bsr_jobs', 29, 'group', 'Group', 'STRING', NULL, NULL, '2017-03-22 12:10:49', '2018-10-26 13:31:19', NULL),
	('nbu_bsr_jobs', 30, 'retentionlevel', 'RL', 'NUMBER', NULL, NULL, '2017-03-22 12:10:49', '2018-10-26 13:31:22', NULL),
	('nbu_bsr_jobs', 31, 'retentionperiod', 'RP', 'NUMBER', NULL, NULL, '2017-03-22 12:10:49', '2018-10-26 13:31:25', NULL),
	('nbu_bsr_jobs', 32, 'restartable', 'Restart', 'NUMBER', NULL, NULL, '2017-03-22 12:10:49', '2018-10-26 13:31:26', NULL),
	('nbu_bsr_jobs', 33, 'kbpersec', 'kB/s', 'NUMBER', NULL, NULL, '2017-03-22 12:10:49', '2018-10-26 13:31:28', NULL),
	('nbu_bsr_job_results', 1, 'customer', 'Customer', 'STRING', NULL, NULL, '2018-04-27 14:24:06', '2018-04-27 14:26:21', NULL),
	('nbu_bsr_job_results', 2, 'client', 'Client name', 'STRING', NULL, NULL, '2018-04-27 14:24:18', '2018-04-27 14:26:03', NULL),
	('nbu_bsr_job_results', 3, 'policy', 'Policy name', 'STRING', NULL, NULL, '2018-04-27 14:24:26', '2018-04-27 14:26:18', NULL),
	('nbu_bsr_job_results', 4, 'schedule', 'Schedule', 'STRING', NULL, NULL, '2018-04-27 14:24:34', '2018-04-27 14:26:13', NULL),
	('nbu_bsr_job_results', 5, 'jobs', 'Jobs', 'NUMBER', NULL, NULL, '2018-04-27 14:24:42', '2018-04-27 14:26:28', NULL),
	('nbu_bsr_job_results', 6, 'bsr', 'BSR%', 'FLOAT', NULL, NULL, '2018-04-27 14:24:52', '2018-04-27 14:26:35', NULL),
	('nbu_bsr_job_results', 7, 'results', 'Results', 'STRING', NULL, NULL, '2018-04-27 14:25:01', '2018-04-27 14:26:42', NULL),
	('nbu_bsr_policy', 1, 'day', 'Backup day', 'DATE', NULL, NULL, '2017-03-22 15:15:29', '2018-08-13 10:54:28', NULL),
	('nbu_bsr_policy', 2, 'policy', 'Policy', 'STRING', NULL, NULL, '2017-03-22 15:15:29', '2017-03-22 15:18:37', NULL),
	('nbu_bsr_policy', 3, 'jobs', 'Jobs', 'NUMBER', 'nbu_bsr_jobs', 'Show jobs for %policy% and %day%', '2017-03-22 15:15:29', '2017-03-22 15:18:43', NULL),
	('nbu_bsr_policy', 4, 'bsr', 'BSR', 'FLOAT', 'nbu_bsr_jobs', 'Show failed jobs for %policy% and %day%', '2017-03-22 15:15:29', '2017-03-23 14:55:40', NULL),
	('nbu_bsr_schedule', 1, 'day', 'Backup day', 'DATE', NULL, NULL, '2017-03-22 15:15:36', '2018-08-13 10:54:30', NULL),
	('nbu_bsr_schedule', 2, 'schedule', 'Schedule', 'STRING', NULL, NULL, '2017-03-22 15:15:36', '2017-03-22 15:19:28', NULL),
	('nbu_bsr_schedule', 3, 'jobs', 'Jobs', 'NUMBER', 'nbu_bsr_jobs', 'Show jobs for %schedule% and %day%', '2017-03-22 15:15:36', '2017-03-22 15:19:06', NULL),
	('nbu_bsr_schedule', 4, 'bsr', 'BSR', 'FLOAT', 'nbu_bsr_jobs', 'Show failed jobs for %schedule% and %day%', '2017-03-22 15:15:36', '2017-03-23 14:55:43', NULL),
	('nbu_bsr_type', 1, 'day', 'Backup day', 'DATE', NULL, NULL, '2017-03-22 15:15:41', '2018-08-13 10:54:32', NULL),
	('nbu_bsr_type', 2, 'type', 'Type', 'STRING', NULL, NULL, '2017-03-22 15:15:41', '2017-03-22 15:19:21', NULL),
	('nbu_bsr_type', 3, 'jobs', 'Jobs', 'NUMBER', NULL, NULL, '2017-03-22 15:15:41', '2020-04-09 15:16:19', NULL),
	('nbu_bsr_type', 4, 'bsr', 'BSR', 'FLOAT', NULL, NULL, '2017-03-22 15:15:41', '2020-04-09 15:16:20', NULL),
	('nbu_bw_jobs', 1, 'bw_day', 'Backup day', 'DATE', NULL, NULL, '2020-04-08 17:45:39', '2020-04-09 13:11:22', NULL),
	('nbu_bw_jobs', 2, 'towers', 'Towers', 'NUMBER', 'nbu_bw_jobs_towers', 'Show %bw_day% jobs per tower', '2020-04-08 17:47:23', '2020-04-09 13:45:12', NULL),
	('nbu_bw_jobs', 3, 'customers', 'Customers', 'NUMBER', 'nbu_bw_jobs_customers', 'Show %bw_day% jobs per customer', '2020-04-08 17:47:36', '2020-04-09 13:45:25', NULL),
	('nbu_bw_jobs', 4, 'masterservers', 'Master servers', 'NUMBER', 'nbu_bw_jobs_masterservers', 'Show %bw_day% jobs per Master server', '2020-04-08 17:47:51', '2020-04-09 13:46:14', NULL),
	('nbu_bw_jobs', 5, 'policytypes', 'Policy types', 'NUMBER', 'nbu_bw_jobs_policytypes', 'Show %bw_day% jobs per policy type', '2020-04-08 17:48:31', '2020-04-09 13:45:41', NULL),
	('nbu_bw_jobs', 6, 'policies', 'Policies', 'NUMBER', 'nbu_bw_jobs_policies', 'Show %bw_day% jobs per policy', '2020-04-08 17:49:18', '2020-04-09 13:45:47', NULL),
	('nbu_bw_jobs', 7, 'scheduletypes', 'Schedule types', 'NUMBER', 'nbu_bw_jobs_scheduletypes', 'Show %bw_day% jobs per schedule type', '2020-04-08 17:49:35', '2020-04-09 13:45:55', NULL),
	('nbu_bw_jobs', 8, 'schedules', 'Schedules', 'NUMBER', 'nbu_bw_jobs_schedules', 'Show %bw_day% jobs per schedule', '2020-04-08 17:49:49', '2020-04-09 13:46:02', NULL),
	('nbu_bw_jobs', 9, 'clients', 'Clients', 'NUMBER', 'nbu_bw_jobs_clients', 'Show %bw_day% jobs per client', '2020-04-08 17:51:02', '2020-04-09 13:46:07', NULL),
	('nbu_bw_jobs', 10, 'jobs', 'Jobs', 'NUMBER', 'nbu_jobs', 'Show all jobs', '2020-04-08 17:52:02', '2020-04-09 13:30:31', NULL),
	('nbu_bw_jobs', 11, 'gb', 'Written (GB)', 'FLOAT', NULL, NULL, '2020-04-08 17:52:40', '2020-04-09 13:33:50', NULL),
	('nbu_bw_jobs', 12, 'in_bsr', 'Jobs in BSR', 'NUMBER', 'nbu_bsr_jobs', 'Show BSR jobs', '2020-04-08 17:52:59', '2020-04-09 13:27:40', NULL),
	('nbu_bw_jobs', 13, 'gb_in_bsr', 'Written (GB)', 'FLOAT', NULL, NULL, '2020-04-08 17:54:21', '2020-04-09 13:34:08', NULL),
	('nbu_bw_jobs', 14, 'bsr', 'BSR', 'FLOAT', 'nbu_bsr_jobs', 'Show failed BSR jobs', '2020-04-08 17:54:57', '2020-04-09 13:27:32', NULL),
	('nbu_bw_jobs_clients', 1, 'bw_day', 'Backup day', 'DATE', NULL, NULL, '2020-04-09 13:59:32', '2020-04-09 13:59:32', NULL),
	('nbu_bw_jobs_clients', 2, 'towers', 'Towers', 'NUMBER', 'nbu_bw_jobs_towers', 'Show %bw_day% jobs per tower', '2020-04-09 13:59:32', '2020-04-09 13:59:32', NULL),
	('nbu_bw_jobs_clients', 3, 'customers', 'Customers', 'NUMBER', 'nbu_bw_jobs_customers', 'Show %bw_day% jobs per customer', '2020-04-09 13:59:32', '2020-04-09 13:59:32', NULL),
	('nbu_bw_jobs_clients', 4, 'masterservers', 'Master servers', 'NUMBER', 'nbu_bw_jobs_masterservers', 'Show %bw_day% jobs per Master server', '2020-04-09 13:59:32', '2020-04-09 13:59:32', NULL),
	('nbu_bw_jobs_clients', 5, 'policytypes', 'Policy types', 'NUMBER', 'nbu_bw_jobs_policytypes', 'Show %bw_day% jobs per policy type', '2020-04-09 13:59:32', '2020-04-09 13:59:32', NULL),
	('nbu_bw_jobs_clients', 6, 'policies', 'Policies', 'NUMBER', 'nbu_bw_jobs_policies', 'Show %bw_day% jobs per policy', '2020-04-09 13:59:32', '2020-04-09 13:59:32', NULL),
	('nbu_bw_jobs_clients', 7, 'scheduletypes', 'Schedule types', 'NUMBER', 'nbu_bw_jobs_scheduletypes', 'Show %bw_day% jobs per schedule type', '2020-04-09 13:59:32', '2020-04-09 13:59:32', NULL),
	('nbu_bw_jobs_clients', 8, 'schedules', 'Schedules', 'NUMBER', 'nbu_bw_jobs_schedules', 'Show %bw_day% jobs per schedule', '2020-04-09 13:59:32', '2020-04-09 13:59:32', NULL),
	('nbu_bw_jobs_clients', 9, 'client', 'Client name', 'STRING', 'nbu_clients_distinct', 'Show client "%client%"', '2020-04-09 13:59:32', '2020-04-09 14:01:03', NULL),
	('nbu_bw_jobs_clients', 10, 'jobs', 'Jobs', 'NUMBER', 'nbu_jobs', 'Show all jobs', '2020-04-09 13:59:32', '2020-04-09 13:59:32', NULL),
	('nbu_bw_jobs_clients', 11, 'gb', 'Written (GB)', 'FLOAT', NULL, NULL, '2020-04-09 13:59:32', '2020-04-09 13:59:32', NULL),
	('nbu_bw_jobs_clients', 12, 'in_bsr', 'Jobs in BSR', 'NUMBER', 'nbu_bsr_jobs', 'Show BSR jobs', '2020-04-09 13:59:32', '2020-04-09 13:59:32', NULL),
	('nbu_bw_jobs_clients', 13, 'gb_in_bsr', 'Written (GB)', 'FLOAT', NULL, NULL, '2020-04-09 13:59:32', '2020-04-09 13:59:32', NULL),
	('nbu_bw_jobs_clients', 14, 'bsr', 'BSR', 'FLOAT', 'nbu_bsr_jobs', 'Show failed BSR jobs', '2020-04-09 13:59:32', '2020-04-09 13:59:32', NULL),
	('nbu_bw_jobs_customers', 1, 'bw_day', 'Backup day', 'DATE', NULL, NULL, '2020-04-09 13:58:46', '2020-04-09 13:58:46', NULL),
	('nbu_bw_jobs_customers', 2, 'towers', 'Towers', 'NUMBER', 'nbu_bw_jobs_towers', 'Show %bw_day% jobs per tower', '2020-04-09 13:58:46', '2020-04-09 13:58:46', NULL),
	('nbu_bw_jobs_customers', 3, 'customer', 'Customer', 'STRING', NULL, NULL, '2020-04-09 13:58:46', '2020-04-09 14:24:59', NULL),
	('nbu_bw_jobs_customers', 4, 'masterservers', 'Master servers', 'NUMBER', 'nbu_bw_jobs_masterservers', 'Show %bw_day% jobs per Master server', '2020-04-09 13:58:46', '2020-04-09 13:58:46', NULL),
	('nbu_bw_jobs_customers', 5, 'policytypes', 'Policy types', 'NUMBER', 'nbu_bw_jobs_policytypes', 'Show %bw_day% jobs per policy type', '2020-04-09 13:58:46', '2020-04-09 13:58:46', NULL),
	('nbu_bw_jobs_customers', 6, 'policies', 'Policies', 'NUMBER', 'nbu_bw_jobs_policies', 'Show %bw_day% jobs per policy', '2020-04-09 13:58:46', '2020-04-09 13:58:46', NULL),
	('nbu_bw_jobs_customers', 7, 'scheduletypes', 'Schedule types', 'NUMBER', 'nbu_bw_jobs_scheduletypes', 'Show %bw_day% jobs per schedule type', '2020-04-09 13:58:46', '2020-04-09 13:58:46', NULL),
	('nbu_bw_jobs_customers', 8, 'schedules', 'Schedules', 'NUMBER', 'nbu_bw_jobs_schedules', 'Show %bw_day% jobs per schedule', '2020-04-09 13:58:46', '2020-04-09 13:58:46', NULL),
	('nbu_bw_jobs_customers', 9, 'clients', 'Clients', 'NUMBER', 'nbu_bw_jobs_clients', 'Show %bw_day% jobs per client', '2020-04-09 13:58:46', '2020-04-09 13:58:46', NULL),
	('nbu_bw_jobs_customers', 10, 'jobs', 'Jobs', 'NUMBER', 'nbu_jobs', 'Show all jobs', '2020-04-09 13:58:46', '2020-04-09 13:58:46', NULL),
	('nbu_bw_jobs_customers', 11, 'gb', 'Written (GB)', 'FLOAT', NULL, NULL, '2020-04-09 13:58:46', '2020-04-09 13:58:46', NULL),
	('nbu_bw_jobs_customers', 12, 'in_bsr', 'Jobs in BSR', 'NUMBER', 'nbu_bsr_jobs', 'Show BSR jobs', '2020-04-09 13:58:46', '2020-04-09 13:58:46', NULL),
	('nbu_bw_jobs_customers', 13, 'gb_in_bsr', 'Written (GB)', 'FLOAT', NULL, NULL, '2020-04-09 13:58:46', '2020-04-09 13:58:46', NULL),
	('nbu_bw_jobs_customers', 14, 'bsr', 'BSR', 'FLOAT', 'nbu_bsr_jobs', 'Show failed BSR jobs', '2020-04-09 13:58:46', '2020-04-09 13:58:46', NULL),
	('nbu_bw_jobs_detail', 1, 'bw_day', 'Backup day', 'DATE', NULL, NULL, '2020-04-08 17:45:39', '2020-04-09 13:11:22', NULL),
	('nbu_bw_jobs_detail', 2, 'tower', 'Tower', 'STRING', NULL, NULL, '2020-04-08 17:47:23', '2020-04-09 13:11:25', NULL),
	('nbu_bw_jobs_detail', 3, 'customer', 'Customer', 'STRING', NULL, NULL, '2020-04-08 17:47:36', '2020-04-09 13:11:26', NULL),
	('nbu_bw_jobs_detail', 4, 'masterserver', 'Master server', 'STRING', NULL, NULL, '2020-04-08 17:47:51', '2020-04-09 13:22:29', NULL),
	('nbu_bw_jobs_detail', 5, 'policytype', 'Policy type', 'STRING', NULL, NULL, '2020-04-08 17:48:31', '2020-04-09 13:11:27', NULL),
	('nbu_bw_jobs_detail', 6, 'policy', 'Policy name', 'STRING', 'nbu_policies', 'Show policy "%policy%"', '2020-04-08 17:49:18', '2020-04-09 13:11:28', NULL),
	('nbu_bw_jobs_detail', 7, 'scheduletype', 'Schedule type', 'STRING', NULL, NULL, '2020-04-08 17:49:35', '2020-04-09 13:11:29', NULL),
	('nbu_bw_jobs_detail', 8, 'schedule', 'Schedule name', 'STRING', 'nbu_schedules', 'Show schedule "%schedule%"', '2020-04-08 17:49:49', '2020-04-09 13:11:30', NULL),
	('nbu_bw_jobs_detail', 9, 'client', 'Client name', 'STRING', 'nbu_clients_distinct', 'Show client "%client%"', '2020-04-08 17:51:02', '2020-04-09 13:11:31', NULL),
	('nbu_bw_jobs_detail', 10, 'jobs', 'Jobs', 'NUMBER', 'nbu_jobs', 'Show all jobs', '2020-04-08 17:52:02', '2020-04-09 13:27:50', NULL),
	('nbu_bw_jobs_detail', 11, 'gb', 'Written (GB)', 'FLOAT', NULL, NULL, '2020-04-08 17:52:40', '2020-04-09 13:33:46', NULL),
	('nbu_bw_jobs_detail', 12, 'in_bsr', 'Jobs in BSR', 'NUMBER', 'nbu_bsr_jobs', 'Show BSR jobs', '2020-04-08 17:52:59', '2020-04-09 13:31:07', NULL),
	('nbu_bw_jobs_detail', 13, 'gb_in_bsr', 'Written (GB)', 'FLOAT', NULL, NULL, '2020-04-08 17:54:21', '2020-04-09 13:34:05', NULL),
	('nbu_bw_jobs_detail', 14, 'bsr', 'BSR', 'FLOAT', 'nbu_bsr_jobs', 'Show failed BSR jobs', '2020-04-08 17:54:57', '2020-04-09 13:31:35', NULL),
	('nbu_bw_jobs_masterservers', 1, 'bw_day', 'Backup day', 'DATE', NULL, NULL, '2020-04-09 13:58:56', '2020-04-09 13:58:56', NULL),
	('nbu_bw_jobs_masterservers', 2, 'towers', 'Towers', 'NUMBER', 'nbu_bw_jobs_towers', 'Show %bw_day% jobs per tower', '2020-04-09 13:58:56', '2020-04-09 13:58:56', NULL),
	('nbu_bw_jobs_masterservers', 3, 'customers', 'Customers', 'NUMBER', 'nbu_bw_jobs_customers', 'Show %bw_day% jobs per customer', '2020-04-09 13:58:56', '2020-04-09 13:58:56', NULL),
	('nbu_bw_jobs_masterservers', 4, 'masterserver', 'Master server', 'STRING', NULL, NULL, '2020-04-09 13:58:56', '2020-04-09 14:02:04', NULL),
	('nbu_bw_jobs_masterservers', 5, 'policytypes', 'Policy types', 'NUMBER', 'nbu_bw_jobs_policytypes', 'Show %bw_day% jobs per policy type', '2020-04-09 13:58:56', '2020-04-09 13:58:56', NULL),
	('nbu_bw_jobs_masterservers', 6, 'policies', 'Policies', 'NUMBER', 'nbu_bw_jobs_policies', 'Show %bw_day% jobs per policy', '2020-04-09 13:58:56', '2020-04-09 13:58:56', NULL),
	('nbu_bw_jobs_masterservers', 7, 'scheduletypes', 'Schedule types', 'NUMBER', 'nbu_bw_jobs_scheduletypes', 'Show %bw_day% jobs per schedule type', '2020-04-09 13:58:56', '2020-04-09 13:58:56', NULL),
	('nbu_bw_jobs_masterservers', 8, 'schedules', 'Schedules', 'NUMBER', 'nbu_bw_jobs_schedules', 'Show %bw_day% jobs per schedule', '2020-04-09 13:58:56', '2020-04-09 13:58:56', NULL),
	('nbu_bw_jobs_masterservers', 9, 'clients', 'Clients', 'NUMBER', 'nbu_bw_jobs_clients', 'Show %bw_day% jobs per client', '2020-04-09 13:58:56', '2020-04-09 13:58:56', NULL),
	('nbu_bw_jobs_masterservers', 10, 'jobs', 'Jobs', 'NUMBER', 'nbu_jobs', 'Show all jobs', '2020-04-09 13:58:56', '2020-04-09 13:58:56', NULL),
	('nbu_bw_jobs_masterservers', 11, 'gb', 'Written (GB)', 'FLOAT', NULL, NULL, '2020-04-09 13:58:56', '2020-04-09 13:58:56', NULL),
	('nbu_bw_jobs_masterservers', 12, 'in_bsr', 'Jobs in BSR', 'NUMBER', 'nbu_bsr_jobs', 'Show BSR jobs', '2020-04-09 13:58:56', '2020-04-09 13:58:56', NULL),
	('nbu_bw_jobs_masterservers', 13, 'gb_in_bsr', 'Written (GB)', 'FLOAT', NULL, NULL, '2020-04-09 13:58:56', '2020-04-09 13:58:56', NULL),
	('nbu_bw_jobs_masterservers', 14, 'bsr', 'BSR', 'FLOAT', 'nbu_bsr_jobs', 'Show failed BSR jobs', '2020-04-09 13:58:56', '2020-04-09 13:58:56', NULL),
	('nbu_bw_jobs_policies', 1, 'bw_day', 'Backup day', 'DATE', NULL, NULL, '2020-04-09 13:59:11', '2020-04-09 13:59:11', NULL),
	('nbu_bw_jobs_policies', 2, 'towers', 'Towers', 'NUMBER', 'nbu_bw_jobs_towers', 'Show %bw_day% jobs per tower', '2020-04-09 13:59:11', '2020-04-09 13:59:11', NULL),
	('nbu_bw_jobs_policies', 3, 'customers', 'Customers', 'NUMBER', 'nbu_bw_jobs_customers', 'Show %bw_day% jobs per customer', '2020-04-09 13:59:11', '2020-04-09 13:59:11', NULL),
	('nbu_bw_jobs_policies', 4, 'masterservers', 'Master servers', 'NUMBER', 'nbu_bw_jobs_masterservers', 'Show %bw_day% jobs per Master server', '2020-04-09 13:59:11', '2020-04-09 13:59:11', NULL),
	('nbu_bw_jobs_policies', 5, 'policytypes', 'Policy types', 'NUMBER', 'nbu_bw_jobs_policytypes', 'Show %bw_day% jobs per policy type', '2020-04-09 13:59:11', '2020-04-09 13:59:11', NULL),
	('nbu_bw_jobs_policies', 6, 'policy', 'Policy name', 'STRING', 'nbu_policies', 'Show policy "%policy%"', '2020-04-09 13:59:11', '2020-04-09 14:11:29', NULL),
	('nbu_bw_jobs_policies', 7, 'scheduletypes', 'Schedule types', 'NUMBER', 'nbu_bw_jobs_scheduletypes', 'Show %bw_day% jobs per schedule type', '2020-04-09 13:59:11', '2020-04-09 13:59:11', NULL),
	('nbu_bw_jobs_policies', 8, 'schedules', 'Schedules', 'NUMBER', 'nbu_bw_jobs_schedules', 'Show %bw_day% jobs per schedule', '2020-04-09 13:59:11', '2020-04-09 13:59:11', NULL),
	('nbu_bw_jobs_policies', 9, 'clients', 'Clients', 'NUMBER', 'nbu_bw_jobs_clients', 'Show %bw_day% jobs per client', '2020-04-09 13:59:11', '2020-04-09 13:59:11', NULL),
	('nbu_bw_jobs_policies', 10, 'jobs', 'Jobs', 'NUMBER', 'nbu_jobs', 'Show all jobs', '2020-04-09 13:59:11', '2020-04-09 13:59:11', NULL),
	('nbu_bw_jobs_policies', 11, 'gb', 'Written (GB)', 'FLOAT', NULL, NULL, '2020-04-09 13:59:11', '2020-04-09 13:59:11', NULL),
	('nbu_bw_jobs_policies', 12, 'in_bsr', 'Jobs in BSR', 'NUMBER', 'nbu_bsr_jobs', 'Show BSR jobs', '2020-04-09 13:59:11', '2020-04-09 13:59:11', NULL),
	('nbu_bw_jobs_policies', 13, 'gb_in_bsr', 'Written (GB)', 'FLOAT', NULL, NULL, '2020-04-09 13:59:11', '2020-04-09 13:59:11', NULL),
	('nbu_bw_jobs_policies', 14, 'bsr', 'BSR', 'FLOAT', 'nbu_bsr_jobs', 'Show failed BSR jobs', '2020-04-09 13:59:11', '2020-04-09 13:59:11', NULL),
	('nbu_bw_jobs_policytypes', 1, 'bw_day', 'Backup day', 'DATE', NULL, NULL, '2020-04-09 13:59:05', '2020-04-09 13:59:05', NULL),
	('nbu_bw_jobs_policytypes', 2, 'towers', 'Towers', 'NUMBER', 'nbu_bw_jobs_towers', 'Show %bw_day% jobs per tower', '2020-04-09 13:59:05', '2020-04-09 13:59:05', NULL),
	('nbu_bw_jobs_policytypes', 3, 'customers', 'Customers', 'NUMBER', 'nbu_bw_jobs_customers', 'Show %bw_day% jobs per customer', '2020-04-09 13:59:05', '2020-04-09 13:59:05', NULL),
	('nbu_bw_jobs_policytypes', 4, 'masterservers', 'Master servers', 'NUMBER', 'nbu_bw_jobs_masterservers', 'Show %bw_day% jobs per Master server', '2020-04-09 13:59:05', '2020-04-09 13:59:05', NULL),
	('nbu_bw_jobs_policytypes', 5, 'policytype', 'Policy type', 'STRING', NULL, NULL, '2020-04-09 13:59:05', '2020-04-09 14:03:33', NULL),
	('nbu_bw_jobs_policytypes', 6, 'policies', 'Policies', 'NUMBER', 'nbu_bw_jobs_policies', 'Show %bw_day% jobs per policy', '2020-04-09 13:59:05', '2020-04-09 13:59:05', NULL),
	('nbu_bw_jobs_policytypes', 7, 'scheduletypes', 'Schedule types', 'NUMBER', 'nbu_bw_jobs_scheduletypes', 'Show %bw_day% jobs per schedule type', '2020-04-09 13:59:05', '2020-04-09 13:59:05', NULL),
	('nbu_bw_jobs_policytypes', 8, 'schedules', 'Schedules', 'NUMBER', 'nbu_bw_jobs_schedules', 'Show %bw_day% jobs per schedule', '2020-04-09 13:59:05', '2020-04-09 13:59:05', NULL),
	('nbu_bw_jobs_policytypes', 9, 'clients', 'Clients', 'NUMBER', 'nbu_bw_jobs_clients', 'Show %bw_day% jobs per client', '2020-04-09 13:59:05', '2020-04-09 13:59:05', NULL),
	('nbu_bw_jobs_policytypes', 10, 'jobs', 'Jobs', 'NUMBER', 'nbu_jobs', 'Show all jobs', '2020-04-09 13:59:05', '2020-04-09 13:59:05', NULL),
	('nbu_bw_jobs_policytypes', 11, 'gb', 'Written (GB)', 'FLOAT', NULL, NULL, '2020-04-09 13:59:05', '2020-04-09 13:59:05', NULL),
	('nbu_bw_jobs_policytypes', 12, 'in_bsr', 'Jobs in BSR', 'NUMBER', 'nbu_bsr_jobs', 'Show BSR jobs', '2020-04-09 13:59:05', '2020-04-09 13:59:05', NULL),
	('nbu_bw_jobs_policytypes', 13, 'gb_in_bsr', 'Written (GB)', 'FLOAT', NULL, NULL, '2020-04-09 13:59:05', '2020-04-09 13:59:05', NULL),
	('nbu_bw_jobs_policytypes', 14, 'bsr', 'BSR', 'FLOAT', 'nbu_bsr_jobs', 'Show failed BSR jobs', '2020-04-09 13:59:05', '2020-04-09 13:59:05', NULL),
	('nbu_bw_jobs_schedules', 1, 'bw_day', 'Backup day', 'DATE', NULL, NULL, '2020-04-09 13:59:26', '2020-04-09 13:59:26', NULL),
	('nbu_bw_jobs_schedules', 2, 'towers', 'Towers', 'NUMBER', 'nbu_bw_jobs_towers', 'Show %bw_day% jobs per tower', '2020-04-09 13:59:26', '2020-04-09 13:59:26', NULL),
	('nbu_bw_jobs_schedules', 3, 'customers', 'Customers', 'NUMBER', 'nbu_bw_jobs_customers', 'Show %bw_day% jobs per customer', '2020-04-09 13:59:26', '2020-04-09 13:59:26', NULL),
	('nbu_bw_jobs_schedules', 4, 'masterservers', 'Master servers', 'NUMBER', 'nbu_bw_jobs_masterservers', 'Show %bw_day% jobs per Master server', '2020-04-09 13:59:26', '2020-04-09 13:59:26', NULL),
	('nbu_bw_jobs_schedules', 5, 'policytypes', 'Policy types', 'NUMBER', 'nbu_bw_jobs_policytypes', 'Show %bw_day% jobs per policy type', '2020-04-09 13:59:26', '2020-04-09 13:59:26', NULL),
	('nbu_bw_jobs_schedules', 6, 'policies', 'Policies', 'NUMBER', 'nbu_bw_jobs_policies', 'Show %bw_day% jobs per policy', '2020-04-09 13:59:26', '2020-04-09 13:59:26', NULL),
	('nbu_bw_jobs_schedules', 7, 'scheduletypes', 'Schedule types', 'NUMBER', 'nbu_bw_jobs_scheduletypes', 'Show %bw_day% jobs per schedule type', '2020-04-09 13:59:26', '2020-04-09 13:59:26', NULL),
	('nbu_bw_jobs_schedules', 8, 'schedule', 'Schedule name', 'STRING', 'nbu_schedules', 'Show schedule "%schedule%"', '2020-04-09 13:59:26', '2020-04-09 14:06:15', NULL),
	('nbu_bw_jobs_schedules', 9, 'clients', 'Clients', 'NUMBER', 'nbu_bw_jobs_clients', 'Show %bw_day% jobs per client', '2020-04-09 13:59:26', '2020-04-09 13:59:26', NULL),
	('nbu_bw_jobs_schedules', 10, 'jobs', 'Jobs', 'NUMBER', 'nbu_jobs', 'Show all jobs', '2020-04-09 13:59:26', '2020-04-09 13:59:26', NULL),
	('nbu_bw_jobs_schedules', 11, 'gb', 'Written (GB)', 'FLOAT', NULL, NULL, '2020-04-09 13:59:26', '2020-04-09 13:59:26', NULL),
	('nbu_bw_jobs_schedules', 12, 'in_bsr', 'Jobs in BSR', 'NUMBER', 'nbu_bsr_jobs', 'Show BSR jobs', '2020-04-09 13:59:26', '2020-04-09 13:59:26', NULL),
	('nbu_bw_jobs_schedules', 13, 'gb_in_bsr', 'Written (GB)', 'FLOAT', NULL, NULL, '2020-04-09 13:59:26', '2020-04-09 13:59:26', NULL),
	('nbu_bw_jobs_schedules', 14, 'bsr', 'BSR', 'FLOAT', 'nbu_bsr_jobs', 'Show failed BSR jobs', '2020-04-09 13:59:26', '2020-04-09 13:59:26', NULL),
	('nbu_bw_jobs_scheduletypes', 1, 'bw_day', 'Backup day', 'DATE', NULL, NULL, '2020-04-09 13:59:21', '2020-04-09 13:59:21', NULL),
	('nbu_bw_jobs_scheduletypes', 2, 'towers', 'Towers', 'NUMBER', 'nbu_bw_jobs_towers', 'Show %bw_day% jobs per tower', '2020-04-09 13:59:21', '2020-04-09 13:59:21', NULL),
	('nbu_bw_jobs_scheduletypes', 3, 'customers', 'Customers', 'NUMBER', 'nbu_bw_jobs_customers', 'Show %bw_day% jobs per customer', '2020-04-09 13:59:21', '2020-04-09 13:59:21', NULL),
	('nbu_bw_jobs_scheduletypes', 4, 'masterservers', 'Master servers', 'NUMBER', 'nbu_bw_jobs_masterservers', 'Show %bw_day% jobs per Master server', '2020-04-09 13:59:21', '2020-04-09 13:59:21', NULL),
	('nbu_bw_jobs_scheduletypes', 5, 'policytypes', 'Policy types', 'NUMBER', 'nbu_bw_jobs_policytypes', 'Show %bw_day% jobs per policy type', '2020-04-09 13:59:21', '2020-04-09 13:59:21', NULL),
	('nbu_bw_jobs_scheduletypes', 6, 'policies', 'Policies', 'NUMBER', 'nbu_bw_jobs_policies', 'Show %bw_day% jobs per policy', '2020-04-09 13:59:21', '2020-04-09 13:59:21', NULL),
	('nbu_bw_jobs_scheduletypes', 7, 'scheduletype', 'Schedule type', 'STRING', NULL, NULL, '2020-04-09 13:59:21', '2020-04-09 14:06:27', NULL),
	('nbu_bw_jobs_scheduletypes', 8, 'schedules', 'Schedules', 'NUMBER', 'nbu_bw_jobs_schedules', 'Show %bw_day% jobs per schedule', '2020-04-09 13:59:21', '2020-04-09 13:59:21', NULL),
	('nbu_bw_jobs_scheduletypes', 9, 'clients', 'Clients', 'NUMBER', 'nbu_bw_jobs_clients', 'Show %bw_day% jobs per client', '2020-04-09 13:59:21', '2020-04-09 13:59:21', NULL),
	('nbu_bw_jobs_scheduletypes', 10, 'jobs', 'Jobs', 'NUMBER', 'nbu_jobs', 'Show all jobs', '2020-04-09 13:59:21', '2020-04-09 13:59:21', NULL),
	('nbu_bw_jobs_scheduletypes', 11, 'gb', 'Written (GB)', 'FLOAT', NULL, NULL, '2020-04-09 13:59:21', '2020-04-09 13:59:21', NULL),
	('nbu_bw_jobs_scheduletypes', 12, 'in_bsr', 'Jobs in BSR', 'NUMBER', 'nbu_bsr_jobs', 'Show BSR jobs', '2020-04-09 13:59:21', '2020-04-09 13:59:21', NULL),
	('nbu_bw_jobs_scheduletypes', 13, 'gb_in_bsr', 'Written (GB)', 'FLOAT', NULL, NULL, '2020-04-09 13:59:21', '2020-04-09 13:59:21', NULL),
	('nbu_bw_jobs_scheduletypes', 14, 'bsr', 'BSR', 'FLOAT', 'nbu_bsr_jobs', 'Show failed BSR jobs', '2020-04-09 13:59:21', '2020-04-09 13:59:21', NULL),
	('nbu_bw_jobs_towers', 1, 'bw_day', 'Backup day', 'DATE', NULL, NULL, '2020-04-09 13:58:37', '2020-04-09 13:58:37', NULL),
	('nbu_bw_jobs_towers', 2, 'tower', 'Tower', 'STRING', NULL, NULL, '2020-04-09 13:58:37', '2020-04-09 14:06:46', NULL),
	('nbu_bw_jobs_towers', 3, 'customers', 'Customers', 'NUMBER', 'nbu_bw_jobs_customers', 'Show %bw_day% jobs per customer', '2020-04-09 13:58:37', '2020-04-09 13:58:37', NULL),
	('nbu_bw_jobs_towers', 4, 'masterservers', 'Master servers', 'NUMBER', 'nbu_bw_jobs_masterservers', 'Show %bw_day% jobs per Master server', '2020-04-09 13:58:37', '2020-04-09 13:58:37', NULL),
	('nbu_bw_jobs_towers', 5, 'policytypes', 'Policy types', 'NUMBER', 'nbu_bw_jobs_policytypes', 'Show %bw_day% jobs per policy type', '2020-04-09 13:58:37', '2020-04-09 13:58:37', NULL),
	('nbu_bw_jobs_towers', 6, 'policies', 'Policies', 'NUMBER', 'nbu_bw_jobs_policies', 'Show %bw_day% jobs per policy', '2020-04-09 13:58:37', '2020-04-09 13:58:37', NULL),
	('nbu_bw_jobs_towers', 7, 'scheduletypes', 'Schedule types', 'NUMBER', 'nbu_bw_jobs_scheduletypes', 'Show %bw_day% jobs per schedule type', '2020-04-09 13:58:37', '2020-04-09 13:58:37', NULL),
	('nbu_bw_jobs_towers', 8, 'schedules', 'Schedules', 'NUMBER', 'nbu_bw_jobs_schedules', 'Show %bw_day% jobs per schedule', '2020-04-09 13:58:37', '2020-04-09 13:58:37', NULL),
	('nbu_bw_jobs_towers', 9, 'clients', 'Clients', 'NUMBER', 'nbu_bw_jobs_clients', 'Show %bw_day% jobs per client', '2020-04-09 13:58:37', '2020-04-09 13:58:37', NULL),
	('nbu_bw_jobs_towers', 10, 'jobs', 'Jobs', 'NUMBER', 'nbu_jobs', 'Show all jobs', '2020-04-09 13:58:37', '2020-04-09 13:58:37', NULL),
	('nbu_bw_jobs_towers', 11, 'gb', 'Written (GB)', 'FLOAT', NULL, NULL, '2020-04-09 13:58:37', '2020-04-09 13:58:37', NULL),
	('nbu_bw_jobs_towers', 12, 'in_bsr', 'Jobs in BSR', 'NUMBER', 'nbu_bsr_jobs', 'Show BSR jobs', '2020-04-09 13:58:37', '2020-04-09 13:58:37', NULL),
	('nbu_bw_jobs_towers', 13, 'gb_in_bsr', 'Written (GB)', 'FLOAT', NULL, NULL, '2020-04-09 13:58:37', '2020-04-09 13:58:37', NULL),
	('nbu_bw_jobs_towers', 14, 'bsr', 'BSR', 'FLOAT', 'nbu_bsr_jobs', 'Show failed BSR jobs', '2020-04-09 13:58:37', '2020-04-09 13:58:37', NULL),
	('nbu_clients', 1, 'masterserver', 'Master server', 'STRING', NULL, NULL, '2017-02-13 10:20:30', '2017-02-13 10:40:30', NULL),
	('nbu_clients', 2, 'tower', 'Tower', 'STRING', NULL, NULL, '2017-02-13 10:24:08', '2017-04-27 13:39:54', NULL),
	('nbu_clients', 3, 'customer', 'Customer', 'STRING', NULL, NULL, '2017-02-13 10:24:08', '2017-04-27 13:39:54', NULL),
	('nbu_clients', 4, 'policyname', 'Policy name', 'STRING', NULL, NULL, '2017-02-13 10:24:44', '2020-06-02 13:45:09', NULL),
	('nbu_clients', 5, 'type', 'Type', 'STRING', NULL, NULL, '2017-02-13 10:24:44', '2017-12-15 10:17:00', NULL),
	('nbu_clients', 6, 'name', 'Host name', 'STRING', NULL, NULL, '2017-02-13 10:25:07', '2017-06-13 09:42:14', NULL),
	('nbu_clients', 7, 'architecture', 'Architecture', 'STRING', NULL, NULL, '2017-02-13 10:25:40', '2017-06-13 09:42:15', NULL),
	('nbu_clients', 8, 'os', 'OS', 'STRING', NULL, NULL, '2017-02-13 10:25:49', '2017-06-13 09:42:18', NULL),
	('nbu_clients', 9, 'jobs', 'Jobs', 'NUMBER', 'nbu_jobs', 'Show jobs for \'%policyname%\' and \'%name%\'', '2017-02-13 10:25:49', '2017-04-27 13:39:37', NULL),
	('nbu_clients', 10, 'failures', 'Failures', 'NUMBER', 'nbu_jobs', 'Show failed jobs for \'%policyname%\' and \'%name%\'', '2017-02-13 10:25:49', '2017-04-27 13:39:35', NULL),
	('nbu_clients', 11, 'gbytes', 'Written (GB)', 'FLOAT', NULL, NULL, '2017-02-13 10:25:49', '2017-06-13 14:39:08', NULL),
	('nbu_clients', 12, 'last_day', 'Last day', 'DATE', NULL, NULL, '2017-02-13 10:25:49', '2017-06-13 14:39:08', NULL),
	('nbu_clients_distinct', 1, 'masterserver', 'Master server', 'STRING', NULL, NULL, '2017-02-13 10:20:30', '2017-02-13 10:40:30', NULL),
	('nbu_clients_distinct', 2, 'tower', 'Tower', 'STRING', NULL, NULL, '2017-02-13 10:24:08', '2017-04-27 13:39:54', NULL),
	('nbu_clients_distinct', 3, 'customer', 'Customer', 'STRING', NULL, NULL, '2017-02-13 10:24:08', '2017-04-27 13:39:54', NULL),
	('nbu_clients_distinct', 4, 'type', 'Type', 'STRING', NULL, NULL, '2017-02-13 10:24:44', '2017-12-15 10:17:06', NULL),
	('nbu_clients_distinct', 5, 'name', 'Host name', 'STRING', NULL, NULL, '2017-02-13 10:25:07', '2017-06-13 09:42:14', NULL),
	('nbu_clients_distinct', 6, 'architecture', 'Architecture', 'STRING', NULL, NULL, '2017-02-13 10:25:40', '2017-12-15 10:05:44', NULL),
	('nbu_clients_distinct', 7, 'os', 'OS', 'STRING', NULL, NULL, '2017-02-13 10:25:49', '2017-06-13 09:42:18', NULL),
	('nbu_clients_distinct', 8, 'jobs', 'Jobs', 'NUMBER', 'nbu_jobs', 'Show jobs for \'%name%\'', '2017-02-13 10:25:49', '2017-12-15 10:13:16', NULL),
	('nbu_clients_distinct', 9, 'failures', 'Failures', 'NUMBER', 'nbu_jobs', 'Show failed jobs for \'%name%\'', '2017-02-13 10:25:49', '2017-12-15 10:13:23', NULL),
	('nbu_clients_distinct', 10, 'gbytes', 'Written (GB)', 'FLOAT', NULL, NULL, '2017-02-13 10:25:49', '2017-06-13 14:39:08', NULL),
	('nbu_clients_distinct', 11, 'last_day', 'Last day', 'DATE', NULL, NULL, '2017-02-13 10:25:49', '2017-06-13 14:39:08', NULL),
	('nbu_codes', 1, 'field', 'Field name', 'STRING', NULL, NULL, '2017-05-12 13:07:33', '2017-05-12 13:08:38', NULL),
	('nbu_codes', 2, 'code', 'Code', 'NUMBER', NULL, NULL, '2017-05-12 13:07:33', '2017-05-12 13:17:18', NULL),
	('nbu_codes', 3, 'description', 'Description', 'STRING', NULL, NULL, '2017-05-12 13:07:33', '2017-05-12 13:17:21', NULL),
	('nbu_consecutive_failures', 1, 'masterserver', 'Master server', 'STRING', NULL, NULL, '2017-08-31 15:36:06', '2017-08-31 15:36:06', NULL),
	('nbu_consecutive_failures', 2, 'tower', 'Tower', 'STRING', NULL, NULL, '2017-08-31 15:36:06', '2017-08-31 15:36:06', NULL),
	('nbu_consecutive_failures', 3, 'customer', 'Customer', 'STRING', NULL, NULL, '2017-08-31 15:36:06', '2017-08-31 15:36:06', NULL),
	('nbu_consecutive_failures', 4, 'client', 'Client name', 'STRING', NULL, NULL, '2017-08-31 15:37:20', '2018-08-30 14:24:28', NULL),
	('nbu_consecutive_failures', 5, 'policy', 'Policy', 'STRING', NULL, NULL, '2017-08-31 15:37:30', '2017-10-18 13:02:16', NULL),
	('nbu_consecutive_failures', 6, 'existing', 'Exists', 'STRING', NULL, NULL, '2017-08-31 15:37:20', '2017-10-18 13:02:15', NULL),
	('nbu_consecutive_failures', 7, 'schedule', 'Schedule', 'STRING', NULL, NULL, '2017-08-31 15:37:38', '2017-10-18 12:58:37', NULL),
	('nbu_consecutive_failures', 8, 'lastfailure', 'Last failure', 'DATE', NULL, NULL, '2017-08-31 15:37:38', '2017-10-18 12:58:37', NULL),
	('nbu_consecutive_failures', 9, 'failures', 'Failures', 'NUMBER', 'nbu_jobs', 'Show failed jobs', '2017-08-31 15:38:29', '2017-10-18 12:59:48', NULL),
	('nbu_flist', 1, 'masterserver', 'Master server', 'STRING', NULL, NULL, '2018-10-26 13:05:26', '2018-10-26 13:05:26', NULL),
	('nbu_flist', 2, 'tower', 'Tower', 'STRING', NULL, NULL, '2018-10-26 13:06:11', '2018-10-26 13:06:11', NULL),
	('nbu_flist', 3, 'customer', 'Customer', 'STRING', NULL, NULL, '2018-10-26 13:06:25', '2018-10-26 13:06:25', NULL),
	('nbu_flist', 4, 'policy', 'Policy name', 'STRING', NULL, NULL, '2018-10-26 13:07:32', '2019-04-01 13:22:35', NULL),
	('nbu_flist', 5, 'policytype', 'Policy type', 'STRING', NULL, NULL, '2018-10-26 13:07:48', '2019-04-01 13:22:37', NULL),
	('nbu_flist', 6, 'schedule', 'Schedule name', 'STRING', NULL, NULL, '2018-10-26 13:08:07', '2019-04-01 13:22:40', NULL),
	('nbu_flist', 7, 'scheduletype', 'Schedule type', 'STRING', NULL, NULL, '2018-10-26 13:08:44', '2019-04-01 13:22:42', NULL),
	('nbu_flist', 8, 'client', 'Client name', 'STRING', NULL, NULL, '2018-10-26 13:06:48', '2019-04-01 13:22:50', NULL),
	('nbu_flist', 9, 'path', 'Object name', 'STRING', NULL, NULL, '2018-10-26 13:07:03', '2019-04-01 13:22:52', NULL),
	('nbu_flist', 10, 'jobid', 'Job ID', 'NUMBER', NULL, NULL, '2018-10-26 13:09:34', '2019-04-01 13:27:58', NULL),
	('nbu_flist', 11, 'parentjob', 'Parent job', 'NUMBER', NULL, NULL, '2018-10-26 13:09:57', '2019-04-01 13:28:02', NULL),
	('nbu_flist', 12, 'jobtype', 'Job type', 'STRING', NULL, NULL, '2018-10-26 13:09:57', '2019-04-01 13:25:18', NULL),
	('nbu_flist', 13, 'subtype', 'Sub type', 'STRING', NULL, NULL, '2018-10-26 13:09:57', '2019-04-01 13:25:18', NULL),
	('nbu_flist', 14, 'state', 'State', 'STRING', NULL, NULL, '2018-10-26 13:09:57', '2019-04-01 13:25:18', NULL),
	('nbu_flist', 15, 'status', 'Status', 'NUMBER', NULL, NULL, '2018-10-26 13:09:57', '2019-04-01 13:25:18', NULL),
	('nbu_flist', 16, 'tries', 'Tries', 'NUMBER', NULL, NULL, '2018-10-26 13:09:57', '2019-04-01 13:25:18', NULL),
	('nbu_flist', 17, 'bsr', 'BSR', 'NUMBER', NULL, NULL, '2018-10-26 13:09:57', '2019-04-01 13:25:18', NULL),
	('nbu_flist', 18, 'bw_day', 'Backup day', 'DATE', NULL, NULL, '2018-10-26 13:10:45', '2019-04-01 13:29:11', NULL),
	('nbu_flist', 19, 'started', 'Started', 'DATE', NULL, NULL, '2018-10-26 13:10:45', '2019-04-01 13:31:17', NULL),
	('nbu_flist', 20, 'elapsed', 'Elapsed', 'TIME', NULL, NULL, '2018-10-26 13:10:55', '2019-04-01 13:31:26', NULL),
	('nbu_flist', 21, 'ended', 'Ended', 'DATE', NULL, NULL, '2018-10-26 13:11:08', '2019-04-01 13:31:30', NULL),
	('nbu_flist', 22, 'gbytes', 'Written (GB)', 'FLOAT', NULL, NULL, '2018-10-26 13:08:30', '2019-04-01 13:33:19', NULL),
	('nbu_flist', 23, 'timestamp', 'Timestamp', 'DATE', NULL, NULL, '2018-10-26 13:08:30', '2019-04-01 13:24:30', NULL),
	('nbu_flist', 24, 'retentionperiod', 'Retention', 'NUMBER', NULL, NULL, '2018-10-26 13:08:30', '2019-04-01 13:33:19', NULL),
	('nbu_flist', 25, 'backupid', 'Backup ID', 'STRING', NULL, NULL, '2018-10-26 13:08:30', '2019-04-01 13:33:19', NULL),
	('nbu_gbsr', 1, 'jobs', 'Jobs', 'NUMBER', 'nbu_bsr_jobs', 'Show jobs', '2017-03-22 12:21:26', '2017-04-12 15:11:30', NULL),
	('nbu_gbsr', 2, 'bsr', 'BSR', 'FLOAT', 'nbu_bsr_jobs', 'Show failed jobs', '2017-03-22 12:21:37', '2017-04-12 15:11:34', NULL),
	('nbu_gbsr_client', 1, 'client', 'Client name', 'STRING', NULL, NULL, '2017-03-22 15:08:37', '2017-03-22 15:17:53', NULL),
	('nbu_gbsr_client', 2, 'jobs', 'Jobs', 'NUMBER', 'nbu_bsr_jobs', 'Show jobs for %client%', '2017-03-22 15:08:20', '2017-03-22 15:09:52', NULL),
	('nbu_gbsr_client', 3, 'bsr', 'BSR', 'FLOAT', 'nbu_bsr_jobs', 'Show failed jobs for %client%', '2017-03-22 15:08:20', '2018-01-04 10:45:20', NULL),
	('nbu_gbsr_customer', 1, 'customer', 'Customer', 'STRING', NULL, NULL, '2017-03-22 15:15:19', '2017-03-22 15:17:39', NULL),
	('nbu_gbsr_customer', 2, 'jobs', 'Jobs', 'NUMBER', 'nbu_bsr_jobs', 'Show jobs for %customer%', '2017-03-22 15:15:19', '2017-03-22 15:18:08', NULL),
	('nbu_gbsr_customer', 3, 'bsr', 'BSR', 'FLOAT', 'nbu_bsr_jobs', 'Show failed jobs for %customer%', '2017-03-22 15:15:19', '2017-03-23 14:55:32', NULL),
	('nbu_gbsr_policy', 1, 'policy', 'Policy', 'STRING', NULL, NULL, '2017-03-22 15:15:29', '2017-03-22 15:18:37', NULL),
	('nbu_gbsr_policy', 2, 'jobs', 'Jobs', 'NUMBER', 'nbu_bsr_jobs', 'Show jobs for %policy%', '2017-03-22 15:15:29', '2017-03-22 15:18:43', NULL),
	('nbu_gbsr_policy', 3, 'bsr', 'BSR', 'FLOAT', 'nbu_bsr_jobs', 'Show failed jobs for %policy%', '2017-03-22 15:15:29', '2017-03-23 14:55:40', NULL),
	('nbu_gbsr_schedule', 1, 'schedule', 'Schedule', 'STRING', NULL, NULL, '2017-03-22 15:15:36', '2017-03-22 15:19:28', NULL),
	('nbu_gbsr_schedule', 2, 'jobs', 'Jobs', 'NUMBER', 'nbu_bsr_jobs', 'Show jobs for %schedule%', '2017-03-22 15:15:36', '2017-03-22 15:19:06', NULL),
	('nbu_gbsr_schedule', 3, 'bsr', 'BSR', 'FLOAT', 'nbu_bsr_jobs', 'Show failed jobs for %schedule%', '2017-03-22 15:15:36', '2018-01-04 10:53:45', NULL),
	('nbu_gbsr_type', 1, 'type', 'Type', 'STRING', NULL, NULL, '2017-03-22 15:15:41', '2017-03-22 15:19:21', NULL),
	('nbu_gbsr_type', 2, 'jobs', 'Jobs', 'NUMBER', NULL, NULL, '2017-03-22 15:15:41', '2020-04-09 15:16:34', NULL),
	('nbu_gbsr_type', 3, 'bsr', 'BSR', 'FLOAT', NULL, NULL, '2017-03-22 15:15:41', '2020-04-09 15:16:33', NULL),
	('nbu_images', 1, 'masterserver', 'Master Server', 'STRING', NULL, NULL, '2017-02-13 10:32:41', '2017-02-13 10:40:47', NULL),
	('nbu_images', 2, 'tower', 'Tower', 'STRING', NULL, NULL, '2017-02-13 10:32:41', '2017-02-13 10:40:47', NULL),
	('nbu_images', 3, 'customer', 'Customer', 'STRING', NULL, NULL, '2017-02-13 10:32:41', '2017-02-13 10:40:47', NULL),
	('nbu_images', 4, 'client', 'Client name', 'STRING', NULL, NULL, '2017-02-13 10:32:41', '2017-02-13 10:40:47', NULL),
	('nbu_images', 5, 'type', 'Type', 'STRING', NULL, NULL, '2017-02-13 10:32:41', '2017-02-13 10:40:47', NULL),
	('nbu_images', 6, 'backupid', 'Backup ID', 'STRING', NULL, NULL, '2017-02-13 10:32:41', '2017-02-13 10:40:47', NULL),
	('nbu_images', 7, 'policytype', 'Policy type', 'STRING', NULL, NULL, '2017-02-13 10:32:41', '2017-02-13 10:40:47', NULL),
	('nbu_images', 8, 'policyname', 'Policy name', 'STRING', NULL, NULL, '2017-02-13 10:32:41', '2017-02-13 10:40:47', NULL),
	('nbu_images', 9, 'scheduletype', 'Schedule type', 'STRING', NULL, NULL, '2017-02-13 10:32:41', '2017-02-13 10:40:47', NULL),
	('nbu_images', 10, 'schedulename', 'Schedule name', 'STRING', NULL, NULL, '2017-02-13 10:32:41', '2017-02-13 10:40:47', NULL),
	('nbu_images', 11, 'files', 'Files', 'NUMBER', NULL, NULL, '2017-02-13 10:32:41', '2017-02-13 10:40:47', NULL),
	('nbu_images', 12, 'copy_number', 'Copy', 'NUMBER', NULL, NULL, '2017-02-13 10:32:41', '2017-02-13 10:40:47', NULL),
	('nbu_images', 13, 'fragment_number', 'Frag', 'NUMBER', NULL, NULL, '2017-02-13 10:32:41', '2017-02-13 10:40:47', NULL),
	('nbu_images', 14, 'id_path', 'Media label', 'STRING', NULL, NULL, '2017-02-13 10:32:41', '2017-02-13 10:40:47', NULL),
	('nbu_images', 15, 'media_type', 'Media type', 'NUMBER', NULL, NULL, '2017-02-13 10:32:41', '2017-02-13 10:40:47', NULL),
	('nbu_images', 16, 'media_date', 'Media date', 'DATE', NULL, NULL, '2017-02-13 10:32:41', '2017-02-13 10:40:47', NULL),
	('nbu_images', 17, 'retention_level', 'Retention', 'STRING', NULL, NULL, '2017-02-13 10:32:41', '2017-02-13 10:40:47', NULL),
	('nbu_images', 18, 'expiration', 'Expiration', 'DATE', NULL, NULL, '2017-02-13 10:32:41', '2017-02-13 10:40:47', NULL),
	('nbu_images', 19, 'kilobytes', 'kB', 'NUMBER', NULL, NULL, '2017-02-13 10:32:41', '2017-02-13 10:40:47', NULL),
	('nbu_images', 20, 'density', 'Density', 'NUMBER', NULL, NULL, '2017-02-13 10:32:41', '2017-02-13 10:40:47', NULL),
	('nbu_images', 21, 'file_number', 'File No.', 'NUMBER', NULL, NULL, '2017-02-13 10:32:41', '2017-02-13 10:40:47', NULL),
	('nbu_images', 22, 'block_size', 'Block size', 'NUMBER', NULL, NULL, '2017-02-13 10:32:41', '2017-02-13 10:40:47', NULL),
	('nbu_images', 23, 'offset', 'Offset', 'NUMBER', NULL, NULL, '2017-02-13 10:32:41', '2017-02-13 10:40:47', NULL),
	('nbu_images', 24, 'host', 'Host name', 'STRING', NULL, NULL, '2017-02-13 10:32:41', '2017-02-13 10:40:47', NULL),
	('nbu_images', 25, 'device_written_on', 'Device', 'STRING', NULL, NULL, '2017-02-13 10:32:41', '2017-02-13 10:40:47', NULL),
	('nbu_images', 26, 'f_flags', 'Flags', 'NUMBER', NULL, NULL, '2017-02-13 10:32:41', '2017-02-13 10:40:47', NULL),
	('nbu_images', 27, 'media_descriptor', 'Media descriptor', 'STRING', NULL, NULL, '2017-02-13 10:32:41', '2017-02-13 10:40:47', NULL),
	('nbu_jobs', 1, 'masterserver', 'Master server', 'STRING', NULL, NULL, '2017-02-13 10:32:41', '2017-02-13 10:40:47', NULL),
	('nbu_jobs', 2, 'jobid', 'Job ID', 'NUMBER', NULL, NULL, '2017-02-13 10:33:58', '2017-02-13 10:40:49', NULL),
	('nbu_jobs', 3, 'childjobs', 'Childs', 'NUMBER', 'nbu_jobs', 'Show child jobs for %parentjob%', '2017-02-13 10:34:19', '2017-03-20 15:47:05', NULL),
	('nbu_jobs', 4, 'parentjob', 'Parent job', 'NUMBER', NULL, NULL, '2017-02-13 10:34:19', '2017-05-11 14:19:36', NULL),
	('nbu_jobs', 5, 'status', 'Status', 'STRING', 'nbu_codes', 'Show description for status \'%status%\'', '2017-02-13 10:36:00', '2017-05-12 13:18:01', NULL),
	('nbu_jobs', 6, 'tower', 'Tower', 'STRING', NULL, NULL, '2017-02-13 10:36:39', '2020-04-09 15:02:31', NULL),
	('nbu_jobs', 7, 'customer', 'Customer', 'STRING', NULL, NULL, '2017-02-13 10:36:39', '2017-05-11 14:27:45', NULL),
	('nbu_jobs', 8, 'policy', 'Policy name', 'STRING', 'nbu_policies', 'Show policy \'%policy%\'', '2017-02-13 10:36:52', '2017-05-11 14:19:55', NULL),
	('nbu_jobs', 9, 'policytype', 'P.type', 'STRING', NULL, NULL, '2017-02-13 10:37:11', '2017-05-11 14:27:39', NULL),
	('nbu_jobs', 10, 'schedule', 'Schedule', 'STRING', 'nbu_schedules', 'Show policy \'%policy%\' and \'%schedule%\'', '2017-02-13 10:37:29', '2017-05-11 14:23:34', NULL),
	('nbu_jobs', 11, 'scheduletype', 'S.type', 'STRING', NULL, NULL, '2017-02-13 10:37:43', '2017-05-11 14:27:41', NULL),
	('nbu_jobs', 12, 'client', 'Client name', 'STRING', NULL, NULL, '2017-02-13 10:38:22', '2018-08-30 14:24:30', NULL),
	('nbu_jobs', 13, 'jobtype', 'Job type', 'STRING', NULL, NULL, '2017-02-13 10:34:34', '2017-05-11 14:20:10', NULL),
	('nbu_jobs', 14, 'subtype', 'Sub type', 'STRING', NULL, NULL, '2017-02-13 10:34:57', '2017-05-11 14:20:12', NULL),
	('nbu_jobs', 15, 'state', 'State', 'STRING', NULL, NULL, '2017-02-13 10:35:29', '2017-05-11 14:20:23', NULL),
	('nbu_jobs', 16, 'operation', 'Operation', 'STRING', NULL, NULL, '2017-02-13 10:35:41', '2017-05-11 14:20:30', NULL),
	('nbu_jobs', 17, 'server', 'Server', 'STRING', NULL, NULL, '2017-02-13 10:38:29', '2017-04-27 13:41:21', NULL),
	('nbu_jobs', 18, 'percent', '%', 'NUMBER', NULL, NULL, '2017-02-13 10:36:12', '2017-05-11 14:23:29', NULL),
	('nbu_jobs', 19, 'bw_day', 'Backup day', 'DATE', NULL, NULL, '2017-02-13 10:38:41', '2017-05-11 14:23:39', NULL),
	('nbu_jobs', 19, 'started', 'Started', 'DATE', NULL, NULL, '2017-02-13 10:38:41', '2017-05-11 14:23:39', NULL),
	('nbu_jobs', 20, 'elapsed', 'Elapsed', 'STRING', NULL, NULL, '2017-02-13 10:39:05', '2017-10-18 11:13:36', NULL),
	('nbu_jobs', 21, 'ended', 'Ended', 'DATE', NULL, NULL, '2017-02-13 10:39:14', '2017-05-11 14:23:42', NULL),
	('nbu_jobs', 22, 'backupid', 'Backup ID', 'STRING', 'nbu_flist', 'Show objects for backup ID %backupid%', '2017-03-22 09:04:19', '2018-10-26 13:24:26', NULL),
	('nbu_jobs', 23, 'stunit', 'ST Unit', 'STRING', NULL, NULL, '2017-03-22 09:04:19', '2018-10-25 10:34:30', NULL),
	('nbu_jobs', 24, 'priority', 'Prio', 'NUMBER', NULL, NULL, '2017-03-22 09:04:31', '2018-10-25 10:34:33', NULL),
	('nbu_jobs', 25, 'tries', 'Tries', 'NUMBER', NULL, NULL, '2017-03-22 09:04:46', '2018-10-25 10:34:36', NULL),
	('nbu_jobs', 26, 'kbytes', 'kB', 'NUMBER', NULL, NULL, '2017-03-22 09:04:56', '2018-10-25 10:34:38', NULL),
	('nbu_jobs', 27, 'files', 'Files', 'NUMBER', NULL, NULL, '2017-03-22 09:05:13', '2018-10-25 10:34:40', NULL),
	('nbu_jobs', 28, 'owner', 'Owner', 'STRING', NULL, NULL, '2017-03-22 09:05:22', '2018-10-25 10:34:43', NULL),
	('nbu_jobs', 29, 'group', 'Group', 'STRING', NULL, NULL, '2017-03-22 09:05:32', '2018-10-25 10:34:45', NULL),
	('nbu_jobs', 30, 'retentionlevel', 'RL', 'NUMBER', NULL, NULL, '2017-03-22 09:05:49', '2018-10-25 10:34:47', NULL),
	('nbu_jobs', 31, 'retentionperiod', 'RP', 'NUMBER', NULL, NULL, '2017-03-22 09:06:01', '2018-10-25 10:34:49', NULL),
	('nbu_jobs', 32, 'restartable', 'Restart', 'NUMBER', NULL, NULL, '2017-03-22 09:06:21', '2018-10-25 10:34:51', NULL),
	('nbu_jobs', 33, 'kbpersec', 'kB/s', 'NUMBER', NULL, NULL, '2017-03-22 09:06:38', '2018-10-25 10:34:53', NULL),
	('nbu_overview_clients', 1, 'tower', 'Tower', 'STRING', NULL, NULL, '2017-06-13 10:06:45', '2017-06-13 10:55:58', NULL),
	('nbu_overview_clients', 2, 'customer', 'Customer', 'STRING', NULL, NULL, '2017-06-13 10:06:45', '2017-06-13 10:55:58', NULL),
	('nbu_overview_clients', 3, 'masterserver', 'Master Server', 'STRING', NULL, NULL, '2017-06-13 10:06:45', '2020-04-22 10:40:52', NULL),
	('nbu_overview_clients', 4, 'name', 'Host name', 'STRING', NULL, NULL, '2017-06-13 10:06:45', '2017-12-15 09:42:09', NULL),
	('nbu_overview_clients', 5, 'architecture', 'Architecture', 'STRING', NULL, NULL, '2017-06-13 10:06:45', '2017-06-13 10:56:00', NULL),
	('nbu_overview_clients', 6, 'os', 'OS', 'STRING', NULL, NULL, '2017-06-13 10:06:45', '2017-06-13 10:56:01', NULL),
	('nbu_overview_clients', 7, 'policies', 'Policies', 'STRING', 'nbu_clients', 'Show policies for \'%name%\'', '2017-06-13 10:06:45', '2017-12-15 09:45:01', NULL),
	('nbu_overview_clients', 8, 'bsrjobs', 'BSR Jobs', 'NUMBER', 'nbu_bsr_jobs', 'Show BSR jobs for \'%name%\'', '2017-06-13 10:06:45', '2017-06-13 11:17:35', NULL),
	('nbu_overview_clients', 9, 'bsr', '%', 'FLOAT', 'nbu_bsr_jobs', 'Show BSR failed jobs for \'%name%\'', '2017-06-13 10:06:45', '2017-06-13 14:35:57', NULL),
	('nbu_overview_clients', 10, 'jobs', 'All Jobs', 'NUMBER', 'nbu_jobs', 'Show jobs for \'%name%\'', '2017-06-13 10:06:45', '2017-06-13 14:35:00', NULL),
	('nbu_overview_clients', 11, 'failures', 'Failed', 'NUMBER', 'nbu_jobs', 'Show failed jobs for \'%name%\'', '2017-06-13 10:06:45', '2017-06-13 14:35:10', NULL),
	('nbu_overview_clients', 12, 'gbytes', 'Written (GB)', 'FLOAT', NULL, NULL, '2017-06-13 10:06:45', '2017-06-13 14:38:26', NULL),
	('nbu_overview_clients', 13, 'images', 'Images', 'NUMBER', NULL, NULL, '2017-06-13 10:06:45', '2017-06-13 14:38:26', NULL),
	('nbu_overview_clients', 14, 'vmedia', 'Virtual media', 'NUMBER', NULL, NULL, '2017-06-13 10:06:45', '2017-06-13 14:38:26', NULL),
	('nbu_overview_clients', 15, 'pmedia', 'Physical media', 'NUMBER', NULL, NULL, '2017-06-13 10:06:45', '2017-06-13 14:38:26', NULL),
	('nbu_overview_clients', 16, 'labels', 'Physical labels', 'STRING', NULL, NULL, '2017-06-13 10:06:45', '2017-06-13 14:38:26', NULL),
	('nbu_overview_clients', 17, 'gbretained', 'Retained (GB)', 'FLOAT', NULL, NULL, '2017-06-13 10:06:45', '2017-06-13 14:38:26', NULL),
	('nbu_overview_customers', 1, 'customer', 'Customer', 'STRING', NULL, NULL, '2017-06-13 10:49:42', '2017-06-13 10:56:09', NULL),
	('nbu_overview_customers', 2, 'clients', 'Clients', 'NUMBER', 'nbu_clients_distinct', 'Show clients for \'%customer%\'', '2017-06-13 10:49:42', '2017-12-15 09:52:57', NULL),
	('nbu_overview_customers', 3, 'integ_clients', 'Integ Clients', 'NUMBER', 'nbu_clients_distinct', 'Show Integ clients for \'%customer%\'', '2017-06-13 10:49:42', '2017-12-15 09:53:04', NULL),
	('nbu_overview_customers', 4, 'policies', 'Policies', 'NUMBER', 'nbu_policies', 'Show policies for \'%customer%\'', '2017-06-13 10:49:42', '2017-10-09 14:42:40', NULL),
	('nbu_overview_customers', 5, 'bsrjobs', 'BSR Jobs', 'NUMBER', 'nbu_bsr_jobs', 'Show BSR jobs for \'%customer%\'', '2017-06-13 10:49:42', '2017-10-09 14:42:42', NULL),
	('nbu_overview_customers', 6, 'bsr', '%', 'FLOAT', 'nbu_bsr_jobs', 'Show failed BSR jobs for \'%customer%\'', '2017-06-13 10:49:42', '2017-10-09 14:42:43', NULL),
	('nbu_overview_customers', 7, 'jobs', 'All Jobs', 'NUMBER', 'nbu_jobs', 'Show jobs for \'%customer%\'', '2017-06-13 10:49:42', '2017-10-09 14:42:47', NULL),
	('nbu_overview_customers', 8, 'failures', 'Failed', 'NUMBER', 'nbu_jobs', 'Show failed jobs for \'%customer%\'', '2017-06-13 10:49:42', '2017-10-09 14:42:51', NULL),
	('nbu_overview_customers', 9, 'gbytes', 'Written (GB)', 'FLOAT', NULL, NULL, '2017-06-13 10:49:42', '2017-10-09 14:42:52', NULL),
	('nbu_overview_customers', 10, 'gbretained', 'Retained (GB)', 'FLOAT', NULL, NULL, '2017-06-13 10:49:42', '2017-10-09 14:42:52', NULL),
	('nbu_overview_jobs', 1, 'masterserver', 'Master Server', 'STRING', NULL, NULL, '2017-06-01 15:20:34', '2017-06-02 09:43:34', NULL),
	('nbu_overview_jobs', 2, 'jobtype', 'Job type', 'STRING', NULL, NULL, '2017-06-01 15:20:34', '2017-06-13 09:18:28', NULL),
	('nbu_overview_jobs', 3, 'subtype', 'Sub type', 'STRING', NULL, NULL, '2017-06-01 15:20:47', '2017-06-13 09:18:30', NULL),
	('nbu_overview_jobs', 4, 'state', 'State', 'STRING', NULL, NULL, '2017-06-01 15:21:30', '2017-06-13 09:18:32', NULL),
	('nbu_overview_jobs', 5, 'operation', 'Operation', 'STRING', NULL, NULL, '2017-06-01 15:21:30', '2017-06-13 09:18:33', NULL),
	('nbu_overview_jobs', 6, 'jobs', 'Jobs', 'NUMBER', 'nbu_jobs', 'Show all jobs', '2017-06-01 15:21:41', '2017-06-13 09:18:35', NULL),
	('nbu_overview_jobs', 7, 'success', 'Success', 'NUMBER', 'nbu_jobs', 'Show successful jobs', '2017-06-01 15:21:58', '2017-06-13 09:18:37', NULL),
	('nbu_overview_jobs', 8, 'fail', 'Failed', 'NUMBER', 'nbu_jobs', 'Show failed jobs', '2017-06-01 15:22:07', '2017-06-13 09:18:39', NULL),
	('nbu_overview_jobs', 9, 'bsr', '%', 'FLOAT', NULL, NULL, '2017-06-01 15:22:23', '2017-06-13 09:18:42', NULL),
	('nbu_overview_jobs', 10, 'gbytes', 'Written (GB)', 'FLOAT', NULL, NULL, '2017-06-01 15:22:42', '2017-06-13 14:38:31', NULL),
	('nbu_policies', 1, 'masterserver', 'Master server', 'STRING', NULL, NULL, '2017-03-20 09:03:42', '2017-03-20 09:03:42', NULL),
	('nbu_policies', 2, 'tower', 'Tower', 'STRING', NULL, NULL, '2017-03-20 09:06:04', '2017-03-20 09:06:04', NULL),
	('nbu_policies', 3, 'customer', 'Customer', 'STRING', NULL, NULL, '2017-03-20 09:06:04', '2017-04-27 13:42:30', NULL),
	('nbu_policies', 4, 'name', 'Policy name', 'STRING', NULL, NULL, '2017-03-20 09:06:38', '2017-04-27 13:42:32', NULL),
	('nbu_policies', 5, 'active', 'Active', 'STRING', NULL, NULL, '2017-03-20 09:07:03', '2019-05-17 13:09:03', NULL),
	('nbu_policies', 6, 'policytype', 'Type', 'STRING', NULL, NULL, '2017-03-20 09:07:18', '2017-04-27 13:42:35', NULL),
	('nbu_policies', 7, 'include', 'Include', 'STRING', NULL, NULL, '2017-03-20 09:07:18', '2017-04-27 13:42:35', NULL),
	('nbu_policies', 8, 'clients', 'Clients', 'NUMBER', 'nbu_clients', 'Show clients for \'%name%\'', '2017-03-20 09:07:45', '2017-07-14 14:55:10', NULL),
	('nbu_policies', 9, 'schedules', 'Schedules', 'NUMBER', 'nbu_schedules', 'Show schedules for \'%name%\'', '2017-03-20 09:07:59', '2017-07-14 14:55:13', NULL),
	('nbu_policies', 10, 'jobs', 'Jobs', 'NUMBER', 'nbu_jobs', 'Show jobs for \'%name%\'', '2017-03-20 09:08:13', '2017-07-14 14:55:15', NULL),
	('nbu_policies', 11, 'failures', 'Failures', 'NUMBER', 'nbu_jobs', 'Show failed jobs for \'%name%\'', '2017-03-20 09:08:35', '2017-07-14 14:55:16', NULL),
	('nbu_policies', 12, 'gbytes', 'Written (GB)', 'FLOAT', NULL, NULL, '2017-03-20 09:08:35', '2017-07-14 14:55:17', NULL),
	('nbu_policies', 13, 'res', 'Residence', 'STRING', NULL, NULL, '2017-03-20 09:08:35', '2019-04-23 09:04:48', NULL),
	('nbu_policies', 14, 'maxjobsperclient', 'J/C', 'NUMBER', NULL, NULL, '2017-03-20 09:09:18', '2019-04-23 09:02:54', NULL),
	('nbu_puredisks', 1, 'masterserver', 'Master Server', 'STRING', NULL, NULL, '2020-03-05 08:32:39', '2020-03-05 08:32:39', NULL),
	('nbu_puredisks', 2, 'diskpool', 'Disk Pool', 'STRING', NULL, NULL, '2020-03-05 08:33:15', '2020-03-05 08:33:45', NULL),
	('nbu_puredisks', 3, 'disk_media_id', 'Media ID', 'STRING', NULL, NULL, '2020-03-05 08:33:37', '2020-03-05 08:33:37', NULL),
	('nbu_puredisks', 4, 'total_capacity', 'Capacity', 'FLOAT', NULL, NULL, '2020-03-05 08:34:21', '2020-03-05 08:34:21', NULL),
	('nbu_puredisks', 5, 'free_space', 'Free space', 'FLOAT', NULL, NULL, '2020-03-05 08:34:55', '2020-03-05 08:34:55', NULL),
	('nbu_puredisks', 6, 'used', 'Used %', 'FLOAT', NULL, NULL, '2020-03-05 08:35:17', '2020-03-05 08:35:17', NULL),
	('nbu_schedules', 1, 'masterserver', 'Master server', 'STRING', NULL, NULL, '2017-03-20 14:46:35', '2017-03-20 14:46:35', NULL),
	('nbu_schedules', 2, 'tower', 'Tower', 'STRING', NULL, NULL, '2017-03-20 14:47:00', '2017-03-20 14:47:00', NULL),
	('nbu_schedules', 3, 'customer', 'Customer', 'STRING', NULL, NULL, '2017-03-20 14:47:00', '2017-04-27 13:43:13', NULL),
	('nbu_schedules', 4, 'policyname', 'Policy name', 'STRING', 'nbu_policies', 'Show policy \'%policyname%\'', '2017-03-20 14:47:13', '2017-04-27 13:43:16', NULL),
	('nbu_schedules', 5, 'name', 'Schedule name', 'STRING', NULL, NULL, '2017-03-20 15:07:14', '2017-04-27 13:43:19', NULL),
	('nbu_schedules', 6, 'backuptype', 'Backup type', 'STRING', NULL, NULL, '2017-03-20 15:08:47', '2017-04-27 13:43:20', NULL),
	('nbu_schedules', 7, 'jobs', 'Jobs', 'NUMBER', 'nbu_jobs', 'Show jobs for \'%policyname%\' and \'%name%\'', '2017-03-20 15:09:06', '2017-04-27 13:43:22', NULL),
	('nbu_schedules', 8, 'failures', 'Failures', 'NUMBER', 'nbu_jobs', 'Show failed jobs for \'%policyname%\' and \'%name%\'', '2017-03-20 15:09:19', '2017-04-27 13:43:25', NULL),
	('nbu_schedules', 9, 'gbytes', 'Written (GB)', 'FLOAT', NULL, NULL, '2017-03-20 15:09:19', '2017-06-13 14:38:46', NULL),
	('nbu_schedules', 10, 'freq_days', 'Freq (d)', 'NUMBER', NULL, NULL, '2017-03-20 15:10:24', '2017-06-13 09:09:31', NULL),
	('nbu_schedules', 11, 'retentionlevel', 'R.level', 'STRING', NULL, NULL, '2017-03-20 15:10:51', '2017-06-13 09:09:33', NULL),
	('nbu_schedules', 12, 'res', 'Residence', 'STRING', NULL, NULL, '2017-03-20 15:10:51', '2017-06-13 09:09:33', NULL),
	('nbu_schedules', 13, 'calendar', 'Calendar', 'NUMBER', NULL, NULL, '2017-03-20 15:11:03', '2019-04-23 09:08:10', NULL),
	('nbu_schedules', 14, 'caldayofweek', 'DoW', 'STRING', NULL, NULL, '2017-03-20 15:11:24', '2019-04-23 09:08:12', NULL),
	('nbu_schedules', 15, 'sun_start', 'Sun', 'STRING', NULL, NULL, '2017-03-20 15:13:30', '2019-04-23 09:08:15', NULL),
	('nbu_schedules', 16, 'sun_hours', '(h)', 'STRING', NULL, NULL, '2017-03-20 15:14:14', '2019-04-23 09:08:17', NULL),
	('nbu_schedules', 17, 'mon_start', 'Mon', 'STRING', NULL, NULL, '2017-03-20 15:14:25', '2019-04-23 09:08:20', NULL),
	('nbu_schedules', 18, 'mon_hours', '(h)', 'STRING', NULL, NULL, '2017-03-20 15:14:36', '2019-04-23 09:08:22', NULL),
	('nbu_schedules', 19, 'tue_start', 'Tue', 'STRING', NULL, NULL, '2017-03-20 15:14:54', '2019-04-23 09:08:27', NULL),
	('nbu_schedules', 20, 'tue_hours', '(h)', 'STRING', NULL, NULL, '2017-03-20 15:15:06', '2019-04-23 09:08:29', NULL),
	('nbu_schedules', 21, 'wed_start', 'Wed', 'STRING', NULL, NULL, '2017-03-20 15:15:19', '2019-04-23 09:08:31', NULL),
	('nbu_schedules', 22, 'wed_hours', '(h)', 'STRING', NULL, NULL, '2017-03-20 15:15:29', '2019-04-23 09:08:32', NULL),
	('nbu_schedules', 23, 'thu_start', 'Thu', 'STRING', NULL, NULL, '2017-03-20 15:15:41', '2019-04-23 09:08:34', NULL),
	('nbu_schedules', 24, 'thu_hours', '(h)', 'STRING', NULL, NULL, '2017-03-20 15:15:53', '2019-04-23 09:08:36', NULL),
	('nbu_schedules', 25, 'fri_start', 'Fri', 'STRING', NULL, NULL, '2017-03-20 15:16:03', '2019-04-23 09:08:37', NULL),
	('nbu_schedules', 26, 'fri_hours', '(h)', 'STRING', NULL, NULL, '2017-03-20 15:16:13', '2019-04-23 09:08:39', NULL),
	('nbu_schedules', 27, 'sat_start', 'Sat', 'STRING', NULL, NULL, '2017-03-20 15:16:25', '2019-04-23 09:08:40', NULL),
	('nbu_schedules', 28, 'sat_hours', '(h)', 'STRING', NULL, NULL, '2017-03-20 15:16:34', '2019-04-23 09:08:43', NULL),
	('nbu_slps', 1, 'masterserver', 'Master server', 'STRING', NULL, NULL, '2019-04-17 14:43:45', '2019-04-17 14:47:23', NULL),
	('nbu_slps', 2, 'name', 'SLP name', 'STRING', NULL, NULL, '2019-04-17 14:43:54', '2019-04-23 09:15:18', NULL),
	('nbu_slps', 3, 'dataclassification', 'Class', 'STRING', NULL, NULL, '2019-04-17 14:44:01', '2019-04-17 14:47:38', NULL),
	('nbu_slps', 4, 'duplicationpriority', 'Prio', 'NUMBER', NULL, NULL, '2019-04-17 14:45:00', '2019-04-17 14:47:48', NULL),
	('nbu_slps', 5, 'state', 'State', 'STRING', NULL, NULL, '2019-04-17 14:45:10', '2019-04-17 14:48:05', NULL),
	('nbu_slps', 6, 'version', 'Version', 'NUMBER', NULL, NULL, '2019-04-17 14:45:15', '2019-04-17 14:48:11', NULL),
	('nbu_slps', 7, 'policies', 'Policies', 'NUMBER', 'nbu_policies', 'Show policies for SLP "%name%"', '2019-04-17 14:45:15', '2019-04-23 09:07:53', NULL),
	('nbu_slps', 8, 'schedules', 'Schedules', 'NUMBER', 'nbu_schedules', 'Show schedules for SLP "%name%"', '2019-04-17 14:45:15', '2019-04-23 09:07:53', NULL),
	('nbu_slps', 9, 'operationindex', 'Index', 'NUMBER', NULL, NULL, '2019-04-17 14:45:25', '2019-04-23 09:09:31', NULL),
	('nbu_slps', 10, 'usefor', 'Type', 'STRING', NULL, NULL, '2019-04-17 14:45:37', '2019-04-23 09:09:33', NULL),
	('nbu_slps', 11, 'storageunit', 'Storage unit', 'STRING', NULL, NULL, '2019-04-17 14:45:47', '2019-04-23 09:09:35', NULL),
	('nbu_slps', 12, 'volumepool', 'Volme pool', 'STRING', NULL, NULL, '2019-04-17 14:46:04', '2019-04-23 09:09:36', NULL),
	('nbu_slps', 13, 'mediaowner', 'Media owner', 'STRING', NULL, NULL, '2019-04-17 14:46:11', '2019-04-23 09:09:38', NULL),
	('nbu_slps', 14, 'retention', 'Retention', 'STRING', NULL, NULL, '2019-04-17 14:46:30', '2019-04-23 09:09:40', NULL),
	('nbu_slps', 15, 'alternatereadserver', 'Alternate read server', 'STRING', NULL, NULL, '2019-04-17 14:46:38', '2019-04-23 09:09:42', NULL),
	('nbu_slps', 16, 'preservempx', 'Preserve MPX', 'NUMBER', NULL, NULL, '2019-04-17 14:46:50', '2019-04-23 09:09:44', NULL),
	('nbu_slps', 17, 'ddostate', 'DDO State', 'STRING', NULL, NULL, '2019-04-17 14:46:55', '2019-04-23 09:09:46', NULL),
	('nbu_slps', 18, 'source', 'Source', 'NUMBER', NULL, NULL, '2019-04-17 14:47:05', '2019-04-23 09:09:48', NULL),
	('nbu_slps', 19, 'slpwindow', 'SLP Window', 'STRING', NULL, NULL, '2019-04-17 14:47:11', '2019-04-23 09:09:50', NULL),
	('nbu_status_breakdown', 1, 'status', 'Status', 'NUMBER', NULL, NULL, '2019-05-24 12:51:22', '2019-05-24 13:02:41', NULL),
	('nbu_status_breakdown', 2, 'description', 'Status description', 'STRING', NULL, NULL, '2019-05-24 12:51:39', '2019-05-24 13:02:42', NULL),
	('nbu_status_breakdown', 3, 'count', 'Count', 'NUMBER', 'nbu_bsr_jobs', 'Show jobst with status %status%', '2019-05-24 12:52:18', '2019-05-24 13:02:42', NULL),
	('nbu_vault_classes', 1, 'masterserver', 'Master server', 'STRING', NULL, NULL, '2017-07-24 15:45:56', '2017-07-24 15:48:24', NULL),
	('nbu_vault_classes', 2, 'profile', 'Profile name', 'STRING', 'nbu_vault_profiles', 'Show profile \'%profile%\'', '2017-07-24 15:45:56', '2017-07-26 10:01:10', NULL),
	('nbu_vault_classes', 3, 'name', 'Class name', 'STRING', NULL, NULL, '2017-07-24 15:45:56', '2017-07-25 09:39:37', NULL),
	('nbu_vault_clients', 1, 'masterserver', 'Master server', 'STRING', NULL, NULL, '2017-07-24 15:45:56', '2017-07-24 15:48:24', NULL),
	('nbu_vault_clients', 2, 'profile', 'Profile name', 'STRING', 'nbu_vault_profiles', 'Show profile \'%profile%\'', '2017-07-24 15:45:56', '2017-07-26 10:01:14', NULL),
	('nbu_vault_clients', 3, 'name', 'Host name', 'STRING', NULL, NULL, '2017-07-24 15:45:56', '2017-07-25 09:39:36', NULL),
	('nbu_vault_profiles', 1, 'masterserver', 'Master server', 'STRING', NULL, NULL, '2017-07-24 15:57:17', '2017-07-24 15:59:38', NULL),
	('nbu_vault_profiles', 2, 'robot', 'Robot', 'STRING', NULL, NULL, '2017-07-24 15:57:45', '2017-07-24 16:03:46', NULL),
	('nbu_vault_profiles', 3, 'vault', 'Vault', 'STRING', NULL, NULL, '2017-07-24 15:57:45', '2017-07-24 16:03:49', NULL),
	('nbu_vault_profiles', 4, 'name', 'Name', 'STRING', NULL, NULL, '2017-07-24 15:57:25', '2017-07-24 16:03:51', NULL),
	('nbu_vault_profiles', 5, 'startday', 'Start day', 'NUMBER', NULL, NULL, '2017-07-24 15:58:46', '2017-07-24 16:03:52', NULL),
	('nbu_vault_profiles', 6, 'starthour', 'Start hour', 'NUMBER', NULL, NULL, '2017-07-24 15:58:57', '2017-07-24 16:03:54', NULL),
	('nbu_vault_profiles', 7, 'endday', 'End day', 'NUMBER', NULL, NULL, '2017-07-24 15:59:04', '2017-07-24 16:03:55', NULL),
	('nbu_vault_profiles', 8, 'endhour', 'End hour', 'NUMBER', NULL, NULL, '2017-07-24 15:59:14', '2017-07-24 16:03:57', NULL),
	('nbu_vault_profiles', 9, 'ipf_enabled', 'Image prop. filters', 'STRING', NULL, NULL, '2017-07-24 15:59:14', '2017-07-25 09:03:12', NULL),
	('nbu_vault_profiles', 10, 'clientfilter', 'Client filter', 'STRING', NULL, NULL, '2017-07-24 15:59:14', '2017-07-25 08:57:18', NULL),
	('nbu_vault_profiles', 11, 'clients', 'Clients', 'NUMBER', 'nbu_vault_clients', 'Show clients for \'%name%\'', '2017-07-24 15:59:14', '2017-07-25 09:28:51', NULL),
	('nbu_vault_profiles', 12, 'backuptypefilter', 'Backup type filter', 'STRING', NULL, NULL, '2017-07-24 15:59:14', '2017-07-25 08:52:17', NULL),
	('nbu_vault_profiles', 13, 'mediaserverfilter', 'Media Server filter', 'STRING', NULL, NULL, '2017-07-24 15:59:14', '2017-07-25 08:52:17', NULL),
	('nbu_vault_profiles', 14, 'classfilter', 'Class filter', 'STRING', NULL, NULL, '2017-07-24 15:59:14', '2017-07-25 08:52:17', NULL),
	('nbu_vault_profiles', 15, 'classes', 'Classes', 'NUMBER', 'nbu_vault_classes', 'Show classes for \'%name%\'', '2017-07-24 15:59:14', '2017-07-25 09:29:05', NULL),
	('nbu_vault_profiles', 16, 'schedulefilter', 'Schedule filter', 'STRING', NULL, NULL, '2017-07-24 15:59:14', '2017-07-25 08:52:17', NULL),
	('nbu_vault_profiles', 17, 'schedules', 'Schedules', 'NUMBER', 'nbu_vault_schedules', 'Show schedules for \'%name%\'', '2017-07-24 15:59:14', '2017-07-25 09:29:13', NULL),
	('nbu_vault_profiles', 18, 'retentionlevelfilter', 'Retention filter', 'STRING', NULL, NULL, '2017-07-24 15:59:14', '2017-07-25 08:52:17', NULL),
	('nbu_vault_profiles', 19, 'ilf_enabled', 'Image loc. filters', 'STRING', NULL, NULL, '2017-07-24 15:59:14', '2017-07-25 09:05:29', NULL),
	('nbu_vault_profiles', 20, 'sourcevolgroupfilter', 'Source VolGroup filter', 'STRING', NULL, NULL, '2017-07-24 15:59:14', '2017-07-25 08:52:17', NULL),
	('nbu_vault_profiles', 21, 'volumepoolfilter', 'Volume pool filter', 'STRING', NULL, NULL, '2017-07-24 15:59:14', '2017-07-25 08:52:17', NULL),
	('nbu_vault_profiles', 22, 'basicdiskfilter', 'Basic disk filter', 'STRING', NULL, NULL, '2017-07-24 15:59:14', '2017-07-25 08:52:17', NULL),
	('nbu_vault_profiles', 23, 'diskgroupfilter', 'Disk group filter', 'STRING', NULL, NULL, '2017-07-24 15:59:14', '2017-07-25 08:52:17', NULL),
	('nbu_vault_profiles', 24, 'duplication_skip', 'Duplication skip', 'STRING', NULL, NULL, '2017-07-24 15:59:14', '2017-07-25 08:52:17', NULL),
	('nbu_vault_profiles', 25, 'duppriority', 'Priority', 'NUMBER', NULL, NULL, '2017-07-24 15:59:14', '2017-07-25 09:27:14', NULL),
	('nbu_vault_profiles', 26, 'multiplex', 'Multiplex', 'STRING', NULL, NULL, '2017-07-24 15:59:14', '2017-07-25 08:52:17', NULL),
	('nbu_vault_profiles', 27, 'sharedrobots', 'Shared robots', 'STRING', NULL, NULL, '2017-07-24 15:59:14', '2017-07-25 08:52:17', NULL),
	('nbu_vault_profiles', 28, 'sortorder', 'Sort order', 'NUMBER', NULL, NULL, '2017-07-24 15:59:14', '2017-07-25 09:08:33', NULL),
	('nbu_vault_profiles', 29, 'altreadhost', 'Alternate read host', 'STRING', NULL, NULL, '2017-07-24 15:59:14', '2017-07-25 09:09:36', NULL),
	('nbu_vault_profiles', 30, 'backupserver', 'Backup server', 'STRING', NULL, NULL, '2017-07-24 15:59:14', '2017-07-25 09:09:10', NULL),
	('nbu_vault_profiles', 31, 'readdrives', 'Read drives', 'NUMBER', NULL, NULL, '2017-07-24 15:59:14', '2017-07-25 09:09:10', NULL),
	('nbu_vault_profiles', 32, 'writedrives', 'Write drives', 'NUMBER', NULL, NULL, '2017-07-24 15:59:14', '2017-07-25 09:09:10', NULL),
	('nbu_vault_profiles', 33, 'fail', 'Fail', 'STRING', NULL, NULL, '2017-07-24 15:59:14', '2017-07-25 09:09:10', NULL),
	('nbu_vault_profiles', 34, 'primary', 'Primary', 'STRING', NULL, NULL, '2017-07-24 15:59:14', '2017-07-25 09:09:10', NULL),
	('nbu_vault_profiles', 35, 'retention', 'Retention', 'STRING', NULL, NULL, '2017-07-24 15:59:14', '2017-07-25 09:09:10', NULL),
	('nbu_vault_profiles', 36, 'sharegroup', 'ShareGroup', 'STRING', NULL, NULL, '2017-07-24 15:59:14', '2017-07-25 09:09:10', NULL),
	('nbu_vault_profiles', 37, 'stgunit', 'Storage unit', 'STRING', NULL, NULL, '2017-07-24 15:59:14', '2017-07-25 09:09:10', NULL),
	('nbu_vault_profiles', 38, 'volpool', 'Volume pool', 'STRING', NULL, NULL, '2017-07-24 15:59:14', '2017-07-25 09:09:10', NULL),
	('nbu_vault_profiles', 39, 'catalogbackup_skip', 'Catalog backup skip', 'STRING', NULL, NULL, '2017-07-24 15:59:14', '2017-07-25 09:09:10', NULL),
	('nbu_vault_profiles', 40, 'eject_skip', 'Eject skip', 'STRING', NULL, NULL, '2017-07-24 15:59:14', '2017-07-25 09:09:10', NULL),
	('nbu_vault_profiles', 41, 'ejectmode', 'Eject mode', 'STRING', NULL, NULL, '2017-07-24 15:59:14', '2017-07-25 09:09:10', NULL),
	('nbu_vault_profiles', 42, 'eject_ene', 'Eject notification email', 'STRING', NULL, NULL, '2017-07-24 15:59:14', '2017-07-25 09:09:10', NULL),
	('nbu_vault_profiles', 43, 'suspend', 'Suspend', 'STRING', NULL, NULL, '2017-07-24 15:59:14', '2017-07-25 09:09:10', NULL),
	('nbu_vault_profiles', 44, 'suspendmode', 'Suspend mode', 'STRING', NULL, NULL, '2017-07-24 15:59:14', '2017-07-25 09:09:10', NULL),
	('nbu_vault_profiles', 45, 'userbtorvaultprefene', 'Use robot/pref ENE', 'STRING', NULL, NULL, '2017-07-24 15:59:14', '2017-07-25 09:16:53', NULL),
	('nbu_vault_profiles', 46, 'imfile', 'IM file', 'STRING', NULL, NULL, '2017-07-24 15:59:14', '2017-07-25 09:09:10', NULL),
	('nbu_vault_profiles', 47, 'mode', 'Mode', 'STRING', NULL, NULL, '2017-07-24 15:59:14', '2017-07-25 09:09:10', NULL),
	('nbu_vault_profiles', 48, 'useglobalrptsdist', 'Use global reports dist.', 'STRING', NULL, NULL, '2017-07-24 15:59:14', '2017-07-25 09:17:29', NULL),
	('nbu_vault_profiles', 49, 'lastmod', 'Last modified', 'DATE', NULL, NULL, '2017-07-24 15:59:30', '2017-07-25 09:16:25', NULL),
	('nbu_vault_robots', 1, 'masterserver', 'Master server', 'STRING', NULL, NULL, '2017-07-24 15:35:15', '2017-07-24 15:38:53', NULL),
	('nbu_vault_robots', 2, 'name', 'Name', 'STRING', NULL, NULL, '2017-07-24 15:35:19', '2017-07-24 15:38:57', NULL),
	('nbu_vault_robots', 3, 'robotnumber', 'Number', 'NUMBER', NULL, NULL, '2017-07-24 15:36:11', '2017-07-24 15:39:00', NULL),
	('nbu_vault_robots', 4, 'robottype', 'Type', 'STRING', NULL, NULL, '2017-07-24 15:36:27', '2017-07-24 15:39:03', NULL),
	('nbu_vault_robots', 5, 'roboticcontrolhost', 'Control host', 'STRING', NULL, NULL, '2017-07-24 15:36:43', '2017-07-24 15:39:11', NULL),
	('nbu_vault_robots', 6, 'usevaultprefene', 'Use vault ENE', 'STRING', NULL, NULL, '2017-07-24 15:36:57', '2017-07-24 15:39:26', NULL),
	('nbu_vault_robots', 7, 'ejectnotificationemail', 'ENE', 'STRING', NULL, NULL, '2017-07-24 15:37:11', '2017-07-24 15:42:59', NULL),
	('nbu_vault_robots', 8, 'vaults', 'Vaults', 'NUMBER', 'nbu_vault_vaults', 'Show vaults for \'%name%\'', '2017-07-24 15:38:10', '2017-07-24 15:53:03', NULL),
	('nbu_vault_robots', 9, 'lastmod', 'Last modified', 'DATE', NULL, NULL, '2017-07-24 15:38:34', '2017-07-26 09:54:41', NULL),
	('nbu_vault_schedules', 1, 'masterserver', 'Master server', 'STRING', NULL, NULL, '2017-07-24 15:45:56', '2017-07-24 15:48:24', NULL),
	('nbu_vault_schedules', 2, 'profile', 'Profile name', 'STRING', 'nbu_vault_profiles', 'Show profile \'%profile%\'', '2017-07-24 15:45:56', '2017-07-26 10:00:42', NULL),
	('nbu_vault_schedules', 3, 'name', 'Schedule name', 'STRING', NULL, NULL, '2017-07-24 15:45:56', '2017-07-25 09:39:39', NULL),
	('nbu_vault_vaults', 1, 'masterserver', 'Master server', 'STRING', NULL, NULL, '2017-07-24 15:45:56', '2017-07-24 15:48:24', NULL),
	('nbu_vault_vaults', 2, 'robot', 'Robot', 'STRING', NULL, NULL, '2017-07-24 15:49:55', '2017-07-24 15:49:55', NULL),
	('nbu_vault_vaults', 3, 'name', 'Name', 'STRING', NULL, NULL, '2017-07-24 15:46:22', '2017-07-24 15:57:50', NULL),
	('nbu_vault_vaults', 4, 'customerid', 'Customer ID', 'STRING', NULL, NULL, '2017-07-24 15:46:46', '2017-07-24 15:57:53', NULL),
	('nbu_vault_vaults', 5, 'offsitevolumegroup', 'Offsite volume group', 'STRING', NULL, NULL, '2017-07-24 15:47:04', '2017-07-24 15:57:54', NULL),
	('nbu_vault_vaults', 6, 'robotvolumegroup', 'Robot volume group', 'STRING', NULL, NULL, '2017-07-24 15:47:16', '2017-07-24 15:57:56', NULL),
	('nbu_vault_vaults', 7, 'vaultcontainers', 'Vault containers', 'STRING', NULL, NULL, '2017-07-24 15:47:28', '2017-07-24 15:57:57', NULL),
	('nbu_vault_vaults', 8, 'vaultseed', 'Vault seed', 'NUMBER', NULL, NULL, '2017-07-24 15:47:41', '2017-07-24 15:57:58', NULL),
	('nbu_vault_vaults', 9, 'vendor', 'Vendor', 'STRING', NULL, NULL, '2017-07-24 15:47:48', '2017-07-24 15:58:00', NULL),
	('nbu_vault_vaults', 10, 'profiles', 'Profiles', 'NUMBER', 'nbu_vault_profiles', 'Show profiles for \'%name%\'', '2017-07-24 15:48:02', '2017-07-24 16:00:39', NULL),
	('nbu_vault_vaults', 11, 'lastmod', 'Last modified', 'DATE', NULL, NULL, '2017-07-24 15:48:15', '2017-07-24 15:58:03', NULL);

INSERT INTO `core_filters` (`report`, `ord`, `source`, `field`, `operator`, `value`, `created`, `updated`, `obsoleted`) VALUES
	('nbu_consecutive_failures', 1, 'nbu_consecutive_failures', 'failures', '>', '1', '2017-08-31 15:40:04', '2017-08-31 15:44:48', '2017-08-31 15:44:46');

INSERT INTO `core_formats` (`report`, `ord`, `source`, `field`, `operator`, `value`, `style`, `description`, `fields`, `created`, `updated`, `obsoleted`) VALUES
	('audit_(partial|missing|complete)', 1, 'audit_(partial|missing|complete)', 'STATUS', '=', 'OK', 'background-color: palegreen; color: green;', 'OK', NULL, '2018-01-18 14:18:56', '2018-01-18 14:19:36', NULL),
	('audit_(partial|missing|complete)', 2, 'audit_(partial|missing|complete)', 'STATUS', '=', 'EXCEPTION', 'background-color: greenyellow; color: green;', 'Exception', NULL, '2018-01-18 14:20:23', '2018-01-18 14:21:13', NULL),
	('audit_(partial|missing|complete)', 3, 'audit_(partial|missing|complete)', 'STATUS', '=', 'WRONG', 'background-color: gold; color: brown;', 'Wrong protection', NULL, '2018-01-18 14:20:23', '2018-01-18 14:24:49', NULL),
	('audit_(partial|missing|complete)', 4, 'audit_(partial|missing|complete)', 'STATUS', '=', 'MISSING', 'background-color: lightpink; color: red;', 'Missing', NULL, '2018-01-18 14:20:23', '2018-01-18 14:22:12', NULL),
	('audit_qrs', 1, 'audit_qrs', 'DATA_CENTER', '!=', NULL, 'background-color: palegreen; color: green;', 'QRS', NULL, '2018-01-18 14:23:54', '2018-01-18 14:32:55', NULL),
	('nbu_(audit|clients|policies|schedules)', 4, 'nbu_(audit|clients|policies|schedules)', 'customer', '=', NULL, 'background-color: lightpink; color: red;', 'No customer', NULL, '2017-03-16 12:44:24', '2017-10-09 15:05:29', NULL),
	('nbu_(audit|clients|policies|schedules)', 5, 'nbu_(audit|clients|policies|schedules)', 'tower', '=', NULL, 'background-color: pink; color: red;', 'No tower', NULL, '2017-04-27 13:50:18', '2017-10-09 15:05:29', NULL),
	('nbu_(bsr_)?jobs', 1, 'nbu_(bsr_)?jobs', 'status', '=', '0', 'background-color: lightgreen; color: green;', 'Success', NULL, '2017-03-22 12:18:38', '2017-04-12 09:15:10', NULL),
	('nbu_(bsr_)?jobs', 2, 'nbu_(bsr_)?jobs', 'status', '=', '1', 'background-color: greenyellow; color: green;', 'Partial', NULL, '2017-03-22 12:18:38', '2017-04-12 09:15:11', NULL),
	('nbu_(bsr_)?jobs', 3, 'nbu_(bsr_)?jobs', 'status', '>', '1', 'background-color: lightpink; color: red;', 'Failed', NULL, '2017-03-22 12:18:38', '2017-05-11 14:17:18', NULL),
	('nbu_(bsr_)?jobs', 4, 'nbu_(bsr_)?jobs', 'childjobs', '!=', '', 'font-weight: bold;', 'Parent Job', NULL, '2017-03-22 12:18:38', '2017-06-02 10:10:54', NULL),
	('nbu_(bsr_|overview_)?jobs', 6, 'nbu_(bsr_|overview_)?jobs', 'state', '=', 'Active', 'background-color: lightblue; color: blue;', 'Active', NULL, '2017-03-22 12:18:38', '2017-06-02 10:07:48', NULL),
	('nbu_(bsr_|overview_)?jobs', 7, 'nbu_(bsr_|overview_)?jobs', 'state', '=', 'Queued', 'background-color: lightsteelblue; color: steelblue;', 'Queued', NULL, '2017-03-22 12:18:38', '2017-06-02 10:07:50', NULL),
	('nbu_(bsr_|overview_)?jobs', 8, 'nbu_(bsr_|overview_)?jobs', 'jobtype', 'not regexp', 'backup|snap', 'background-color: honeydew; font-style: italic;', 'Not a backup job', NULL, '2017-03-22 12:18:38', '2017-06-02 10:12:46', NULL),
	('nbu_(clients|policies|schedules)(_.+)?', 0, 'nbu_policies', 'clients', '=', '0', 'background-color: gainsboro; color: black;', 'No clients', NULL, '2017-03-20 14:23:33', '2017-12-15 10:03:27', NULL),
	('nbu_(clients|policies|schedules)(_.+)?', 1, 'nbu_(clients|policies|schedules)', 'jobs', '=', '0', 'background-color: silver; color: black;', 'No jobs', NULL, '2017-03-15 14:24:58', '2017-12-15 10:03:29', NULL),
	('nbu_(clients|policies|schedules)(_.+)?', 2, 'nbu_(clients|policies|schedules)', 'jobs', '>', '0', 'background-color: lightgreen; color: green;', 'Jobs', NULL, '2017-03-16 12:44:24', '2017-12-15 10:03:30', NULL),
	('nbu_(clients|policies|schedules)(_.+)?', 3, 'nbu_(clients|policies|schedules)', 'failures', '>', '0', 'background-color: greenyellow; color: green;', 'Failures', NULL, '2017-03-16 12:44:24', '2017-12-15 10:03:31', NULL),
	('nbu_(g?bsr($|_(c|p|s|t).+)|overview|bsr_job_results|bw_jobs)', 1, 'nbu_(g?bsr($|_(c|p|s|t).+)|overview|bsr_job_results|bw_jobs)', 'bsr', '>=', '0', 'background-color: salmon; color: darkred;', 'Below 75%', NULL, '2017-03-22 12:30:00', '2020-04-08 18:11:10', NULL),
	('nbu_(g?bsr($|_(c|p|s|t).+)|overview|bsr_job_results|bw_jobs)', 2, 'nbu_(g?bsr($|_(c|p|s|t).+)|overview|bsr_job_results|bw_jobs)', 'bsr', '>=', '75', 'background-color: lightpink; color: red;', '75%', NULL, '2017-03-22 12:30:00', '2020-04-08 18:11:09', NULL),
	('nbu_(g?bsr($|_(c|p|s|t).+)|overview|bsr_job_results|bw_jobs)', 3, 'nbu_(g?bsr($|_(c|p|s|t).+)|overview|bsr_job_results|bw_jobs)', 'bsr', '>=', '90', 'background-color: gold; color: brown;', '90%', NULL, '2017-03-22 12:30:00', '2020-04-08 18:11:09', NULL),
	('nbu_(g?bsr($|_(c|p|s|t).+)|overview|bsr_job_results|bw_jobs)', 4, 'nbu_(g?bsr($|_(c|p|s|t).+)|overview|bsr_job_results|bw_jobs)', 'bsr', '>=', '95', 'background-color: greenyellow; color: green;', '95%', NULL, '2017-03-22 12:30:00', '2020-04-08 18:11:08', NULL),
	('nbu_(g?bsr($|_(c|p|s|t).+)|overview|bsr_job_results|bw_jobs)', 5, 'nbu_(g?bsr($|_(c|p|s|t).+)|overview|bsr_job_results|bw_jobs)', 'bsr', '>=', '98', 'background-color: lightgreen; color: green;', '98%', NULL, '2017-03-22 12:30:00', '2020-04-08 18:11:08', NULL),
	('nbu_audit', 1, 'nbu_audit', 'vault', '=', NULL, 'background-color: greenyellow; color: green;', 'Without vaulting', NULL, '2017-10-09 15:02:36', '2017-10-09 15:08:03', NULL),
	('nbu_audit', 2, 'nbu_audit', 'vault', '!=', NULL, 'background-color: lightgreen; color: green;', 'With vaulting', NULL, '2017-10-09 15:03:30', '2017-10-09 15:08:07', NULL),
	('nbu_bw_jobs', 0, 'nbu_bw_jobs', 'in_bsr', '=', '0', 'background-color: lightblue; color: blue;', 'No BSR jobs', NULL, '2017-03-22 12:18:38', '2017-06-02 10:07:48', NULL),
	('nbu_codes', 1, 'nbu_codes', 'code', '=', '0', 'background-color: lightgreen; color: green;', 'Success', NULL, '2017-05-12 13:36:29', '2017-05-12 13:37:35', NULL),
	('nbu_codes', 2, 'nbu_codes', 'code', '=', '1', 'background-color: greenyellow; color: green;', 'Partial', NULL, '2017-05-12 13:36:29', '2017-05-12 13:37:32', NULL),
	('nbu_codes', 3, 'nbu_codes', 'code', '>', '1', 'background-color: lightpink; color: red;', 'Failed', NULL, '2017-05-12 13:36:29', '2017-05-12 13:38:06', NULL),
	('nbu_codes', 4, 'nbu_codes', 'field', '!=', 'status', 'background-color: lightblue; color: blue;', 'Other codes', NULL, '2017-05-12 13:36:29', '2017-05-12 13:39:50', NULL),
	('nbu_consecutive_failures', 1, 'nbu_consecutive_failures', 'failures', '>', '0', 'background-color: lightgreen; color: green;', 'Less than 3 failures', NULL, '2017-08-31 15:40:54', '2017-08-31 15:45:54', NULL),
	('nbu_consecutive_failures', 2, 'nbu_consecutive_failures', 'failures', '>', '2', 'background-color: greenyellow; color: green;', 'Less than 5 failures', NULL, '2017-08-31 15:41:31', '2017-08-31 15:41:39', NULL),
	('nbu_consecutive_failures', 3, 'nbu_consecutive_failures', 'failures', '>', '4', 'background-color: gold; color: brown;', 'Less than 7 failures', NULL, '2017-08-31 15:42:23', '2017-08-31 15:42:29', NULL),
	('nbu_consecutive_failures', 4, 'nbu_consecutive_failures', 'failures', '>', '6', 'background-color: lightpink; color: red;', 'Less than 10 failures', NULL, '2017-08-31 15:43:22', '2017-08-31 15:47:02', NULL),
	('nbu_consecutive_failures', 5, 'nbu_consecutive_failures', 'failures', '>', '9', 'background-color: salmon; color: darkred;', 'More than 10 failures', NULL, '2017-08-31 15:44:04', '2017-08-31 15:47:04', NULL),
	('nbu_consecutive_failures', 6, 'nbu_consecutive_failures', 'existing', '=', 'N', 'background-color: silver; color: black;', 'Non-existing client/policy', NULL, '2017-08-31 15:44:04', '2017-10-20 09:44:04', NULL),
	('nbu_flist', 1, 'nbu_flist', 'policytype', 'regexp', 'win|ux|vmw', 'background-color: lightgreen; color: green;', 'FS backup objects', NULL, '2018-10-26 13:14:14', '2019-04-01 13:47:26', NULL),
	('nbu_flist', 2, 'nbu_flist', 'policytype', 'not regexp', 'win|ux|vmw', 'background-color: lightblue; color: blue;', 'INTEG backup objects', NULL, '2018-10-26 13:14:55', '2019-04-01 13:47:28', NULL),
	('nbu_flist', 3, 'nbu_flist', 'schedule_type', 'regexp', 'full', 'font-weight:bold;', 'Full backup objects', NULL, '2018-10-26 13:14:55', '2018-10-26 13:15:02', NULL),
	('nbu_images', 1, 'nbu_images', 'id_path', 'regexp', '^@', 'background-color: honeydew; font-style: italic;', 'Virtual tape', NULL, '2018-10-26 13:14:55', '2018-10-26 13:15:02', NULL),
	('nbu_images', 2, 'nbu_images', 'id_path', 'regexp', '^\\w', 'background-color: lightcyan; color: black;', 'Physical tape', NULL, '2018-10-26 13:14:55', '2018-10-26 13:15:02', NULL),
	('nbu_puredisks', 1, 'nbu_puredisks', 'used', '>', '0', 'background-color: lightgreen; color: green;', 'Normal', NULL, '2020-03-05 08:37:24', '2020-03-05 08:39:18', NULL),
	('nbu_puredisks', 2, 'nbu_puredisks', 'used', '>', '80', 'background-color: gold; color: brown;', 'High', NULL, '2020-03-05 08:37:24', '2020-03-05 08:40:46', NULL),
	('nbu_puredisks', 3, 'nbu_puredisks', 'used', '>', '90', 'background-color: lightpink; color: red;', 'Critical', NULL, '2020-03-05 08:37:24', '2020-03-05 08:41:29', NULL),
	('nbu_slps', 1, 'nbu_slps', 'usefor', '=', 'Snapshot', 'background-color: greenyellow; color: green;', 'Snapshot', NULL, '2019-04-17 15:02:15', '2019-04-17 15:02:35', NULL),
	('nbu_slps', 2, 'nbu_slps', 'usefor', 'REGEXP', 'Backup', 'background-color: lightgreen; color: green;', 'Backup', NULL, '2019-04-17 15:00:28', '2019-04-17 15:03:37', NULL),
	('nbu_slps', 3, 'nbu_slps', 'usefor', '=', 'Duplication', 'background-color: lightblue; color: blue;', 'Duplication', NULL, '2019-04-17 15:01:24', '2019-04-17 15:01:47', NULL),
	('nbu_slps', 4, 'nbu_slps', 'usefor', '=', 'Replication', 'background-color: silver; color: black;', 'Replication', NULL, '2019-04-17 15:03:21', '2019-04-17 15:03:33', NULL),
	('nbu_status_breakdown', 1, 'nbu_status_breakdown', 'status', '=', '0', 'background-color: lightgreen; color: green;', 'Successful', NULL, '2019-05-24 12:56:10', '2019-05-24 13:00:47', NULL),
	('nbu_status_breakdown', 2, 'nbu_status_breakdown', 'status', '=', '1', 'background-color: greenyellow; color: green;', 'Partially successful', NULL, '2019-05-24 12:56:57', '2019-05-24 13:00:46', NULL),
	('nbu_status_breakdown', 3, 'nbu_status_breakdown', 'status', '>', '1', 'background-color: salmon; color: darkred;', 'Failures', NULL, '2019-05-24 12:57:38', '2019-05-24 13:01:16', NULL),
	('nbu_vault_(c|s)', 1, 'nbu_vault_(c|s)', 'name', '!=', ' ', 'background-color: lightblue; color: blue;', 'Profile item', NULL, '2017-07-26 09:48:01', '2017-07-26 10:06:23', NULL),
	('nbu_vault_profiles', 1, 'nbu_vault_profiles', 'clients', 'regexp', '0|', 'background-color: lightpink; color: red;', 'Without clients', NULL, '2017-07-26 09:46:59', '2017-07-26 09:58:06', NULL),
	('nbu_vault_profiles', 2, 'nbu_vault_profiles', 'clients', '>', '0', 'background-color: lightblue; color: blue;', 'With clients', NULL, '2017-07-26 09:47:07', '2017-07-26 09:56:05', NULL),
	('nbu_vault_robots', 1, 'nbu_vault_robots', 'vaults', '=', '0', 'background-color: lightpink; color: red;', 'Without vaults', NULL, '2017-07-26 09:44:38', '2017-07-26 09:53:26', NULL),
	('nbu_vault_robots', 2, 'nbu_vault_robots', 'vaults', '>', '0', 'background-color: lightblue; color: blue;', 'With vaults', NULL, '2017-07-26 09:45:08', '2017-07-26 09:56:07', NULL),
	('nbu_vault_vaults', 1, 'nbu_vault_vaults', 'profiles', '=', '0', 'background-color: lightpink; color: red;', 'Without profiles', NULL, '2017-07-26 09:45:48', '2017-07-26 09:53:30', NULL),
	('nbu_vault_vaults', 2, 'nbu_vault_vaults', 'profiles', '>', '0', 'background-color: lightblue; color: blue;', 'With profiles', NULL, '2017-07-26 09:45:54', '2017-07-26 09:56:10', NULL);

INSERT INTO `core_links` (`source`, `field`, `ord`, `target`, `filter`, `operator`, `value`, `created`, `updated`, `obsoleted`) VALUES
	('nbu(_bsr)?_jobs', 'backupid', 1, 'nbu_flist', 'masterserver', '=', '%masterserver%', '2017-03-20 15:38:43', '2018-10-26 13:37:14', NULL),
	('nbu(_bsr)?_jobs', 'backupid', 2, 'nbu_flist', 'backupid', '=', '%backupid%', '2017-03-20 15:38:43', '2018-10-26 13:35:48', NULL),
	('nbu(_bsr)?_jobs', 'childjobs', 1, 'nbu_jobs', 'parentjob', '=', '%parentjob%', '2017-03-20 15:36:14', '2017-04-10 15:06:36', NULL),
	('nbu(_bsr)?_jobs', 'policy', 1, 'nbu_policies', 'name', '=', '%policy%', '2017-03-20 15:37:51', '2020-04-09 13:16:17', NULL),
	('nbu(_bsr)?_jobs', 'schedule', 1, 'nbu_schedules', 'policyname', '=', '%policy%', '2017-03-20 15:38:11', '2020-04-09 13:16:16', NULL),
	('nbu(_bsr)?_jobs', 'schedule', 2, 'nbu_schedules', 'name', '=', '%schedule%', '2017-03-20 15:38:43', '2020-04-09 13:16:09', NULL),
	('nbu(_bsr)?_jobs', 'status', 1, 'nbu_codes', 'field', '=', 'status', '2017-03-20 15:38:43', '2017-05-12 13:19:39', NULL),
	('nbu(_bsr)?_jobs', 'status', 2, 'nbu_codes', 'code', '=', '%status%', '2017-03-20 15:38:43', '2017-05-12 13:19:38', NULL),
	('nbu_bsr($|_(c|p|s).+)', 'bsr', 1, 'nbu_bsr_jobs', 'bw_day', '=', '%day%', '2017-03-22 12:23:55', '2020-04-08 17:41:38', NULL),
	('nbu_bsr($|_(c|p|s).+)', 'jobs', 1, 'nbu_bsr_jobs', 'bw_day', '=', '%day%', '2017-03-22 12:23:55', '2020-04-08 17:41:43', NULL),
	('nbu_bw_jobs', 'bsr', 1, 'nbu_bsr_jobs', 'bw_day', '=', '%bw_day%', '2020-04-08 18:03:26', '2020-04-08 18:27:44', NULL),
	('nbu_bw_jobs', 'bsr', 10, 'nbu_bsr_jobs', 'status', '>', '1', '2020-04-08 18:03:26', '2020-04-09 14:47:57', NULL),
	('nbu_bw_jobs', 'clients', 1, 'nbu_bw_jobs_clients', 'bw_day', '=', '%bw_day%', '2020-04-08 18:03:26', '2020-04-08 18:27:44', NULL),
	('nbu_bw_jobs', 'customers', 1, 'nbu_bw_jobs_customers', 'bw_day', '=', '%bw_day%', '2020-04-08 18:03:26', '2020-04-08 18:27:44', NULL),
	('nbu_bw_jobs', 'in_bsr', 1, 'nbu_bsr_jobs', 'bw_day', '=', '%bw_day%', '2020-04-08 18:03:26', '2020-04-08 18:27:54', NULL),
	('nbu_bw_jobs', 'jobs', 1, 'nbu_jobs', 'bw_day', '=', '%bw_day%', '2020-04-08 18:03:26', '2020-04-08 18:43:19', NULL),
	('nbu_bw_jobs', 'masterservers', 1, 'nbu_bw_jobs_masterservers', 'bw_day', '=', '%bw_day%', '2020-04-08 18:03:26', '2020-04-08 18:27:44', NULL),
	('nbu_bw_jobs', 'policies', 1, 'nbu_bw_jobs_policies', 'bw_day', '=', '%bw_day%', '2020-04-08 18:03:26', '2020-04-08 18:27:44', NULL),
	('nbu_bw_jobs', 'policytypes', 1, 'nbu_bw_jobs_policytypes', 'bw_day', '=', '%bw_day%', '2020-04-08 18:03:26', '2020-04-08 18:27:44', NULL),
	('nbu_bw_jobs', 'schedules', 1, 'nbu_bw_jobs_schedules', 'bw_day', '=', '%bw_day%', '2020-04-08 18:03:26', '2020-04-08 18:27:44', NULL),
	('nbu_bw_jobs', 'scheduletypes', 1, 'nbu_bw_jobs_scheduletypes', 'bw_day', '=', '%bw_day%', '2020-04-08 18:03:26', '2020-04-08 18:27:44', NULL),
	('nbu_bw_jobs', 'towers', 1, 'nbu_bw_jobs_towers', 'bw_day', '=', '%bw_day%', '2020-04-08 18:03:26', '2020-04-08 18:27:44', NULL),
	('nbu_bw_jobs_(client|d)', 'bsr', 5, 'nbu_bsr_jobs', 'client', '=', '%client%', '2020-04-08 18:03:26', '2020-04-09 15:06:18', NULL),
	('nbu_bw_jobs_(client|d)', 'client', 1, 'nbu_clients_distinct', 'name', '=', '%client%', '2017-06-13 11:03:39', '2020-04-09 15:06:16', NULL),
	('nbu_bw_jobs_(client|d)', 'in_bsr', 5, 'nbu_bsr_jobs', 'client', '=', '%client%', '2020-04-08 18:03:26', '2020-04-09 15:06:19', NULL),
	('nbu_bw_jobs_(client|d)', 'jobs', 5, 'nbu_jobs', 'client', '=', '%client%', '2020-04-08 18:03:26', '2020-04-09 15:06:21', NULL),
	('nbu_bw_jobs_(m|d)', 'bsr', 2, 'nbu_bsr_jobs', 'masterserver', '=', '%masterserver%', '2020-04-08 18:03:26', '2020-04-09 13:13:20', NULL),
	('nbu_bw_jobs_(m|d)', 'in_bsr', 2, 'nbu_bsr_jobs', 'masterserver', '=', '%masterserver%', '2020-04-08 18:03:26', '2020-04-09 13:14:38', NULL),
	('nbu_bw_jobs_(m|d)', 'jobs', 2, 'nbu_jobs', 'masterserver', '=', '%masterserver%', '2020-04-08 18:03:26', '2020-04-09 13:15:28', NULL),
	('nbu_bw_jobs_(policies|d)', 'bsr', 3, 'nbu_bsr_jobs', 'policy', '=', '%policy%', '2020-04-08 18:03:26', '2020-04-09 13:13:51', NULL),
	('nbu_bw_jobs_(policies|d)', 'in_bsr', 3, 'nbu_bsr_jobs', 'policy', '=', '%policy%', '2020-04-08 18:03:26', '2020-04-09 13:14:48', NULL),
	('nbu_bw_jobs_(policies|d)', 'jobs', 3, 'nbu_jobs', 'policy', '=', '%policy%', '2020-04-08 18:03:26', '2020-04-09 13:15:19', NULL),
	('nbu_bw_jobs_(policies|d)', 'policy', 1, 'nbu_policies', 'name', '=', '%policy%', '2017-03-20 15:37:51', '2020-04-09 13:16:17', NULL),
	('nbu_bw_jobs_(schedules|d)', 'bsr', 4, 'nbu_bsr_jobs', 'schedule', '=', '%schedule%', '2020-04-08 18:03:26', '2020-04-09 13:14:01', NULL),
	('nbu_bw_jobs_(schedules|d)', 'in_bsr', 4, 'nbu_bsr_jobs', 'schedule', '=', '%schedule%', '2020-04-08 18:03:26', '2020-04-09 13:14:54', NULL),
	('nbu_bw_jobs_(schedules|d)', 'jobs', 4, 'nbu_jobs', 'schedule', '=', '%schedule%', '2020-04-08 18:03:26', '2020-04-09 13:15:14', NULL),
	('nbu_bw_jobs_(schedules|d)', 'schedule', 1, 'nbu_schedules', 'policyname', '=', '%policy%', '2017-03-20 15:38:11', '2020-04-09 13:16:16', NULL),
	('nbu_bw_jobs_(schedules|d)', 'schedule', 2, 'nbu_schedules', 'name', '=', '%schedule%', '2017-03-20 15:38:43', '2020-04-09 13:16:09', NULL),
	('nbu_bw_jobs_clients', 'bsr', 9, 'nbu_bsr_jobs', 'client', '=', '%client%', '2020-04-08 18:03:26', '2020-04-08 18:27:44', NULL),
	('nbu_bw_jobs_clients', 'in_bsr', 9, 'nbu_bsr_jobs', 'client', '=', '%client%', '2020-04-08 18:03:26', '2020-04-08 18:27:54', NULL),
	('nbu_bw_jobs_clients', 'jobs', 9, 'nbu_jobs', 'client', '=', '%client%', '2020-04-08 18:03:26', '2020-04-09 14:52:41', NULL),
	('nbu_bw_jobs_customers', 'bsr', 3, 'nbu_bsr_jobs', 'customer', '=', '%customer%', '2020-04-08 18:03:26', '2020-04-08 18:27:44', NULL),
	('nbu_bw_jobs_customers', 'in_bsr', 3, 'nbu_bsr_jobs', 'customer', '=', '%customer%', '2020-04-08 18:03:26', '2020-04-08 18:27:54', NULL),
	('nbu_bw_jobs_customers', 'jobs', 3, 'nbu_jobs', 'customer', '=', '%customer%', '2020-04-08 18:03:26', '2020-04-09 14:52:41', NULL),
	('nbu_bw_jobs_masterservers', 'bsr', 4, 'nbu_bsr_jobs', 'masterserver', '=', '%masterserver%', '2020-04-08 18:03:26', '2020-04-08 18:27:44', NULL),
	('nbu_bw_jobs_masterservers', 'in_bsr', 4, 'nbu_bsr_jobs', 'masterserver', '=', '%masterserver%', '2020-04-08 18:03:26', '2020-04-08 18:27:54', NULL),
	('nbu_bw_jobs_masterservers', 'jobs', 4, 'nbu_jobs', 'masterserver', '=', '%masterserver%', '2020-04-08 18:03:26', '2020-04-09 14:52:41', NULL),
	('nbu_bw_jobs_policies', 'bsr', 6, 'nbu_bsr_jobs', 'policy', '=', '%policy%', '2020-04-08 18:03:26', '2020-04-08 18:27:44', NULL),
	('nbu_bw_jobs_policies', 'in_bsr', 6, 'nbu_bsr_jobs', 'policy', '=', '%policy%', '2020-04-08 18:03:26', '2020-04-08 18:27:54', NULL),
	('nbu_bw_jobs_policies', 'jobs', 6, 'nbu_jobs', 'policy', '=', '%policy%', '2020-04-08 18:03:26', '2020-04-09 14:52:41', NULL),
	('nbu_bw_jobs_policytypes', 'bsr', 5, 'nbu_bsr_jobs', 'policytype', '=', '%policytype%', '2020-04-08 18:03:26', '2020-04-08 18:27:44', NULL),
	('nbu_bw_jobs_policytypes', 'in_bsr', 5, 'nbu_bsr_jobs', 'policytype', '=', '%policytype%', '2020-04-08 18:03:26', '2020-04-08 18:27:54', NULL),
	('nbu_bw_jobs_policytypes', 'jobs', 5, 'nbu_jobs', 'policytype', '=', '%policytype%', '2020-04-08 18:03:26', '2020-04-09 14:52:41', NULL),
	('nbu_bw_jobs_schedules', 'bsr', 8, 'nbu_bsr_jobs', 'schedule', '=', '%schedule%', '2020-04-08 18:03:26', '2020-04-08 18:27:44', NULL),
	('nbu_bw_jobs_schedules', 'in_bsr', 8, 'nbu_bsr_jobs', 'schedule', '=', '%schedule%', '2020-04-08 18:03:26', '2020-04-08 18:27:54', NULL),
	('nbu_bw_jobs_schedules', 'jobs', 8, 'nbu_jobs', 'schedule', '=', '%schedule%', '2020-04-08 18:03:26', '2020-04-09 14:52:41', NULL),
	('nbu_bw_jobs_scheduletypes', 'bsr', 7, 'nbu_bsr_jobs', 'scheduletype', '=', '%scheduletype%', '2020-04-08 18:03:26', '2020-04-08 18:27:44', NULL),
	('nbu_bw_jobs_scheduletypes', 'in_bsr', 7, 'nbu_bsr_jobs', 'scheduletype', '=', '%scheduletype%', '2020-04-08 18:03:26', '2020-04-08 18:27:54', NULL),
	('nbu_bw_jobs_scheduletypes', 'jobs', 7, 'nbu_jobs', 'scheduletype', '=', '%scheduletype%', '2020-04-08 18:03:26', '2020-04-09 14:52:41', NULL),
	('nbu_bw_jobs_towers', 'bsr', 2, 'nbu_bsr_jobs', 'tower', '=', '%tower%', '2020-04-08 18:03:26', '2020-04-08 18:27:44', NULL),
	('nbu_bw_jobs_towers', 'in_bsr', 2, 'nbu_bsr_jobs', 'tower', '=', '%tower%', '2020-04-08 18:03:26', '2020-04-08 18:27:54', NULL),
	('nbu_bw_jobs_towers', 'jobs', 2, 'nbu_jobs', 'tower', '=', '%tower%', '2020-04-08 18:03:26', '2020-04-09 14:52:41', NULL),
	('nbu_clients', 'failures', 2, 'nbu_jobs', 'client', '=', '%name%', '2017-03-20 14:01:30', '2017-03-20 14:50:23', NULL),
	('nbu_clients', 'failures', 3, 'nbu_jobs', 'status', '>', '1', '2017-03-20 14:01:30', '2017-03-20 14:50:24', NULL),
	('nbu_clients', 'jobs', 2, 'nbu_jobs', 'client', '=', '%name%', '2017-03-20 14:01:30', '2017-03-20 14:48:02', NULL),
	('nbu_clients_distinct', 'failures', 1, 'nbu_jobs', 'client', '=', '%name%', '2017-03-20 14:01:30', '2017-12-15 10:13:51', NULL),
	('nbu_clients_distinct', 'failures', 2, 'nbu_jobs', 'status', '>', '1', '2017-03-20 14:01:30', '2017-12-15 10:13:53', NULL),
	('nbu_clients_distinct', 'jobs', 1, 'nbu_jobs', 'client', '=', '%name%', '2017-03-20 14:01:30', '2017-12-15 10:13:49', NULL),
	('nbu_consecutive_failures', 'failures', 1, 'nbu_jobs', 'client', '=', '%client%', '2017-08-31 15:48:03', '2017-08-31 15:48:03', NULL),
	('nbu_consecutive_failures', 'failures', 2, 'nbu_jobs', 'policy', '=', '%policy%', '2017-08-31 15:48:22', '2017-08-31 15:48:22', NULL),
	('nbu_consecutive_failures', 'failures', 3, 'nbu_jobs', 'schedule', '=', '%schedule%', '2017-08-31 15:48:45', '2017-08-31 15:48:45', NULL),
	('nbu_g?bsr($|_(c|p|s).+)', 'bsr', 2, 'nbu_bsr_jobs', 'status', '>', '1', '2017-03-22 12:23:55', '2020-04-08 17:41:32', NULL),
	('nbu_g?bsr_client', 'bsr', 3, 'nbu_bsr_jobs', 'status', '>', '1', '2017-03-22 15:08:20', '2018-01-04 10:35:27', NULL),
	('nbu_g?bsr_client', 'jobs', 2, 'nbu_bsr_jobs', 'client', '=', '%client%', '2017-03-22 15:08:20', '2018-01-04 10:35:35', NULL),
	('nbu_g?bsr_customer', 'bsr', 2, 'nbu_bsr_jobs', 'customer', '=', '%customer%', '2017-03-22 15:15:20', '2018-01-04 10:35:40', NULL),
	('nbu_g?bsr_customer', 'jobs', 2, 'nbu_bsr_jobs', 'customer', '=', '%customer%', '2017-03-22 15:15:20', '2018-01-04 10:35:42', NULL),
	('nbu_g?bsr_policy', 'bsr', 2, 'nbu_bsr_jobs', 'policytype', '=', '%policy%', '2017-03-22 15:15:29', '2018-01-04 10:35:46', NULL),
	('nbu_g?bsr_policy', 'jobs', 2, 'nbu_bsr_jobs', 'policytype', '=', '%policy%', '2017-03-22 15:15:29', '2018-01-04 10:35:48', NULL),
	('nbu_g?bsr_schedule', 'bsr', 2, 'nbu_bsr_jobs', 'scheduletype', '=', '%schedule%', '2017-03-22 15:15:36', '2018-01-04 10:35:53', NULL),
	('nbu_g?bsr_schedule', 'jobs', 2, 'nbu_bsr_jobs', 'scheduletype', '=', '%schedule%', '2017-03-22 15:15:36', '2018-01-04 10:35:58', NULL),
	('nbu_overview_clients', 'bsr', 1, 'nbu_bsr_jobs', 'client', '=', '%name%', '2017-03-20 14:01:30', '2017-06-13 10:18:26', NULL),
	('nbu_overview_clients', 'bsr', 2, 'nbu_bsr_jobs', 'status', '>', '1', '2017-03-20 14:01:30', '2017-06-13 10:18:27', NULL),
	('nbu_overview_clients', 'bsrjobs', 1, 'nbu_bsr_jobs', 'client', '=', '%name%', '2017-03-20 14:01:30', '2017-06-13 10:18:40', NULL),
	('nbu_overview_clients', 'failures', 1, 'nbu_jobs', 'client', '=', '%name%', '2017-03-20 14:01:30', '2017-06-13 10:18:26', NULL),
	('nbu_overview_clients', 'failures', 2, 'nbu_jobs', 'status', '>', '1', '2017-03-20 14:01:30', '2017-06-13 10:18:27', NULL),
	('nbu_overview_clients', 'jobs', 1, 'nbu_jobs', 'client', '=', '%name%', '2017-03-20 14:01:30', '2017-06-13 10:18:40', NULL),
	('nbu_overview_clients', 'policies', 1, 'nbu_clients', 'name', '=', '%name%', '2017-03-20 14:01:30', '2017-06-13 10:18:26', NULL),
	('nbu_overview_customers', 'bsr', 1, 'nbu_bsr_jobs', 'customer', '=', '%customer%', '2017-06-13 11:03:39', '2017-06-13 11:04:54', NULL),
	('nbu_overview_customers', 'bsr', 2, 'nbu_bsr_jobs', 'status', '>', '1', '2017-06-13 11:03:39', '2017-06-13 11:03:39', NULL),
	('nbu_overview_customers', 'bsrjobs', 1, 'nbu_bsr_jobs', 'customer', '=', '%customer%', '2017-06-13 11:03:39', '2017-06-13 11:05:06', NULL),
	('nbu_overview_customers', 'clients', 1, 'nbu_clients_distinct', 'customer', '=', '%customer%', '2017-06-13 11:03:39', '2017-12-15 09:53:27', NULL),
	('nbu_overview_customers', 'failures', 1, 'nbu_jobs', 'customer', '=', '%customer%', '2017-06-13 11:03:39', '2017-06-13 11:04:54', NULL),
	('nbu_overview_customers', 'failures', 2, 'nbu_jobs', 'status', '>', '1', '2017-06-13 11:03:39', '2017-06-13 11:03:39', NULL),
	('nbu_overview_customers', 'integ_clients', 1, 'nbu_clients_distinct', 'customer', '=', '%customer%', '2017-06-13 11:03:39', '2017-12-15 09:53:31', NULL),
	('nbu_overview_customers', 'integ_clients', 2, 'nbu_clients_distinct', 'type', '=', 'INTEG', '2017-06-13 11:03:39', '2017-12-15 09:53:31', NULL),
	('nbu_overview_customers', 'jobs', 1, 'nbu_jobs', 'customer', '=', '%customer%', '2017-06-13 11:03:39', '2017-06-13 11:05:06', NULL),
	('nbu_overview_customers', 'policies', 1, 'nbu_policies', 'customer', '=', '%customer%', '2017-06-13 11:03:39', '2017-06-13 11:08:21', NULL),
	('nbu_overview_jobs', 'fail', 1, 'nbu_jobs', 'jobtype', '=', '%jobtype%', '2017-06-01 15:45:25', '2017-06-02 09:39:25', NULL),
	('nbu_overview_jobs', 'fail', 2, 'nbu_jobs', 'subtype', '=', '%subtype%', '2017-06-01 15:45:46', '2017-06-02 09:39:26', NULL),
	('nbu_overview_jobs', 'fail', 3, 'nbu_jobs', 'state', '=', '%state%', '2017-06-01 15:46:05', '2017-06-02 09:39:27', NULL),
	('nbu_overview_jobs', 'fail', 4, 'nbu_jobs', 'operation', '=', '%operation%', '2017-06-01 15:46:24', '2017-06-02 09:39:27', NULL),
	('nbu_overview_jobs', 'fail', 5, 'nbu_jobs', 'status', '>', '1', '2017-06-01 16:01:39', '2017-06-02 09:39:27', NULL),
	('nbu_overview_jobs', 'jobs', 1, 'nbu_jobs', 'jobtype', '=', '%jobtype%', '2017-06-01 15:45:25', '2017-06-02 09:39:28', NULL),
	('nbu_overview_jobs', 'jobs', 2, 'nbu_jobs', 'subtype', '=', '%subtype%', '2017-06-01 15:45:46', '2017-06-02 09:39:28', NULL),
	('nbu_overview_jobs', 'jobs', 3, 'nbu_jobs', 'state', '=', '%state%', '2017-06-01 15:46:05', '2017-06-02 09:39:28', NULL),
	('nbu_overview_jobs', 'jobs', 4, 'nbu_jobs', 'operation', '=', '%operation%', '2017-06-01 15:46:24', '2017-06-02 09:39:29', NULL),
	('nbu_overview_jobs', 'success', 1, 'nbu_jobs', 'jobtype', '=', '%jobtype%', '2017-06-01 15:45:25', '2017-06-02 09:39:29', NULL),
	('nbu_overview_jobs', 'success', 2, 'nbu_jobs', 'subtype', '=', '%subtype%', '2017-06-01 15:45:46', '2017-06-02 09:39:29', NULL),
	('nbu_overview_jobs', 'success', 3, 'nbu_jobs', 'state', '=', '%state%', '2017-06-01 15:46:05', '2017-06-02 09:39:30', NULL),
	('nbu_overview_jobs', 'success', 4, 'nbu_jobs', 'operation', '=', '%operation%', '2017-06-01 15:46:24', '2017-06-02 09:39:30', NULL),
	('nbu_overview_jobs', 'success', 5, 'nbu_jobs', 'status', '<=', '1', '2017-06-01 16:01:39', '2017-06-02 09:39:31', NULL),
	('nbu_policies', 'clients', 1, 'nbu_clients', 'policyname', '=', '%name%', '2017-03-20 14:35:01', '2017-03-20 14:39:15', NULL),
	('nbu_policies', 'failures', 1, 'nbu_jobs', 'policy', '=', '%name%', '2017-03-20 13:01:30', '2017-03-20 13:50:21', NULL),
	('nbu_policies', 'failures', 2, 'nbu_jobs', 'status', '>', '1', '2017-03-20 13:01:30', '2017-03-20 13:50:24', NULL),
	('nbu_policies', 'jobs', 1, 'nbu_jobs', 'policy', '=', '%name%', '2017-03-20 13:01:30', '2017-03-20 13:44:59', NULL),
	('nbu_policies', 'schedules', 1, 'nbu_schedules', 'policyname', '=', '%name%', '2017-03-20 14:35:01', '2017-03-20 15:52:41', NULL),
	('nbu_schedules', 'failures', 1, 'nbu_jobs', 'policy', '=', '%policyname%', '2017-03-20 15:18:56', '2017-03-20 15:18:56', NULL),
	('nbu_schedules', 'failures', 2, 'nbu_jobs', 'schedule', '=', '%name%', '2017-03-20 15:19:12', '2017-03-20 15:19:12', NULL),
	('nbu_schedules', 'failures', 3, 'nbu_jobs', 'status', '>', '1', '2017-03-20 15:19:30', '2017-03-20 15:19:30', NULL),
	('nbu_schedules', 'jobs', 1, 'nbu_jobs', 'policy', '=', '%policyname%', '2017-03-20 15:17:52', '2017-03-20 15:18:24', NULL),
	('nbu_schedules', 'jobs', 2, 'nbu_jobs', 'schedule', '=', '%name%', '2017-03-20 15:18:39', '2017-03-20 15:18:39', NULL),
	('nbu_schedules', 'policyname', 1, 'nbu_policies', 'name', '=', '%policyname%', '2017-03-20 15:17:18', '2017-03-20 15:17:18', NULL),
	('nbu_slps', 'policies', 1, 'nbu_policies', 'masterserver', '=', '%masterserver%', '2019-04-23 09:12:40', '2019-04-23 09:12:40', NULL),
	('nbu_slps', 'policies', 2, 'nbu_policies', 'res', '=', '%name%', '2019-04-23 09:13:20', '2019-04-23 09:15:07', NULL),
	('nbu_slps', 'schedules', 1, 'nbu_schedules', 'masterserver', '=', '%masterserver%', '2019-04-23 09:13:49', '2019-04-23 09:13:49', NULL),
	('nbu_slps', 'schedules', 2, 'nbu_schedules', 'res', '=', '%name%', '2019-04-23 09:14:19', '2019-04-23 09:14:19', NULL),
	('nbu_status_breakdown', 'count', 1, 'nbu_bsr_jobs', 'status', '=', '%status%', '2019-05-24 12:52:53', '2019-05-24 13:01:31', NULL),
	('nbu_vault_(c|s)', 'profile', 1, 'nbu_vault_profiles', 'name', '=', '%profile%', '2017-07-26 10:01:54', '2017-07-26 10:05:06', NULL),
	('nbu_vault_profiles', 'classes', 1, 'nbu_vault_classes', 'profile', '=', '%name%', '2017-07-24 16:01:34', '2017-07-24 16:01:34', NULL),
	('nbu_vault_profiles', 'clients', 1, 'nbu_vault_clients', 'profile', '=', '%name%', '2017-07-24 16:01:34', '2017-07-24 16:01:34', NULL),
	('nbu_vault_profiles', 'schedules', 1, 'nbu_vault_schedules', 'profile', '=', '%name%', '2017-07-24 16:01:34', '2017-07-25 09:42:16', NULL),
	('nbu_vault_robots', 'profiles', 1, 'nbu_vault_profiles', 'robot', '=', '%name%', '2017-07-24 16:02:56', '2017-07-24 16:02:56', NULL),
	('nbu_vault_robots', 'vaults', 1, 'nbu_vault_vaults', 'robot', '=', '%name%', '2017-07-24 15:52:08', '2017-07-24 15:55:27', NULL),
	('nbu_vault_vaults', 'profiles', 1, 'nbu_vault_profiles', 'vault', '=', '%name%', '2017-07-24 16:01:34', '2017-07-24 16:01:34', NULL);

INSERT INTO `core_reports` (`ord`, `name`, `category`, `title`, `created`, `updated`, `obsoleted`) VALUES
	(1, 'nbu_policies', 'NBU Reports', 'Policies', '2017-02-13 10:31:58', '2017-04-12 12:28:38', NULL),
	(2, 'nbu_schedules', 'NBU Reports', 'Schedules', '2017-03-20 08:55:23', '2017-04-12 12:28:41', NULL),
	(3, 'nbu_clients_distinct', 'NBU Reports', 'Clients', '2017-02-13 10:06:41', '2017-12-15 10:19:44', NULL),
	(4, 'nbu_clients', 'NBU Reports', 'Clients & policies', '2017-02-13 10:06:41', '2017-12-15 10:19:50', NULL),
	(4, 'nbu_slps', 'NBU Reports', 'Storage Lifecycle Policies', '2017-02-13 10:06:41', '2017-12-15 10:19:50', NULL),
	(5, '---', 'NBU Reports', '', '2017-03-22 15:31:14', '2017-06-13 10:02:04', NULL),
	(5, 'nbu_bw_jobs', 'NBU Reports', 'Job list', '2017-03-20 08:55:38', '2020-04-08 17:42:35', NULL),
	(6, 'nbu_consecutive_failures', 'NBU Reports', 'Consecutive failures', '2017-03-22 15:31:14', '2017-08-31 15:29:54', NULL),
	(7, 'nbu_bsr_job_results', 'NBU Reports', 'Failing BSR Job Results', '2017-03-22 15:31:14', '2018-04-27 14:32:21', NULL),
	(8, '---', 'NBU Reports', ' ', '2017-03-22 15:31:14', '2018-04-27 14:21:44', NULL),
	(9, 'nbu_images', 'NBU Reports', 'Images per client', '2017-03-22 15:31:14', '2018-04-27 14:21:44', NULL),
	(12, 'nbu_flist', 'NBU Reports', 'Backup/Image objects', '2018-08-30 14:06:49', '2018-09-05 10:28:15', NULL),
	(13, '---', 'NBU Reports', ' ', '2018-08-30 14:07:11', '2018-10-26 13:02:17', NULL),
	(14, 'nbu_overview_jobs', 'NBU Reports', 'Jobs overview', '2017-06-01 15:18:00', '2018-10-26 13:02:19', NULL),
	(15, 'nbu_overview_customers', 'NBU Reports', 'Customers overview', '2017-06-13 10:47:39', '2018-10-26 13:02:21', NULL),
	(16, 'nbu_overview_clients', 'NBU Reports', 'Clients overview', '2017-06-01 15:18:00', '2018-10-26 13:02:23', NULL),
	(17, 'nbu_bsr_jobs', NULL, 'BSR Job list', '2017-03-20 08:56:19', '2018-10-26 13:02:25', NULL),
	(18, 'nbu_codes', NULL, 'Codes', '2017-05-12 13:06:47', '2018-10-26 13:02:29', NULL),
	(20, 'nbu_bsr', 'BSR', 'Daily BSR', '2017-03-20 08:57:55', '2018-01-04 10:34:49', NULL),
	(21, 'nbu_bsr_client', 'BSR', 'Daily BSR per client', '2017-03-20 08:58:13', '2018-01-04 10:22:31', NULL),
	(22, 'nbu_bsr_customer', 'BSR', 'Daily BSR per customer', '2017-03-20 08:58:13', '2018-01-04 10:22:31', NULL),
	(23, 'nbu_bsr_policy', 'BSR', 'Daily BSR per policy type', '2017-03-20 08:58:13', '2018-01-04 10:22:32', NULL),
	(24, 'nbu_bsr_schedule', 'BSR', 'Daily BSR per schedule type', '2017-03-20 08:58:13', '2018-01-04 10:22:32', NULL),
	(25, 'nbu_bsr_type', 'BSR', 'Daily BSR per job type', '2017-03-20 08:58:13', '2018-01-04 10:22:33', NULL),
	(26, '---', 'BSR', '', '2017-03-22 15:31:14', '2018-01-04 10:22:34', NULL),
	(27, 'nbu_gbsr', 'BSR', 'Global BSR', '2017-03-22 15:31:34', '2018-01-04 10:22:56', NULL),
	(28, 'nbu_gbsr_client', 'BSR', 'Global BSR per client', '2018-01-04 10:23:22', '2018-01-04 10:23:22', NULL),
	(29, 'nbu_gbsr_customer', 'BSR', 'Global BSR per customer', '2018-01-04 10:23:39', '2018-01-04 10:23:39', NULL),
	(30, 'nbu_gbsr_policy', 'BSR', 'Global BSR per policy type', '2018-01-04 10:24:02', '2018-01-04 10:25:03', NULL),
	(31, 'nbu_gbsr_schedule', 'BSR', 'Global BSR per schedule type', '2018-01-04 10:24:28', '2018-01-04 10:25:01', NULL),
	(32, 'nbu_gbsr_type', 'BSR', 'Global BSR per job type', '2018-01-04 10:24:54', '2018-01-04 10:24:54', NULL),
	(33, '---', 'BSR', ' ', '2018-08-30 14:02:52', '2018-08-30 14:02:52', NULL),
	(34, 'nbu_status_breakdown', 'BSR', 'Status breakdown', '2018-08-30 14:04:16', '2019-05-24 13:02:21', NULL),
	(40, 'nbu_vault_robots', 'Vaults', 'Robots', '2017-07-24 15:33:40', '2018-01-04 10:21:14', NULL),
	(41, 'nbu_vault_vaults', 'Vaults', 'Vaults', '2017-07-24 15:44:25', '2018-01-04 10:21:16', NULL),
	(42, 'nbu_vault_profiles', 'Vaults', 'Profiles', '2017-07-24 15:56:03', '2018-01-04 10:21:20', NULL),
	(43, '---', 'Vaults', '', '2017-07-26 09:59:46', '2018-01-04 10:21:22', NULL),
	(44, 'nbu_vault_clients', 'Vaults', 'Clients', '2017-07-25 09:34:05', '2018-01-04 10:21:24', NULL),
	(45, 'nbu_vault_classes', 'Vaults', 'Classes', '2017-07-25 09:34:05', '2018-01-04 10:21:32', NULL),
	(46, 'nbu_vault_schedules', 'Vaults', 'Schedules', '2017-07-25 09:34:45', '2018-01-04 10:21:35', NULL),
	(50, 'nbu_puredisks', 'Devices', 'Pure Disks', '2020-03-05 08:29:30', '2020-03-05 08:31:29', NULL),
	(90, 'nbu_audit', 'Audits', 'Configuration audit', '2017-10-09 14:55:29', '2018-01-04 10:21:10', NULL),
	(91, '---', 'Audits', '', '2018-01-18 13:01:58', '2018-01-18 13:08:03', NULL),
	(92, 'audit_qrs', 'Audits', 'QRS', '2018-01-18 13:01:58', '2018-01-18 13:08:03', NULL),
	(93, 'audit_missing', 'Audits', 'Missing hosts', '2018-01-18 13:01:58', '2018-01-18 13:08:03', NULL),
	(94, 'audit_partial', 'Audits', 'Partial hosts', '2018-01-18 13:01:58', '2018-01-18 13:08:03', NULL),
	(95, 'audit_complete', 'Audits', 'Complete hosts', '2018-01-18 13:01:58', '2018-01-18 13:08:03', NULL);

INSERT INTO `core_sorts` (`report`, `ord`, `source`, `field`, `sort`, `created`, `updated`, `obsoleted`) VALUES
	('nbu_(bsr_)?jobs', 1, 'nbu_(bsr_)?jobs', 'jobid', 'DESC', '2017-08-28 15:15:57', '2017-08-28 15:20:31', NULL),
	('nbu_overview_clients', 1, 'nbu_overview_clients', 'customer', 'ASC', '2020-04-22 11:42:41', '2020-04-22 11:42:42', NULL);

INSERT INTO `core_sources` (`report`, `ord`, `name`, `title`, `description`, `fields`, `link`, `pivot`, `tower`, `customer`, `timeperiod`, `limit`, `created`, `updated`, `obsoleted`) VALUES
	('audit_complete', 1, 'audit_complete', 'Complete hosts', 'QRS fully complete servers/RLIs', NULL, NULL, NULL, 0, 0, 0, 10, '2018-01-18 13:04:22', '2018-01-18 13:08:19', NULL),
	('audit_missing', 1, 'audit_missing', 'Missing hosts', 'QRS completely missing servers/RLIs', NULL, NULL, NULL, 0, 0, 0, 10, '2018-01-18 13:04:22', '2018-01-18 13:08:19', NULL),
	('audit_partial', 1, 'audit_partial', 'Partial hosts', 'QRS partially completed servers/RLIs', NULL, NULL, NULL, 0, 0, 0, 10, '2018-01-18 13:04:22', '2018-01-18 13:08:19', NULL),
	('audit_qrs', 1, 'audit_qrs', 'QRS', 'QRS servers/RLIs', NULL, NULL, NULL, 0, 0, 0, 10, '2018-01-18 13:04:22', '2018-01-18 13:08:19', NULL),
	('nbu_audit', 1, 'nbu_audit', 'Configuration audit', 'List of clients with policies, schedules and vault profiles', NULL, NULL, NULL, 0, 0, 0, 10, '2017-10-09 14:55:59', '2017-10-09 15:06:33', NULL),
	('nbu_bsr', 1, 'nbu_bsr', 'BSR', 'Daily BSR per day', NULL, NULL, NULL, 1, 1, 1, 7, '2017-03-22 12:20:38', '2017-05-12 13:27:04', NULL),
	('nbu_bsr_all', 1, 'nbu_bsr', 'BSR', 'Daily BSR per day', NULL, NULL, NULL, 1, 1, 1, 7, '2017-03-22 15:32:54', '2017-05-12 13:27:06', NULL),
	('nbu_bsr_all', 2, 'nbu_bsr_customer', 'BSR per customer', 'Daily BSR per customer', NULL, NULL, 'day,customer', 1, 1, 1, 10, '2017-03-22 15:33:17', '2017-05-12 13:25:48', NULL),
	('nbu_bsr_all', 3, 'nbu_bsr_policy', 'BSR per policy type', 'Daily BSR per policy type', NULL, NULL, 'day,policy', 1, 1, 1, 10, '2017-03-22 15:33:34', '2017-05-12 13:25:50', NULL),
	('nbu_bsr_client', 1, 'nbu_bsr_client', 'BSR per client', 'Daily BSR per client', NULL, NULL, 'client,day', 1, 1, 1, 10, '2017-03-22 15:03:40', '2017-05-12 13:25:51', NULL),
	('nbu_bsr_customer', 1, 'nbu_bsr_customer', 'BSR per customer', 'Daily BSR per customer', NULL, NULL, 'day,customer', 1, 1, 1, 10, '2017-03-22 15:03:40', '2017-05-12 13:25:51', NULL),
	('nbu_bsr_jobs', 1, 'nbu_bsr_jobs', 'BSR Jobs', 'List of BSR jobs', NULL, NULL, NULL, 1, 1, 1, 10, '2017-03-20 09:01:31', '2017-05-12 13:25:52', NULL),
	('nbu_bsr_job_results', 1, 'nbu_bsr_job_results', 'Failing BSR Job results', 'Failing BSR jobs and ther results', NULL, NULL, NULL, 1, 1, 1, 10, '2018-04-27 14:23:13', '2018-04-27 14:31:59', NULL),
	('nbu_bsr_policy', 1, 'nbu_bsr_policy', 'BSR per policy type', 'Daily BSR per policy type', NULL, NULL, 'day,policy', 1, 1, 1, 10, '2017-03-22 15:03:40', '2017-05-12 13:25:52', NULL),
	('nbu_bsr_schedule', 1, 'nbu_bsr_schedule', 'BSR per schedule type', 'Daily BSR per schedule type', NULL, NULL, 'day,schedule', 1, 1, 1, 10, '2017-03-22 15:03:40', '2017-05-12 13:25:53', NULL),
	('nbu_bsr_type', 1, 'nbu_bsr_type', 'BSR per job type', 'Daily BSR per job type', NULL, NULL, 'day,type', 1, 1, 1, 10, '2017-03-22 15:03:40', '2017-05-12 13:25:53', NULL),
	('nbu_bw_jobs', 1, 'nbu_bw_jobs', 'Jobs per backup day', 'List of jobs by backup day', NULL, NULL, NULL, 1, 1, 1, 10, '2020-04-08 17:44:14', '2020-04-09 13:49:13', NULL),
	('nbu_bw_jobs_clients', 1, 'nbu_bw_jobs_clients', 'Jobs per client', 'List of jobs by client', NULL, NULL, NULL, 1, 1, 1, 10, '2020-04-08 17:44:14', '2020-04-08 18:18:35', NULL),
	('nbu_bw_jobs_customers', 1, 'nbu_bw_jobs_customers', 'Jobs per customer', 'List of jobs by customer', NULL, NULL, NULL, 1, 1, 1, 10, '2020-04-08 17:44:14', '2020-04-08 18:18:35', NULL),
	('nbu_bw_jobs_detail', 1, 'nbu_bw_jobs_detail', 'Jobs (detailed)', 'Detailed list of jobs', NULL, NULL, NULL, 1, 1, 1, 10, '2020-04-08 17:44:14', '2020-04-08 18:18:35', NULL),
	('nbu_bw_jobs_masterservers', 1, 'nbu_bw_jobs_masterservers', 'Jobs per Master server', 'List of jobs by Master server', NULL, NULL, NULL, 1, 1, 1, 10, '2020-04-08 17:44:14', '2020-04-08 18:18:35', NULL),
	('nbu_bw_jobs_policies', 1, 'nbu_bw_jobs_policies', 'Jobs per policy', 'List of jobs by policy', NULL, NULL, NULL, 1, 1, 1, 10, '2020-04-08 17:44:14', '2020-04-08 18:18:35', NULL),
	('nbu_bw_jobs_policytypes', 1, 'nbu_bw_jobs_policytypes', 'Jobs per policy type', 'List of jobs by policy type', NULL, NULL, NULL, 1, 1, 1, 10, '2020-04-08 17:44:14', '2020-04-08 18:18:35', NULL),
	('nbu_bw_jobs_schedules', 1, 'nbu_bw_jobs_schedules', 'Jobs per schedule', 'List of jobs by schedule', NULL, NULL, NULL, 1, 1, 1, 10, '2020-04-08 17:44:14', '2020-04-08 18:18:35', NULL),
	('nbu_bw_jobs_scheduletypes', 1, 'nbu_bw_jobs_scheduletypes', 'Jobs per schedule type', 'List of jobs by schedule type', NULL, NULL, NULL, 1, 1, 1, 10, '2020-04-08 17:44:14', '2020-04-08 18:18:35', NULL),
	('nbu_bw_jobs_towers', 1, 'nbu_bw_jobs_towers', 'Jobs per tower', 'List of jobs by tower', NULL, NULL, NULL, 1, 1, 1, 10, '2020-04-08 17:44:14', '2020-04-08 18:18:35', NULL),
	('nbu_clients', 1, 'nbu_clients', 'Clients with policies', 'List of clients with policies', NULL, NULL, NULL, 1, 1, 1, 10, '2017-02-13 10:09:51', '2017-12-15 10:19:21', NULL),
	('nbu_clients_distinct', 1, 'nbu_clients_distinct', 'Clients', 'List of clients', NULL, NULL, NULL, 1, 1, 1, 10, '2017-02-13 10:09:51', '2017-12-15 10:19:16', NULL),
	('nbu_codes', 1, 'nbu_codes', 'Codes', 'List of codes', NULL, NULL, NULL, 0, 0, 0, 25, '2017-05-12 13:07:10', '2017-06-13 11:26:10', NULL),
	('nbu_consecutive_failures', 1, 'nbu_consecutive_failures', 'Consecutive failures', 'List of consecutive failures', NULL, NULL, NULL, 1, 1, 1, 10, '2017-08-31 15:30:54', '2017-08-31 15:31:17', NULL),
	('nbu_flist', 1, 'nbu_flist', 'Backup/Image objects', 'List of objects for client/backup ID', NULL, NULL, NULL, 1, 1, 1, 10, '2018-10-26 13:03:57', '2018-10-26 13:04:38', NULL),
	('nbu_gbsr', 1, 'nbu_gbsr', 'BSR', 'Global BSR', NULL, NULL, NULL, 1, 1, 1, 10, '2018-01-04 10:27:31', '2018-01-04 10:28:45', NULL),
	('nbu_gbsr_client', 1, 'nbu_gbsr_client', 'BSR per client', 'Global BSR per client', NULL, NULL, NULL, 1, 1, 1, 10, '2018-01-04 10:28:41', '2018-01-04 10:28:41', NULL),
	('nbu_gbsr_customer', 1, 'nbu_gbsr_customer', 'BSR per customer', 'Global BSR per customer', NULL, NULL, NULL, 1, 1, 1, 10, '2018-01-04 10:28:41', '2018-01-04 10:28:41', NULL),
	('nbu_gbsr_policy', 1, 'nbu_gbsr_policy', 'BSR per policy type', 'Global BSR per policy type', NULL, NULL, NULL, 1, 1, 1, 10, '2018-01-04 10:28:41', '2018-01-04 10:31:01', NULL),
	('nbu_gbsr_schedule', 1, 'nbu_gbsr_schedule', 'BSR per schedule type', 'Global BSR per schedule type', NULL, NULL, NULL, 1, 1, 1, 10, '2018-01-04 10:28:41', '2018-01-04 10:28:41', NULL),
	('nbu_gbsr_type', 1, 'nbu_gbsr_type', 'BSR per job type', 'Global BSR per job type', NULL, NULL, NULL, 1, 1, 1, 10, '2018-01-04 10:28:41', '2018-01-04 10:28:41', NULL),
	('nbu_images', 1, 'nbu_images', 'Images per client', 'List of images per client', NULL, NULL, NULL, 1, 1, 0, 10, '2018-01-04 10:28:41', '2018-01-04 10:28:41', NULL),
	('nbu_jobs', 1, 'nbu_jobs', 'Jobs', 'List of jobs', NULL, NULL, NULL, 1, 1, 1, 10, '2017-03-20 09:01:05', '2017-05-12 13:25:58', NULL),
	('nbu_overview_clients', 1, 'nbu_overview_clients', 'Clients overview', 'Overview of clients', NULL, NULL, NULL, 1, 1, 1, 10, '2017-02-13 10:09:51', '2017-06-13 11:28:35', NULL),
	('nbu_overview_customers', 1, 'nbu_overview_customers', 'Customers overview', 'Overview of customers', NULL, NULL, NULL, 1, 1, 1, 25, '2017-06-13 10:46:59', '2017-06-13 11:28:28', NULL),
	('nbu_overview_jobs', 1, 'nbu_overview_jobs', 'Jobs overview', 'Overview of jobs', NULL, NULL, NULL, 1, 1, 1, 25, '2017-06-01 15:19:03', '2017-06-02 09:38:54', NULL),
	('nbu_policies', 1, 'nbu_policies', 'Policies', 'List of policies', NULL, NULL, NULL, 1, 1, 1, 10, '2017-02-13 10:32:12', '2017-05-12 13:25:59', NULL),
	('nbu_schedules', 1, 'nbu_schedules', 'Schedules', 'List of schedules', NULL, NULL, NULL, 1, 1, 1, 10, '2017-02-13 10:32:12', '2017-05-12 13:25:59', NULL),
	('nbu_slps', 1, 'nbu_slps', 'Storage Lifecycle Policies', 'List of Storage Lifecycle Policies (SLP`s)', NULL, NULL, NULL, 1, 1, 0, 10, '2019-04-17 14:41:50', '2019-04-17 14:41:50', NULL),
	('nbu_status_breakdown', 1, 'nbu_status_breakdown', 'Status breakdown', 'List of occurences of BSR job statuses', NULL, NULL, NULL, 1, 1, 1, 10, '2019-05-24 12:50:34', '2019-05-24 13:02:04', NULL),
	('nbu_vault_classes', 1, 'nbu_vault_classes', 'Classes', 'List of included classes', NULL, NULL, NULL, 0, 0, 0, 10, '2017-07-24 15:45:21', '2017-07-25 09:36:39', NULL),
	('nbu_vault_clients', 1, 'nbu_vault_clients', 'Clients', 'List of included clients', NULL, NULL, NULL, 0, 0, 0, 10, '2017-07-24 15:45:21', '2017-07-25 09:36:33', NULL),
	('nbu_vault_profiles', 1, 'nbu_vault_profiles', 'Profiles', 'List of vault profiles', NULL, NULL, NULL, 0, 0, 0, 10, '2017-07-24 15:56:37', '2017-07-24 15:56:37', NULL),
	('nbu_vault_robots', 1, 'nbu_vault_robots', 'Robots', 'List of robots', NULL, NULL, NULL, 0, 0, 0, 10, '2017-07-24 15:34:10', '2017-07-24 15:41:36', NULL),
	('nbu_vault_schedules', 1, 'nbu_vault_schedules', 'Schedules', 'List of included schedules', NULL, NULL, NULL, 0, 0, 0, 10, '2017-07-24 15:45:21', '2017-07-25 09:36:45', NULL),
	('nbu_vault_vaults', 1, 'nbu_vault_vaults', 'Vaults', 'List of vaults', NULL, NULL, NULL, 0, 0, 0, 10, '2017-07-24 15:45:21', '2017-07-24 15:45:21', NULL),
	('nbu_puredisks', 1, 'nbu_puredisks', 'Pure Disks', 'List of devices (pure disks)', NULL, NULL, NULL, 0, 0, 0, 25, '2020-03-05 08:31:06', '2020-03-05 08:31:06', NULL);

CREATE DATABASE IF NOT EXISTS mars_backup;
CREATE TABLE IF NOT EXISTS mars_backup.bpdbjobs_report LIKE mars40.bpdbjobs_report;

ALTER EVENT nbu_event ENABLE;
