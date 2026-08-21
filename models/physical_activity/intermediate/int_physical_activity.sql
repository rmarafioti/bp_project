with physical_activity_results as (
    
    select
        activity.person_id,
        activity.date_day,
        activity.time_of_day,
        activity.weight,
        activity.average_heart_rate,
        activity.physical_activity_distance,
        activity.physical_activity_duration,
        activity.calories_burned,
        activity.physical_activity,
        activity.physical_activity_intensity,

        dates.year,
        dates.week_start_date,
        dates.week_end_date,
from {{ ref('stg_physical_activity') }} as activity
left join {{ ref('dim_date') }} as dates
    on activity.date_day = dates.date_day

),

intensity_duration as (

    select
        person_id,
        date_day,
        time_of_day,
        weight,
        average_heart_rate,
        physical_activity_distance,
        physical_activity_duration,
        calories_burned,
        physical_activity,
        physical_activity_intensity,
        year,
        week_start_date,
        week_end_date,
        case 
            when physical_activity_intensity = 'Vigorous Intensity'
                or physical_activity_intensity = 'Max Intensity'
                    then physical_activity_duration
        end                                             as vigorous_intensity,
        case
            when physical_activity_intensity = 'Moderate Intensity'
                then physical_activity_duration
        end                                             as moderate_intensity,
    from physical_activity_results
),

cumulative as (

    select
        person_id,
        date_day,
        time_of_day,
        weight,
        average_heart_rate,
        physical_activity_distance,
        physical_activity_duration,
        calories_burned,
        physical_activity,
        physical_activity_intensity,
        year,

        sum(moderate_intensity) over (
            partition by person_id, week_start_date
            order by date_day
        ) as cumulative_weekly_moderate_intensity,

        sum(vigorous_intensity) over (
            partition by person_id, week_start_date
            order by date_day
        ) as cumulative_weekly_vigorous_intensity,

    from intensity_duration
)

select
    person_id,
    date_day,
    time_of_day,
    weight,
    average_heart_rate,
    physical_activity_distance,
    physical_activity_duration,
    calories_burned,
    physical_activity,
    physical_activity_intensity,
    year,
    round(cumulative_weekly_moderate_intensity, 1)          as cumulative_weekly_moderate_intensity,
    round(cumulative_weekly_vigorous_intensity, 1)          as cumulative_weekly_vigorous_intensity,
    if(cumulative_weekly_moderate_intensity >= 2.5, 1, 0)    as has_met_weekly_moderate_hours,
    if(cumulative_weekly_vigorous_intensity >= 1.25, 1, 0)   as has_met_weekly_vigorous_hours,

from cumulative