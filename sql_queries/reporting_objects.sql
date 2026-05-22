-- profit margin function

USE retail_sales_db;

DROP FUNCTION IF EXISTS fn_profit_margin;

DELIMITER $$

CREATE FUNCTION fn_profit_margin(
    revenue DECIMAL(10,2),
    cost DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE margin_percentage DECIMAL(10,2);

    IF revenue = 0 THEN
        SET margin_percentage = 0;
    ELSE
        SET margin_percentage = ((revenue - cost) / revenue) * 100;
    END IF;

    RETURN margin_percentage;
END $$

DELIMITER ;

-- STORED PROCEDURE: Store Sales Performance Report
DELIMITER $$

CREATE PROCEDURE sp_store_sales_performance(
    IN start_date DATE,
    IN end_date DATE
)
BEGIN
    SELECT
        s.store_name,
        s.city,
        COUNT(DISTINCT o.order_id) AS total_orders,
        COUNT(DISTINCT o.customer_id) AS total_customers,
        ROUND(SUM(p.amount), 2) AS total_revenue,
        ROUND(AVG(p.amount), 2) AS average_order_value
    FROM stores s
    JOIN orders o
        ON s.store_id = o.store_id
    JOIN payments p
        ON o.order_id = p.order_id
    WHERE p.payment_status = 'Paid'
      AND p.payment_date BETWEEN start_date AND end_date
    GROUP BY s.store_name, s.city
    ORDER BY total_revenue DESC;
END $$

DELIMITER ;

USE retail_sales_db;

-- VIEW: Monthly Sales Performance

CREATE OR REPLACE VIEW vw_monthly_sales_performance AS
SELECT
    DATE_FORMAT(p.payment_date, '%Y-%m') AS sales_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS total_customers,
    ROUND(SUM(p.amount), 2) AS total_revenue,
    ROUND(AVG(p.amount), 2) AS average_order_value
FROM payments p
JOIN orders o
    ON p.order_id = o.order_id
WHERE p.payment_status = 'Paid'
GROUP BY DATE_FORMAT(p.payment_date, '%Y-%m');