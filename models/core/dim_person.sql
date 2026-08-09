select
    {{ dbt_utils.generate_surrogate_key(['person_id']) }} as person_key,
    person_first_name,
    person_last_name,
    person_display_name,
    date_of_birth,
    age,
    gender,
    height,
from {{ ref('stg_person_information')}}