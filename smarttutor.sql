-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 09, 2025 at 10:42 PM
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
(14, 31, 31, 47),
(15, 32, 32, 47),
(16, 32, 32, 48);

-- --------------------------------------------------------

--
-- Table structure for table `communities`
--

CREATE TABLE `communities` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `subject` varchar(255) NOT NULL,
  `created_by` int(11) NOT NULL,
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `communities`
--

INSERT INTO `communities` (`id`, `name`, `description`, `subject`, `created_by`, `status`, `created_at`) VALUES
(8, 'Exams help ', 'This community is for english students', 'English', 47, 'approved', '2024-12-11 20:57:14'),
(9, 'Social Communitry', 'this is for english', 'English', 47, 'approved', '2024-12-12 04:56:37');

-- --------------------------------------------------------

--
-- Table structure for table `community_chat`
--

CREATE TABLE `community_chat` (
  `id` int(11) NOT NULL,
  `community_id` int(11) DEFAULT NULL,
  `sender_id` int(11) NOT NULL,
  `sender_role` enum('student','tutor') NOT NULL,
  `message` text DEFAULT NULL,
  `sent_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `community_chat`
--

INSERT INTO `community_chat` (`id`, `community_id`, `sender_id`, `sender_role`, `message`, `sent_at`) VALUES
(8, 9, 31, 'student', 'hi', '2024-12-12 04:59:18');

-- --------------------------------------------------------

--
-- Table structure for table `community_files`
--

CREATE TABLE `community_files` (
  `id` int(11) NOT NULL,
  `community_id` int(11) DEFAULT NULL,
  `sender_id` int(11) NOT NULL,
  `sender_role` enum('student','tutor') NOT NULL,
  `file_url` varchar(255) DEFAULT NULL,
  `file_type` varchar(50) DEFAULT NULL,
  `uploaded_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `community_files`
--

INSERT INTO `community_files` (`id`, `community_id`, `sender_id`, `sender_role`, `file_url`, `file_type`, `uploaded_at`) VALUES
(5, 9, 31, 'student', 'uploads\\1733979581232-Final_report.pdf', 'application', '2024-12-12 04:59:41');

-- --------------------------------------------------------

--
-- Table structure for table `community_members`
--

CREATE TABLE `community_members` (
  `id` int(11) NOT NULL,
  `community_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `joined_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `community_members`
--

INSERT INTO `community_members` (`id`, `community_id`, `student_id`, `joined_at`) VALUES
(14, 8, 31, '2024-12-12 01:59:12'),
(15, 9, 31, '2024-12-12 09:58:48');

-- --------------------------------------------------------

--
-- Table structure for table `meeting_details`
--

CREATE TABLE `meeting_details` (
  `Meeting_ID` int(11) NOT NULL,
  `Tutor_ID` int(11) DEFAULT NULL,
  `Student_ID` int(11) DEFAULT NULL,
  `Session_ID` varchar(50) NOT NULL,
  `Session_Start_Date` date DEFAULT curdate(),
  `Session_Start_Time` time NOT NULL,
  `Session_End_Time` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `meeting_details`
--

INSERT INTO `meeting_details` (`Meeting_ID`, `Tutor_ID`, `Student_ID`, `Session_ID`, `Session_Start_Date`, `Session_Start_Time`, `Session_End_Time`) VALUES
(21, 47, 31, '9NDX5YX0ZN', '2025-03-09', '02:28:00', '04:28:00'),
(22, 47, 32, '9NDX5YX0ZN', '2025-03-09', '02:28:00', '04:28:00');

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
(31, 31, '24P-6491', 'munammustafa253@gmail.com', '03412464855', '$2b$10$FIt7jTy9P0YYy2zp5UXfb.iNu7ViyuK4NxIVettzu8wCT4lmcE2r6'),
(32, 32, '25P-2934', 'munammustafa953@gmail.com', '03435231900', '$2b$10$Dcm8Qds6u6U2evoxKfzRke6rGqe.OBhOOahK08JJO2JecUxtvWLXa');

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
(20, 31, 'approved', 31, 'approved', 47, 'approved'),
(21, 32, 'approved', 32, 'approved', 47, 'approved'),
(22, 32, 'approved', 32, 'approved', 48, 'approved');

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
(31, 'Munam Mustafa', '24S-6491', 'Munam253', 'munammustafa953@gmail.com', '03412464850', '$2b$10$K6/IjHHg5Brx3iaMJSokt.8Fx7K2AgM7rn8rDAv1ZSepmpxsLXXYa'),
(32, 'Munam Mustafa', '25S-2934', 'Munam25', 'munammustafa253@gmail.com', '03435231909', '$2b$10$0zmWPpVNAc0oR9fy.Om8XObcmbglRcdliUl5oX2OvKzO7mKw7Hxq6');

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
(28, 47, 'munammustafa253@gmail.com', '24T-6654', 'Pakistan', 'Rawalpindi', 'English, Urdu', 'FAST NUCES', 'Computer Science', 'Bachelor', 'Nil', '2009', '2014', '47.pdf', 'English, Urdu', '9, 10', 'Both', 'I am XYZ.', 'I have good experience.', 5000.00, 'Monday, Tuesday, Wednesday', 'midnight', '47.jpeg'),
(29, 48, 'i210460@nu.edu.pk', '24T-8073', 'Pakistan', 'Islamabad', 'English, Urdu', 'FAST NUCES', 'CS', 'BS', 'Nil', '2008', '2014', '48.pdf', 'English, Maths', '10', 'Group Session', 'I am Munam Mustafa', 'This is demo.', 3000.00, 'Monday, Tuesday', 'anytime', '48.jpeg');

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
(47, 'accepted', 26),
(48, 'accepted', 27);

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
(47, 'Munam Mustafa', '24T-6654', 'munammustafa253@gmail.com', '03412464850', '$2b$10$W0DxlF3UBLPk38JihzHzAOp6h1mA5W4DbHEl2zRr.O3bro.lJ0VwO', 'Munam253'),
(48, 'Munam Mustafa', '24T-8073', 'i210460@nu.edu.pk', '03435231909', '$2b$10$6L2YYXf96j6R1jyCBhWSFu3mD3skWOsw7cy3gqV8oaBzQ/AP/Dlke', 'Munam25');

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
-- Indexes for table `communities`
--
ALTER TABLE `communities`
  ADD PRIMARY KEY (`id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `community_chat`
--
ALTER TABLE `community_chat`
  ADD PRIMARY KEY (`id`),
  ADD KEY `community_id` (`community_id`),
  ADD KEY `sender_id` (`sender_id`);

--
-- Indexes for table `community_files`
--
ALTER TABLE `community_files`
  ADD PRIMARY KEY (`id`),
  ADD KEY `community_id` (`community_id`),
  ADD KEY `sender_id` (`sender_id`);

--
-- Indexes for table `community_members`
--
ALTER TABLE `community_members`
  ADD PRIMARY KEY (`id`),
  ADD KEY `community_id` (`community_id`),
  ADD KEY `student_id` (`student_id`);

--
-- Indexes for table `meeting_details`
--
ALTER TABLE `meeting_details`
  ADD PRIMARY KEY (`Meeting_ID`),
  ADD KEY `Tutor_ID` (`Tutor_ID`),
  ADD KEY `Student_ID` (`Student_ID`);

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
  MODIFY `record_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `communities`
--
ALTER TABLE `communities`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `community_chat`
--
ALTER TABLE `community_chat`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `community_files`
--
ALTER TABLE `community_files`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `community_members`
--
ALTER TABLE `community_members`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `meeting_details`
--
ALTER TABLE `meeting_details`
  MODIFY `Meeting_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `otp_table`
--
ALTER TABLE `otp_table`
  MODIFY `otpid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT for table `parent_table`
--
ALTER TABLE `parent_table`
  MODIFY `Parent_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `student_approve_tutor_status_table`
--
ALTER TABLE `student_approve_tutor_status_table`
  MODIFY `status_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `student_table`
--
ALTER TABLE `student_table`
  MODIFY `Student_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `tutor_profile_data_table`
--
ALTER TABLE `tutor_profile_data_table`
  MODIFY `tutor_profile_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `tutor_profile_status_table`
--
ALTER TABLE `tutor_profile_status_table`
  MODIFY `profile_status_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `tutor_table`
--
ALTER TABLE `tutor_table`
  MODIFY `Tutor_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

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
-- Constraints for table `communities`
--
ALTER TABLE `communities`
  ADD CONSTRAINT `communities_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `tutor_table` (`Tutor_ID`);

--
-- Constraints for table `community_chat`
--
ALTER TABLE `community_chat`
  ADD CONSTRAINT `community_chat_ibfk_1` FOREIGN KEY (`community_id`) REFERENCES `communities` (`id`);

--
-- Constraints for table `community_files`
--
ALTER TABLE `community_files`
  ADD CONSTRAINT `community_files_ibfk_1` FOREIGN KEY (`community_id`) REFERENCES `communities` (`id`);

--
-- Constraints for table `community_members`
--
ALTER TABLE `community_members`
  ADD CONSTRAINT `community_members_ibfk_1` FOREIGN KEY (`community_id`) REFERENCES `communities` (`id`),
  ADD CONSTRAINT `community_members_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `student_table` (`Student_ID`);

--
-- Constraints for table `meeting_details`
--
ALTER TABLE `meeting_details`
  ADD CONSTRAINT `meeting_details_ibfk_1` FOREIGN KEY (`Tutor_ID`) REFERENCES `tutor_table` (`Tutor_ID`) ON DELETE CASCADE,
  ADD CONSTRAINT `meeting_details_ibfk_2` FOREIGN KEY (`Student_ID`) REFERENCES `student_table` (`Student_ID`) ON DELETE CASCADE;

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
