With avgorderval as (
   Select
      order_id,
      SUM(payment_value) AS order_total_value,
	   MAX(IF(payment_type = 'voucher',1,0)) as has_voucher_flag
	  from `brilliant-vent-489218-d2.analytics_engineering_mart.fct_payments`
	  group by 1
)
Select
       AVG(CASE WHEN has_voucher_flag = 1 THEN order_total_value END) as avg_voucher_orderval,
       AVG(CASE WHEN has_voucher_flag = 0 THEN order_total_value END) as avg_nonvoucher_orderval
	   from avgorderval