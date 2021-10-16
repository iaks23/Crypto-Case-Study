[![forthebadge](https://forthebadge.com/images/badges/as-seen-on-tv.svg)](https://forthebadge.com) [![forthebadge](https://forthebadge.com/images/badges/powered-by-black-magic.svg)](https://forthebadge.com)
<img align="left" width="170" height="35" src="https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white">

# Crypto Case Study
> A SQL Case Study performed on Daily BTC data available on the [Serious SQL](https://www.datawithdanny.com) course by Danny Ma.

[![star-useful](https://img.shields.io/badge/🌟-If%20useful-red.svg)](https://shields.io) 
[![view-repo](https://img.shields.io/badge/View-Repo-blueviolet)](https://github.com/iaks23?tab=repositories)
[![view-profile](https://img.shields.io/badge/Go%20To-Profile-orange)](https://github.com/iaks23)


## Table of Contents 📖

* [🔭 Dataset Exploration](#explore)
* [🧼 Data Cleaning](#clean)
* [📊 Business Problem Solutions](#solutions)







# 📊 Business Problem Solutions <a name='solutions'></a>

### Q1: What is the earliest & latest <code>market_date</code> value? 

```sql

REATE temp table market_dates AS 

SELECT market_date, 

RANK() OVER(
ORDER BY market_date) as ascending,


RANK() OVER(
ORDER BY market_date desc) as descending

FROM trading.daily_btc;

select * from market_dates;
```

|Ascending|Descending|
|---|---|
|2014-09-17|2021-02-24|

The earliest date is, 17th of September 2014 and the latest date is, 24th February 2021.

### Q2: What was the historic all-time high and low values for the <code>close_price</code> rounded to 6 decimal places and their dates?

```sql
SELECT close_price, market_date FROM trading.daily_btc where close_price IS NOT NULL ORDER BY close_price DESC LIMIT 1)

UNION

(SELECT close_price, market_date FROM trading.daily_btc ORDER BY close_price ASC LIMIT 1)
```

|Market Date|Close Price|
|---|---|
|2015-01-14|178.102997|
|2021-02-21|57539.945313|

### Q3: Which date had the most <code>volume</code> traded (to nearest integer) and what was the <code>close_price</code> for that day?

```sql
SELECT market_date, volume, ROUND(close_price) AS rounded_price FROM trading.daily_btc 
WHERE volume IS NOT NULL and close_price IS NOT NULL ORDER BY 2 DESC;
```

|Market Date|Volume|Rounded Price|
|---|---|---|
|2021-01-11|123320567399|35567|

### Q4: How many days had a <code>low_price</code> price which was 10% less than the <code>open_price</code> - what percentage of the total number of trading days is this rounded to the nearest integer?

> 💡 Hint: remove days where volume is null

```sql
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
```
|Low Days|Percentage|
|---|---|
|79|3%|

### Q5: What percentage of days have a higher close_price than open_price?

```sql

WITH cte AS (
 SELECT SUM(
 CASE WHEN close_price > open_price THEN 1
 ELSE 0
 END) AS good_days,
 COUNT(*) AS total_days
 FROM trading.daily_btc
)
SELECT good_days, ROUND(100.0 * good_days / total_days) AS percentage FROM cte;
```

|Good Days|Percentage|
|---|---|
|1283|55%|

> 💡 Point To Remember: Remember integer floor dvision!

### Q6: What was the largest difference between high_price and low_price and which date did it occur? 

```sql
select (high_price - low_price) AS difference, market_date from trading.daily_btc ORDER BY difference DESC NULLS LAST LIMIT 1;
```

|Difference|Market Date|
|---|---|
|8914.339844|2021-02-23|

### Q7: If you invested $10,000 on the 1st January 2016 - how much is your investment worth in 1st of January 2021 and what is your total growth of your investment as a percentage of your original investment? Use the `close_price` for this calculation.

```sql
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
```

|BTC Volume|Start Price|End Price|Growth Rate|Final Investment|
|---|---|---|---|---|
|23.0237551162093533|434.334015|29374.152344|6663|676303|

----------------------

© Akshaya Parthasarathy, 2021

For feedback, or if you just feel like saying Hi!

[![LINKEDIN](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/akshaya-parthasarathy23)
[![INSTAGRAM](https://img.shields.io/badge/Instagram-E4405F?style=for-the-badge&logo=instagram&logoColor=white)](https://www.instagram.com/aks_sarathy/)
[![REDDIT](https://img.shields.io/badge/Reddit-FF4500?style=for-the-badge&logo=reddit&logoColor=white)](https://www.reddit.com/user/longstoryshort_)
