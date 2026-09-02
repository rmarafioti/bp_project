{% set activity_list = dbt_utils.get_column_values(ref('stg_physical_activity'), 'physical_activity') if execute else [] %}

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
),

activities as (

    select
        {{ dbt_utils.generate_surrogate_key(['person_id', 'year']) }}       as person_key,
        {{ dbt_utils.generate_surrogate_key(['month', 'year']) }}           as month_key,
        {% for activity in activity_list %}
        sum(case when physical_activity = '{{ activity }}' then 1 else 0 end) as {{ activity | trim | lower }}_count{% if not loop.last %},{% endif %}
        {% endfor %}
    from {{ ref('stg_physical_activity') }}
    where physical_activity is not null
    group by 1,2

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

    fct_table.physical_activity_count,
    fct_table.total_average_heart_rate,
    fct_table.total_physical_activity_distance,
    fct_table.total_physical_activity_duration,
    fct_table.total_calories_burned,
    fct_table.total_moderate_intensity_hours,
    fct_table.has_met_monthly_moderate_hours,
    fct_table.total_vigorous_intensity_hours,
    fct_table.has_met_monthly_vigorous_hours,

    activities.* except (person_key, month_key),

from {{ ref('fct_monthly_physical_activity')}} as fct_table
left join activities
    on fct_table.person_key = activities.person_key
    and fct_table.month_key = activities.month_key
left join {{ ref('dim_person')}} as dim_person
    on fct_table.person_key = dim_person.person_key
left join month_spine
    on fct_table.month_key = month_spine.month_key