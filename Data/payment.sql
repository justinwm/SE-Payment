-- phpMyAdmin SQL Dump
-- version 3.5.7
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jul 02, 2013 at 07:50 PM
-- Server version: 5.6.10
-- PHP Version: 5.3.15

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `payment`
--

--
-- Dumping data for table `se_address`
--


--
-- Dumping data for table `se_admin`
--

INSERT INTO `se_admin` (`id`, `name`, `password`, `type`) VALUES
(1, 'root', '123', 'this is root administrator');

--
-- Dumping data for table `se_buyer`
--

INSERT INTO `se_buyer` (`UID`, `PASSWDPAYMENT`, `CREDIT`, `VIP`) VALUES
(1, '81dc9bdb52d04dc20036dbd8313ed055', 0, 0),
(3, '202cb962ac59075b964b07152d234b70', 0, 0),
(4, '202cb962ac59075b964b07152d234b70', 0, 0),
(6, '202cb962ac59075b964b07152d234b70', 0, 0),
(7, '202cb962ac59075b964b07152d234b70', 0, 0);

--
-- Dumping data for table `se_card`
--

INSERT INTO `se_card` (`ID`, `PASSWD`) VALUES
('3500456655263302', '202cb962ac59075b964b07152d234b70'),
('3503656656782542', '202cb962ac59075b964b07152d234b70'),
('3545842856277646', '202cb962ac59075b964b07152d234b70'),
('3558835208007483', '202cb962ac59075b964b07152d234b70'),
('36008670281287', '202cb962ac59075b964b07152d234b70'),
('36140705258707', '202cb962ac59075b964b07152d234b70'),
('40106654787826', '202cb962ac59075b964b07152d234b70'),
('4013073022054211', '202cb962ac59075b964b07152d234b70'),
('4013153160103002', '202cb962ac59075b964b07152d234b70'),
('4013277073065063', '202cb962ac59075b964b07152d234b70'),
('4013371650118864', '202cb962ac59075b964b07152d234b70'),
('4013475714876225', '202cb962ac59075b964b07152d234b70'),
('4013518832253478', '202cb962ac59075b964b07152d234b70'),
('4013717753525332', '202cb962ac59075b964b07152d234b70'),
('4013726753848065', '202cb962ac59075b964b07152d234b70'),
('4013733076775470', '202cb962ac59075b964b07152d234b70'),
('4013811357884763', '202cb962ac59075b964b07152d234b70'),
('4013823267318162', '202cb962ac59075b964b07152d234b70');

--
-- Dumping data for table `se_general_goods`
--

INSERT INTO `se_general_goods` (`id`, `name`, `price`, `seller_id`, `bought_count`, `score`, `score_count`, `place`, `image_uri`, `stock`, `description`) VALUES
(1, '???', '10000.00', 2, 0, '0.0000000000', 0, '??', NULL, 10, '????');

--
-- Dumping data for table `se_goods`
--

INSERT INTO `se_goods` (`id`, `type`) VALUES
(1, 1);

--
-- Dumping data for table `se_orders`
--

INSERT INTO `se_orders` (`ID`, `BUYER`, `SELLER`, `TOTALPRICE`, `ADDRESSID`, `ISDELETE`, `STATE`, `ISAUDIT`) VALUES
(69, 1, 5, '605.00', NULL, 'YES', 'canceled', 'NO'),
(70, 2, 2, '12000.00', NULL, 'NO', 'refunding', 'NO'),
(71, 1, 2, '605.00', NULL, 'NO', 'refunded', 'NO'),
(72, 1, 2, '12000.00', NULL, 'YES', 'finished', 'NO'),
(73, 1, 2, '605.00', NULL, 'NO', 'payed', 'NO'),
(74, 1, 2, '12000.00', NULL, 'NO', 'created', 'NO'),
(75, 1, 2, '605.00', NULL, 'NO', 'created', 'NO'),
(76, 1, 2, '12000.00', NULL, 'NO', 'created', 'NO'),
(77, 1, 2, '605.00', NULL, 'NO', 'created', 'NO'),
(78, 1, 2, '12000.00', NULL, 'NO', 'created', 'NO'),
(79, 1, 2, '605.00', NULL, 'NO', 'created', 'NO'),
(80, 1, 2, '12000.00', NULL, 'NO', 'created', 'NO'),
(81, 1, 2, '605.00', NULL, 'NO', 'created', 'NO'),
(82, 1, 5, '12000.00', NULL, 'NO', 'created', 'NO'),
(83, 1, 2, '605.00', NULL, 'NO', 'created', 'NO'),
(84, 1, 2, '12000.00', NULL, 'NO', 'created', 'NO'),
(85, 1, 5, '605.00', NULL, 'NO', 'created', 'NO'),
(86, 1, 2, '12000.00', NULL, 'NO', 'created', 'NO'),
(87, 1, 5, '605.00', NULL, 'NO', 'created', 'NO'),
(88, 1, 2, '12000.00', NULL, 'NO', 'created', 'NO'),
(89, 1, 2, '605.00', NULL, 'NO', 'created', 'NO'),
(90, 1, 2, '12000.00', NULL, 'NO', 'created', 'NO');

