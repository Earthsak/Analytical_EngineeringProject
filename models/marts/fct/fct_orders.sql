select
    o.order_id,
    o.customer_id,
    o.order_purchase_timestamp,
    CAST(o.order_purchase_timestamp AS DATE) AS order_date,
    sum(oi.price) as order_revenue,
	sum(oi.freight_value) as shipping_revenue,
	Count(Distinct oi.order_id) as total_orders
from {{ ref('stg_orders') }} o
left join {{ ref('stg_order_items') }} oi
    on o.order_id = oi.order_id
group by 1,2,3