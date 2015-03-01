#  Description:
#    Update ImageSeek data from v3 to v4 manually.
#  Author:
#    serveryang@qq.com

# MySQL usage
USE `imgseek_v4.0_production`;

INSERT INTO `imgseek_v4.0_production`.scenics(province_id, name, slug, places_count, pictures_count, created_at, updated_at)
SELECT 1, name, '-', places_count, pictures_count, created_at, updated_at
FROM `imgseek_v3.0_production`.scenics;

INSERT INTO `imgseek_v4.0_production`.places(scenic_id, name, slug, description, audio, audio_type, audio_size, cover, cover_type, cover_size, pictures_count, created_at, updated_at)
SELECT scenic_id, name, '-', description, audio, audio_type, audio_size, cover, cover_type, cover_size, pictures_count, created_at, updated_at
FROM `imgseek_v3.0_production`.places;

INSERT INTO `imgseek_v4.0_production`.pictures(place_id, scenic_id, title, image, image_type, image_size, sig, siglen, feature_count, uid, status, match_result, created_at, updated_at)
SELECT place_id, scenic_id, title, image, image_type, image_size, sig, siglen, 0, '', '', '', created_at, updated_at
FROM `imgseek_v3.0_production`.pictures;

SET SQL_SAFE_UPDATES=0;
UPDATE `imgseek_v4.0_production`.places SET scenic_id = '2' WHERE scenic_id = '3';
UPDATE `imgseek_v4.0_production`.places SET scenic_id = '3' WHERE scenic_id = '4';
UPDATE `imgseek_v4.0_production`.places SET scenic_id = '4' WHERE scenic_id = '5';

UPDATE `imgseek_v4.0_production`.pictures SET scenic_id = '2' WHERE scenic_id = '3';
UPDATE `imgseek_v4.0_production`.pictures SET scenic_id = '3' WHERE scenic_id = '4';
UPDATE `imgseek_v4.0_production`.pictures SET scenic_id = '4' WHERE scenic_id = '5';


DROP PROCEDURE IF EXISTS pro_bind_placd_id_to_picture;

DROP TABLE IF EXISTS pids;
CREATE TABLE IF NOT EXISTS pids ( place_id_v4 INT, place_name VARCHAR(255) , image VARCHAR(255) );
TRUNCATE TABLE pids;

SET SQL_SAFE_UPDATES = 0;

CREATE INDEX idx_v4_pictures_placeid_image ON `imgseek_v4.0_production`.pictures(place_id, image);

DELIMITER //
CREATE PROCEDURE pro_bind_placd_id_to_picture()
BEGIN
	DECLARE place_id INT DEFAULT 0;
	DECLARE place_id_v4 INT DEFAULT -1;
	DECLARE place_name VARCHAR(255) DEFAULT NULL;
	DECLARE picture_image VARCHAR(255) DEFAULT NULL;
	DECLARE done INT DEFAULT 0;
	DECLARE zero_place_id_count INT DEFAULT -1;

	DECLARE cur CURSOR FOR
	(
		SELECT pic.place_id, p.name, pic.image
		FROM `imgseek_v3.0_production`.places AS p, `imgseek_v3.0_production`.pictures AS pic
		WHERE p.id = pic.place_id
	);
	DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;

	OPEN cur;
	FETCH cur INTO place_id, place_name, picture_image;

	WHILE done <> 1 DO
		FETCH cur INTO place_id, place_name, picture_image;
		SET place_id_v4 = ( SELECT id FROM `imgseek_v4.0_production`.places AS p WHERE p.name = place_name );

		IF place_id_v4 = -1 THEN
			SELECT CONCAT('Find unbind place_name : ', place_name );
		ELSE
			UPDATE `imgseek_v4.0_production`.pictures SET place_id = place_id_v4 WHERE image = picture_image;
		END IF;

		INSERT INTO pids VALUE( place_id_v4, place_name, picture_image );
	END WHILE;
	CLOSE cur;
END; //

DELIMITER ;
CALL pro_bind_placd_id_to_picture();

DROP INDEX idx_v4_pictures_placeid_image ON `imgseek_v4.0_production`.pictures;
