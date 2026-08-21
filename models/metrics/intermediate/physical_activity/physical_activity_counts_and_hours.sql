with daily_activity as (

    select
        fct_activity.person_key,
        fct_activity.date_day,
        
        dim_date.month_name,

        fct_activity.physical_activity_distance,
        fct_activity.physical_activity_duration,
        fct_activity.physical_activity_intensity

    from {{ ref('fct_physical_activity') }} as fct_activity
    left join {{ ref('dim_date') }} as dim_date
        on fct_activity.date_day = dim_date.date_day

),

daily_moderate_intensity as (

    select * from daily_activity
    where physical_activity_intensity = 'Moderate Intensity'

),

daily_vigorous_intensity as (

    select * from daily_activity
    where physical_activity_intensity in ('Vigorous Intensity', 'Max Intensity')

),

monthly_activity as (

    select
        person_key,
        month_name,
        count(*)                           as monthly_physical_activity_count,
        sum(physical_activity_distance)    as monthly_physical_activity_distance,
        sum(physical_activity_duration)    as monthly_physical_activity_duration,
    from daily_activity
    group by 1,2 

),

monthly_moderate_activity as (

    select
        person_key,
        month_name,
        count(*)                           as monthly_moderate_physical_activity_count,
        sum(physical_activity_distance)    as monthly_moderate_physical_activity_distance,
        sum(physical_activity_duration)    as monthly_moderate_physical_activity_duration,
    from daily_moderate_intensity
    group by 1, 2

),

monthly_vigorous_activity as (

    select
        person_key,
        month_name,
        count(*)                           as monthly_vigorous_physical_activity_count,
        sum(physical_activity_distance)    as monthly_vigorous_physical_activity_distance,
        sum(physical_activity_duration)    as monthly_vigorous_physical_activity_duration,
    from daily_vigorous_intensity
    group by 1, 2

),


overall_activity as (

    select
        person_key,
        count(*)                            as total_physical_activity_count,
        sum(average_heart_rate)             as total_heart_rate,
        sum(physical_activity_distance)     as total_physical_activity_distance,
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
         
),

monthly_activity_count as (

    select
        person_key,
        'Physical Activity'                 as metric_category,
        'Monthly'                           as metric_subcategory,
        'Total Workout Count'               as metric_name,
        month_name                          as metric_period,
        cast(null as string)                as metric_reading,
        monthly_physical_activity_count     as metric_value,
        cast(null as string)                as metric_label,
        cast(null as int64)                 as has_met_goal
    from monthly_activity
         
),

monthly_activity_hours as (

    select
        person_key,
        'Physical Activity'                 as metric_category,
        'Monthly'                           as metric_subcategory,
        'Total Workout Hours'               as metric_name,
        month_name                          as metric_period,
        cast(null as string)                as metric_reading,
        monthly_physical_activity_duration  as metric_value,
        cast(null as string)                as metric_label,
        cast(null as int64)                 as has_met_goal
    from monthly_activity
         
),

monthly_moderate_intensity_hours as (

    select
        person_key,
        'Physical Activity'                 as metric_category,
        'Monthly'                           as metric_subcategory,
        'Moderate Intensity Total Hours'    as metric_name,
        month_name                          as metric_period,
        cast(null as string)                as metric_reading,
        monthly_moderate_physical_activity_duration  as metric_value,
        cast(null as string)                as metric_label,
        if(monthly_moderate_physical_activity_duration >= 10, 1, 0) as has_met_goal
    from monthly_moderate_activity
         
),

monthly_vigorous_intensity_hours as (

    select
        person_key,
        'Physical Activity'                 as metric_category,
        'Monthly'                           as metric_subcategory,
        'Vigorous Intensity Total Hours'    as metric_name,
        month_name                          as metric_period,
        cast(null as string)                as metric_reading,
        monthly_vigorous_physical_activity_duration    as metric_value,
        cast(null as string)                as metric_label,
        if(monthly_vigorous_physical_activity_duration >= 5, 1, 0) as has_met_goal
    from monthly_vigorous_activity
         
)

select * from overall_activity_count

union all

select * from overall_activity_hours

union all

select * from monthly_activity_count

union all

select * from monthly_activity_hours

union all

select * from monthly_moderate_intensity_hours

union all

select * from monthly_vigorous_intensity_hours