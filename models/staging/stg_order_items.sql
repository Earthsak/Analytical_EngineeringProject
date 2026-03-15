select *
from {{ source('raw', 'raw_order_items') }}