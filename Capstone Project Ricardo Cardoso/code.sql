Query 1.1:

SELECT *
FROM survey
LIMIT 10;


-----------//-------------

Query 1.2:

SELECT question,
   COUNT(DISTINCT user_id)
FROM survey
   GROUP BY question;


-----------//-------------

Query 2.1:

SELECT * FROM quiz 
LIMIT 5;
SELECT * FROM home_try_on 
LIMIT 5;
SELECT * FROM purchase 
LIMIT 5;


-----------//-------------


Query 2.2:

SELECT DISTINCT quiz.user_id, 
      home_try_on.user_id IS NOT NULL AS 'is_home_try_on’, home_try_on.number_of_pairs, 
purchase.user_id IS NOT NULL AS 'is_purchase'
FROM quiz
    LEFT JOIN home_try_on
	ON quiz.user_id = home_try_on.user_id
    LEFT JOIN purchase
	ON purchase.user_id = quiz.user_id
LIMIT 10;


----------//-------------

Query 2.3:

WITH funnels AS (
  SELECT DISTINCT q.user_id,
    h.user_id IS NOT NULL AS 'is_home_try_on',
    h.number_of_pairs,
    p.user_id IS NOT NULL AS 'is_purchase’
  FROM quiz q
   LEFT JOIN home_try_on h
    ON q.user_id = h.user_id
   LEFT JOIN purchase p
    ON p.user_id = q.user_id
   )

SELECT COUNT(*) AS 'number of users',
     SUM(is_home_try_on) AS 'number of users who tried at home',
      SUM(is_purchase) AS 'number of users who purchased',
   1.0 * SUM(is_purchase) / COUNT(user_id) AS 'overall conversion',
   1.0 * SUM(is_home_try_on) / COUNT(user_id) AS 'quiz to home try on rate',
      1.0 * SUM(is_purchase) / SUM(is_home_try_on) AS 'try on to purchase rate'
FROM funnels;


Query 2.4.1: Convertion rate for customer how had 3 number of pairs

WITH funnels AS (
SELECT DISTINCT q.user_id,
   h.user_id IS NOT NULL AS 'is_home_try_on',
   h.number_of_pairs,
   p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON p.user_id = q.user_id
)

SELECT 
      1.0 * SUM(is_purchase) / SUM(is_home_try_on)  AS 'try on to purchase rate'
FROM funnels
WHERE number_of_pairs = '3 pairs';


----------//-------------


Query 2.4.2: Convertion rate for customer how had 5 number of pairs

WITH funnels AS (
SELECT DISTINCT q.user_id,
   h.user_id IS NOT NULL AS 'is_home_try_on',
   h.number_of_pairs,
   p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON p.user_id = q.user_id
)

SELECT 
      1.0 * SUM(is_purchase) / SUM(is_home_try_on)  AS 'try on to purchase rate'
FROM funnels
WHERE number_of_pairs = '5 pairs';

