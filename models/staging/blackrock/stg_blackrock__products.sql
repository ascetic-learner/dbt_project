with 

source as (

    select * from {{ source('blackrock', 'products') }}

),

renamed as (

    select
       id as product_id,
        name as product_name,
        price::number(10, 2) as unit_price,
        category as product_category
        
    from source

)

select * from renamed