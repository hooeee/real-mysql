SELECT o.order_id, o.order_date, o.status, o.total_amount, c.name, c.email
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE c.name = 'Alice';