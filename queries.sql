WITH funnel AS ( SELECT q.user_id, 
       h.user_id is not null as "is_home_try_on",
       h.number_of_pairs, 
       p.user_id is not null as "is_purchase"
    FROM quiz q 
    LEFT JOIN home_try_on h ON q.user_id = h.user_id
    LEFT JOIN purchase p ON q.user_id = p.user_id
  )
SELECT COUNT(*) AS "Total", 
      SUM(is_home_try_on) AS "HTO", 
      SUM(is_purchase) AS "Purchased",
      1.0 * SUM(is_home_try_on) / COUNT(*) as "Quiz_to_HTO",
      1.0 * SUM(is_purchase) / SUM(is_home_try_on) as "HTO_to_Purchase"
FROM funnel;


WITH funnel AS ( SELECT q.user_id, 
       h.user_id is not null as "is_home_try_on",
       h.number_of_pairs, 
       p.user_id is not null as "is_purchase"
    FROM quiz q 
    LEFT JOIN home_try_on h ON q.user_id = h.user_id
    LEFT JOIN purchase p ON q.user_id = p.user_id
  )
SELECT number_of_pairs AS "Pairs_Sent",
    SUM(is_home_try_on) AS "#_Of_HTOs", 
    SUM(is_purchase) "#_of_Purchases", 
    ROUND(1.0 * SUM(is_purchase) / SUM(is_home_try_on), 2) AS "HTO_to_Purchase"
FROM funnel
WHERE number_of_pairs IS NOT NULL
GROUP BY number_of_pairs;


--                                                   Simpler Queries                                         --

SELECT style, COUNT(*) FROM quiz 
GROUP BY style
ORDER BY style desc;

SELECT style, COUNT(*) FROM purchase
GROUP BY style; 

SELECT color, COUNT(*) FROM quiz 
GROUP BY color
ORDER BY 2 desc
LIMIT 2;

SELECT COUNT(*) FROM purchase
WHERE color LIKE "%Tortoise%"
or color LIKE "%Black%";
