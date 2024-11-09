-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 09, 2024 at 03:02 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `smarttutor`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin_table`
--

CREATE TABLE `admin_table` (
  `Admin_ID` int(11) NOT NULL,
  `Admin_name` varchar(100) DEFAULT NULL,
  `Admin_Roll_number` varchar(50) DEFAULT NULL,
  `Admin_password` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin_table`
--

INSERT INTO `admin_table` (`Admin_ID`, `Admin_name`, `Admin_Roll_number`, `Admin_password`) VALUES
(1, 'Munam Mustafa', '24A-0460', 'Munam253@');

-- --------------------------------------------------------

--
-- Table structure for table `parent_table`
--

CREATE TABLE `parent_table` (
  `Parent_ID` int(11) NOT NULL,
  `Student_ID` int(11) DEFAULT NULL,
  `Parent_Roll_No` varchar(50) DEFAULT NULL,
  `Parent_Email` varchar(100) DEFAULT NULL,
  `Parent_number` varchar(15) DEFAULT NULL,
  `Parent_Password` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `parent_table`
--

INSERT INTO `parent_table` (`Parent_ID`, `Student_ID`, `Parent_Roll_No`, `Parent_Email`, `Parent_number`, `Parent_Password`) VALUES
(12, 12, '24P-5434', 'munammustafa953@gmail.com', '03435231900', '$2b$10$RCd.1fsAJdh295X3hr5rnuO77z7mDzJZd8ma34Cjtx/I2afXsWYv6'),
(13, 13, '24P-8570', 'munammustafa253@gmail.com', '03435231900', '$2b$10$r3YR6UCX8QVeXqBvKco4neGCCPlNgeMov8ll13Zapq4iVjREyx6Am');

-- --------------------------------------------------------

--
-- Table structure for table `student_table`
--

CREATE TABLE `student_table` (
  `Student_ID` int(11) NOT NULL,
  `Student_Name` varchar(100) DEFAULT NULL,
  `Student_roll_No` varchar(50) DEFAULT NULL,
  `Student_UserName` varchar(50) DEFAULT NULL,
  `Student_Email` varchar(100) DEFAULT NULL,
  `Student_number` varchar(15) DEFAULT NULL,
  `Password` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student_table`
--

INSERT INTO `student_table` (`Student_ID`, `Student_Name`, `Student_roll_No`, `Student_UserName`, `Student_Email`, `Student_number`, `Password`) VALUES
(12, 'Munam Mustafa', '24S-5434', 'Munam253', 'munammustafa253@gmail.com', '03435231909', '$2b$10$uKDzde2K1mYE5m3ekt523uBtx3S7YibzgxQiqE.JPnK4/R.VnCnle'),
(13, 'Munam Mustafa', '24S-8570', 'Munam25', 'munammustafa953@gmail.com', '03435231909', '$2b$10$fV2YAjNMqd4ykpEgJyouduzS8pdyR3osUpdhIi.P9G7czTzwvSN6C');

-- --------------------------------------------------------

--
-- Table structure for table `tutor_profile_status_table`
--

CREATE TABLE `tutor_profile_status_table` (
  `Tutor_ID` int(11) DEFAULT NULL,
  `profile_status` varchar(50) DEFAULT NULL,
  `profile_status_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tutor_profile_status_table`
--

INSERT INTO `tutor_profile_status_table` (`Tutor_ID`, `profile_status`, `profile_status_ID`) VALUES
(25, 'Not created', 4);

-- --------------------------------------------------------

--
-- Table structure for table `tutor_table`
--

CREATE TABLE `tutor_table` (
  `Tutor_ID` int(11) NOT NULL,
  `Tutor_Name` varchar(100) DEFAULT NULL,
  `Tutor_Roll_No` varchar(50) DEFAULT NULL,
  `Tutor_Email` varchar(100) DEFAULT NULL,
  `Tutor_Number` varchar(15) DEFAULT NULL,
  `Tutor_password` varchar(255) DEFAULT NULL,
  `Tutor_UserName` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tutor_table`
--

INSERT INTO `tutor_table` (`Tutor_ID`, `Tutor_Name`, `Tutor_Roll_No`, `Tutor_Email`, `Tutor_Number`, `Tutor_password`, `Tutor_UserName`) VALUES
(25, 'Ammar Arshad', '24T-9604', 'i210460@nu.edu.pk', '03435231909', '$2b$10$HBsc9TJueL2axl6QYhRje.25JUOjlFyOraEBYJVjtlK9/4Zqtz0te', 'Ammar');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin_table`
--
ALTER TABLE `admin_table`
  ADD PRIMARY KEY (`Admin_ID`),
  ADD UNIQUE KEY `Admin_ID` (`Admin_ID`);

--
-- Indexes for table `parent_table`
--
ALTER TABLE `parent_table`
  ADD PRIMARY KEY (`Parent_ID`),
  ADD KEY `Student_ID` (`Student_ID`);

--
-- Indexes for table `student_table`
--
ALTER TABLE `student_table`
  ADD PRIMARY KEY (`Student_ID`);

--
-- Indexes for table `tutor_profile_status_table`
--
ALTER TABLE `tutor_profile_status_table`
  ADD PRIMARY KEY (`profile_status_ID`),
  ADD KEY `Tutor_ID` (`Tutor_ID`);

--
-- Indexes for table `tutor_table`
--
ALTER TABLE `tutor_table`
  ADD PRIMARY KEY (`Tutor_ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin_table`
--
ALTER TABLE `admin_table`
  MODIFY `Admin_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `parent_table`
--
ALTER TABLE `parent_table`
  MODIFY `Parent_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `student_table`
--
ALTER TABLE `student_table`
  MODIFY `Student_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `tutor_profile_status_table`
--
ALTER TABLE `tutor_profile_status_table`
  MODIFY `profile_status_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tutor_table`
--
ALTER TABLE `tutor_table`
  MODIFY `Tutor_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `parent_table`
--
ALTER TABLE `parent_table`
  ADD CONSTRAINT `parent_table_ibfk_1` FOREIGN KEY (`Student_ID`) REFERENCES `student_table` (`Student_ID`);

--
-- Constraints for table `tutor_profile_status_table`
--
ALTER TABLE `tutor_profile_status_table`
  ADD CONSTRAINT `tutor_profile_status_table_ibfk_1` FOREIGN KEY (`Tutor_ID`) REFERENCES `tutor_table` (`Tutor_ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
