Select
       order_id,
	   ANY_VALUE(customer_id) as customer_id,
	   Sum(payment_value) as total_payment_value,
	   Count(*) as payment_count,
	   Count(Distinct payment_type) as distinct_payment_types,
	   CASE 
           WHEN COUNT(*) = 1 THEN 'simple'
           WHEN COUNT(*) BETWEEN 2 AND 5 THEN 'moderate'
           ELSE 'complex'
       END AS payment_complexity
  from {{ref('fct_payments')}}
  group by order_id