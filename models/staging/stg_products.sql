select *
from {{ source('raw', 'raw_products') }}