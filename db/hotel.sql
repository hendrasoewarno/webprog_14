-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Jan 16, 2024 at 09:30 AM
-- Server version: 5.7.36
-- PHP Version: 7.4.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `hotel`
--

-- --------------------------------------------------------

--
-- Table structure for table `ar`
--

DROP TABLE IF EXISTS `ar`;
CREATE TABLE IF NOT EXISTS `ar` (
  `GroupId` varchar(30) NOT NULL,
  `Tanggal` date NOT NULL,
  `Jenis` varchar(30) NOT NULL,
  `Keterangan` tinytext NOT NULL,
  `Amount` double NOT NULL,
  `PaymentId` int(11) DEFAULT NULL,
  `ARId` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`ARId`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `ar`
--

INSERT INTO `ar` (`GroupId`, `Tanggal`, `Jenis`, `Keterangan`, `Amount`, `PaymentId`, `ARId`) VALUES
('hendraso19062401', '2024-01-03', 'AR', 'Total D/K', 30000000, NULL, 16),
('hendraso19062401', '2024-01-03', 'Payment', 'VoucherId 001', 30000000, 1, 17),
('hendraso19062401', '2024-01-04', 'Payment', 'Pembayaran AR', 100000, 0, 18),
('hendraso19062401', '2024-01-04', 'Payment', 'Pembayaran AR', 1000000, 0, 19);

-- --------------------------------------------------------

--
-- Table structure for table `dk`
--

DROP TABLE IF EXISTS `dk`;
CREATE TABLE IF NOT EXISTS `dk` (
  `GroupId` varchar(30) NOT NULL,
  `RoomId` varchar(10) NOT NULL,
  `Tanggal` date NOT NULL,
  `Jenis` varchar(30) NOT NULL,
  `Keterangan` tinytext NOT NULL,
  `Amount` double NOT NULL,
  `DKId` int(11) NOT NULL AUTO_INCREMENT,
  `ARId` int(11) DEFAULT NULL,
  PRIMARY KEY (`DKId`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `dk`
--

INSERT INTO `dk` (`GroupId`, `RoomId`, `Tanggal`, `Jenis`, `Keterangan`, `Amount`, `DKId`, `ARId`) VALUES
('hendraso19062401', '101', '2024-01-03', 'Room', 'Room Charge 101@2024-01-03', 10000000, 10, 16),
('hendraso19062401', '101', '2024-01-04', 'Room', 'Room Charge 101@2024-01-04', 10000000, 11, 16),
('hendraso19062401', '101', '2024-01-05', 'Room', 'Room Charge 101@2024-01-05', 10000000, 12, 16),
('hendraso19062401', '101', '2024-01-16', 'Room', 'Room Charge 101@2024-01-16', 1000000, 19, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `guest`
--

DROP TABLE IF EXISTS `guest`;
CREATE TABLE IF NOT EXISTS `guest` (
  `GuestId` varchar(30) NOT NULL,
  `Nama` varchar(50) NOT NULL,
  `JenisId` varchar(30) NOT NULL,
  `NomorId` varchar(16) NOT NULL,
  `ContactNo` varchar(20) NOT NULL,
  PRIMARY KEY (`GuestId`),
  UNIQUE KEY `JenisId` (`JenisId`,`NomorId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `guest`
--

INSERT INTO `guest` (`GuestId`, `Nama`, `JenisId`, `NomorId`, `ContactNo`) VALUES
('hendraso1906', 'Hendra Soewarno', 'KTP', '1234567890123456', '081xxxxxxxxxx');

-- --------------------------------------------------------

--
-- Table structure for table `occupied`
--

DROP TABLE IF EXISTS `occupied`;
CREATE TABLE IF NOT EXISTS `occupied` (
  `RoomId` varchar(10) NOT NULL,
  `GuestId` varchar(30) NOT NULL,
  `VoucherId` varchar(30) NOT NULL,
  `DariTanggal` date NOT NULL,
  `SampaiTanggal` date NOT NULL,
  `CheckInTime` datetime DEFAULT NULL,
  `CheckOutTime` datetime DEFAULT NULL,
  `Rate` double NOT NULL,
  `OccupiedId` int(11) NOT NULL AUTO_INCREMENT,
  `GroupId` varchar(30) NOT NULL,
  PRIMARY KEY (`OccupiedId`),
  UNIQUE KEY `RoomId` (`RoomId`,`GuestId`,`VoucherId`,`DariTanggal`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `occupied`
--

INSERT INTO `occupied` (`RoomId`, `GuestId`, `VoucherId`, `DariTanggal`, `SampaiTanggal`, `CheckInTime`, `CheckOutTime`, `Rate`, `OccupiedId`, `GroupId`) VALUES
('101', 'hendraso1906', '001', '2024-01-03', '2024-01-05', '2024-01-03 10:30:38', '2024-01-03 11:33:11', 10000000, 4, 'hendraso19062401'),
('101', 'hendraso1906', '', '2024-01-16', '2024-01-17', '2024-01-16 14:22:33', '2024-01-16 14:38:08', 1000000, 5, 'hendraso19062401');

-- --------------------------------------------------------

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
CREATE TABLE IF NOT EXISTS `payment` (
  `GroupId` varchar(30) NOT NULL,
  `Tanggal` date NOT NULL,
  `VoucherId` varchar(30) NOT NULL,
  `Jenis` varchar(10) NOT NULL,
  `Amount` double NOT NULL,
  `PaymentId` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`PaymentId`),
  UNIQUE KEY `VoucherId` (`VoucherId`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `payment`
--

INSERT INTO `payment` (`GroupId`, `Tanggal`, `VoucherId`, `Jenis`, `Amount`, `PaymentId`) VALUES
('hendraso19062401', '2024-01-03', '001', 'Cash', 30000000, 1),
('hendraso19062401', '2024-01-04', '', 'Cash', 1000000, 2);

-- --------------------------------------------------------

--
-- Table structure for table `rate`
--

DROP TABLE IF EXISTS `rate`;
CREATE TABLE IF NOT EXISTS `rate` (
  `JenisKamar` varchar(30) NOT NULL,
  `Rate` double NOT NULL,
  PRIMARY KEY (`JenisKamar`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `rate`
--

INSERT INTO `rate` (`JenisKamar`, `Rate`) VALUES
('STANDARD', 610000),
('DELUXE', 752500),
('SUITE', 1000000),
('PRESIDENT', 5000000),
('PRESIDENT SUITE', 10000000);

-- --------------------------------------------------------

--
-- Table structure for table `room`
--

DROP TABLE IF EXISTS `room`;
CREATE TABLE IF NOT EXISTS `room` (
  `RoomId` varchar(10) NOT NULL,
  `Lantai` int(11) NOT NULL,
  `JenisKamar` varchar(30) NOT NULL,
  `Status` int(1) NOT NULL,
  `ReadyTime` datetime DEFAULT NULL,
  `Keterangan` tinytext NOT NULL,
  PRIMARY KEY (`RoomId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `room`
--

INSERT INTO `room` (`RoomId`, `Lantai`, `JenisKamar`, `Status`, `ReadyTime`, `Keterangan`) VALUES
('101', 1, 'PRESIDENT', 0, '2024-01-16 14:44:02', 'Ok'),
('102', 1, 'PRESIDENT', 0, '2023-12-27 14:03:56', 'Ok'),
('201', 2, 'DELUXE', 0, '2023-12-27 14:03:57', 'Ok');

-- --------------------------------------------------------

--
-- Table structure for table `zoperator`
--

DROP TABLE IF EXISTS `zoperator`;
CREATE TABLE IF NOT EXISTS `zoperator` (
  `userid` varchar(30) NOT NULL,
  `description` tinytext NOT NULL,
  `password` varchar(50) NOT NULL,
  `creaby` varchar(30) NOT NULL,
  `creatime` datetime NOT NULL,
  `modiby` varchar(30) NOT NULL,
  `moditime` datetime NOT NULL,
  PRIMARY KEY (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `zoperator`
--

INSERT INTO `zoperator` (`userid`, `description`, `password`, `creaby`, `creatime`, `modiby`, `moditime`) VALUES
('hendra', 'Hendra Soewarno', 'soewarno', 'hendra', '2023-06-18 00:00:00', 'hendra', '2023-06-18 00:00:00');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
