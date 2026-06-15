with src as (

    select * from {{ source('dbt_learning', 'raw_orders') }}

),

renamed as (

    select
        id as order_id,
        customer_id,
        product_id,
        order_date::date as order_date,
        lower(status) as order_status,
        quantity::integer as quantity

    from src

)

select * from renamed
