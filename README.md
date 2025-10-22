# Customer Analytics SQL Assignment

## Overview
This repository contains SQL queries for customer analytics, focusing on customer behavior analysis, loyalty segmentation, and churn risk identification.

## Business Objectives
- Analyze customer spending patterns and loyalty points
- Identify at-risk customers for proactive retention
- Segment customers based on purchasing behavior and loyalty tiers
- Calculate key customer metrics for business intelligence

Q1- Count the total number of customers who joined in 2023.
![image alt](https://github.com/KateChukwusom/launchpad-SQLtask/blob/02203c1dad6f3d5cd939e7764e331c1cfe6b256a/Question%201.png)

Q2- For each customer return customer_id, full_name, total_revenue (sum of total_amount from orders). Sort descending.
![image alt](https://github.com/KateChukwusom/launchpad-SQLtask/blob/02203c1dad6f3d5cd939e7764e331c1cfe6b256a/Total%20revenue%20generated%20by%20each%20customer.png)

Q3- Return the top 5 customers by total_revenue with their rank.
![image alt](https://github.com/KateChukwusom/launchpad-SQLtask/blob/02203c1dad6f3d5cd939e7764e331c1cfe6b256a/Rank%20top%20five.png)

Q4- Produce a table with year, month, monthly_revenue for all months in 2023 ordered chronologically.
![image alt](https://github.com/KateChukwusom/launchpad-SQLtask/blob/02203c1dad6f3d5cd939e7764e331c1cfe6b256a/Year%2C%20month%20revenue.png)

Q5- Find customers with no orders in the last 60 days relative to 2023-12-31 (i.e., consider last active date up to 2023-12-31). Return customer_id, full_name, last_order_date.
![image alt](https://github.com/KateChukwusom/launchpad-SQLtask/blob/02203c1dad6f3d5cd939e7764e331c1cfe6b256a/question%205.png)

Q6- Calculate average order value (AOV) for each customer: return customer_id, full_name, aov (average total_amount of their orders). Exclude customers with no orders.
![image alt](https://github.com/KateChukwusom/launchpad-SQLtask/blob/02203c1dad6f3d5cd939e7764e331c1cfe6b256a/question%206.png)

Q7- For all customers who have at least one order, compute customer_id, full_name, total_revenue, spend_rank where spend_rank is a dense rank, highest spender = rank 1.
![image alt](https://github.com/KateChukwusom/launchpad-SQLtask/blob/02203c1dad6f3d5cd939e7764e331c1cfe6b256a/Question%207.png)

Q8- List customers who placed more than 1 order and show customer_id, full_name, order_count, first_order_date, last_order_date.
![image alt](https://github.com/KateChukwusom/launchpad-SQLtask/blob/02203c1dad6f3d5cd939e7764e331c1cfe6b256a/QUESTION%208.png)

Q9- Compute total loyalty points per customer. Include customers with 0 points.
![image alt](https://github.com/KateChukwusom/launchpad-SQLtask/blob/02203c1dad6f3d5cd939e7764e331c1cfe6b256a/question%209.png)

Q10 -Assign loyalty tiers based on total points: Bronze: < 100 Silver: 100–499 Gold: >= 500 Output: tier, tier_count, tier_total_points
![image alt](https://github.com/KateChukwusom/launchpad-SQLtask/blob/02203c1dad6f3d5cd939e7764e331c1cfe6b256a/question%2010.png)

Q11- Identify customers who spent more than ₦50,000 in total but have less than 200 loyalty points. Return customer_id, full_name, total_spend, total_points.
![image alt](https://github.com/KateChukwusom/launchpad-SQLtask/blob/02203c1dad6f3d5cd939e7764e331c1cfe6b256a/question%2011.png)

Q12- Flag customers as churn_risk if they have no orders in the last 90 days (relative to 2023-12-31) AND are in the Bronze tier. Return customer_id, full_name, last_order_date, total_points.
![image alt](https://github.com/KateChukwusom/launchpad-SQLtask/blob/02203c1dad6f3d5cd939e7764e331c1cfe6b256a/question%2012.png)

