CREATE DATABASE IF NOT EXISTS `changes_db`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'enigma'@'%' IDENTIFIED BY 'enigma';
GRANT ALL PRIVILEGES ON `bachelordb`.* TO 'enigma'@'%';
GRANT ALL PRIVILEGES ON `changes_db`.* TO 'enigma'@'%';
FLUSH PRIVILEGES;
