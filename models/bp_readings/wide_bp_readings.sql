select
    fct_table.bp_reading_key,
    fct_table.person_key,

    dim_person.person_display_name,
    dim_person.date_of_birth,
    dim_person.gender,
    dim_person.height,

    fct_table.date_day,

    dim_date.month,
    dim_date.month_name,
    dim_date.year,

    dim_readings.time_of_day,
    dim_readings.general_mood,

    fct_table.systolic_reading,
    fct_table.diastolic_reading,
    fct_table.bp_reading,

    dim_readings.bp_category,

    fct_table.systolic_change_from_previous_day,
    fct_table.diastolic_change_from_previous_day,

from {{ ref('fct_bp_readings')}} as fct_table
left join {{ ref('dim_bp_readings')}} as dim_readings
    on fct_table.bp_reading_key = dim_readings.bp_reading_key
left join {{ ref('dim_person')}} as dim_person
    on fct_table.person_key = dim_person.person_key
left join {{ ref('dim_date') }} as dim_date
    on fct_table.date_key = dim_date.date_key
