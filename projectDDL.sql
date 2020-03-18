CREATE DATABASE IF NOT EXISTS group5;

USE group5;

-- SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS URL;
DROP TABLE IF EXISTS Hashtag;
DROP TABLE IF EXISTS Tweet;
DROP TABLE IF EXISTS User;

CREATE TABLE User (
    screen_name VARCHAR(15) NOT NULL,
    name VARCHAR(20) DEFAULT NULL,
    sub_category VARCHAR(8) DEFAULT NULL,
    category VARCHAR(22) DEFAULT NULL,
    ofstate VARCHAR(20) DEFAULT NULL,
    numFollowers INT,
    numFollowing INT,
    PRIMARY KEY (screen_name)
);
    
CREATE TABLE Tweet (
    tid VARCHAR(19) NOT NULL,
    textbody VARCHAR(280) DEFAULT NULL,
    retweet_count INT,
    retweeted INT(1),
    posted TIMESTAMP,
    posting_user VARCHAR(15) NOT NULL,
    posted_month int,
    posted_year int,
    PRIMARY KEY (tid),
    FOREIGN KEY (posting_user)
        REFERENCES User (screen_name)
);
    
CREATE TABLE Hashtag (
    tid VARCHAR(19) NOT NULL,
    hashtagname VARCHAR(239) NOT NULL,
    PRIMARY KEY (tid , hashtagname),
    FOREIGN KEY (tid)
        REFERENCES Tweet (tid)
);
    

CREATE TABLE URL (
    tid VARCHAR(19) NOT NULL,
    url VARCHAR(500) NOT NULL,
    PRIMARY KEY (tid , url),
    FOREIGN KEY (tid)
        REFERENCES Tweet (tid)
);
 
DROP TRIGGER IF EXISTS ensure_presidential_candidate_state_null;
DELIMITER //
CREATE TRIGGER ensure_presidential_candidate_state_null
BEFORE INSERT ON user
FOR EACH ROW
BEGIN
	IF NEW.category LIKE "presidential_candidate"
    THEN
		SET NEW.ofstate = NULL;
	END IF;
END; //
DELIMITER ;

DROP TRIGGER IF EXISTS ensure_retweet_count_zero;
DELIMITER //
CREATE TRIGGER ensure_retweet_count_zero
BEFORE INSERT ON tweet
FOR EACH ROW
BEGIN
	IF NEW.retweeted = 1
    THEN
		SET NEW.retweet_count = 0;
	END IF;
END; //
DELIMITER ;

DROP TRIGGER IF EXISTS validate_category;
DELIMITER //
CREATE TRIGGER validate_category
BEFORE INSERT ON user
FOR EACH ROW
BEGIN
	IF NEW.sub_category NOT LIKE "senate_group"
    AND NEW.sub_category NOT LIKE "presidential_candidate"
    AND NEW.sub_category NOT LIKE "reporter"
    AND NEW.sub_category NOT LIKE "senator"
    AND NEW.sub_category NOT LIKE "general"
    AND NEW.sub_category != NULL
    THEN
		SIGNAL SQLSTATE '44000' SET MESSAGE_TEXT = 'Invalid category';
	END IF;
END; //
DELIMITER ;

DROP TRIGGER IF EXISTS validate_sub_category;
DELIMITER //
CREATE TRIGGER validate_sub_category
BEFORE INSERT ON user
FOR EACH ROW
BEGIN
	IF NEW.sub_category NOT LIKE "GOP"
    AND NEW.sub_category NOT LIKE "Democrat"
    AND NEW.sub_category NOT LIKE "NA"
    AND NEW.sub_category != NULL
    THEN
		SIGNAL SQLSTATE '44000' SET MESSAGE_TEXT = 'Invalid sub_category';
	END IF;
END; //
DELIMITER ;

