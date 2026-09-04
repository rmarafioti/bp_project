select
    
    fct_table.person_key,

    dim_person.person_id,
    dim_person.person_display_name,
    dim_person.date_of_birth,
    dim_person.age,
    dim_person.gender,
    dim_person.height,

    fct_table.date_day,

    dim_date.month,
    dim_date.month_name,
    dim_date.year,

    fct_table.caffeine_drink_count,
    fct_table.caffeine_drink_description,
    fct_table.water_intake_oz,
    fct_table.hydration_band,

from {{ ref('fct_hydration_and_caffeine')}} as fct_table
left join {{ ref('dim_person')}} as dim_person
    on fct_table.person_key = dim_person.person_key
left join {{ ref('dim_date') }} as dim_date
    on fct_table.date_key = dim_date.date_key