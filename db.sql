CREATE TABLE IF NOT EXISTS `playtime` (
    `id` INT AUTO_INCREMENT,
    `identifier` VARCHAR(60) NOT NULL,
    `name` VARCHAR(100) DEFAULT NULL,
    `time` INT DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE KEY `identifier` (`identifier`)
);