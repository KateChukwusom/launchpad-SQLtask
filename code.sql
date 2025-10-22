
Q1-- Count the total number of customers who joined in 2023.

SELECT 
	COUNT(*) AS total_customers2023
	FROM customers
	WHERE YEAR(join_date) = 2023;

Q2-- For each customer return customer_id, full_name, total_revenue (sum of total_amount from orders). Sort descending.
SELECT 
	c.customer_id,
	c.full_name,
	SUM(o.total_amount) AS total_revenue
FROM customers c
	LEFT JOIN orders o
	ON c.customer_id = o.order_id
	GROUP BY c.customer_id, c.full_name
	ORDER BY total_revenue DESC

Q3-- Return the top 5 customers by total_revenue with their rank.
-- main query: pull out top 5 customerss
SELECT * 
FROM 
-- subquery: rank customers order by total revenue
(
SELECT 
	c.customer_id,
	c.full_name,
	SUM(o.total_amount) AS total_revenue,
	ROW_NUMBER() OVER (ORDER BY SUM(o.total_amount) DESC) AS rank_customers
FROM customers c
	LEFT JOIN orders o
	ON c.customer_id = o.order_id
	GROUP BY c.customer_id, c.full_name
	) t
	WHERE rank_customers  <= 5 

Q4-- Produce a table with year, month, monthly_revenue for all months in 2023 ordered chronologically.
SELECT 
	YEAR(order_date) AS year,
	MONTH(order_date) AS month,
	SUM(total_amount) AS total_revenue
FROM orders 
WHERE YEAR(order_date) = 2023
-- Group by year and month for each customers
GROUP BY YEAR(order_date),
		 MONTH(order_date)
ORDER BY year, month  

Q5-- Find customers with no orders in the last 60 days relative to 2023-12-31 (i.e., consider last active date up to 2023-12-31). Return customer_id, full_name, last_order_date.
SELECT 
	c.customer_id,
	c.full_name,
	-- subquery: select last order date where order date <= '2023-12-31'
	(SELECT
	MAX(order_date) FROM orders o WHERE o.customer_id = c.customer_id AND order_date <= '2023-12-31') AS last_order_date
	FROM customers c
	-- subquery: select customers that did not order between '2023-11-01' AND '2023-12-31'
	WHERE c.customer_id NOT IN 
	-- subquery: select customers that ordered between '2023-11-01' AND '2023-12-31'
	(
    SELECT customer_id 
    FROM orders 
    WHERE order_date BETWEEN '2023-11-01' AND '2023-12-31'
  
);

Q6-- Calculate average order value (AOV) for each customer: return customer_id, full_name, aov (average total_amount of their orders). Exclude customers with no orders

SELECT 
	   c.customer_id,
		c.full_name,
		SUM(o.total_amount) AS total_revenue,
		COUNT(o.order_id) AS order_count,
		SUM(o.total_amount)/COUNT(o.order_id) AS Average_Order_Value
FROM customers c
 JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id,
		c.full_name

Q7-- For all customers who have at least one order, compute customer_id, full_name, total_revenue, spend_rank where spend_rank is a dense rank, highest spender = rank 1.
SELECT
	c.customer_id,
	c.full_name,
	SUM(o.total_amount) AS total_revenue,
	DENSE_RANK() OVER (ORDER BY SUM(o.total_amount) DESC) AS spend_rank
	FROM customers c
	LEFT JOIN orders o
	ON o.customer_id = c.customer_id
	GROUP BY c.customer_id, c.full_name 
	
Q8-- List customers who placed more than 1 order and show customer_id, full_name, order_count, first_order_date, last_order_date.

SELECT 
	c.customer_id,
	c.full_name,
	COUNT(o.order_id) AS order_count,
	MIN(o.order_date) AS first_order_date,
	MAX(o.order_date) AS last_order_date
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
HAVING COUNT(o.order_id) > 1 
ORDER BY order_count DESC;

Q9-- Compute total loyalty points per customer. Include customers with 0 points.
SELECT 
	c.customer_id,
	c.full_name,
	SUM(l.points_earned) as total_loyalty_points
FROM customers c
LEFT JOIN loyalty_points l
ON c.customer_id = l.customer_id
WHERE points_earned >= 0
GROUP BY 
c.customer_id,
c.full_name


Q10-- Assign loyalty tiers based on total points Bronze: < 100 Silver: 100–499 Gold: >= 500 Output: tier, tier_count, tier_total_points
 WITH customer_tiers AS 
 (
 -- CTE: select customers and assign loyalty tiers based on the category: 'Tier'
    SELECT 
		c.customer_id,
		SUM(l.points_earned) AS total_points,
        CASE 
			WHEN SUM(l.points_earned) >= 500 THEN 'Gold'
			WHEN SUM(l.points_earned) >= 100 THEN 'Silver'
			WHEN SUM(l.points_earned) < 100 THEN 'Bronze'
			else 'n/a'
        END AS tier
    FROM customers c
    LEFT JOIN loyalty_points l
	ON c.customer_id = l.customer_id
    GROUP BY c.customer_id
)
-- select tier, tier count and tier total points from the CTE
SELECT 
    tier,
    COUNT(*) AS tier_count,
    SUM(total_points) AS tier_total_points
FROM customer_tiers
GROUP BY tier


Q11-- Identify customers who spent more than ₦50,000 in total but have less than 200 loyalty points.Return customer_id, full_name, total_spend, total_points.

SELECT 
	c.customer_id,
	c.full_name,
	MAX(O.total_amount) OVER (PARTITION BY c.customer_id) AS total_spend,
	MAX(l.points_earned) OVER (PARTITION BY c.customer_id) AS total_points
FROM customers c
	LEFT JOIN orders o
ON o.customer_id = c.customer_id
	LEFT JOIN loyalty_points l
ON l.customer_id = c.customer_id
WHERE O.total_amount > 50000 AND l.points_earned < 200 

Q12-- Flag customers as churn_risk if they have no orders in the last 90 days (relative to 2023-12-31) AND are in the Bronze tier. Return customer_id, full_name, last_order_date, total_points.
WITH customer_estimates AS
(
-- specify customers, last order date and loyal points
SELECT 
        c.customer_id,
        c.full_name,
		MAX(o.order_date) AS last_order_date,
		l.points_earned AS total_points,
     CASE 
         WHEN SUM(l.points_earned) >= 500 THEN 'Gold'
         WHEN SUM(l.points_earned) >= 100 THEN 'Silver'
		 WHEN SUM(l.points_earned) < 100 THEN 'Bronze'
         ELSE 'n/a'
     END AS tier
    FROM customers c
    LEFT JOIN orders o 
	ON c.customer_id = o.customer_id 
        AND o.order_date <= '2023-12-31'
    LEFT JOIN loyalty_points l 
	ON c.customer_id = l.customer_id
    GROUP BY c.customer_id, c.full_name, l.points_earned 
	)
SELECT 
    customer_id,
    full_name,
    last_order_date,
    total_points,
    'churn_risk' AS status
FROM customer_estimates
-- Where no last order occured in the last 90 days 
WHERE last_order_date < '2023-10-02'
    AND tier = 'Bronze'
ORDER BY last_order_date;
