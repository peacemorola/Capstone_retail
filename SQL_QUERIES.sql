SELECT
    TO_CHAR(o.order_date, 'YYYY-MM') AS month,
    SUM(od.profit) AS total_profit,
    SUM(od.amount) AS total_sales
FROM retail.order o
JOIN retail.order_details od ON o.order_pk = od.order_pk
GROUP BY 1
ORDER BY 1;


SELECT
    c.customer_name,
    SUM(od.profit) AS total_profit,
    SUM(od.amount) AS total_sales
FROM retail.customer c
JOIN retail.order o ON c.customer_pk = o.customer_pk
JOIN retail.order_details od ON o.order_pk = od.order_pk
GROUP BY c.customer_name
ORDER BY total_profit DESC
LIMIT 10;

SELECT
    pc.category,
    pc.sub_category,
    SUM(od.quantity) AS total_quantity
FROM retail.order_details od
JOIN retail.product_category pc ON od.category_id = pc.category_id
GROUP BY pc.category, pc.sub_category
ORDER BY total_quantity DESC;

SELECT
    c.city,
    SUM(od.profit) AS total_profit
FROM retail.customer c
JOIN retail.order o ON c.customer_pk = o.customer_pk
JOIN retail.order_details od ON o.order_pk = od.order_pk
GROUP BY c.city
HAVING SUM(od.profit) < 80000
ORDER BY total_profit ASC;

SELECT
    TO_CHAR(o.order_date, 'Month') AS month,
    ROUND(AVG(od.amount), 2) AS avg_monthly_sales
FROM retail.order o
JOIN retail.order_details od ON o.order_pk = od.order_pk
GROUP BY EXTRACT(MONTH FROM o.order_date), TO_CHAR(o.order_date, 'Month')
order BY EXTRACT(MONTH FROM o.order_date);

WITH city_revenue AS (
    SELECT
        c.city,
        SUM(od.amount) AS total_revenue
    FROM retail.customer c
    JOIN retail.order o ON c.customer_pk = o.customer_pk
    JOIN retail.order_details od ON o.order_pk = od.order_pk
    GROUP BY c.city
),
percentile_cutoff AS (
    SELECT PERCENTILE_CONT(0.95) 
           WITHIN GROUP (ORDER BY total_revenue) AS p95
    FROM city_revenue
)
SELECT cr.city, cr.total_revenue
FROM city_revenue cr, percentile_cutoff p
WHERE cr.total_revenue > p.p95
ORDER BY cr.total_revenue DESC;




