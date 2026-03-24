Select p.order_id,
       o.customer_id,
	   CAST(o.order_purchase_timestamp AS DATE) AS order_date,
       p.payment_sequential,
	   p.payment_type,
	   p.payment_installments,
	   p.payment_value
  from {{ref('stg_payments')}} p inner join {{ref('stg_orders')}} o 
   on p.order_id = o.order_id 
