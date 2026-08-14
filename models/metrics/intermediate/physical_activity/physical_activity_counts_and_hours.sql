with activity as (

    select
        activity.person_key,
        count(*)                                    as total_physical_activity_count,
        sum(activity.average_heart_rate)            as total_heart_rate,
        sum(activity.physical_activity_distance)    as total_physical_activity_distance,
        sum(activity.physical_activity_duration)    as total_physical_activity_duration,
    from {{ ref('fct_physical_activity') }} as activity
    group by 1

),


activity_by_month as (

    select
        activity.person_key,
        dim_date.month_name,
        count(*)                                    as monthly_physical_activity_count,
        sum(activity.average_heart_rate)            as monthly_heart_rate,
        sum(activity.physical_activity_distance)    as monthly_physical_activity_distance,
        sum(activity.physical_activity_duration)    as monthly_physical_activity_duration,
    from {{ ref('fct_physical_activity') }} as activity
    left join {{ ref('dim_date')}} as dim_date
        on activity.date_key = dim_date.date_key
    group by 1,2

),

avg_heart_rate as (

    select
        person_key,
        month_name,
        monthly_heart_rate,
        monthly_physical_activity_count,
        monthly_physical_activity_distance,
        monthly_physical_activity_duration,
        round(
            safe_divide(
                monthly_heart_rate,
                monthly_physical_activity_count), 1
        )  as avg_monthly_heart_rate,
    from activity_by_month

),

monthly_physical_intensity as (

    select
        person_key,
        month_name,
        monthly_physical_activity_count,
        monthly_heart_rate,
        monthly_physical_activity_distance,
        monthly_physical_activity_duration,
        case
            when avg_monthly_heart_rate >= 150 then 'Max Intensity'
            when avg_monthly_heart_rate >= 124 then 'Vigorous Intensity'
            when avg_monthly_heart_rate >= 88 then 'Moderate Intensity'
            else 'No Physical Intensity'
        end as avg_monthly_physical_intensity,
    from avg_heart_rate

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
    from activity
         
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
    from activity
         
),

-- the amount of workouts per month
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
    from monthly_physical_intensity
         
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
    from monthly_physical_intensity
         
),

-- first we need to add up the workouts with an avg hr moderate intensity by date
-- then we calculate the number of hours at that intensity rather than the avg monthly heart rate first
monthly_moderate_intensity_hours as (

    select
        person_key,
        'Physical Activity'                 as metric_category,
        'Monthly'                           as metric_subcategory,
        'Moderate Intensity Total Hours'    as metric_name,
        month_name                          as metric_period,
        cast(null as string)                as metric_reading,
        monthly_physical_activity_duration  as metric_value,
        cast(null as string)                as metric_label,
        if(monthly_physical_activity_duration >= 10, 1, 0) as has_met_goal
    from monthly_physical_intensity
    where avg_monthly_physical_intensity = 'Moderate Intensity'
         
),

-- first we need to add up the workouts with an avg hr vigorous intensity by date
-- then we calculate the number of hours at that intensity rather than the avg monthly heart rate first
monthly_vigorous_intensity_hours as (

    select
        person_key,
        'Physical Activity'                 as metric_category,
        'Monthly'                           as metric_subcategory,
        'Vigorous Intensity Total Hours'    as metric_name,
        month_name                          as metric_period,
        cast(null as string)                as metric_reading,
        monthly_physical_activity_duration    as metric_value,
        cast(null as string)                as metric_label,
        if(monthly_physical_activity_duration >= 5, 1, 0) as has_met_goal
    from monthly_physical_intensity
    where avg_monthly_physical_intensity = 'Vigorous Intensity'
         
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