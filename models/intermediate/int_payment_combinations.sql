WITH order_payment_list AS (
    SELECT
        order_id,
        -- Sort alphabetically so combinations are consistent
        ARRAY_TO_STRING(ARRAY_AGG(DISTINCT payment_type ORDER BY payment_type), ' + ') AS payment_combination,
		 Count(Distinct payment_type) as distinct_payment_types
    FROM {{ ref('fct_payments') }}
    GROUP BY 1
    HAVING COUNT(*) > 1 
)

SELECT
    payment_combination,
    COUNT(*) AS occurrence_count
FROM order_payment_list
where distinct_payment_types > 1
GROUP BY 1
ORDER BY occurrence_count DESC