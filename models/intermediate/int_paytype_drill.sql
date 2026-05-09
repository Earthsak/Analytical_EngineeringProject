WITH orderval AS ( 
   SELECT order_id, 
   SUM(payment_value) AS order_total_value, 
   ARRAY_TO_STRING(ARRAY_AGG(DISTINCT payment_type ORDER BY payment_type), ' + ') AS payment_combination 
  FROM {{ref('fct_payments')}} 
   GROUP BY 1 
   ), agg_by_type AS ( 
   SELECT payment_combination, 
   SUM(order_total_value) AS type_revenue, COUNT(order_id) AS type_orders,
   -- Calculating global totals using window functions (OVER()) 
   SUM(SUM(order_total_value)) OVER() AS global_revenue, 
   SUM(COUNT(order_id)) OVER() AS global_orders FROM orderval
   GROUP BY 1 
   ) 
   SELECT payment_combination, 
   SAFE_DIVIDE(type_revenue, global_revenue) * 100.0 AS revenue_contribution_pct, 
   SAFE_DIVIDE(type_orders, global_orders) * 100.0 AS order_penetration_pct 
   FROM agg_by_type 
   WHERE payment_combination IN ('voucher', 'credit_card + voucher')