--
-- Dumping data for table `se_order_operation`
--

INSERT INTO `se_order_operation` (`OID`, `OPERATION`, `TIME`, `OPERATOR`) VALUES
(69, 'created', '2013-05-18 03:59:01', 11),
(69, 'delete', '2013-05-18 04:04:44', 11),
(69, 'cancel', '2013-06-18 04:00:23', 11),
(70, 'created', '2013-06-18 03:59:01', 11),
(70, 'pay', '2013-06-18 04:00:55', 11),
(70, 'refund', '2013-06-18 04:02:01', 11),
(71, 'created', '2013-06-18 04:00:08', 11),
(71, 'pay', '2013-06-18 04:01:15', 11),
(71, 'refund', '2013-06-18 05:50:32', 11),
(72, 'created', '2013-06-18 04:00:08', 11),
(72, 'pay', '2013-06-18 04:02:17', 11),
(72, 'shipping', '2013-06-18 04:03:03', 14),
(72, 'confirm_receipt', '2013-06-18 04:04:03', 11),
(72, 'delete', '2013-06-18 04:04:40', 11),
(73, 'created', '2013-06-18 04:00:10', 11),
(73, 'pay', '2013-06-18 04:05:34', 11),
(74, 'created', '2013-06-18 04:00:10', 11),
(75, 'created', '2013-06-18 04:00:11', 11),
(76, 'created', '2013-06-18 04:00:11', 11),
(77, 'created', '2013-06-18 04:07:21', 11),
(78, 'created', '2013-06-18 04:07:21', 11),
(79, 'created', '2013-06-18 04:07:22', 11),
(80, 'created', '2013-06-18 04:07:22', 11),
(81, 'created', '2013-06-18 04:07:23', 11),
(82, 'created', '2013-06-18 04:07:23', 11),
(83, 'created', '2013-06-18 04:07:24', 11),
(84, 'created', '2013-06-18 04:07:24', 11),
(85, 'created', '2013-06-18 04:07:25', 11),
(86, 'created', '2013-06-18 04:07:25', 11),
(87, 'created', '2013-06-18 04:07:26', 11),
(88, 'created', '2013-06-18 04:07:26', 11),
(89, 'created', '2013-06-18 04:07:26', 11),
(90, 'created', '2013-06-18 04:07:26', 11);

--
-- Dumping data for table `se_realname`
--

