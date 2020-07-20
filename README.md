# Warby-Parker-Analysis

**TLDR** - I used SQL to analyze the results of an A/B test

This analysis of Warby-Parker was done as a part of the Data Science Path on Codecademy. The general gist of the problem at hand is that Warby-Parker is an eyewear company that is attempting to do business in a different way than its competitors. First, the company has its customers take a style quiz to determine which products they might be interested in. Then Warby-Parker sends the customer a few pairs to try on and ideally, the customer then purchases one of the pairs. Another interesting aspect of this study is that we are conducting an A/B test, with 50% of the customers receiving 3 pairs to try on with the other 50% receiving 5 pairs, in order to determine if the number of pairs has an impact on the customers decision to purchase a pair of sunglasses. 



The relevant data for this analysis is spread across 3 tables: **quiz, home_try_on, & purchase**. 

Below are some the queries that I wrote and take-aways I was able to obtain. 

```
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
```
This query is useful as it calculates the conversion rate of the customers who took the survey and then progressed to the home try on stage *(75%)* and also the conversion rate of the customers who purchased a product after trying it on *(66%)*
```
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
```
With this query, I was able to analyze the results of the A/B test. The results showed that only *53%* of customers who were sent 3 pairs of eyewear ended up purchasing something. In the group that was sent **5 pairs** to try on, **79%** of the customers ended up purchasing a product. With this information, it is clear that there is a significant result of sending customers more products to try on. 

The following queries are remarkably simpler, but use the results of the quiz to develop a profile on Warby-Parker's customers. 
```
SELECT style, COUNT(*) FROM quiz 
GROUP BY style
ORDER BY style desc;

SELECT style, COUNT(*) FROM purchase
GROUP BY style; 
```
The result of these queries reveal that there is an even split between men and women shopping for eyewear at Warby-Parker. 
```
SELECT color, COUNT(*) FROM quiz 
GROUP BY color
ORDER BY 2 desc
LIMIT 2;

SELECT COUNT(*) FROM purchase
WHERE color LIKE "%Tortoise%"
or color LIKE "%Black%";
```
The quiz revealed that the 2 colors the customers are most interested in are Tortoise and Black. Additionally of the 495 purchases, 59% of them were either Tortoise or Black. With this in mind, it is important that Warby-Parker stay well stocked with these styles. 
