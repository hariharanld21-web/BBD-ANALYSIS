-- What are orders, customers and revenue by customer region and month?
-- INNER JOIN chosen: only orders with a matching customer can be assigned a region, and every order has one.
-- COUNT(DISTINCT customer_id) is needed because one customer can place several orders in a month; COUNT(*) would count orders, not customers.
SELECT c.region, o.order_month,
       COUNT(o.order_id) AS number_of_orders,
       COUNT(DISTINCT o.customer_id) AS number_of_customers,
       SUM(o.amount) AS total_revenue,
       AVG(o.amount) AS average_revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.status = 'completed'
GROUP BY c.region, o.order_month
ORDER BY c.region, o.order_month;
