select 
    first_name,
    last_name,
    first_name || ' ' || last_name as full_name,
    email,
    customer_since,
    case 
    when email is null or trim(email) = ' ' then false
    else true
    end as has_email
from {{ref('stg_customers')}}


union all 

select 
    first_name,
    last_name,
    first_name || ' ' || last_name as full_name,
    email,
    customer_since,
    case 
    when email is null or trim(email) = ' ' then false
    else true
    end as has_email

    from {{ref('stg_blackrock__customers')}}


