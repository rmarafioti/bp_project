with physical_activity_monthly as (

    select
        person_id,
        month,
        year,
        average_heart_rate,
        physical_activity_distance,
        physical_activity_duration,
        calories_burned,
        physical_activity_intensity,
        case 
            when physical_activity_intensity = 'Vigorous Intensity'
                or physical_activity_intensity = 'Max Intensity'
                    then physical_activity_duration
        end                                             as vigorous_intensity_hours,
        case
            when physical_activity_intensity = 'Moderate Intensity'
                then physical_activity_duration
        end                                             as moderate_intensity_hours,
    from {{ ref('stg_physical_activity') }}

),

counts as (

    select
        person_id,
        month,
        year,
        count(*)                        as physical_activity_count,
        sum(average_heart_rate)         as total_average_heart_rate,
        sum(physical_activity_distance) as total_physical_activity_distance,
        sum(physical_activity_duration) as total_physical_activity_duration,
        sum(calories_burned)            as total_calories_burned,
        sum(moderate_intensity_hours)   as total_moderate_intensity_hours,
        sum(vigorous_intensity_hours)   as total_vigorous_intensity_hours,
    from physical_activity_monthly
    group by 1,2,3

),

final as (

    select
        person_id,
        month,
        year,
        physical_activity_count,
        total_average_heart_rate,
        total_physical_activity_distance,
        total_physical_activity_duration,
        total_calories_burned,
        total_moderate_intensity_hours,
        total_vigorous_intensity_hours,
        if(total_moderate_intensity_hours >= 10, 1, 0)  as has_met_monthly_moderate_hours,
        if(total_vigorous_intensity_hours >= 5, 1, 0)    as has_met_monthly_vigorous_hours,
    from counts

)

select * from final
