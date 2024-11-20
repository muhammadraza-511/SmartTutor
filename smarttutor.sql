-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 20, 2024 at 09:34 PM
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
-- Table structure for table `otp_table`
--

CREATE TABLE `otp_table` (
  `otpid` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `otp` int(11) NOT NULL,
  `timestamp` datetime NOT NULL,
  `status` varchar(50) DEFAULT 'unauthenticated'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `otp_table`
--

INSERT INTO `otp_table` (`otpid`, `email`, `otp`, `timestamp`, `status`) VALUES
(18, 'munammustafa253@gmail.com', 460199, '2024-11-21 00:32:13', 'authorized'),
(19, 'i210460@nu.edu.pk', 479929, '2024-11-21 00:45:01', 'authorized'),
(20, 'i210511@nu.edu.pk', 629464, '2024-11-21 01:02:15', 'authorized'),
(21, 'i210730@nu.edu.pk', 503410, '2024-11-21 01:25:47', 'authorized');

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
(23, 23, '24P-3713', 'munammustafa953@gmail.com', '03125027950', '$2b$10$onwYOscdBzIm6HC89WtKOO87eLRL6G3rBbxss8NevER4u1he9.Ede');

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
(23, 'Munam Mustafa', '24S-3713', 'Munam253', 'munammustafa253@gmail.com', '03435231909', '$2b$10$DU8qzH9FVE5t/.mV0ImGGeGGbwv/3xinJTPnPdqnWU9xTAG1cE93a');

-- --------------------------------------------------------

--
-- Table structure for table `tutor_profile_data_table`
--

CREATE TABLE `tutor_profile_data_table` (
  `tutor_profile_ID` int(11) NOT NULL,
  `Tutor_ID` int(11) DEFAULT NULL,
  `tutor_email` varchar(100) DEFAULT NULL,
  `tutor_rollno` varchar(50) DEFAULT NULL,
  `tutor_country` varchar(100) DEFAULT NULL,
  `tutor_city` varchar(100) DEFAULT NULL,
  `tutor_language` varchar(100) DEFAULT NULL,
  `tutor_university` varchar(150) DEFAULT NULL,
  `tutor_degree_name` varchar(100) DEFAULT NULL,
  `tutor_degree_type` varchar(50) DEFAULT NULL,
  `tutor_specialization` varchar(100) DEFAULT NULL,
  `tutor_starting_year` year(4) DEFAULT NULL,
  `tutor_ending_year` year(4) DEFAULT NULL,
  `tutor_degree_link` varchar(255) DEFAULT NULL,
  `tutor_teaches_subject` varchar(100) DEFAULT NULL,
  `tutor_teaches_to_grade` varchar(50) DEFAULT NULL,
  `tutor_preferable_session` varchar(100) DEFAULT NULL,
  `tutor_introduction` text DEFAULT NULL,
  `tutor_experience` text DEFAULT NULL,
  `tutor_teaching_fee` decimal(10,2) DEFAULT NULL,
  `tutor_availability_days` varchar(100) DEFAULT NULL,
  `tutor_availability_time` varchar(100) DEFAULT NULL,
  `tutor_profile_pic` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tutor_profile_data_table`
--

INSERT INTO `tutor_profile_data_table` (`tutor_profile_ID`, `Tutor_ID`, `tutor_email`, `tutor_rollno`, `tutor_country`, `tutor_city`, `tutor_language`, `tutor_university`, `tutor_degree_name`, `tutor_degree_type`, `tutor_specialization`, `tutor_starting_year`, `tutor_ending_year`, `tutor_degree_link`, `tutor_teaches_subject`, `tutor_teaches_to_grade`, `tutor_preferable_session`, `tutor_introduction`, `tutor_experience`, `tutor_teaching_fee`, `tutor_availability_days`, `tutor_availability_time`, `tutor_profile_pic`) VALUES
(21, 37, 'i210460@nu.edu.pk', '24T-2914', 'Pakistan', 'Islamabad', 'English, Urdu', 'FAST NUCES', 'Computer Science', 'Bachelor', 'CS', '2010', '2014', '37.pdf', 'English, Urdu, Maths', '8, 9', 'One to one Session', 'I am munam mustafa', 'I have good experience', 500.00, 'Monday, Tuesday, Wednesday, Thursday', 'anytime', '37.jpg'),
(22, 38, 'i210511@nu.edu.pk', '24T-6998', 'Pakistan', 'Islamabad', 'English, Pashto', 'FAST ', 'BS(CS)', 'Bachelor', 'CS', '2011', '2016', '38.pdf', 'English, Maths', '9, 10', 'Both', 'I am raza', 'I have experience', 200.00, 'Monday, Tuesday', 'midnight', '38.jpeg'),
(23, 39, 'i210730@nu.edu.pk', '24T-1435', 'Pakistan', 'Islamabad', 'English, Urdu', 'Fast', 'CS', 'BS', 'CS', '2006', '2010', '39.pdf', 'English, Urdu', '7, 9', 'Group Session', 'i AM ALIAN', 'I HAVE EXPERIENCE', 100.00, 'Monday, Tuesday, Wednesday', 'anytime', '39.jpeg');

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
(37, 'pending', 16),
(38, 'pending', 17),
(39, 'rejected', 18);

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
(37, 'Munam Mustafa', '24T-2914', 'i210460@nu.edu.pk', '03435231909', '$2b$10$q84qsfdl7W/ncmDMNYg7deTyrnUeNYownevyU6IDOLNJ3zZY/WOwu', 'Munam253'),
(38, 'Muhammad Raza', '24T-6998', 'i210511@nu.edu.pk', '03435231909', '$2b$10$DAw.rgqBOw4JBKValECG..dDT9.1BMhqE87yl2NFgCItlJTx5gevO', 'Raza253'),
(39, 'Alian Anwar', '24T-1435', 'i210730@nu.edu.pk', '03435231909', '$2b$10$.RAJEddGdijvTp4oURZAEOvGiwLrSRyoSn0X6ijuPu7Wbi3iOEoHy', 'Alian253');

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
-- Indexes for table `otp_table`
--
ALTER TABLE `otp_table`
  ADD PRIMARY KEY (`otpid`);

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
-- Indexes for table `tutor_profile_data_table`
--
ALTER TABLE `tutor_profile_data_table`
  ADD PRIMARY KEY (`tutor_profile_ID`),
  ADD KEY `Tutor_ID` (`Tutor_ID`);

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
-- AUTO_INCREMENT for table `otp_table`
--
ALTER TABLE `otp_table`
  MODIFY `otpid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `parent_table`
--
ALTER TABLE `parent_table`
  MODIFY `Parent_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `student_table`
--
ALTER TABLE `student_table`
  MODIFY `Student_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `tutor_profile_data_table`
--
ALTER TABLE `tutor_profile_data_table`
  MODIFY `tutor_profile_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `tutor_profile_status_table`
--
ALTER TABLE `tutor_profile_status_table`
  MODIFY `profile_status_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `tutor_table`
--
ALTER TABLE `tutor_table`
  MODIFY `Tutor_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `parent_table`
--
ALTER TABLE `parent_table`
  ADD CONSTRAINT `parent_table_ibfk_1` FOREIGN KEY (`Student_ID`) REFERENCES `student_table` (`Student_ID`);

--
-- Constraints for table `tutor_profile_data_table`
--
ALTER TABLE `tutor_profile_data_table`
  ADD CONSTRAINT `tutor_profile_data_table_ibfk_1` FOREIGN KEY (`Tutor_ID`) REFERENCES `tutor_table` (`Tutor_ID`);

--
-- Constraints for table `tutor_profile_status_table`
--
ALTER TABLE `tutor_profile_status_table`
  ADD CONSTRAINT `tutor_profile_status_table_ibfk_1` FOREIGN KEY (`Tutor_ID`) REFERENCES `tutor_table` (`Tutor_ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
