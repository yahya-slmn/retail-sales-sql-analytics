-- total revenue 
SELECT 
    ROUND(SUM(amount), 2) AS total_revenue
FROM payments
WHERE payment_status = 'Paid';

-- total orders
SELECT 
    COUNT(*) AS total_orders
FROM orders;

-- completed orders only
SELECT 
    COUNT(*) AS completed_orders
FROM orders
WHERE order_status = 'Completed';

-- revenue by months
SELECT
    DATE_FORMAT(payment_date, '%Y-%m') AS sales_month,
    ROUND(SUM(amount), 2) AS monthly_revenue
FROM payments
WHERE payment_status = 'Paid'
GROUP BY DATE_FORMAT(payment_date, '%Y-%m')
ORDER BY sales_month;

-- revenue by stores
SELECT
    s.store_name,
    s.city,
    ROUND(SUM(p.amount), 2) AS total_revenue
FROM payments p
JOIN orders o
    ON p.order_id = o.order_id
JOIN stores s
    ON o.store_id = s.store_id
WHERE p.payment_status = 'Paid'
GROUP BY s.store_name, s.city
ORDER BY total_revenue DESC;

-- revenue by category
SELECT
    c.category_name,
    ROUND(SUM((oi.quantity * oi.unit_price) - oi.discount_amount), 2) AS category_revenue
FROM order_items oi
JOIN products pr
    ON oi.product_id = pr.product_id
JOIN categories c
    ON pr.category_id = c.category_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed'
GROUP BY c.category_name
ORDER BY category_revenue DESC;

-- top selling products by qty 
SELECT
    pr.product_name,
    SUM(oi.quantity) AS total_quantity_sold
FROM order_items oi
JOIN products pr
    ON oi.product_id = pr.product_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed'
GROUP BY pr.product_name
ORDER BY total_quantity_sold DESC;

-- top customers by revenue 
SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.city,
    ROUND(SUM(p.amount), 2) AS total_spent
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN payments p
    ON o.order_id = p.order_id
WHERE p.payment_status = 'Paid'
GROUP BY customer_name, c.city
ORDER BY total_spent DESC;

-- employees sales performance 
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    s.store_name,
    COUNT(o.order_id) AS total_orders_handled,
    ROUND(SUM(p.amount), 2) AS total_sales
FROM employees e
JOIN stores s
    ON e.store_id = s.store_id
JOIN orders o
    ON e.employee_id = o.employee_id
JOIN payments p
    ON o.order_id = p.order_id
WHERE p.payment_status = 'Paid'
GROUP BY employee_name, s.store_name
ORDER BY total_sales DESC;

-- average order value 
SELECT
    ROUND(SUM(amount) / COUNT(DISTINCT order_id), 2) AS average_order_value
FROM payments
WHERE payment_status = 'Paid';

-- low stock products
SELECT
    product_name,
    stock_quantity
FROM products
WHERE stock_quantity < 50
ORDER BY stock_quantity ASC;

-- payement method usage
SELECT
    payment_method,
    COUNT(*) AS total_transactions,
    ROUND(SUM(amount), 2) AS total_amount
FROM payments
GROUP BY payment_method
ORDER BY total_transactions DESC;

-- customer order frequency 
SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY customer_name
ORDER BY total_orders DESC;

-- profit by product 
SELECT
    pr.product_name,
    SUM(oi.quantity) AS total_units_sold,
    ROUND(SUM((oi.unit_price - pr.cost_price) * oi.quantity - oi.discount_amount), 2) AS total_profit
FROM order_items oi
JOIN products pr
    ON oi.product_id = pr.product_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed'
GROUP BY pr.product_name
ORDER BY total_profit DESC;

-- ranking products by revenue
SELECT
    product_name,
    total_revenue,
    RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank
FROM (
    SELECT
        pr.product_name,
        ROUND(SUM((oi.quantity * oi.unit_price) - oi.discount_amount), 2) AS total_revenue
    FROM order_items oi
    JOIN products pr
        ON oi.product_id = pr.product_id
    JOIN orders o
        ON oi.order_id = o.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY pr.product_name
) product_sales;

-- monthly revenue growth
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(payment_date, '%Y-%m') AS sales_month,
        SUM(amount) AS revenue
    FROM payments
    WHERE payment_status = 'Paid'
    GROUP BY DATE_FORMAT(payment_date, '%Y-%m')
)
SELECT
    sales_month,
    ROUND(revenue, 2) AS revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY sales_month))
        / LAG(revenue) OVER (ORDER BY sales_month) * 100,
        2
    ) AS revenue_growth_percentage
FROM monthly_sales;

-- product performance classification 
SELECT
    pr.product_name,
    ROUND(SUM((oi.quantity * oi.unit_price) - oi.discount_amount), 2) AS total_revenue,
    CASE
        WHEN SUM((oi.quantity * oi.unit_price) - oi.discount_amount) >= 1000 THEN 'High Performer'
        WHEN SUM((oi.quantity * oi.unit_price) - oi.discount_amount) >= 300 THEN 'Medium Performer'
        ELSE 'Low Performer'
    END AS performance_category
FROM order_items oi
JOIN products pr
    ON oi.product_id = pr.product_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed'
GROUP BY pr.product_name
ORDER BY total_revenue DESC;

-- orders without successful payment 
SELECT
    o.order_id,
    o.order_date,
    o.order_status,
    p.payment_status
FROM orders o
LEFT JOIN payments p
    ON o.order_id = p.order_id
WHERE p.payment_status <> 'Paid'
   OR p.payment_status IS NULL;