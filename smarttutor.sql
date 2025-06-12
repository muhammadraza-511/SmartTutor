-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 12, 2025 at 08:19 PM
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
(16, 33, 33, 50),
(17, 33, 33, 47),
(18, 34, 34, 47),
(19, 35, 35, 48),
(20, 36, 36, 48),
(21, 37, 37, 48),
(22, 38, 38, 48),
(23, 39, 39, 48),
(24, 40, 40, 48),
(25, 41, 41, 48),
(26, 42, 42, 48);

-- --------------------------------------------------------

--
-- Table structure for table `chat_messages`
--

CREATE TABLE `chat_messages` (
  `message_id` int(11) NOT NULL,
  `chat_id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `user_role` enum('tutor','parent') NOT NULL,
  `message` text DEFAULT NULL,
  `file_url` varchar(255) DEFAULT NULL,
  `file_type` varchar(50) DEFAULT NULL,
  `sent_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `chat_messages`
--

INSERT INTO `chat_messages` (`message_id`, `chat_id`, `sender_id`, `user_role`, `message`, `file_url`, `file_type`, `sent_at`) VALUES
(20, 10, 33, 'parent', 'hi', NULL, 'text', '2025-03-09 10:00:10'),
(90, 13, 33, 'parent', 'hi', NULL, 'text', '2025-03-16 11:32:32'),
(91, 13, 33, 'parent', NULL, 'uploads\\1742124759199-National University of Computing and Emerging.pdf', 'application', '2025-03-16 11:32:39'),
(92, 13, 33, 'parent', NULL, 'uploads\\1742124766592-stitch1.jpg', 'image', '2025-03-16 11:32:46'),
(93, 13, 50, 'tutor', NULL, 'uploads\\1742124774856-i210730 Report.pdf', 'application', '2025-03-16 11:32:54'),
(94, 13, 50, 'tutor', NULL, 'uploads\\1742124780433-stitch2.jpg', 'image', '2025-03-16 11:33:00'),
(95, 13, 50, 'tutor', 'hi 2', NULL, 'text', '2025-03-16 11:33:04'),
(96, 13, 50, 'tutor', 'hi', NULL, 'text', '2025-03-19 00:17:31'),
(97, 13, 33, 'parent', 'bye', NULL, 'text', '2025-03-19 00:17:38'),
(98, 13, 33, 'parent', NULL, 'uploads\\1742343496486-299.jpg', 'image', '2025-03-19 00:18:16');

-- --------------------------------------------------------

--
-- Table structure for table `chat_rooms`
--

CREATE TABLE `chat_rooms` (
  `chat_id` int(11) NOT NULL,
  `chat_name` varchar(255) NOT NULL,
  `parent_id` int(11) NOT NULL,
  `tutor_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `chat_rooms`
--

INSERT INTO `chat_rooms` (`chat_id`, `chat_name`, `parent_id`, `tutor_id`) VALUES
(10, 'Parent 33 - Tutor 47', 33, 47),
(13, 'Parent 33 - Tutor 50', 33, 50);

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
(8, 9, 31, 'student', 'hi', '2024-12-12 04:59:18'),
(9, 8, 47, 'tutor', 'hi', '2025-03-12 07:14:56'),
(10, 9, 38, 'student', 'kesa hai', '2025-05-29 19:27:16'),
(11, 9, 39, 'student', 'behtreen', '2025-05-29 19:27:49'),
(12, 9, 38, 'student', 'mmmm', '2025-05-29 19:28:06'),
(13, 9, 41, 'student', 'hi bhai', '2025-05-29 19:40:24');

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
(15, 9, 31, '2024-12-12 09:58:48'),
(16, 9, 33, '2025-03-06 20:50:12'),
(17, 9, 38, '2025-05-30 00:26:57'),
(18, 9, 39, '2025-05-30 00:27:33'),
(19, 9, 41, '2025-05-30 00:39:57');

-- --------------------------------------------------------

--
-- Table structure for table `emotions_details`
--

CREATE TABLE `emotions_details` (
  `Emotion_ID` int(11) NOT NULL,
  `Student_ID` int(11) NOT NULL,
  `Session_ID` varchar(255) NOT NULL,
  `Emotion_Type` varchar(50) NOT NULL,
  `captured_time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `emotions_details`
--

INSERT INTO `emotions_details` (`Emotion_ID`, `Student_ID`, `Session_ID`, `Emotion_Type`, `captured_time`) VALUES
(2, 33, 'GP7CFG9T8P', 'neutral', '2025-03-19 01:18:32'),
(3, 31, 'GP7CFG9T8P', 'neutral', '2025-03-19 01:18:32'),
(4, 32, 'GP7CFG9T8P', 'neutral', '2025-03-19 01:18:46'),
(5, 33, 'GP7CFG9T8P', 'fear', '2025-03-19 01:19:08'),
(6, 31, 'GP7CFG9T8P', 'neutral', '2025-03-19 01:19:14'),
(7, 32, 'GP7CFG9T8P', 'neutral', '2025-03-19 01:19:31'),
(8, 33, 'GP7CFG9T8P', 'happy', '2025-03-19 01:19:53'),
(9, 31, 'GP7CFG9T8P', 'happy', '2025-03-19 01:19:59'),
(10, 32, 'GP7CFG9T8P', 'neutral', '2025-03-19 01:20:15'),
(11, 33, 'GP7CFG9T8P', 'neutral', '2025-03-19 01:20:39'),
(12, 31, 'GP7CFG9T8P', 'fear', '2025-03-19 01:20:43'),
(13, 40, 'A1UK4EZJJ2', 'happy', '2025-05-29 19:41:12'),
(14, 36, 'A1UK4EZJJ2', 'neutral', '2025-05-29 19:41:13'),
(15, 42, 'A1UK4EZJJ2', 'neutral', '2025-05-29 19:41:37'),
(16, 39, 'A1UK4EZJJ2', 'neutral', '2025-05-29 19:41:46'),
(17, 40, 'A1UK4EZJJ2', 'sad', '2025-05-29 19:41:48'),
(18, 36, 'A1UK4EZJJ2', 'neutral', '2025-05-29 19:42:15'),
(19, 35, 'A1UK4EZJJ2', 'sad', '2025-05-29 19:42:16'),
(20, 42, 'A1UK4EZJJ2', 'neutral', '2025-05-29 19:42:22'),
(21, 39, 'A1UK4EZJJ2', 'fear', '2025-05-29 19:42:31'),
(22, 40, 'A1UK4EZJJ2', 'angry', '2025-05-29 19:42:33'),
(23, 36, 'A1UK4EZJJ2', 'fear', '2025-05-29 19:43:00'),
(24, 42, 'A1UK4EZJJ2', 'angry', '2025-05-29 19:43:07'),
(25, 39, 'A1UK4EZJJ2', 'neutral', '2025-05-29 19:43:16'),
(26, 40, 'A1UK4EZJJ2', 'fear', '2025-05-29 19:43:18'),
(27, 36, 'A1UK4EZJJ2', 'fear', '2025-05-29 19:43:45'),
(28, 42, 'A1UK4EZJJ2', 'neutral', '2025-05-29 19:43:52'),
(29, 39, 'A1UK4EZJJ2', 'fear', '2025-05-29 19:44:01'),
(30, 40, 'A1UK4EZJJ2', 'neutral', '2025-05-29 19:44:03'),
(31, 42, 'A1UK4EZJJ2', 'neutral', '2025-05-29 19:44:36'),
(32, 40, 'A1UK4EZJJ2', 'angry', '2025-05-29 19:44:48'),
(33, 38, 'A1UK4EZJJ2', 'sad', '2025-05-29 19:45:10'),
(34, 35, 'A1UK4EZJJ2', 'sad', '2025-05-29 19:45:18'),
(35, 42, 'A1UK4EZJJ2', 'fear', '2025-05-29 19:45:22'),
(36, 39, 'A1UK4EZJJ2', 'fear', '2025-05-29 19:45:30'),
(37, 41, 'A1UK4EZJJ2', 'neutral', '2025-05-29 19:45:33'),
(38, 38, 'A1UK4EZJJ2', 'sad', '2025-05-29 19:45:53'),
(39, 35, 'A1UK4EZJJ2', 'sad', '2025-05-29 19:46:03'),
(40, 39, 'A1UK4EZJJ2', 'fear', '2025-05-29 19:46:15'),
(41, 41, 'A1UK4EZJJ2', 'neutral', '2025-05-29 19:46:18'),
(42, 38, 'A1UK4EZJJ2', 'fear', '2025-05-29 19:46:38'),
(43, 39, 'A1UK4EZJJ2', 'neutral', '2025-05-29 19:47:00');

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
(8, 47, 31, 'D59M5U0TTL', '2025-03-03', '02:50:00', '05:55:00'),
(9, 47, 31, '9TZV4XBFUN', '2025-03-03', '09:03:00', '10:03:00'),
(10, 50, 33, 'Q6TGI6B04L', '2025-03-19', '05:18:00', '08:18:00'),
(11, 47, 31, 'GP7CFG9T8P', '2025-03-19', '06:13:00', '08:13:00'),
(12, 47, 32, 'GP7CFG9T8P', '2025-03-19', '06:13:00', '08:13:00'),
(13, 47, 33, 'GP7CFG9T8P', '2025-03-19', '06:13:00', '08:13:00'),
(14, 47, 31, 'DXGWW9KTIP', '2025-03-29', '00:30:00', '01:30:00'),
(15, 47, 32, 'DXGWW9KTIP', '2025-03-29', '00:30:00', '01:30:00'),
(16, 47, 31, 'B2TQK916R9', '2025-03-30', '17:21:00', '18:21:00'),
(17, 47, 32, 'B2TQK916R9', '2025-03-30', '17:21:00', '18:21:00'),
(18, 47, 31, 'BXRMBIDCJS', '2025-03-31', '04:30:00', '05:30:00'),
(19, 47, 32, 'BXRMBIDCJS', '2025-03-31', '04:30:00', '05:30:00'),
(20, 47, 31, 'NIDCTI0JAE', '2025-04-04', '18:59:00', '20:59:00'),
(21, 47, 32, 'NIDCTI0JAE', '2025-04-04', '18:59:00', '20:59:00'),
(22, 47, 31, 'W30UBM41OF', '2025-04-04', '22:08:00', '23:50:00'),
(23, 47, 32, 'W30UBM41OF', '2025-04-04', '22:08:00', '23:50:00'),
(24, 47, 31, 'EOA1AJ5CQ0', '2025-04-04', '01:27:00', '03:27:00'),
(25, 47, 32, 'EOA1AJ5CQ0', '2025-04-04', '01:27:00', '03:27:00'),
(26, 47, 31, 'LT723J27PL', '2025-04-05', '18:55:00', '20:56:00'),
(27, 47, 32, 'LT723J27PL', '2025-04-05', '18:55:00', '20:56:00'),
(28, 47, 31, 'NY4JFQZBBJ', '2025-04-10', '16:31:00', '18:31:00'),
(29, 47, 32, 'NY4JFQZBBJ', '2025-04-10', '16:31:00', '18:31:00'),
(30, 47, 31, '6AOPY1Q3L8', '2025-04-10', '19:00:00', '20:00:00'),
(31, 47, 32, '6AOPY1Q3L8', '2025-04-10', '19:00:00', '20:00:00'),
(32, 47, 31, 'GC43NY7UF6', '2025-04-10', '21:41:00', '23:41:00'),
(33, 47, 32, 'GC43NY7UF6', '2025-04-10', '21:41:00', '23:41:00'),
(34, 47, 31, 'GMC9DIDLUW', '2025-04-10', '11:53:00', '00:53:00'),
(35, 47, 34, 'GMC9DIDLUW', '2025-04-10', '11:53:00', '00:53:00'),
(36, 47, 31, 'VME91DX2LP', '2025-04-10', '00:03:00', '01:03:00'),
(37, 47, 34, 'VME91DX2LP', '2025-04-10', '00:03:00', '01:03:00'),
(38, 47, 31, 'HA2AS7ZCSY', '2025-04-11', '13:07:00', '14:07:00'),
(39, 47, 32, 'HA2AS7ZCSY', '2025-04-11', '13:07:00', '14:07:00'),
(40, 47, 34, 'HA2AS7ZCSY', '2025-04-11', '13:07:00', '14:07:00'),
(41, 48, 35, 'A1UK4EZJJ2', '2025-05-29', '00:39:00', '01:39:00'),
(42, 48, 36, 'A1UK4EZJJ2', '2025-05-29', '00:39:00', '01:39:00'),
(43, 48, 37, 'A1UK4EZJJ2', '2025-05-29', '00:39:00', '01:39:00'),
(44, 48, 38, 'A1UK4EZJJ2', '2025-05-29', '00:39:00', '01:39:00'),
(45, 48, 39, 'A1UK4EZJJ2', '2025-05-29', '00:39:00', '01:39:00'),
(46, 48, 40, 'A1UK4EZJJ2', '2025-05-29', '00:39:00', '01:39:00'),
(47, 48, 41, 'A1UK4EZJJ2', '2025-05-29', '00:39:00', '01:39:00'),
(48, 48, 42, 'A1UK4EZJJ2', '2025-05-29', '00:39:00', '01:39:00'),
(49, 47, 33, 'PYFYZ4CYR2', '2025-06-04', '15:34:00', '16:34:00');

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
(48, 'aliananwar0@gmail.com', 415941, '2025-03-05 23:52:11', 'authorized'),
(53, 'zeeaanmalick@gmail.com', 773512, '2025-05-29 22:17:18', 'authorized');

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
(32, 32, '25P-2934', 'munammustafa953@gmail.com', '03435231900', '$2b$10$Dcm8Qds6u6U2evoxKfzRke6rGqe.OBhOOahK08JJO2JecUxtvWLXa'),
(33, 33, '25P-6505', 'i210730@nu.edu.pk', '12345678123', '$2b$10$5g0rqJaVp79O3VvjEpgEA.nf/ElcWwHtspRw/bm68Hz6izvGKSd1K'),
(34, 34, '25P-9799', 'm.raza.momi@gmail.com', '03041506232', '$2b$10$568efQkL9uZQHM.RpiUcCuC8BzmrZ6Bkz1b9ekUt3Dwc8Cd6uxb/K'),
(35, 35, '25P-8456', 'm.raza.momi@gmail.com', '03041506231', '$2b$10$oFn4IOS.YZsSWilC.4/ufOtQVgfME9IwN/hfnrwlEmIaNlG8tsuh.'),
(36, 36, '25P-9242', 'm.raza.momi@gmail.com', '03041506231', '$2b$10$8w9q0djsKo/jKYigkufmneCNHya2ALt9aO2e6yhI9yqWNIsHzcjtm'),
(37, 37, '25P-5729', 'm.raza.momi@gmail.com', '03041506231', '$2b$10$TQ.HeytoC.ZaaKVmQN2P/ekuqIfwh17CCw44iXYAc8NlIPR4E4jfq'),
(38, 38, '25P-5048', 'm.raza.momi@gmail.com', '03041506231', '$2b$10$N8/eXQsPTglugpnfQugjmeth9Xm0sLB0NKtAjME/cFtPO.rn89b3O'),
(39, 39, '25P-9719', 'm.raza.momi@gmail.com', '03041506231', '$2b$10$nN.prn6RngFumw58DbhySeydRGOw/dUdwLpocmUPaRhxZkWtpdRFa'),
(40, 40, '25P-6762', 'm.raza.momi@gmail.com', '03041506231', '$2b$10$.qvi8UHF2r9B9zRwfZaMRerRYBacCc2VhimITxEiKqkX/Hd/idW3.'),
(41, 41, '25P-9782', 'm.raza.momi@gmail.com', '03041506231', '$2b$10$OJhLn/GreEB0ViKebHKM/e9W2Jo7WYHd2w/szr9nbn5blpF5f00lO'),
(42, 42, '25P-9380', 'm.raza.momi@gmail.com', '03041506231', '$2b$10$/y3m4XkjCx/gEh/trnnhZODOhgMa4X2DL4QPrQKeFNfigYq.Nm6SS');

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
(22, 33, 'approved', 33, 'approved', 50, 'approved'),
(23, 33, 'approved', 33, 'approved', 47, 'approved'),
(24, 34, 'approved', 34, 'approved', 47, 'approved'),
(25, 35, 'approved', 35, 'pending', 48, 'approved'),
(26, 35, 'approved', 35, 'pending', 47, 'pending'),
(27, 36, 'approved', 36, 'pending', 48, 'approved'),
(28, 36, 'approved', 36, 'pending', 47, 'pending'),
(29, 37, 'approved', 37, 'pending', 47, 'pending'),
(30, 37, 'approved', 37, 'pending', 48, 'approved'),
(31, 38, 'approved', 38, 'pending', 47, 'pending'),
(32, 38, 'approved', 38, 'pending', 48, 'approved'),
(33, 39, 'approved', 39, 'pending', 47, 'pending'),
(34, 39, 'approved', 39, 'pending', 48, 'approved'),
(35, 40, 'approved', 40, 'pending', 47, 'pending'),
(36, 40, 'approved', 40, 'pending', 48, 'approved'),
(37, 41, 'approved', 41, 'pending', 47, 'pending'),
(38, 41, 'approved', 41, 'pending', 48, 'approved'),
(39, 42, 'approved', 42, 'pending', 47, 'pending'),
(40, 42, 'approved', 42, 'pending', 48, 'approved');

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
(32, 'Munam Mustafa', '25S-2934', 'Munam25', 'munammustafa253@gmail.com', '03435231909', '$2b$10$0zmWPpVNAc0oR9fy.Om8XObcmbglRcdliUl5oX2OvKzO7mKw7Hxq6'),
(33, 'Alian Anwar', '25S-6505', 'Alian 72', 'rajaalyan977@gmail.com', '12345678912', '$2b$10$k5ScogwmU7PfupGUFUOzrO3hNb..eJh4wGixCnvqgcl4cLycNKg42'),
(34, 'Muhammad Raza', '25S-9799', 'mraza', 'i210511@nu.edu.pk', '03041506231', '$2b$10$M9J4HlszOoqMEWhUajxv6O4eROrPC.O1kFUvXtmLJJctIgPexvDfy'),
(35, 'Zian Saeed', '25S-8456', 'zian123', 'zeeaanmalick@gmail.com', '123456789012', '$2b$10$JfqCrYzgRm2KV8oEr1nloenHcRcLJ4oH1RO78bbOh5pqA7XbFshRK'),
(36, 'Ahmad Raza', '25S-9242', 'ahmad123', 'i211574@nu.edu.pk', '03041506121', '$2b$10$54cdf89VSVKFyfhkMuGA/epQSXFyCyI1nMvAzq9H3l8s1akEx/A/S'),
(37, 'Dawood Tanvir', '25S-5729', 'dawood123', 'i211665@nu.edu.pk', '03041506569', '$2b$10$ICc9vHJ7g1yMf2lmufsDG.GJoJcNQWGSf6XTxg1p0jPPlLVeog1m2'),
(38, 'Usman Zafar', '25S-5048', 'zafar123', 'i210608@nu.edu.pk', '03041506900', '$2b$10$RRSp.hsJ6EOSKkX2e7Bo5ecJ6xDGEMpWKETFnLrHbM3oBUlH/qg46'),
(39, 'Abdullah Tahir', '25S-9719', 'abd123', 'i212960@nu.edu.pk', '03041506111', '$2b$10$cCmjQSi1847jOmsFkiQj5en7MtXUOkVc6vTn3znLnW1AfVS9V5is.'),
(40, 'Ammar Arshad', '25S-6762', 'ammar123', 'i210456@nu.edu.pk', '03041506999', '$2b$10$BcBGKHLzNR.vxRtlmKVUTevf8M3jrb4VJLr7p5Mu2xhaGoSfcAbdC'),
(41, 'Hadeed Rauf', '25S-9782', 'hadeed123', 'i210859@nu.edu.pk', '03041506888', '$2b$10$K8QU4gcl1mbfoEp/FLumeePUF0lGIghAdAvr6LCtcKErZ4bxCNj/u'),
(42, 'Sohail Shabaz', '25S-9380', 'sohail123', 'i211356@nu.edu.pk', '03041506333', '$2b$10$8uQO1sUn6.ipWGIEaVkGhOURPzFm2RjrabWsie5ADB8YCbMviDGvK');

-- --------------------------------------------------------

--
-- Table structure for table `student_tutor_chat_rooms`
--

CREATE TABLE `student_tutor_chat_rooms` (
  `chat_id` int(11) NOT NULL,
  `chat_name` varchar(255) NOT NULL,
  `student_id` int(11) NOT NULL,
  `tutor_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student_tutor_chat_rooms`
--

INSERT INTO `student_tutor_chat_rooms` (`chat_id`, `chat_name`, `student_id`, `tutor_id`) VALUES
(1, 'Student 33 - Tutor 47', 33, 47),
(6, 'Student 33 - Tutor 50', 33, 50),
(7, 'Student 31 - Tutor 47', 31, 47),
(8, 'Student 35 - Tutor 48', 35, 48),
(9, 'Student 38 - Tutor 48', 38, 48),
(10, 'Student 42 - Tutor 48', 42, 48);

-- --------------------------------------------------------

--
-- Table structure for table `student_tutor_messages`
--

CREATE TABLE `student_tutor_messages` (
  `message_id` int(11) NOT NULL,
  `chat_id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `user_role` enum('tutor','student') NOT NULL,
  `message` text DEFAULT NULL,
  `file_url` varchar(255) DEFAULT NULL,
  `file_type` varchar(50) DEFAULT NULL,
  `sent_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student_tutor_messages`
--

INSERT INTO `student_tutor_messages` (`message_id`, `chat_id`, `sender_id`, `user_role`, `message`, `file_url`, `file_type`, `sent_at`) VALUES
(43, 6, 33, 'student', 'hi', NULL, NULL, '2025-03-16 11:34:57'),
(44, 6, 33, 'student', NULL, 'uploads\\1742124906312-WhatsApp Image 2025-03-11 at 10.29.57_2f5b3b05.jpg', 'image', '2025-03-16 11:35:06'),
(45, 6, 33, 'student', NULL, 'uploads\\1742124911443-National University of Computing and Emerging.pdf', 'application', '2025-03-16 11:35:11'),
(46, 6, 50, 'tutor', NULL, 'uploads\\1742124930647-stitch1.jpg', 'image', '2025-03-16 11:35:30'),
(47, 6, 50, 'tutor', NULL, 'uploads\\1742124939523-NLP Asssignment 3.ipynb', 'application', '2025-03-16 11:35:39'),
(48, 6, 50, 'tutor', 'hi 2', NULL, NULL, '2025-03-16 11:35:46'),
(49, 6, 33, 'student', 'hi', NULL, NULL, '2025-03-19 00:15:11'),
(50, 6, 50, 'tutor', 'bye', NULL, NULL, '2025-03-19 00:15:25'),
(51, 7, 31, 'student', 'nm', NULL, NULL, '2025-04-04 13:58:36'),
(52, 8, 48, 'tutor', 'h', NULL, NULL, '2025-05-29 17:56:22'),
(53, 9, 38, 'student', 'kesa hai', NULL, NULL, '2025-05-29 19:24:02'),
(54, 9, 38, 'student', 'kidaaaa', NULL, NULL, '2025-05-29 19:24:57'),
(55, 10, 42, 'student', 'Hello motherfucker', NULL, NULL, '2025-05-29 19:32:36');

-- --------------------------------------------------------

--
-- Table structure for table `tutor_generate_quiz_table`
--

CREATE TABLE `tutor_generate_quiz_table` (
  `Quiz_ID` int(11) NOT NULL,
  `Tutor_ID` int(11) NOT NULL,
  `Quiz_Topic` varchar(255) NOT NULL,
  `Quiz_Question` text NOT NULL,
  `Quiz_Option1` varchar(255) NOT NULL,
  `Quiz_Option2` varchar(255) NOT NULL,
  `Quiz_Option3` varchar(255) NOT NULL,
  `Quiz_Option4` varchar(255) NOT NULL,
  `Quiz_Correct_Option` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tutor_generate_quiz_table`
--

INSERT INTO `tutor_generate_quiz_table` (`Quiz_ID`, `Tutor_ID`, `Quiz_Topic`, `Quiz_Question`, `Quiz_Option1`, `Quiz_Option2`, `Quiz_Option3`, `Quiz_Option4`, `Quiz_Correct_Option`, `created_at`) VALUES
(10, 47, 'def', '1', '1', '1', '11', '1', '2', '2025-06-12 14:45:28'),
(13, 47, 'ABC', '1', '1', '1', '1', '1', '1', '2025-06-12 17:01:19'),
(14, 47, 'ABC', '1', '1', '1', '1', '1', '1', '2025-06-12 17:01:19'),
(15, 47, 'ABC', '1', '1', '1', '1', '1', '1', '2025-06-12 17:01:19'),
(16, 47, 'ABC', '1', '1', '1', '1', '1', '1', '2025-06-12 17:01:19'),
(17, 47, 'ABC', '1', '1', '1', '1', '1', '1', '2025-06-12 17:01:19');

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
(29, 48, 'i210460@nu.edu.pk', '24T-8073', 'Pakistan', 'Islamabad', 'English, Urdu', 'FAST NUCES', 'CS', 'BS', 'Nil', '2008', '2014', '48.pdf', 'English, Maths', '10', 'Group Session', 'I am Munam Mustafa', 'This is demo.', 3000.00, 'Monday, Tuesday', 'anytime', '48.jpeg'),
(31, 50, 'rajaalyan977@gmail.com', '25T-5025', '', '', 'English', '', '', '', '', '0000', '0000', NULL, 'English, Urdu', '', 'Both', '', '', 1500.00, 'Monday', 'anytime', '50.jpg');

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
(48, 'accepted', 27),
(50, 'accepted', 29);

-- --------------------------------------------------------

--
-- Table structure for table `tutor_schedule_quiz_table`
--

CREATE TABLE `tutor_schedule_quiz_table` (
  `Schedule_ID` int(11) NOT NULL,
  `Quiz_ID` int(11) NOT NULL,
  `Tutor_ID` int(11) NOT NULL,
  `Student_ID` int(11) NOT NULL,
  `Quiz_Topic` varchar(255) NOT NULL,
  `Start_Time` datetime NOT NULL,
  `End_Time` datetime NOT NULL,
  `status` varchar(50) DEFAULT 'pending',
  `Quiz_score` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tutor_schedule_quiz_table`
--

INSERT INTO `tutor_schedule_quiz_table` (`Schedule_ID`, `Quiz_ID`, `Tutor_ID`, `Student_ID`, `Quiz_Topic`, `Start_Time`, `End_Time`, `status`, `Quiz_score`) VALUES
(4, 12, 47, 33, 'ABC', '2025-06-12 20:37:00', '2025-06-12 21:37:00', 'completed', 60),
(6, 13, 47, 31, 'ABC', '2025-06-12 22:23:00', '2025-06-12 23:23:00', 'completed', 80);

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
(48, 'Munam Mustafa', '24T-8073', 'i210460@nu.edu.pk', '03435231909', '$2b$10$6L2YYXf96j6R1jyCBhWSFu3mD3skWOsw7cy3gqV8oaBzQ/AP/Dlke', 'Munam25'),
(50, 'Alian Anwar', '25T-5025', 'rajaalyan977@gmail.com', '03486977089', '$2b$10$YWB.V7su/0jzkbAxsPG03Ozd6MB2BDTjBJk2xE9C3d77O6BiYcbSG', 'Alian 72');

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
-- Indexes for table `chat_messages`
--
ALTER TABLE `chat_messages`
  ADD PRIMARY KEY (`message_id`),
  ADD KEY `chat_id` (`chat_id`);

--
-- Indexes for table `chat_rooms`
--
ALTER TABLE `chat_rooms`
  ADD PRIMARY KEY (`chat_id`),
  ADD UNIQUE KEY `parent_id` (`parent_id`,`tutor_id`);

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
-- Indexes for table `emotions_details`
--
ALTER TABLE `emotions_details`
  ADD PRIMARY KEY (`Emotion_ID`);

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
-- Indexes for table `student_tutor_chat_rooms`
--
ALTER TABLE `student_tutor_chat_rooms`
  ADD PRIMARY KEY (`chat_id`),
  ADD KEY `student_id` (`student_id`),
  ADD KEY `tutor_id` (`tutor_id`);

--
-- Indexes for table `student_tutor_messages`
--
ALTER TABLE `student_tutor_messages`
  ADD PRIMARY KEY (`message_id`),
  ADD KEY `chat_id` (`chat_id`);

--
-- Indexes for table `tutor_generate_quiz_table`
--
ALTER TABLE `tutor_generate_quiz_table`
  ADD PRIMARY KEY (`Quiz_ID`);

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
-- Indexes for table `tutor_schedule_quiz_table`
--
ALTER TABLE `tutor_schedule_quiz_table`
  ADD PRIMARY KEY (`Schedule_ID`);

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
  MODIFY `record_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `chat_messages`
--
ALTER TABLE `chat_messages`
  MODIFY `message_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=99;

--
-- AUTO_INCREMENT for table `chat_rooms`
--
ALTER TABLE `chat_rooms`
  MODIFY `chat_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `communities`
--
ALTER TABLE `communities`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `community_chat`
--
ALTER TABLE `community_chat`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `community_files`
--
ALTER TABLE `community_files`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `community_members`
--
ALTER TABLE `community_members`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `emotions_details`
--
ALTER TABLE `emotions_details`
  MODIFY `Emotion_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT for table `meeting_details`
--
ALTER TABLE `meeting_details`
  MODIFY `Meeting_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;

--
-- AUTO_INCREMENT for table `otp_table`
--
ALTER TABLE `otp_table`
  MODIFY `otpid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- AUTO_INCREMENT for table `parent_table`
--
ALTER TABLE `parent_table`
  MODIFY `Parent_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `student_approve_tutor_status_table`
--
ALTER TABLE `student_approve_tutor_status_table`
  MODIFY `status_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `student_table`
--
ALTER TABLE `student_table`
  MODIFY `Student_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `student_tutor_chat_rooms`
--
ALTER TABLE `student_tutor_chat_rooms`
  MODIFY `chat_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `student_tutor_messages`
--
ALTER TABLE `student_tutor_messages`
  MODIFY `message_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=56;

--
-- AUTO_INCREMENT for table `tutor_generate_quiz_table`
--
ALTER TABLE `tutor_generate_quiz_table`
  MODIFY `Quiz_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `tutor_profile_data_table`
--
ALTER TABLE `tutor_profile_data_table`
  MODIFY `tutor_profile_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `tutor_profile_status_table`
--
ALTER TABLE `tutor_profile_status_table`
  MODIFY `profile_status_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `tutor_schedule_quiz_table`
--
ALTER TABLE `tutor_schedule_quiz_table`
  MODIFY `Schedule_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `tutor_table`
--
ALTER TABLE `tutor_table`
  MODIFY `Tutor_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

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
-- Constraints for table `chat_messages`
--
ALTER TABLE `chat_messages`
  ADD CONSTRAINT `chat_messages_ibfk_1` FOREIGN KEY (`chat_id`) REFERENCES `chat_rooms` (`chat_id`) ON DELETE CASCADE;

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
-- Constraints for table `student_tutor_chat_rooms`
--
ALTER TABLE `student_tutor_chat_rooms`
  ADD CONSTRAINT `student_tutor_chat_rooms_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `student_table` (`Student_ID`) ON DELETE CASCADE,
  ADD CONSTRAINT `student_tutor_chat_rooms_ibfk_2` FOREIGN KEY (`tutor_id`) REFERENCES `tutor_table` (`Tutor_ID`) ON DELETE CASCADE;

--
-- Constraints for table `student_tutor_messages`
--
ALTER TABLE `student_tutor_messages`
  ADD CONSTRAINT `student_tutor_messages_ibfk_1` FOREIGN KEY (`chat_id`) REFERENCES `student_tutor_chat_rooms` (`chat_id`) ON DELETE CASCADE;

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
