with month_spine as (

    select
        month_key,
        month,
        month_name,
        year,
    from {{ ref('dim_date')}}
    qualify row_number() over (
        partition by
            month,
            year
        order by month asc
    ) = 1
)

select
    fct_table.person_key,

    dim_person.person_id,
    dim_person.person_display_name,
    dim_person.date_of_birth,
    dim_person.age,
    dim_person.gender,
    dim_person.height,

    month_spine.month,
    month_spine.month_name,
    month_spine.year,

    fct_table.average_nightly_sleep_hours,
    fct_table.percent_met_nightly_sleep_goal,

from {{ ref('fct_monthly_sleep') }} as fct_table
left join {{ ref('dim_person')}} as dim_person
    on fct_table.person_key = dim_person.person_key
left join month_spine
    on fct_table.month_key = month_spine.month_key