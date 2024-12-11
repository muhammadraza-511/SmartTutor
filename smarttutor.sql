-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 28, 2024 at 05:54 PM
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
(1, 'Social Community', 'm c c', 'Maths', 41, 'approved', '2024-11-26 13:53:56'),
(2, 'Social Community', 'mx x ', 'Maths', 41, 'approved', '2024-11-26 14:01:27'),
(3, 'Social Community', 'new onw', 'English', 41, 'approved', '2024-11-27 11:29:53'),
(4, 'Alian Anwar', ',,,,,', 'English', 41, 'rejected', '2024-11-27 11:35:55'),
(5, 'Alian Anwar 1', 'x c.,cc', 'English', 41, 'approved', '2024-11-27 11:36:08');

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
(1, 1, 28, 'student', 'mm', '2024-11-28 16:15:49'),
(2, 1, 28, 'student', 'mmsm', '2024-11-28 16:48:36'),
(3, 1, 41, 'tutor', 'kkk', '2024-11-28 16:49:04'),
(4, 1, 29, 'student', 'nwe onw', '2024-11-28 16:52:54');

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
(1, 1, 28, 'student', 'uploads\\1732810563560-task1A.PNG', 'image', '2024-11-28 16:16:03'),
(2, 1, 40, 'tutor', 'uploads\\1732810597766-28.pdf', 'application', '2024-11-28 16:16:37'),
(3, 1, 41, 'tutor', 'uploads\\1732812557042-41.pdf', 'application', '2024-11-28 16:49:17');

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
(5, 1, 28, '2024-11-27 16:06:56'),
(8, 5, 28, '2024-11-27 16:58:23'),
(9, 3, 28, '2024-11-27 16:59:00'),
(10, 1, 29, '2024-11-28 21:52:29');

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
(26, 'munammustafa953@gmail.com', 406696, '2024-11-25 00:15:47', 'authorized'),
(27, 'rajaalyan977@gmail.com', 420649, '2024-11-26 18:55:33', 'authorized'),
(28, 'i210730@nu.edu.pk', 909811, '2024-11-26 19:14:10', 'authorized');

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
(26, 26, '24P-3394', 'munammustafa953@gmail.com', '03435231900', '$2b$10$NokLdgMimUlLZtb.pwk.w.Xt8re0DbAGhHISiyIMUA5/UDcZxd9fS'),
(28, 28, '24P-6020', 'aliananwar0@gmail.com', '12345678123', '$2b$10$94j9xEacBY6gHgEKL8D4YOvb.hx1MxFqa4RVtr5nVkKTQ8H.1szq.'),
(29, 29, '24P-9472', 'aliananwar0@gmail.com', '12345678123', '$2b$10$d.dJbfWL9980u9SowSbT5OjKzLuqm47F//LN38iCVth4NB1cZ6knq');

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
(26, 'Munam Mustafa', '24S-3394', 'Munam25', 'munammustafa253@gmail.com', '03435231909', '$2b$10$iqK5vkeN36hOXYytNYihEe8OARekqBR7tgzmkShnZ4w1GhY92BHiC'),
(28, 'Alian Anwar', '24S-6020', 'Alian 72', 'i210730@nu.edu.pk', '12345678912', '$2b$10$cU961frIhN1BBYZaXiMTmuDXCJIz0HaAmHGGkVbPYNTGQDTdSAzAS'),
(29, 'Raja Alyan', '24S-9472', 'Alian 7272', 'rajaalyan977@gmail.com', '12345678912', '$2b$10$QxUzKICvY/Em53eYfvL.wucSp6sfloynqyGFAbvJfcJh21p6Oz6we');

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
(24, 40, 'munammustafa253@gmail.com', '24T-1954', 'Pakistan', 'Islamabad', 'English, Urdu, Punjabi', 'FAST NUCES', 'CS', 'Bachelor', 'CS', '2011', '2016', '40.pdf', 'English, Urdu, Chemistry', '7, 8, 9', 'Group Session', 'I am Munam Mustafa', 'I have alot of experience', 5000.00, 'Monday, Tuesday, Wednesday, Thursday', 'anytime', '40.jpeg'),
(25, 41, 'rajaalyan977@gmail.com', '24T-1687', 'Pakistan', 'Rawalpindi', 'English', 'Fast', 'BS', 'CS', 'web development', '2021', '2024', '41.pdf', 'Maths', 'A', 'Both', ',sx,', '2 years', 1500.00, 'Monday', 'anytime', '41.png');

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
(40, 'accepted', 19),
(41, 'pending', 20);

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
(40, 'Munam Mustafa', '24T-1954', 'munammustafa253@gmail.com', '03435231909', '$2b$10$gtrcvj5dqMjjklgjEd78buwuGX5wZTddPeQz1YXZSnAwZH4jpjRF6', 'Munam253'),
(41, 'Alian Anwar', '24T-1687', 'rajaalyan977@gmail.com', '03486977089', '$2b$10$4octtdowuk5WsFSUrNjwS./5mwl13ixY58Z7WlZmVFM/cJEdtxjvm', 'Alian 72');

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
-- AUTO_INCREMENT for table `communities`
--
ALTER TABLE `communities`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `community_chat`
--
ALTER TABLE `community_chat`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `community_files`
--
ALTER TABLE `community_files`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `community_members`
--
ALTER TABLE `community_members`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `otp_table`
--
ALTER TABLE `otp_table`
  MODIFY `otpid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `parent_table`
--
ALTER TABLE `parent_table`
  MODIFY `Parent_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `student_approve_tutor_status_table`
--
ALTER TABLE `student_approve_tutor_status_table`
  MODIFY `status_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `student_table`
--
ALTER TABLE `student_table`
  MODIFY `Student_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `tutor_profile_data_table`
--
ALTER TABLE `tutor_profile_data_table`
  MODIFY `tutor_profile_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `tutor_profile_status_table`
--
ALTER TABLE `tutor_profile_status_table`
  MODIFY `profile_status_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `tutor_table`
--
ALTER TABLE `tutor_table`
  MODIFY `Tutor_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

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
