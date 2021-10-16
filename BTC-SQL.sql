/*Q1: What is the earliest and latest market_date values?*/

CREATE temp table market_dates AS 

SELECT market_date, 

RANK() OVER(
ORDER BY market_date) as ascending,


RANK() OVER(
ORDER BY market_date desc) as descending

FROM trading.daily_btc;

select * from market_dates;




/*Q2: What was the historic all-time high and low values for the `close_price` rounded to 6 decimal places and their dates?*/

(SELECT close_price, market_date FROM trading.daily_btc where close_price IS NOT NULL ORDER BY close_price DESC LIMIT 1)

UNION

(SELECT close_price, market_date FROM trading.daily_btc ORDER BY close_price ASC LIMIT 1)




/*Q3: Which date had the most `volume` traded (to nearest integer) and what was the `close_price` for that day?*/

SELECT market_date, volume, ROUND(close_price) AS rounded_price FROM trading.daily_btc 
WHERE volume IS NOT NULL and close_price IS NOT NULL ORDER BY 2 DESC;



/*Q4: How many days had a low_price price which was 10% less than the open_price - what percentage of the total number of trading days is this rounded to the nearest integer?*/

WITH cte AS (
SELECT
SUM(
CASE
WHEN low_price < 0.9 * open_price THEN 1
ELSE 0
END
) AS low_days,
COUNT(*) AS total_days
FROM trading.daily_btc
WHERE volume IS NOT NULL
)
SELECT
low_days,
ROUND(100 * low_days / total_days) AS _percentage
FROM cte;


/*Q5: What percentage of days have a higher close_price than open_price?*/



WITH cte AS (
 SELECT SUM(
 CASE WHEN close_price > open_price THEN 1
 ELSE 0
 END) AS good_days,
 COUNT(*) AS total_days
 FROM trading.daily_btc
)
SELECT good_days, ROUND(100.0 * good_days / total_days) AS percentage FROM cte;



/*Q6:What was the largest difference between high_price and low_price and which date did it occur?*/

select (high_price - low_price) AS difference, market_date from trading.daily_btc ORDER BY difference DESC NULLS LAST LIMIT 1;


/*Q7: If you invested $10,000 on the 1st January 2016 - how much is your investment worth in 1st of January 2021 and what is your total growth of your investment as a percentage of your original investment? Use the `close_price` for this calculation.
*/

WITH start_investment AS (
SELECT
10000 / close_price AS btc_volume,
close_price AS start_price
FROM trading.daily_btc
WHERE market_date = '2016-01-01'
),
end_investment AS (
SELECT
close_price AS end_price
FROM trading.daily_btc
WHERE market_date = '2021-01-01'
)
SELECT
btc_volume,
start_price,
end_price,
ROUND(100 * (end_price - start_price) / start_price) AS growth_rate,
ROUND(btc_volume * end_price) AS final_investment
FROM start_investment
CROSS JOIN end_investment;




