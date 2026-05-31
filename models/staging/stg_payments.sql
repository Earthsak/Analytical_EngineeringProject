select *
from {{ source('raw', 'raw_payments') }}
where payment_value > 0
-- Filtering out 9 zero-value payment rows (6 voucher, 3 not_defined)
-- Detected by Python validation script on range check
-- Zero-value payments distort AOV and LTV calculations in mart layer