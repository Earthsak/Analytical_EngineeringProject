select
    product_id,
    product_category_name as product_category ,
    product_weight_g,
    product_length_cm,
    product_height_cm,
	product_width_cm
from {{ ref('stg_products') }}