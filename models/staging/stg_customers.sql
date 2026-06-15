with src as (

    select * from {{ source('dbt_learning', 'raw_customers') }}

),

renamed as (

    select
        id as customer_id,
        first_name,
        last_name,
        email,
        created_at::date as customer_since

    from src

)
--git sync
select * from renamed
