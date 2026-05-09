With avgorderval as (
   Select
      order_id,
      SUM(payment_value) AS order_total_value,
	  ARRAY_TO_STRING(ARRAY_AGG(DISTINCT payment_type ORDER BY payment_type), ' + ') AS payment_combination,
	  from `brilliant-vent-489218-d2.analytics_engineering_mart.fct_payments`
	  group by 1
	  )
	  Select payment_combination,Avg(order_total_value) as average_paytype_orderval from avgorderval 
	  group by payment_combination
	  