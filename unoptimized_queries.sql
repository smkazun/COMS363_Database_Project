/**
 * Q1
 */
set @inmonth = 1;
set @inyear = 2016;
-- set @k = 10;    --- THIS does not work with LIMIT so it is hardcoded instead

SELECT t.retweet_count, t.textbody, t.posting_user, u.category, u.sub_category
FROM tweet t, user u
WHERE t.posting_user = u.screen_name AND (SELECT YEAR(t.posted)) = @inyear AND (SELECT MONTH(t.posted)) = @inmonth
ORDER BY retweet_count DESC
LIMIT 10;

/**
 * Q2
 */
set @k = 10;
set @inmonth = 1;
set @inyear = 2016;
set @hashtag = "NYE2016"; 

SELECT u.screen_name, u.category, t.textbody, t.retweet_count
FROM tweet t, user u, hashtag h
WHERE t.posting_user = u.screen_name AND h.hashtagname = @hashtag AND h.tid = t.tid
									AND (SELECT YEAR(t.posted)) = @inyear 
                                    AND (SELECT MONTH(t.posted)) = @inmonth -- in a given month and year
ORDER BY retweet_count DESC
LIMIT 10;
 
/**
 * Q3
 */
set @k = 10;
set @year = 2016;

SELECT distinct a.hashtagname, group_concat(a.ofstate), count(*) AS state_cnt
FROM ( SELECT h.hashtagname, (SELECT YEAR(t.posted)), u.ofstate, count(*) AS tweet_cnt
		FROM tweet t
        INNER JOIN hashtag h ON h.tid = t.tid
        INNER JOIN user u ON u.screen_name = t.posting_user
        GROUP BY h.hashtagname, u.ofstate, (SELECT YEAR(t.posted)) = @year
) AS a
GROUP BY a.hashtagname
ORDER BY state_cnt DESC
LIMIT 10;
 
 /**
 * Q6
 */
set @k = 10;
-- set @hashtag = ("DemDebate", "GOPDebate");

SELECT u.screen_name, u.ofstate
FROM user u, hashtag h, tweet t
WHERE h.hashtagname IN ('DemDebate', 'GOPDebate') AND h.tid = t.tid AND t.posting_user = u.screen_name
GROUP BY u.screen_name HAVING COUNT(u.screen_name) = 2
ORDER BY u.numFollowers DESC
LIMIT 10;
 
 /**
 * Q10
 */
SET @month = 1;
SET @year = 2016;
SET @state1 = "Iowa";
SET @state2 = "Texas";
-- List of states

SELECT DISTINCT h.hashtagname, GROUP_CONCAT(DISTINCT u.ofstate) as states
FROM user u
INNER JOIN tweet t
INNER JOIN hashtag h
ON t.tid = h.tid
ON u.screen_name = t.posting_user
WHERE YEAR(t.posted) = 2016
AND MONTH(t.posted) = 1
AND u.ofstate IN ('IA', 'TX')
GROUP BY h.hashtagname;
 
 /**
 * Q15
 */
set @subcategory = 'GOP';
set @inmonth = 1;
set @inyear = 2016;

SELECT u.screen_name, u.ofstate, l.url
FROM user u, url l, tweet t
WHERE u.screen_name = t.posting_user AND u.sub_category = @subcategory AND l.tid = t.tid
									AND (SELECT YEAR(t.posted)) = @inyear 
									AND (SELECT MONTH(t.posted)) = @inmonth;
 
 /**
 * Q23
 */
set @k = 10;
set @sub_category = 'democrat';
set @year = 2016;

SELECT distinct h.hashtagname, COUNT(h.hashtagname) as cnt
FROM hashtag h, user u, tweet t
WHERE h.tid=t.tid 
		AND t.posting_user = u.screen_name 
		AND u.sub_category= @sub_category 
        AND (SELECT MONTH(t.posted)) IN (1,2,3)
        AND (SELECT YEAR(t.posted)) = @year
GROUP BY (h.hashtagname)
ORDER BY COUNT(h.hashtagname) DESC
LIMIT 10;
 
 /**
 * Q27
 */
set @k = 10;
set @month1 = 1;
set @month2 = 2;
set @year = 2016;
 
SELECT DISTINCT posting_user, posted, SUM(retweet_count) sum
FROM tweet
WHERE YEAR(posted) = @year
AND MONTH(posted) = @month1
GROUP BY posting_user
UNION
SELECT DISTINCT posting_user, posted, SUM(retweet_count) sum
FROM tweet
WHERE YEAR(posted) = @year
AND MONTH(posted) = @month2
GROUP BY posting_user
ORDER BY sum DESC
LIMIT 10;