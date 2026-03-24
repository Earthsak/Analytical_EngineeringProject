with customer_first_orderdate as (
Select
    min(CAST(order_purchase_timestamp AS DATE)) as customer_first_order_date,
	customer_id
    from {{ref('fct_orders')}}
	group by customer_id
),
customer_status as (
Select o.customer_id,
       CAST(o.order_purchase_timestamp AS DATE) AS order_date,
       MAX(Case when CAST(o.order_purchase_timestamp AS DATE) = co.customer_first_order_date then 1 else 0 end) as customer_status 
       from {{ref('fct_orders')}} o join customer_first_orderdate co  
	   on o.customer_id = co.customer_id
	   group by customer_id,order_date
)
Select cs.order_date,
       Count(Distinct Case when cs.customer_status = 1 then customer_id end ) as new_customer_count,
	   Count(Distinct Case when cs.customer_status = 0 then customer_id end ) as existing_customer_count
	   from customer_status cs
	   group by cs.order_date