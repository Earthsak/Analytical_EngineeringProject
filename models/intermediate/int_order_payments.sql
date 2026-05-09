With paymenttypes as (
      Select
       order_id,
	   ANY_VALUE(customer_id) as customer_id,
	   Sum(payment_value) as total_payment_value,
	   Count(*) as payment_count,
	   Count(Distinct payment_type) as distinct_payment_types
	    from {{ref('fct_payments')}}
         group by order_id
  )
  Select order_id,customer_id,total_payment_value,payment_count,distinct_payment_types,
           CASE 
           WHEN distinct_payment_types = 1 THEN 'single'
            ELSE  'multiple'
       END AS payment_type_group
	   from paymenttypes