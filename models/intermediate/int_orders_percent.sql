With ordercounttype as (
  SELECT
      Count(Case when payment_count > 1 then 1 end) as orders_with_multiple_paycount,
	  COUNT(Case when distinct_payment_types > 1 then 1 end) as orders_with_multiple_paytypes,
	  Count(order_id) as order_count,
	  SUM(Case when payment_type_group = 'single' then total_payment_value end) as single_payment_value,
	  SUM(Case when payment_type_group = 'multiple' then total_payment_value end) as multiple_payment_value,
	  SUM(total_payment_value) as total_captured_revenue
	  from  {{ref('int_order_payments')}}
)
Select ((orders_with_multiple_paycount/order_count)*100.0) as orders_with_multiple_paycount,
       ((orders_with_multiple_paytypes/order_count)*100.0) as orders_with_multiple_paytypes,
	   ((single_payment_value/total_captured_revenue)*100.0) as single_payment_percent,
	   ((multiple_payment_value/total_captured_revenue)*100.0) as multiple_payment_percent,
	   single_payment_value,
	   multiple_payment_value,
       total_captured_revenue
	   FROM ordercounttype