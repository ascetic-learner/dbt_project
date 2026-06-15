with 

source as (

    select * from {{ source('blackrock', 'payments') }}

),

renamed as (

    select
        id as payment_id,
        order_id,
        amount::number(10, 2) as payment_amount,
        lower(payment_method) as payment_method,
        paid_at::date as paid_at

    from source

)

select * from renamed