with dailyactivecustomer as (
Select
    CAST(order_purchase_timestamp AS DATE) AS order_date,
	COUNT(DISTINCT customer_id) as daily_active_customer,
	Sum(order_revenue) as daily_revenue
	from {{ref('fct_orders') }}
	group by order_date
)
Select 
    order_date,
	daily_active_customer as daily_active_customer,
	daily_revenue as total_revenue,
	(daily_revenue/daily_active_customer) as revenue_per_customer 
	from dailyactivecustomer  
	