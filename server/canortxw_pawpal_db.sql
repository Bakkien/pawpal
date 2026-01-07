-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jan 07, 2026 at 11:47 AM
-- Server version: 10.3.39-MariaDB-log-cll-lve
-- PHP Version: 8.1.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `canortxw_pawpal_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_adoptions`
--

CREATE TABLE `tbl_adoptions` (
  `adoption_id` int(11) NOT NULL,
  `pet_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `house_type` enum('Apartment','Condo','Landed House') DEFAULT NULL,
  `owned` enum('Yes','No') NOT NULL,
  `reason` text DEFAULT NULL,
  `status` enum('Pending','Approve','Reject') NOT NULL DEFAULT 'Pending',
  `requested_date` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_donations`
--

CREATE TABLE `tbl_donations` (
  `donation_id` int(11) NOT NULL,
  `pet_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `donation_type` enum('Food','Medical','Money') DEFAULT NULL,
  `amount` double(10,2) DEFAULT 0.00,
  `description` text DEFAULT NULL,
  `donation_date` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `tbl_donations`
--

INSERT INTO `tbl_donations` (`donation_id`, `pet_id`, `user_id`, `donation_type`, `amount`, `description`, `donation_date`) VALUES
(1, 2, 3, 'Money', 5.00, 'Cash Donation', '2026-01-04 20:54:36'),
(2, 2, 3, 'Money', 5.00, 'Cash Donation', '2026-01-04 21:00:47'),
(3, 2, 3, 'Money', 10.50, 'Cash Donation', '2026-01-05 08:44:31'),
(4, 2, 3, 'Medical', 0.00, '2 pack of pain bills', '2026-01-06 13:15:27');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_pets`
--

CREATE TABLE `tbl_pets` (
  `pet_id` int(11) NOT NULL COMMENT 'Unique ID',
  `user_id` int(11) NOT NULL COMMENT 'Foreign key to tbl_users',
  `pet_name` varchar(100) NOT NULL,
  `pet_type` varchar(50) NOT NULL,
  `gender` varchar(50) NOT NULL COMMENT 'Male/Female/Both',
  `age` varchar(50) NOT NULL,
  `category` varchar(50) NOT NULL COMMENT 'Adoption/Donation/Help',
  `health` varchar(50) NOT NULL COMMENT 'Healthy/Critical/Unknown',
  `description` text DEFAULT NULL,
  `image_paths` text DEFAULT NULL COMMENT 'JSON or comma-separated list of up to 3 paths',
  `lat` varchar(50) DEFAULT NULL COMMENT 'Latitude',
  `lng` varchar(50) DEFAULT NULL COMMENT 'Longitude',
  `created_at` datetime DEFAULT current_timestamp(),
  `is_adopted` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_pets`
--

INSERT INTO `tbl_pets` (`pet_id`, `user_id`, `pet_name`, `pet_type`, `gender`, `age`, `category`, `health`, `description`, `image_paths`, `lat`, `lng`, `created_at`, `is_adopted`) VALUES
(2, 1, 'Doggie', 'Dog', 'Male', '2 years old', 'Donation Request', 'Critical', 'He is injured, please help me!', '[\"image1: ../uploads/pet/pet_2_1.png\"]', '6.4591117', '100.5022967', '2025-12-05 21:44:19', 0),
(4, 1, 'Little White', 'Rabbit', 'Female', '1 years old', 'Help/Rescue', 'Healthy', 'Help me, my rabbit is run away from my house.', '[\"image1: ../uploads/pet/pet_4_1.png\"]', '6.4606617', '100.5019317', '2025-12-06 09:00:25', 0),
(5, 1, 'Kitties', 'Cat', 'Both', '2 months', 'Adoption', 'Healthy', 'There got 4 cute kitties come adopt them.', '[\"image1: ../uploads/pet/pet_5_1.png\"]', '6.4606617', '100.5019317', '2026-01-02 11:30:46', 0),
(6, 2, 'Snoky', 'Cat', 'Male', '3 months', 'Adoption', 'Healthy', 'He is hiding under the train rail.', '[\"image1: ../uploads/pet/pet_6_1.png\"]', '6.4606617', '100.5019317', '2026-01-02 11:32:27', 0);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(11) NOT NULL,
  `avatar` text DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `wallet` double(10,2) NOT NULL DEFAULT 0.00,
  `reg_date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `avatar`, `name`, `email`, `password`, `phone`, `wallet`, `reg_date`) VALUES
(1, '../uploads/profile/user_1.png', 'Tan Yee Kien', 'yeekientan@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '0123456789', 30.50, '2025-11-24 12:48:24'),
(2, NULL, 'Bakkien', 'bakkien@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '0123456789', 0.00, '2025-11-24 12:54:17'),
(3, NULL, 'jackshen', 'jackshen@gmail.com', '2891baceeef1652ee698294da0e71ba78a2a4064', '0123456789', 129.50, '2026-01-02 14:19:25');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_adoptions`
--
ALTER TABLE `tbl_adoptions`
  ADD PRIMARY KEY (`adoption_id`);

--
-- Indexes for table `tbl_donations`
--
ALTER TABLE `tbl_donations`
  ADD PRIMARY KEY (`donation_id`);

--
-- Indexes for table `tbl_pets`
--
ALTER TABLE `tbl_pets`
  ADD PRIMARY KEY (`pet_id`),
  ADD KEY `fk_pet_user` (`user_id`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_adoptions`
--
ALTER TABLE `tbl_adoptions`
  MODIFY `adoption_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_donations`
--
ALTER TABLE `tbl_donations`
  MODIFY `donation_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tbl_pets`
--
ALTER TABLE `tbl_pets`
  MODIFY `pet_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique ID', AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tbl_pets`
--
ALTER TABLE `tbl_pets`
  ADD CONSTRAINT `fk_pet_user` FOREIGN KEY (`user_id`) REFERENCES `tbl_users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
