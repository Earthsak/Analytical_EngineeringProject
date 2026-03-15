select
    oi.order_id,
	oi.order_item_id,
	oi.product_id,
	o.customer_id,
    oi.price as order_revenue,
	oi.freight_value as shipping_revenue
from {{ ref('stg_order_items') }} oi
left join {{ ref('stg_orders') }} o
on oi.order_id = o.order_id