DROP TRIGGER IF EXISTS format_state;
DELIMITER //
CREATE TRIGGER format_state
BEFORE INSERT ON user
FOR EACH ROW
BEGIN
	IF NEW.ofstate NOT LIKE "__"
    THEN
		SET NEW.ofstate = (
			CASE
				WHEN NEW.ofstate LIKE "Alabama" THEN "AL"
				WHEN NEW.ofstate LIKE "Alaska" THEN	"AK"
				WHEN NEW.ofstate LIKE "Arizona" THEN "AZ"
				WHEN NEW.ofstate LIKE "Arkansas" THEN "AR"
				WHEN NEW.ofstate LIKE "California" THEN	"CA"
				WHEN NEW.ofstate LIKE "Colorado" THEN "CO"
				WHEN NEW.ofstate LIKE "Connecticut" THEN "CT"
				WHEN NEW.ofstate LIKE "Delaware" THEN "DE"
				WHEN NEW.ofstate LIKE "District of Columbia" THEN "DC"
				WHEN NEW.ofstate LIKE "Florida" THEN "FL"
				WHEN NEW.ofstate LIKE "Georgia" THEN "GA"
				WHEN NEW.ofstate LIKE "Hawaii" THEN	"HI"
				WHEN NEW.ofstate LIKE "Idaho" THEN	"ID"
				WHEN NEW.ofstate LIKE "Illinois" THEN "IL"
				WHEN NEW.ofstate LIKE "Indiana" THEN "IN"
				WHEN NEW.ofstate LIKE "Iowa" THEN "IA"
				WHEN NEW.ofstate LIKE "Kansas" THEN	"KS"
				WHEN NEW.ofstate LIKE "Kentucky" THEN "KY"
				WHEN NEW.ofstate LIKE "Louisiana" THEN "LA"
				WHEN NEW.ofstate LIKE "Maine" THEN "ME"
				WHEN NEW.ofstate LIKE "Maryland" THEN "MD"
				WHEN NEW.ofstate LIKE "Massachusetts" THEN "MA"
				WHEN NEW.ofstate LIKE "Michigan" THEN "MI"
				WHEN NEW.ofstate LIKE "Minnesota" THEN "MN"
				WHEN NEW.ofstate LIKE "Mississippi" THEN "MS"
				WHEN NEW.ofstate LIKE "Missouri" THEN "MO"
				WHEN NEW.ofstate LIKE "Montana" THEN "MT"
				WHEN NEW.ofstate LIKE "Nebraska" THEN "NE"
				WHEN NEW.ofstate LIKE "Nevada" THEN	"NV"
				WHEN NEW.ofstate LIKE "New Hampshire" THEN "NH"
				WHEN NEW.ofstate LIKE "New Jersey" THEN	"NJ"
				WHEN NEW.ofstate LIKE "New Mexico" THEN "NM"
				WHEN NEW.ofstate LIKE "New York" THEN "NY"
				WHEN NEW.ofstate LIKE "North Carolina" THEN	"NC"
				WHEN NEW.ofstate LIKE "North Dakota" THEN "ND"
				WHEN NEW.ofstate LIKE "Ohio" THEN "OH"
				WHEN NEW.ofstate LIKE "Oklahoma" THEN "OK"
				WHEN NEW.ofstate LIKE "Oregon" THEN	"OR"
				WHEN NEW.ofstate LIKE "Pennsylvania" THEN "PA"
				WHEN NEW.ofstate LIKE "Rhode Island" THEN "RI"
				WHEN NEW.ofstate LIKE "South Carolina" THEN	"SC"
				WHEN NEW.ofstate LIKE "South Dakota" THEN "SD"
				WHEN NEW.ofstate LIKE "Tennessee" THEN "TN"
				WHEN NEW.ofstate LIKE "Texas" THEN "TX"
				WHEN NEW.ofstate LIKE "Utah" THEN "UT"
				WHEN NEW.ofstate LIKE "Vermont" THEN "VT"
				WHEN NEW.ofstate LIKE "Virginia" THEN "VA"
				WHEN NEW.ofstate LIKE "Washington" THEN "WA"
				WHEN NEW.ofstate LIKE "West Virginia" THEN "WV"
				WHEN NEW.ofstate LIKE "Wisconsin" THEN "WI"
				WHEN NEW.ofstate LIKE "Wyoming" THEN "WY"
			END);
	END IF;
END; //
DELIMITER ;

DROP TRIGGER IF EXISTS get_month_and_year;
DELIMITER //
CREATE TRIGGER get_month_and_year
BEFORE INSERT ON tweet
FOR EACH ROW
BEGIN
	SET NEW.posted_year = YEAR(NEW.posted);
    SET NEW.posted_month = MONTH(NEW.posted);
END; //
DELIMITER ;