/* if you are using sqlite the following are not necessary */
DROP DATABASE IF EXISTS payment;
CREATE DATABASE payment;
/* if failed on following CREATE USER sql due to exits laolao already just delete it and redo >.<*/
-- CREATE USER 'laolao'@'localhost' IDENTIFIED BY 'laolao';
-- GRANT ALL PRIVILEGES ON payment.* TO 'laolao'@'localhost';
USE payment;
/* if you are using sqlite please start here */
/* key tables has referenced foreign keys*/
-- --------------------------------------------------------
--
-- Table structure for table `se_user`
--

DROP TABLE IF EXISTS `se_user`;
CREATE TABLE IF NOT EXISTS `se_user` (
  `UID` int(10) NOT NULL AUTO_INCREMENT,
  `USERNAME` char(20) CHARACTER SET utf8 NOT NULL,
  `PASSWD` char(32) CHARACTER SET utf8 NOT NULL,
  `EMAIL` char(40) CHARACTER SET utf8 NOT NULL,
  `TYPE` tinyint(1) NOT NULL,
  `BALANCE` decimal(11,2) DEFAULT '0.00',
  `PHONE` char(11) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `BLACKLIST` tinyint(1) NOT NULL DEFAULT '0',
  `REALNAME` char(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `IDENTITY` char(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `AUTHENTICATED` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`UID`),
  UNIQUE KEY `ID` (`UID`),
  UNIQUE KEY `USERNAME` (`USERNAME`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=11 ;

/* if you are using sqlite please use following instead */
/*
DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `UID` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
  `USERNAME` char(20) NOT NULL UNIQUE,
  `PASSWD` char(32) NOT NULL,
  `EMAIL` char(30) NOT NULL,
  `TYPE` tinyint(1) NOT NULL,
  `BALANCE` int(11) DEFAULT '0',
  `PHONE` char(11) DEFAULT NULL
);
*/


DROP TABLE IF EXISTS se_goods;
CREATE TABLE se_goods(
	id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
	/* if you are using sqlite please use following instead */
	/* id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT */
	type INTEGER NOT NULL
	/*	1: general goods
		2: hotel room
		3: airplane ticket
	It is better to use get funcions in GeneralGoodsModel and other models*/
)ENGINE=InnoDB  DEFAULT CHARSET=utf8;
-- --------------------------------------------------------

--
-- Table structure for table `se_address`
--

CREATE TABLE IF NOT EXISTS `se_address` (
  `ADDRESSID` int(11) NOT NULL AUTO_INCREMENT,
  `UID` int(11) NOT NULL,
  `PROVINCE` char(50) DEFAULT NULL,
  `CITY` char(50) DEFAULT NULL,
  `STRICT` char(50) DEFAULT NULL,
  `STREET` char(100) DEFAULT NULL,
  PRIMARY KEY (`ADDRESSID`),
  KEY `UID` (`UID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2;
/* if you are using sqlite please use following instead */
/*
CREATE TABLE IF NOT EXISTS `se_address` (
  `ADDRESSID` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  `UID` int(11) NOT NULL,
  `PROVINCE` char(50) DEFAULT NULL,
  `CITY` char(50) DEFAULT NULL,
  `STRICT` char(50) DEFAULT NULL,
  `STREET` char(100) DEFAULT NULL
);
*/


DROP TABLE IF EXISTS se_orders;
CREATE TABLE se_orders(
	ID INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
	/* if you are using sqlite please use following instead */
	/* id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT */
	BUYER INT(10) NOT NULL,
	SELLER INT(10) NOT NULL,
	TOTALPRICE numeric(15,2) NOT NULL,
    	ADDRESSID INT DEFAULT NULL,
	ISDELETE varchar(5) CHARACTER SET utf8 NOT NULL DEFAULT 'NO',
	STATE char(20) CHARACTER SET utf8 NOT NULL DEFAULT 'created',
   	 ISAUDIT varchar(5) CHARACTER SET utf8 NOT NULL DEFAULT 'NO',
	foreign key (BUYER) references `se_user`(`UID`) on delete cascade,
	foreign key (SELLER) references `se_user`(`UID`) on delete cascade,
   	 foreign key (ADDRESSID) references `se_address`(`ADDRESSID`) on delete cascade
)ENGINE=InnoDB  DEFAULT CHARSET=utf8;



/* group 1 */
--
--
-- --------------------------------------------------------

--
-- Table structure for table `se_buyer`
--

CREATE TABLE IF NOT EXISTS `se_buyer` (
  `UID` int(11) NOT NULL,
  `PASSWDPAYMENT` char(32) CHARACTER SET utf8 NOT NULL,
  `CREDIT` int(11) NOT NULL DEFAULT '0',
  `VIP` tinyint(1) NOT NULL DEFAULT '0',
   PRIMARY KEY (`UID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;
/* if you are using sqlite please use following instead */
/*
CREATE TABLE IF NOT EXISTS `buyer` (
  `UID` int(11) NOT NULL,
  `PASSWDPAYMENT` char(32) NOT NULL,
  `CREDIT` int(11) NOT NULL DEFAULT '0',
  `VIP` tinyint(1) NOT NULL DEFAULT '0',
  `AUTHENTICATED` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`UID`)
);
*/

--
-- Table structure for table 'se_seller'
--

CREATE TABLE IF NOT EXISTS `se_seller` (
  `UID` int(11) NOT NULL,
  `PASSWDCONSIGN` char(32) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
   KEY `se_seller_ibfk_1` (`UID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `se_usercard`
--



/* if you are using sqlite please use following instead */
/*
CREATE TABLE IF NOT EXISTS `seller` (
  `UID` int(11) NOT NULL,
  `PASSWDCONSIGN` char(32) NOT NULL
);
*/
CREATE TABLE IF NOT EXISTS `se_usercard` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `USERID` int(11) DEFAULT NULL,
  `CARDID` char(50) NOT NULL,
   PRIMARY KEY (`ID`),
   KEY `se_user_id` (`USERID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `se_buyer`
--
ALTER TABLE `se_buyer`
  ADD CONSTRAINT `se_buyer_ibfk_1` FOREIGN KEY (`UID`) REFERENCES `se_user` (`UID`);

--
-- Constraints for table `se_address`
--
ALTER TABLE `se_address`
  ADD CONSTRAINT `se_address_ibfk_1` FOREIGN KEY (`UID`) REFERENCES `se_user` (`UID`);

--
-- Constraints for table `se_seller`
--
ALTER TABLE `se_seller`
  ADD CONSTRAINT `se_seller_ibfk_1` FOREIGN KEY (`UID`) REFERENCES `se_user` (`UID`);

--
-- Constraints for table `se_usercard`
--

ALTER TABLE `se_usercard`
  ADD CONSTRAINT `se_usercard_ibfk_1` FOREIGN KEY (`USERID`) REFERENCES `se_user` (`UID`);

/* group 2 */


DROP TABLE IF EXISTS se_order_goods;
CREATE TABLE se_order_goods(
	OID INTEGER NOT NULL,
	GID INTEGER NOT NULL,
	PRICE numeric(15,2) NOT NULL,
	AMOUNT INTEGER NOT NULL,
	STATE char(20) DEFAULT 'created',
	NAME VARCHAR(256) CHARACTER SET utf8 NOT NULL,
    IMGURL VARCHAR(256) CHARACTER SET utf8,
	PRIMARY KEY(oid,gid),
	foreign key (OID) references se_orders(ID) on delete cascade,
	foreign key (GID) references se_goods(ID) on delete cascade
)ENGINE=InnoDB  DEFAULT CHARSET=utf8;
DROP TABLE IF EXISTS se_order_operation;
CREATE TABLE se_order_operation(
    	`OID` INTEGER NOT NULL,
	`OPERATION` char(20) CHARACTER SET utf8 NOT NULL,
	`TIME` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`OPERATOR` INTEGER NOT NULL DEFAULT 0,
	primary key(`OID`,`TIME`),
	foreign key (`OID`) references `se_orders`(`ID`) on delete cascade
)ENGINE=InnoDB  DEFAULT CHARSET=utf8;

/* group 3 */


DROP TABLE IF EXISTS se_general_goods;
CREATE TABLE se_general_goods(
	id INTEGER NOT NULL PRIMARY KEY,
	name VARCHAR(256),
	price numeric(15,2),
	seller_id INTEGER,
	bought_count INTEGER,
	score numeric(11,10),
	score_count INTEGER,
	place VARCHAR(64),
	image_uri VARCHAR(256),
	stock INTEGER,
	description VARCHAR(1024),
	foreign key (id) references se_goods(id) on delete cascade,
	foreign key (seller_id) references se_user(UID) on delete cascade
)ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS se_hotel_room;
CREATE TABLE se_hotel_room(
	id INTEGER NOT NULL PRIMARY KEY,
	name VARCHAR(256),
	price numeric(15,2),
	seller_id INTEGER,
	bought_count INTEGER,	
	score numeric(11,10),
	score_count INTEGER,
	place VARCHAR(64),
	image_uri VARCHAR(256),
	stock INTEGER,
	description VARCHAR(1024),
	date_time BIGINT,
	suit_type VARCHAR(32),
	foreign key (id) references se_goods(id) on delete cascade,
	foreign key (seller_id) references se_user(UID) on delete cascade
)ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS se_airplane_ticket;
CREATE TABLE se_airplane_ticket(
	id INTEGER NOT NULL PRIMARY KEY,
	name VARCHAR(256),
	seller_id INTEGER,
	bought_count INTEGER,
	score numeric(11,10),
	score_count INTEGER,
	image_uri VARCHAR(256),
	stock INTEGER,
	description VARCHAR(1024),
	price numeric(15,2),
	departure_date_time BIGINT,
	arrival_date_time BIGINT,
	departure_place VARCHAR(64),
	arrival_place VARCHAR(64),
	non_stop BOOLEAN,
	carbin_type VARCHAR(32),
	foreign key (id) references se_goods(id) on delete cascade,
	foreign key (seller_id) references se_user(UID) on delete cascade
)ENGINE=InnoDB  DEFAULT CHARSET=utf8;

/* if you are using sqlite please use following instead */
/*
DROP TABLE IF EXISTS general_goods;
CREATE TABLE general_goods(
	id INTEGER NOT NULL PRIMARY KEY,
	name VARCHAR(256),
	price numeric(15,2),
	seller_id INTEGER,
	bought_count INTEGER,
	score numeric(11,10),
	score_count INTEGER,
	place VARCHAR(64),
	image_uri VARCHAR(256),
	stock INTEGER,
	description VARCHAR(1024),
	foreign key (id) references goods(id) on delete cascade,
	foreign key (seller_id) references user(UID) on delete cascade
);

DROP TABLE IF EXISTS hotel_room;
CREATE TABLE hotel_room(
	id INTEGER NOT NULL PRIMARY KEY,
	name VARCHAR(256),
	price numeric(15,2),
	seller_id INTEGER,
	bought_count INTEGER,
	score numeric(11,10),
	score_count INTEGER,
	place VARCHAR(64),
	image_uri VARCHAR(256),
	stock INTEGER,
	description VARCHAR(1024),
	date_time BIGINT,
	suit_type VARCHAR(32),
	foreign key (id) references goods(id) on delete cascade,
	foreign key (seller_id) references user(UID) on delete cascade
);

DROP TABLE IF EXISTS airplane_ticket;
CREATE TABLE airplane_ticket(
	id INTEGER NOT NULL PRIMARY KEY,
	name VARCHAR(256),
	seller_id INTEGER,
	bought_count INTEGER,
	score numeric(11,10),
	score_count INTEGER,
	image_uri VARCHAR(256),
	stock INTEGER,
	description VARCHAR(1024),
	price numeric(15,2),
	departure_date_time BIGINT,
	arrival_date_time BIGINT,
	departure_place VARCHAR(64),
	arrival_place VARCHAR(64),
	non_stop BOOLEAN,
	carbin_type VARCHAR(32),
	foreign key (id) references goods(id) on delete cascade,
	foreign key (seller_id) references user(UID) on delete cascade
);
*/

DROP TABLE IF EXISTS se_browse_history;
CREATE TABLE se_browse_history(
	id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
	/* if you are using sqlite please use following instead */
	/* id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT */
	good_id INTEGER,
	user_id INTEGER,
	date_time BIGINT,
	foreign key (good_id) references se_goods(id) on delete cascade,
	foreign key (user_id) references se_user(UID) on delete cascade
)ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS se_search_history;
CREATE TABLE se_search_history(
	id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
	/* if you are using sqlite please use following instead */
	/* id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT */
	search_key VARCHAR(256),
	user_id INTEGER,
	date_time BIGINT,
	foreign key (user_id) references se_user(UID) on delete cascade
)ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS se_feedback;
CREATE TABLE se_feedback(
	id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
	/* if you are using sqlite please use following instead */
	/* id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, */
	user_id INTEGER,
	transaction_id INTEGER,
	goods_id INTEGER,
	score INTEGER,
	comment VARCHAR(1024),
	date_time DATETIME,
	foreign key (user_id) references se_user(UID) on delete cascade,
	foreign key (transaction_id) references se_orders(id) on delete cascade,
	foreign key (goods_id) references se_goods(id) on delete cascade
	/* if you are using sqlite please use following instead */
	/* foreign key (transaction_id) references transactions(id) on delete cascade, */
)ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS se_shopping_cart;
CREATE TABLE se_shopping_cart(
	id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
	/* if you are using sqlite please use following instead */
	/* id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT */
	user_id INTEGER,
	good_id INTEGER,
	good_count INTEGER,
	foreign key (good_id) references se_goods(id) on delete cascade,
	foreign key (user_id) references se_user(UID) on delete cascade
)ENGINE=InnoDB  DEFAULT CHARSET=utf8;
/* group 4 */
CREATE TABLE IF NOT EXISTS `se_auditor` (
  `id` int(10) NOT NULL,
  `passwd` char(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE se_dispute(
	oid INTEGER NOT NULL,
	buyer_reason varchar(256) NOT NULL,
	seller_reason varchar(256) DEFAULT NULL,
	time int(11) NOT NULL,
	PRIMARY KEY(oid),
	foreign key(oid) references se_orders(ID) on delete cascade
)ENGINE=InnoDB  DEFAULT CHARSET=utf8;

CREATE TABLE se_dispute_result(
	oid INTEGER NOT NULL,
	aid INTEGER NOT NULL,
	time int(11) NOT NULL,
	result int(1) NOT NULL,
	PRIMARY KEY(oid),
	foreign key(oid) references se_orders(ID) on delete cascade,
	foreign key(aid) references se_auditor(id) on delete cascade
)ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS se_sysaccount;
CREATE TABLE se_sysaccount(
	oid INTEGER NOT NULL ,
	record numeric(15,2) NOT NULL,
	time int(11) NOT NULL,
	foreign key (oid) references se_orders(ID) on delete cascade
)ENGINE=InnoDB  DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS se_audit_error;
CREATE TABLE se_audit_error(
	oid INTEGER NOT NULL,
	need_pay numeric(15,2) NOT NULL,
	actual_pay numeric(15,2) NOT NULL,
	time DATETIME NOT NULL,
	iscorrected int(1) DEFAULT'0' NOT NULL,
	foreign key (oid) references se_orders(ID) on delete cascade
)ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TRIGGER IF EXISTS `check_error`;
DELIMITER //
CREATE TRIGGER `check_error` AFTER INSERT ON `se_sysaccount`
 FOR EACH ROW BEGIN
	DECLARE need_pay DOUBLE;
	DECLARE actual_pay DOUBLE;
	DECLARE cc INT;
	SELECT `totalprice` INTO need_pay FROM `se_orders` WHERE `se_orders`.`id`=new.oid;
	SELECT SUM(`record`) INTO actual_pay FROM `se_sysaccount` WHERE `se_sysaccount`.`oid`=new.oid AND `se_sysaccount`.`record` > 0;
	SELECT COUNT(*) INTO cc FROM `se_audit_error` WHERE `oid`=new.oid;
	IF(cc>0) THEN
		IF(need_pay!=actual_pay) THEN
		UPDATE 	`se_audit_error` SET `actual_pay`=actual_pay, `time`=UNIX_TIMESTAMP(), `iscorrected`=0 WHERE `oid`=new.oid;
		ELSEIF(need_pay=actual_pay) THEN
		UPDATE 	`se_audit_error` SET `iscorrected`=1 WHERE `oid`=new.oid;
		END IF;
	ELSEIF(need_pay!=actual_pay) THEN
	INSERT INTO 
	`se_audit_error` (`oid`, `need_pay`, `actual_pay`, `time`, `iscorrected` ) 
	VALUES (new.oid, need_pay, actual_pay, UNIX_TIMESTAMP(), 0);
	END IF;
    END
//
DELIMITER ;



/* group 5 */
DROP TABLE IF EXISTS se_admin;
CREATE TABLE se_admin (
  	id int(8) NOT NULL AUTO_INCREMENT,
  	name char(32) CHARACTER SET utf8 NOT NULL,
  	password char(32) CHARACTER SET utf8 NOT NULL,
  	type tinyint(1) NOT NULL,
  	PRIMARY KEY (id),
  	UNIQUE KEY (name)

)ENGINE=InnoDB  DEFAULT CHARSET=utf8;
INSERT INTO se_admin VALUES (1, 'root', '123', 0);





CREATE TABLE IF NOT EXISTS `se_card` (
  `ID` char(32) NOT NULL,
  `PASSWD` char(32) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO se_card VALUES ('3500456655263302', '202cb962ac59075b964b07152d234b70');
INSERT INTO se_card VALUES ('3503656656782542', '202cb962ac59075b964b07152d234b70');
INSERT INTO se_card VALUES ('3545842856277646', '202cb962ac59075b964b07152d234b70');
INSERT INTO se_card VALUES ('3558835208007483', '202cb962ac59075b964b07152d234b70');
INSERT INTO se_card VALUES ('36008670281287', '202cb962ac59075b964b07152d234b70');
INSERT INTO se_card VALUES ('36140705258707', '202cb962ac59075b964b07152d234b70');
INSERT INTO se_card VALUES ('40106654787826', '202cb962ac59075b964b07152d234b70');
INSERT INTO se_card VALUES ('4013073022054211', '202cb962ac59075b964b07152d234b70');
INSERT INTO se_card VALUES ('4013153160103002', '202cb962ac59075b964b07152d234b70');
INSERT INTO se_card VALUES ('4013277073065063', '202cb962ac59075b964b07152d234b70');
INSERT INTO se_card VALUES ('4013371650118864', '202cb962ac59075b964b07152d234b70');
INSERT INTO se_card VALUES ('4013475714876225', '202cb962ac59075b964b07152d234b70');
INSERT INTO se_card VALUES ('4013518832253478', '202cb962ac59075b964b07152d234b70');
INSERT INTO se_card VALUES ('4013717753525332', '202cb962ac59075b964b07152d234b70');
INSERT INTO se_card VALUES ('4013726753848065', '202cb962ac59075b964b07152d234b70');
INSERT INTO se_card VALUES ('4013733076775470', '202cb962ac59075b964b07152d234b70');
INSERT INTO se_card VALUES ('4013811357884763', '202cb962ac59075b964b07152d234b70');
INSERT INTO se_card VALUES ('4013823267318162', '202cb962ac59075b964b07152d234b70');

DROP TABLE IF EXISTS se_realname;
CREATE TABLE se_realname (
	`ID` char(32) NOT NULL PRIMARY KEY,
	`NAME` char(32) CHARACTER SET utf8 NOT NULL
);
INSERT INTO se_realname VALUES ('110105197804041313', '江翰竹');
INSERT INTO se_realname VALUES ('110105197804041372', '王澜');
INSERT INTO se_realname VALUES ('110105197804041452', '于治诚');
INSERT INTO se_realname VALUES ('110105197804041858', '翁京耿');
INSERT INTO se_realname VALUES ('110105197804043431', '孙标湖');
INSERT INTO se_realname VALUES ('110105197804044354', '翁贤超');
INSERT INTO se_realname VALUES ('110105197804045314', '梁传建');
INSERT INTO se_realname VALUES ('110105197804047491', '卢睿政');
INSERT INTO se_realname VALUES ('110105197804048873', '连凌功');
INSERT INTO se_realname VALUES ('110105197804049972', '区习慈');
INSERT INTO se_realname VALUES ('130108199703141421', '吴乐曼');
INSERT INTO se_realname VALUES ('130108199703142803', '庄霞涣');
INSERT INTO se_realname VALUES ('130108199703144243', '时润菘');
INSERT INTO se_realname VALUES ('130108199703144307', '胡芬');
INSERT INTO se_realname VALUES ('130108199703144788', '欧馨友');
INSERT INTO se_realname VALUES ('130108199703146361', '史卿秀');
INSERT INTO se_realname VALUES ('130108199703147284', '廉勉晨');
INSERT INTO se_realname VALUES ('130108199703148244', '欧水娟');
INSERT INTO se_realname VALUES ('130108199703148666', '褚荣思');
INSERT INTO se_realname VALUES ('130108199703149685', '符穗泳');
INSERT INTO se_realname VALUES ('230506198303013584', '汤美玉');
INSERT INTO se_realname VALUES ('230506198303013648', '梁开毓');
INSERT INTO se_realname VALUES ('230506198303014704', '龚钧蓓');
INSERT INTO se_realname VALUES ('230506198303015504', '王清清');
INSERT INTO se_realname VALUES ('230506198303015563', '钱翘曼');
INSERT INTO se_realname VALUES ('230506198303015985', '涂翠蔓');
INSERT INTO se_realname VALUES ('230506198303017104', '廉娥童');
INSERT INTO se_realname VALUES ('230506198303017147', '戚卉碧');
INSERT INTO se_realname VALUES ('23050619830301806X', '詹翱寒');
INSERT INTO se_realname VALUES ('330106198406018953', '王房华');
INSERT INTO se_realname VALUES ('33010619840601985X', '易想泰');
INSERT INTO se_realname VALUES ('340100200202201020', '潘开迎');
INSERT INTO se_realname VALUES ('34010020020220108X', '辛楚京');
INSERT INTO se_realname VALUES ('340100200202202146', '丘腾曼');
INSERT INTO se_realname VALUES ('34010020020220300X', '区向培');
INSERT INTO se_realname VALUES ('340100200202203747', '梁炼菲');
INSERT INTO se_realname VALUES ('340100200202204547', '路丽秋');
INSERT INTO se_realname VALUES ('34010020020220458X', '方玲儿');
INSERT INTO se_realname VALUES ('340100200202207721', '王问峦');
INSERT INTO se_realname VALUES ('340100200202208740', '梁家霞');
INSERT INTO se_realname VALUES ('370500197710051653', '王问峦');
INSERT INTO se_realname VALUES ('370500197710053034', '赖窍涛');
INSERT INTO se_realname VALUES ('370500197710053931', '王士男');
INSERT INTO se_realname VALUES ('370500197710054475', '王遍盛');
INSERT INTO se_realname VALUES ('370500197710054539', '鲁明康');
INSERT INTO se_realname VALUES ('370500197710054619', '司徒宇森');
INSERT INTO se_realname VALUES ('370500197710055013', '吕友映');
INSERT INTO se_realname VALUES ('370500197710056593', '龚仲');
INSERT INTO se_realname VALUES ('370500197710057510', '康亮贯');
INSERT INTO se_realname VALUES ('370500197710058476', '汤尘菲');
INSERT INTO se_realname VALUES ('370500198310051653', '王觉钧');
INSERT INTO se_realname VALUES ('370500198310053034', '连瓢韦');
INSERT INTO se_realname VALUES ('370500198310053931', '伍來艾');
INSERT INTO se_realname VALUES ('370500198310054475', '蔡谷冠');
INSERT INTO se_realname VALUES ('370500198310054539', '元镜察');
INSERT INTO se_realname VALUES ('370500198310054619', '王肯兵');
INSERT INTO se_realname VALUES ('370500198310055013', '邢鸣木');
INSERT INTO se_realname VALUES ('370500198310056593', '彭振俊');
INSERT INTO se_realname VALUES ('370500198310057510', '王结达');
INSERT INTO se_realname VALUES ('370500198310058476', '任和歆');

DROP TABLE IF EXISTS se_blacklistappeal;
CREATE TABLE se_blacklistapeal (
  	name char(32) CHARACTER SET utf8 NOT NULL PRIMARY KEY,
  	reason char(255) CHARACTER SET utf8 NOT NULL
)ENGINE=InnoDB  DEFAULT CHARSET=utf8;

