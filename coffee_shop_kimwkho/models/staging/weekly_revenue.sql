-- show weekly revenue per product category

with weekly_revenue as (
    select 
        timestamp_trunc(created_at, week) as week_of
        , sum(total) as weekly_total_revenue
    from {{ source('coffee_shop', 'orders')}}
    left join `analytics-engineers-club`.`coffee_shop`.`order_items` on orders.id = order_items.order_id  
    group by 1
),

ordered_items as (
    select
        category as product_category
    from {{ source('coffee_shop', 'products')}} 
left join `analytics-engineers-club`.`coffee_shop`.`order_items` on order_items.product_id = products.id 
)

select
    week_of
    , weekly_total_revenue
    , product_category
from weekly_revenue, ordered_items