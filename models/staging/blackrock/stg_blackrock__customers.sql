with 

source as (

    select * from {{ source('blackrock', 'customers') }}

),

renamed as (

    select
        id as customer_id,
        first_name,
        last_name,
        email,
        created_at::date as customer_since

    from source

)

select * from renamed