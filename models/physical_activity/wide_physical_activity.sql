select
    fct_table.physical_activity_key,
    fct_table.person_key,

    dim_person.person_id,
    dim_person.person_display_name,
    dim_person.date_of_birth,
    dim_person.age,
    dim_person.gender,
    dim_person.height,

    fct_table.weight,
    fct_table.date_day,

    dim_date.month,
    dim_date.month_name,
    dim_date.week_start_date,
    dim_date.week_end_date,
    dim_date.year,

    dim_activity.time_of_day,
    dim_activity.physical_activity,
    dim_activity.physical_activity_intensity,

    fct_table.average_heart_rate,
    fct_table.physical_activity_distance,
    fct_table.physical_activity_duration,
    fct_table.calories_burned,
    -- cumulative hours of moderate and vigorous activity per week dimension
    -- resets at the start of the new week
    -- new dimension in an int model but first need a separate dimension for moderate and 
    -- vigourous activity hours
    -- window function checks if week start date and end date equal the previous records
    -- then add to the dimension. if not reset to 0

    -- flag for has met weekly moderate physical activity?

from {{ ref('fct_physical_activity')}} as fct_table
left join {{ ref('dim_physical_activity')}} as dim_activity
    on fct_table.physical_activity_key = dim_activity.physical_activity_key
left join {{ ref('dim_person')}} as dim_person
    on fct_table.person_key = dim_person.person_key
left join {{ ref('dim_date') }} as dim_date
    on fct_table.date_key = dim_date.date_key