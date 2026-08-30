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

    fct_table.bp_reading_count,
    fct_table.weight_count,
    fct_table.total_weight,
    fct_table.lastest_monthly_recorded_weight,
    fct_table.total_systolic_readings,
    fct_table.total_diastolic_readings,
    fct_table.total_systolic_absolute_change_from_previous_day,
    fct_table.total_diastolic_absolute_change_from_previous_day,
    fct_table.normal_bp_category_count,
    fct_table.most_common_monthly_bp_category,
    fct_table.most_common_monthly_bp_category_count,

    fct_table.time_of_day,
    fct_table.avg_monthly_morning_systolic_reading,
    fct_table.avg_monthly_morning_diastolic_reading,
    fct_table.avg_monthly_morning_reading,
    fct_table.monthly_morning_bp_category,

    fct_table.avg_monthly_afternoon_systolic_reading,
    fct_table.avg_monthly_afternoon_diastolic_reading,
    fct_table.avg_monthly_afternoon_reading,
    fct_table.monthly_afternoon_bp_category,

    fct_table.avg_monthly_evening_systolic_reading,
    fct_table.avg_monthly_evening_diastolic_reading,
    fct_table.avg_monthly_evening_reading,
    fct_table.monthly_evening_bp_category,

from {{ ref('fct_monthly_bp_readings')}} as fct_table
left join {{ ref('dim_person')}} as dim_person
    on fct_table.person_key = dim_person.person_key
left join month_spine
    on fct_table.month_key = month_spine.month_key