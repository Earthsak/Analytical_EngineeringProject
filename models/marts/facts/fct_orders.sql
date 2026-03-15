select
    o.order_id,
    o.customer_id,
    o.order_purchase_timestamp,
    sum(oi.price) as order_revenue
from {{ ref('stg_orders') }} o
left join {{ ref('stg_order_items') }} oi
    on o.order_id = oi.order_id
group by 1,2,3