INSERT INTO categories (category_name)
VALUES
('Electronics'),
('Furniture'),
('Clothing'),
('Sports'),
('Accessories');

INSERT INTO products
(product_name, category_id, unit_price, cost_price, stock_quantity)
VALUES
('Laptop', 1, 1200.00, 900.00, 50),
('Smartphone', 1, 800.00, 600.00, 100),
('Office Chair', 2, 150.00, 100.00, 40),
('Desk', 2, 300.00, 220.00, 20),
('T-Shirt', 3, 25.00, 10.00, 200),
('Running Shoes', 4, 120.00, 80.00, 75),
('Backpack', 5, 60.00, 35.00, 90);

INSERT INTO stores
(store_name, city, country, opening_date)
VALUES
('Riyadh Central', 'Riyadh', 'Saudi Arabia', '2022-01-15'),
('Jeddah Mall', 'Jeddah', 'Saudi Arabia', '2022-05-10'),
('Dammam Plaza', 'Dammam', 'Saudi Arabia', '2023-02-01');

INSERT INTO employees
(first_name, last_name, store_id, job_title, hire_date)
VALUES
('Ahmed', 'Ali', 1, 'Sales Representative', '2022-02-01'),
('Sara', 'Mohammed', 1, 'Store Manager', '2022-01-20'),
('Omar', 'Khaled', 2, 'Sales Representative', '2022-06-01'),
('Lina', 'Yousef', 3, 'Sales Representative', '2023-03-10');

INSERT INTO customers
(first_name, last_name, email, phone, city, country)
VALUES
('Yahya', 'Sleiman', 'yahya@email.com', '0501111111', 'Riyadh', 'Saudi Arabia'),
('Ali', 'Hassan', 'ali@email.com', '0502222222', 'Jeddah', 'Saudi Arabia'),
('Mona', 'Ibrahim', 'mona@email.com', '0503333333', 'Dammam', 'Saudi Arabia'),
('Khaled', 'Nasser', 'khaled@email.com', '0504444444', 'Riyadh', 'Saudi Arabia');

INSERT INTO orders
(customer_id, store_id, employee_id, order_date, order_status)
VALUES
(1, 1, 1, '2025-01-10', 'Completed'),
(2, 2, 3, '2025-01-12', 'Completed'),
(3, 3, 4, '2025-02-05', 'Pending'),
(1, 1, 2, '2025-02-10', 'Completed'),
(4, 2, 3, '2025-03-01', 'Cancelled');

INSERT INTO order_items
(order_id, product_id, quantity, unit_price, discount_amount)
VALUES
(1, 1, 1, 1200.00, 50.00),
(1, 7, 2, 60.00, 0.00),

(2, 2, 1, 800.00, 25.00),
(2, 5, 3, 25.00, 5.00),

(3, 3, 1, 150.00, 0.00),

(4, 6, 2, 120.00, 10.00),
(4, 5, 4, 25.00, 0.00),

(5, 4, 1, 300.00, 0.00);

INSERT INTO payments
(order_id, payment_date, payment_method, payment_status, amount)
VALUES
(1, '2025-01-10', 'Credit Card', 'Paid', 1270.00),
(2, '2025-01-12', 'Cash', 'Paid', 850.00),
(3, '2025-02-05', 'Debit Card', 'Pending', 150.00),
(4, '2025-02-10', 'Digital Wallet', 'Paid', 330.00),
(5, '2025-03-01', 'Bank Transfer', 'Refunded', 300.00);

