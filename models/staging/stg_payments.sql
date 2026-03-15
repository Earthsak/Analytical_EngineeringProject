select *
from {{ source('raw', 'raw_payments') }}