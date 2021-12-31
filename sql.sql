USE ``;

CREATE TABLE IF NOT EXISTS `esx_shifts` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `identifier` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    `start` varchar(50) DEFAULT NULL,
    `end` varchar(50) DEFAULT NULL,
    `job` varchar(50) DEFAULT NULL,
    `changable` text DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8;
