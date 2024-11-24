-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 24, 2024 at 10:13 PM
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
-- Table structure for table `assigned_tutors_record_table`
--

CREATE TABLE `assigned_tutors_record_table` (
  `record_ID` int(11) NOT NULL,
  `Student_ID` int(11) NOT NULL,
  `Parent_ID` int(11) NOT NULL,
  `Tutor_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `assigned_tutors_record_table`
--

INSERT INTO `assigned_tutors_record_table` (`record_ID`, `Student_ID`, `Parent_ID`, `Tutor_ID`) VALUES
(9, 25, 25, 40),
(10, 26, 26, 40);

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
(25, 'munammustafa253@gmail.com', 574598, '2024-11-25 00:08:07', 'authorized'),
(26, 'munammustafa953@gmail.com', 406696, '2024-11-25 00:15:47', 'authorized');

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
(25, 25, '24P-6351', 'munammustafa253@gmail.com', '03435231900', '$2b$10$ys0BZ.PtT9I0qo6xZxks2OvWdNmGeWce..rRwhV6U8my5.Ks8F87S'),
(26, 26, '24P-3394', 'munammustafa953@gmail.com', '03435231900', '$2b$10$NokLdgMimUlLZtb.pwk.w.Xt8re0DbAGhHISiyIMUA5/UDcZxd9fS');

-- --------------------------------------------------------

--
-- Table structure for table `student_approve_tutor_status_table`
--

CREATE TABLE `student_approve_tutor_status_table` (
  `status_ID` int(11) NOT NULL,
  `Student_ID` int(11) NOT NULL,
  `student_approving_status` varchar(50) NOT NULL,
  `Parent_ID` int(11) NOT NULL,
  `parent_approving_status` varchar(50) NOT NULL,
  `Tutor_ID` int(11) NOT NULL,
  `tutor_approving_status` varchar(50) NOT NULL DEFAULT 'pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student_approve_tutor_status_table`
--

INSERT INTO `student_approve_tutor_status_table` (`status_ID`, `Student_ID`, `student_approving_status`, `Parent_ID`, `parent_approving_status`, `Tutor_ID`, `tutor_approving_status`) VALUES
(17, 26, 'approved', 26, 'pending', 40, 'pending');

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
(25, 'Munam Mustafa', '24S-6351', 'Munam253', 'munammustafa953@gmail.com', '03435231909', '$2b$10$4ae5oCQMXPp/yByvZwaiUORXTbNp7o4s8ntJ/6/Zzio6X7Zcj0WKa'),
(26, 'Munam Mustafa', '24S-3394', 'Munam25', 'munammustafa253@gmail.com', '03435231909', '$2b$10$iqK5vkeN36hOXYytNYihEe8OARekqBR7tgzmkShnZ4w1GhY92BHiC');

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
(24, 40, 'munammustafa253@gmail.com', '24T-1954', 'Pakistan', 'Islamabad', 'English, Urdu, Punjabi', 'FAST NUCES', 'CS', 'Bachelor', 'CS', '2011', '2016', '40.pdf', 'English, Urdu, Chemistry', '7, 8, 9', 'Group Session', 'I am Munam Mustafa', 'I have alot of experience', 5000.00, 'Monday, Tuesday, Wednesday, Thursday', 'anytime', '40.jpeg');

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
(40, 'accepted', 19);

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
(40, 'Munam Mustafa', '24T-1954', 'munammustafa253@gmail.com', '03435231909', '$2b$10$gtrcvj5dqMjjklgjEd78buwuGX5wZTddPeQz1YXZSnAwZH4jpjRF6', 'Munam253');

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
-- Indexes for table `assigned_tutors_record_table`
--
ALTER TABLE `assigned_tutors_record_table`
  ADD PRIMARY KEY (`record_ID`),
  ADD KEY `Student_ID` (`Student_ID`),
  ADD KEY `Parent_ID` (`Parent_ID`),
  ADD KEY `Tutor_ID` (`Tutor_ID`);

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
-- Indexes for table `student_approve_tutor_status_table`
--
ALTER TABLE `student_approve_tutor_status_table`
  ADD PRIMARY KEY (`status_ID`),
  ADD KEY `Student_ID` (`Student_ID`),
  ADD KEY `Parent_ID` (`Parent_ID`),
  ADD KEY `Tutor_ID` (`Tutor_ID`);

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
-- AUTO_INCREMENT for table `assigned_tutors_record_table`
--
ALTER TABLE `assigned_tutors_record_table`
  MODIFY `record_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `otp_table`
--
ALTER TABLE `otp_table`
  MODIFY `otpid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `parent_table`
--
ALTER TABLE `parent_table`
  MODIFY `Parent_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `student_approve_tutor_status_table`
--
ALTER TABLE `student_approve_tutor_status_table`
  MODIFY `status_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `student_table`
--
ALTER TABLE `student_table`
  MODIFY `Student_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `tutor_profile_data_table`
--
ALTER TABLE `tutor_profile_data_table`
  MODIFY `tutor_profile_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `tutor_profile_status_table`
--
ALTER TABLE `tutor_profile_status_table`
  MODIFY `profile_status_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `tutor_table`
--
ALTER TABLE `tutor_table`
  MODIFY `Tutor_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `assigned_tutors_record_table`
--
ALTER TABLE `assigned_tutors_record_table`
  ADD CONSTRAINT `assigned_tutors_record_table_ibfk_1` FOREIGN KEY (`Student_ID`) REFERENCES `student_table` (`Student_ID`),
  ADD CONSTRAINT `assigned_tutors_record_table_ibfk_2` FOREIGN KEY (`Parent_ID`) REFERENCES `parent_table` (`Parent_ID`),
  ADD CONSTRAINT `assigned_tutors_record_table_ibfk_3` FOREIGN KEY (`Tutor_ID`) REFERENCES `tutor_table` (`Tutor_ID`);

--
-- Constraints for table `parent_table`
--
ALTER TABLE `parent_table`
  ADD CONSTRAINT `parent_table_ibfk_1` FOREIGN KEY (`Student_ID`) REFERENCES `student_table` (`Student_ID`);

--
-- Constraints for table `student_approve_tutor_status_table`
--
ALTER TABLE `student_approve_tutor_status_table`
  ADD CONSTRAINT `student_approve_tutor_status_table_ibfk_1` FOREIGN KEY (`Student_ID`) REFERENCES `student_table` (`Student_ID`),
  ADD CONSTRAINT `student_approve_tutor_status_table_ibfk_2` FOREIGN KEY (`Parent_ID`) REFERENCES `parent_table` (`Parent_ID`),
  ADD CONSTRAINT `student_approve_tutor_status_table_ibfk_3` FOREIGN KEY (`Tutor_ID`) REFERENCES `tutor_table` (`Tutor_ID`);

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
