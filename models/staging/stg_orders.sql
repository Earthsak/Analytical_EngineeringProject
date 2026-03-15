select *
from {{ source('raw', 'raw_orders') }}