INSERT INTO `se_realname` (`ID`, `NAME`) VALUES
('110105197804041313', '江翰竹'),
('110105197804041372', '王澜'),
('110105197804041452', '于治诚'),
('110105197804041858', '翁京耿'),
('110105197804043431', '孙标湖'),
('110105197804044354', '翁贤超'),
('110105197804045314', '梁传建'),
('110105197804047491', '卢睿政'),
('110105197804048873', '连凌功'),
('110105197804049972', '区习慈'),
('130108199703141421', '吴乐曼'),
('130108199703142803', '庄霞涣'),
('130108199703144243', '时润菘'),
('130108199703144307', '胡芬'),
('130108199703144788', '欧馨友'),
('130108199703146361', '史卿秀'),
('130108199703147284', '廉勉晨'),
('130108199703148244', '欧水娟'),
('130108199703148666', '褚荣思'),
('130108199703149685', '符穗泳'),
('230506198303013584', '汤美玉'),
('230506198303013648', '梁开毓'),
('230506198303014704', '龚钧蓓'),
('230506198303015504', '王清清'),
('230506198303015563', '钱翘曼'),
('230506198303015985', '涂翠蔓'),
('230506198303017104', '廉娥童'),
('230506198303017147', '戚卉碧'),
('23050619830301806X', '詹翱寒'),
('330106198406018953', '王房华'),
('33010619840601985X', '易想泰'),
('340100200202201020', '潘开迎'),
('34010020020220108X', '辛楚京'),
('340100200202202146', '丘腾曼'),
('34010020020220300X', '区向培'),
('340100200202203747', '梁炼菲'),
('340100200202204547', '路丽秋'),
('34010020020220458X', '方玲儿'),
('340100200202207721', '王问峦'),
('340100200202208740', '梁家霞'),
('370500197710051653', '王问峦'),
('370500197710053034', '赖窍涛'),
('370500197710053931', '王士男'),
('370500197710054475', '王遍盛'),
('370500197710054539', '鲁明康'),
('370500197710054619', '司徒宇森'),
('370500197710055013', '吕友映'),
('370500197710056593', '龚仲'),
('370500197710057510', '康亮贯'),
('370500197710058476', '汤尘菲'),
('370500198310051653', '王觉钧'),
('370500198310053034', '连瓢韦'),
('370500198310053931', '伍來艾'),
('370500198310054475', '蔡谷冠'),
('370500198310054539', '元镜察'),
('370500198310054619', '王肯兵'),
('370500198310055013', '邢鸣木'),
('370500198310056593', '彭振俊'),
('370500198310057510', '王结达'),
('370500198310058476', '任和歆');

--
-- Dumping data for table `se_search_history`
--

INSERT INTO `se_search_history` (`id`, `search_key`, `se_user_id`, `date_time`) VALUES
(1, '', NULL, 1372208611),
(2, '', NULL, 1372208860),
(3, '', NULL, 1372209477),
(4, '', NULL, 1372225377),
(5, '', NULL, 1372765723);

--
-- Dumping data for table `se_seller`
--

INSERT INTO `se_seller` (`UID`, `PASSWDCONSIGN`) VALUES
(2, '202cb962ac59075b964b07152d234b70'),
(5, '202cb962ac59075b964b07152d234b70');

--
-- Dumping data for table `se_user`
--

INSERT INTO `se_user` (`UID`, `USERNAME`, `PASSWD`, `EMAIL`, `TYPE`, `BALANCE`, `PHONE`, `BLACKLIST`, `REALNAME`, `IDENTITY`, `AUTHENTICATED`) VALUES
(1, 'civi', '81dc9bdb52d04dc20036dbd8313ed055', 'justinwm@163.com', 0, '377.30', '18768113961', 0, '孙标湖', '110105197804043431', 1),
(2, 'civi1', '202cb962ac59075b964b07152d234b70', '22@11.com', 1, '0.00', NULL, 0, 'civi', '1234', 1),
(3, '1234567', '202cb962ac59075b964b07152d234b70', '22@qq.com', 0, '0.00', NULL, 0, '王澜', '110105197804041372', 1),
(4, 'justinwm', '202cb962ac59075b964b07152d234b70', '123@qq.com', 0, '20.00', '18768113960', 0, '文明', '123456', 1),
(5, 'testing', '202cb962ac59075b964b07152d234b70', 'ee@qq.com', 1, '0.00', NULL, 0, NULL, NULL, 0),
(6, '111111.', '202cb962ac59075b964b07152d234b70', '22@11.com', 0, '0.00', NULL, 0, NULL, NULL, 0),
(7, 'gggghhh', '202cb962ac59075b964b07152d234b70', 'gg@gmail.com', 0, '0.00', '', 0, NULL, NULL, 0);

--
-- Dumping data for table `se_usercard`
--

INSERT INTO `se_usercard` (`ID`, `USERID`, `CARDID`) VALUES
(2, 4, '123'),
(5, 1, '3500456655263302');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;