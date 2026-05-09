WITH custval AS ( 
   SELECT
         customer_id,   
   SUM(payment_value) AS order_total_value, 
   ARRAY_TO_STRING(ARRAY_AGG(DISTINCT payment_type ORDER BY payment_type), ' + ') AS payment_combination 
  FROM {{ref('fct_payments')}}
   GROUP BY 1
  )
  Select payment_combination ,Count(customer_id ) as customer_count, Sum(order_total_value) as total_value
       from custval
       group by payment_combination