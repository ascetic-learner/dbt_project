with orders as (

    select * from {{ ref('stg_orders') }}

),

products as (

    select * from {{ ref('stg_products') }}

),

payments as (

    select
        order_id,
        sum(payment_amount) as total_paid
    from {{ ref('stg_payments') }}
    group by 1

),

a_final as (

    select
        orders.order_id,
        orders.customer_id,
        orders.product_id,
        products.product_name,
        products.product_category,
        orders.order_date,
        orders.order_status,
        orders.quantity,
        products.unit_price,
        orders.quantity * products.unit_price as line_total,
        coalesce(payments.total_paid, 0) as total_paid,
        case
            when orders.order_status = 'completed'
             and payments.total_paid is not null
            then true
            else false
        end as is_paid

    from orders
    inner join products
        on orders.product_id = products.product_id
    left join payments
        on orders.order_id = payments.order_id

),

blackrock_orders as (

    select * from {{ ref('stg_blackrock__orders') }}

),

blackrock_products as (

    select * from {{ ref('stg_blackrock__products') }}

),

blackrock_payments as (

    select
        order_id,
        sum(payment_amount) as total_paid
    from {{ ref('stg_blackrock__payments') }}
    group by 1

),

b_final as (

    select
        o.order_id,
        o.customer_id,
        o.product_id,
        p.product_name,
        p.product_category,
        o.order_date,
        o.order_status,
        o.quantity,
        p.unit_price,
        o.quantity * p.unit_price as line_total,
        coalesce(py.total_paid, 0) as total_paid,
        case
            when o.order_status = 'completed'
             and py.total_paid is not null
            then true
            else false
        end as is_paid

    from blackrock_orders o
    inner join blackrock_products p
        on o.product_id = p.product_id
    left join blackrock_payments py
        on o.order_id = py.order_id

)

select * from a_final

union all

select * from b_final