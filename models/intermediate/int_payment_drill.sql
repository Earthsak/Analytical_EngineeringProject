WITH order_grain_summary AS (
  SELECT 
    order_id,
   
    SUM(IF(payment_type = 'voucher', payment_value, 0)) AS order_voucher_value,
    SUM(payment_value) AS order_total_value,
    MAX(IF(payment_type = 'voucher', 1, 0)) AS has_voucher_flag
 FROM {{ ref('fct_payments') }}
  GROUP BY 1
)
SELECT
  -- 1. Revenue Contribution: Total Voucher $ / Total $
  SAFE_DIVIDE(SUM(order_voucher_value), SUM(order_total_value)) * 100.0 AS voucher_revenue_pct,
  
  -- 2. Order Penetration: Orders with a Voucher / Total Unique Orders
  SAFE_DIVIDE(SUM(has_voucher_flag), COUNT(order_id)) * 100.0 AS voucher_order_penetration_pct,
  
  (SUM(CASE WHEN has_voucher_flag = 1 THEN order_total_value END)/SUM(order_total_value)*100.0 ) as revenue_by_vouchers,
  
FROM order_grain_summary 