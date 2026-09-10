with combined as (

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
    -- archived data
    from {{ ref('stg_physical_activity') }}

    union all

    select
        person_id,
        date_day,
        physical_activity_time_of_day as time_of_day,
        weight,
        average_heart_rate,
        physical_activity_distance,
        physical_activity_duration,
        calories_burned,
        physical_activity,
        physical_activity_intensity,
    -- live data
    from {{ ref('stg_daily_data_raw') }}

),

physical_activity_results as (
    
    select
        combined.person_id,
        combined.date_day,
        combined.time_of_day,
        combined.weight,
        combined.average_heart_rate,
        combined.physical_activity_distance,
        combined.physical_activity_duration,
        combined.calories_burned,
        combined.physical_activity,
        combined.physical_activity_intensity,

        dates.month,
        dates.year,
        dates.week_start_date,
        dates.week_end_date,
from combined
left join {{ ref('dim_date') }} as dates
    on combined.date_day = dates.date_day

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
        month,
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
        month,
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
    month,
    year,
    time_of_day,
    weight,
    average_heart_rate,
    physical_activity_distance,
    physical_activity_duration,
    calories_burned,
    physical_activity,
    physical_activity_intensity,
    round(cumulative_weekly_moderate_intensity, 1)              as cumulative_weekly_moderate_intensity,
    round(cumulative_weekly_vigorous_intensity, 1)              as cumulative_weekly_vigorous_intensity,
    if(cumulative_weekly_moderate_intensity >= 2.5, 1, 0)       as has_met_weekly_moderate_hours,
    if(cumulative_weekly_vigorous_intensity >= 1.25, 1, 0)      as has_met_weekly_vigorous_hours,

from cumulative