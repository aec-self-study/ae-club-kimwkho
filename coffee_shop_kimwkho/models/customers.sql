{{
    config (
        materialized = 'table'
    )
}}

with customer_orders as (
    select
        customer_id
        , count(*) as n_orders
        , min(created_at) as first_order_at
    from {{ source('coffee_shop_kimwkho', 'orders') }} as orders 
    group by 1
)

select 
    customers.id as customer_id
    , customers.name
    , customers.email
    , coalesce(customer_orders.n_orders, 0) as n_orders
    , customer_orders.first_order_at
from {{ source ( 'coffee_shop_kimwkho', 'customers')}} as customers 
left join customer_orders
    on customer_id = customer_orders.customer_id