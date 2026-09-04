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

    fct_table.bed_time,
    fct_table.wake_up_time,
    fct_table.amount_of_nightly_sleep_hours,
    fct_table.sleep_band,
    
from {{ ref('fct_daily_sleep')}} as fct_table
left join {{ ref('dim_person')}} as dim_person
    on fct_table.person_key = dim_person.person_key
left join {{ ref('dim_date') }} as dim_date
    on fct_table.date_key = dim_date.date_key