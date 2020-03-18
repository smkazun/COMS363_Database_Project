/**
 * Q1
 */
SELECT t.retweet_count, t.textbody, t.posting_user, u.category, u.sub_category
FROM tweet t, user u
WHERE t.posting_user = u.screen_name
AND t.posted_year = 2016 
AND t.posted_month = 3
ORDER BY retweet_count DESC
LIMIT 10;

/**
 * Q2
 */
SELECT u.screen_name, u.category, t.textbody, t.retweet_count
FROM hashtag h
INNER JOIN tweet t
INNER JOIN user u
ON u.screen_name = t.posting_user
ON t.tid = h.tid
WHERE h.hashtagname = "Trump2016"
AND t.posted_year = 2016
AND t.posted_month = 1
ORDER BY retweet_count DESC
LIMIT 10;
 
/**
 * Q3
 */
SELECT distinct a.hashtagname, group_concat(a.ofstate) as states, count(*) AS state_cnt
FROM ( SELECT h.hashtagname, t.posted_year, u.ofstate, count(*) AS tweet_cnt
		FROM tweet t
        INNER JOIN hashtag h ON h.tid = t.tid
        INNER JOIN user u ON u.screen_name = t.posting_user
        WHERE t.posted_year = 2016 AND u.screen_name = t.posting_user
        GROUP BY h.hashtagname, u.ofstate, t.posted_year
) AS a
GROUP BY a.hashtagname
ORDER BY state_cnt DESC
LIMIT 10;
 
 /**
 * Q6
 */
SELECT u.screen_name, u.ofstate
FROM user u, hashtag h
INNER JOIN tweet t
ON h.tid = t.tid
WHERE h.hashtagname IN ('DemDebate', 'GOPDebate')
AND t.posting_user = u.screen_name
GROUP BY u.screen_name
HAVING COUNT(u.screen_name) = 2
ORDER BY u.numFollowers DESC
LIMIT 10;
 
 /**
 * Q10
 */
SELECT DISTINCT h.hashtagname, GROUP_CONCAT(DISTINCT u.ofstate) as states
FROM user u
INNER JOIN tweet t
INNER JOIN hashtag h
ON t.tid = h.tid
ON u.screen_name = t.posting_user
WHERE u.ofstate IN ('IA', 'TX')
AND t.posted_year = 2016
AND t.posted_month = 1
GROUP BY h.hashtagname;
 
 /**
 * Q15
 */
SELECT u.screen_name, u.ofstate, l.url
FROM user u, url l, tweet t
WHERE u.screen_name = t.posting_user
AND t.posted_year = @inyear 
AND t.posted_month = @inmonth
AND u.sub_category = @subcategory
AND l.tid = t.tid;

 /**
 * Q23
 */
SELECT distinct h.hashtagname, COUNT(h.hashtagname) as cnt
FROM hashtag h, user u, tweet t
WHERE h.tid=t.tid
	AND t.posting_user = u.screen_name
	AND u.sub_category = 'GOP'
	AND t.posted_month IN (1,2,3)
	AND t.posted_year = 2016
GROUP BY (h.hashtagname)
ORDER BY COUNT(h.hashtagname) DESC
LIMIT 10;
 
 /**
 * Q27
 */
SELECT DISTINCT posting_user, posted, SUM(retweet_count) sum
FROM tweet
WHERE posted_year = @year
AND posted_month = @month1
GROUP BY posting_user
UNION
SELECT DISTINCT posting_user, posted, SUM(retweet_count) sum
FROM tweet
WHERE posted_year = @year
AND posted_month = @month2
GROUP BY posting_user
ORDER BY sum DESC
LIMIT 10;


/**
 * INDEXES USED FOR OPTIMIZATION
 */
CREATE INDEX year_month_idx ON tweet(posted_year, posted_month);

CREATE INDEX month_idx ON tweet(posted_month);

CREATE INDEX year_idx ON tweet(posted_year);

CREATE INDEX state_idx ON user(ofstate);

CREATE INDEX hashtagname_idx ON hashtag(hashtagname);