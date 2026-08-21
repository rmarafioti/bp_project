with 
overall_activity as (

    select
        person_key,
        count(*)                            as total_physical_activity_count,
        sum(average_heart_rate)             as total_heart_rate,
        sum(physical_activity_duration)     as total_physical_activity_duration,
    from {{ ref('fct_physical_activity') }}
    group by 1

),

overall_activity_count as (

    select
        person_key,
        'Physical Activity'                 as metric_category,
        'Overall'                           as metric_subcategory,
        'Total Workout Count'               as metric_name,
        cast(null as string)                as metric_period,
        cast(null as string)                as metric_reading,
        total_physical_activity_count       as metric_value,
        cast(null as string)                as metric_label,
        cast(null as int64)                 as has_met_goal
    from overall_activity
         
),

overall_activity_hours as (

    select
        person_key,
        'Physical Activity'                 as metric_category,
        'Overall'                           as metric_subcategory,
        'Total Workout Hours'               as metric_name,
        cast(null as string)                as metric_period,
        cast(null as string)                as metric_reading,
        total_physical_activity_duration    as metric_value,
        cast(null as string)                as metric_label,
        cast(null as int64)                 as has_met_goal
    from overall_activity
         
)

select * from overall_activity_count

union all

select * from overall_activity_hours
