with dailyactivecustomer as (
Select
    order_date,
	COUNT(DISTINCT customer_id) as daily_active_customer,
	Sum(order_revenue) as daily_order_revenue,
	Sum(shipping_revenue) as daily_shipping_revenue,
	Sum(total_orders) as daily_order_count
	from {{ref('fct_orders') }}
	group by order_date
),
customer_first_orderdate as (
Select
    min(order_date) as customer_first_order_date,
	customer_id
    from {{ref('fct_orders')}}
	group by customer_id
),
customerstatus as (
Select o.customer_id,
       o.order_date,
       MAX(Case when o.order_date = co.customer_first_order_date then 1 else 0 end) as customer_status 
       from {{ref('fct_orders')}} o join customer_first_orderdate co  
	   on o.customer_id = co.customer_id
	   group by customer_id,order_date
),
customercount as (
Select order_date,
       Count(Distinct Case when customer_status = 1 then customer_id end ) as new_customer_count,
	   Count(Distinct Case when customer_status = 0 then customer_id end ) as existing_customer_count
	   from customerstatus 
	   group by order_date
)	   
Select 
    cs.order_date,
	dc.daily_order_count,
	dc.daily_active_customer as daily_active_customer,
	dc.daily_order_revenue as total_order_revenue,
	dc.daily_shipping_revenue as total_shipping_revenue,
	(dc.daily_order_revenue/dc.daily_active_customer) as revenue_per_customer,
	(dc.daily_order_revenue + dc.daily_shipping_revenue) as total_revenue,
	((dc.daily_order_revenue + dc.daily_shipping_revenue)/dc.daily_order_count) as avg_order_value,
	cs.new_customer_count as new_customers,
	cs.existing_customer_count as existing_customers
	from dailyactivecustomer dc left join customercount cs 
	on dc.order_date = cs.order_date