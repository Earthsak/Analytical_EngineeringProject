
With Revenue AS
(
Select
    CAST(o.order_purchase_timestamp AS DATE) AS order_date,
	SUM(oi.order_revenue) as product_revenue,
	Sum(oi.shipping_revenue ) as shipping_revenue,
	Count(Distinct oi.order_id) as total_orders
	
from {{ ref('fct_order_items') }} oi
 left join {{ ref('fct_orders') }} o
 ON oi.order_id = o.order_id
group by order_date 
)
Select order_date,total_orders,
(product_revenue + shipping_revenue) as total_revenue ,
((product_revenue + shipping_revenue)/total_orders) as avg_order_value
from Revenue