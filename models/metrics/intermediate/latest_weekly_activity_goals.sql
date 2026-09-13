with latest_weekly_activity as (

    select
        fct_table.person_key,
        fct_table.physical_activity_intensity,
        cast(dim_date.week_start_date as string) as week_start_date,

        sum(fct_table.physical_activity_duration) as total_hours
    from {{ ref('fct_physical_activity')}} as fct_table
    left join {{ ref('dim_date') }} as dim_date
        on fct_table.date_key = dim_date.date_key
    group by 1,2,3
    qualify row_number() over (
        partition by
            person_key,
            physical_activity_intensity
        order by week_start_date desc
    ) = 1

),

vigorous_intensity_hours as (

    select
        person_key,
        physical_activity_intensity,
        week_start_date,
        total_hours as vigorous_hours
    from latest_weekly_activity
    where physical_activity_intensity = 'Vigorous Intensity'

),

max_intensity_hours as (

    select
        person_key,
        physical_activity_intensity,
        week_start_date,
        total_hours as max_hours
    from latest_weekly_activity
    where physical_activity_intensity = 'Max Intensity'

),

full_vigorous_count as (

    select
        vigorous_intensity_hours.person_key,
        vigorous_intensity_hours.week_start_date,
        vigorous_intensity_hours.vigorous_hours + max_intensity_hours.max_hours as total_vigorous_hours,
    from vigorous_intensity_hours
    left join max_intensity_hours
        on vigorous_intensity_hours.person_key = max_intensity_hours.person_key
        and vigorous_intensity_hours.week_start_date = max_intensity_hours.week_start_date
    
),

metrics as (
    
    select
        person_key,
        'Physical Activity'                                     as metric_category,
        'Activity Hours'                                        as metric_subcategory,
        'Latest Weekly Moderate Activity Hours'                 as metric_name,
        week_start_date                                         as metric_period,
        cast(null as string)                                    as metric_reading,
        total_hours                                             as metric_value,
        case 
            when total_hours > 2.5 then concat(total_hours - 2.5, ' Above Weekly Goal')
            when total_hours = 2.5 then 'Met Weekly Goal'
             when total_hours < 2.5 then concat(2.5 - total_hours, ' Below Weekly Goal')
        end                                                     as metric_label,
        if(total_hours >= 2.5, 1, 0)                            as has_met_goal
    from latest_weekly_activity
    where 
        physical_activity_intensity = 'Moderate Intensity'

union all 

    select
        person_key,
        'Physical Activity'                                     as metric_category,
        'Activity Hours'                                        as metric_subcategory,
        'Latest Weekly Vigorous Activity Hours'                 as metric_name,
        week_start_date                                         as metric_period,
        cast(null as string)                                    as metric_reading,
        total_vigorous_hours                                    as metric_value,
        case
            when total_vigorous_hours > 1.25 then concat(total_vigorous_hours - 1.25, ' Above Weekly Goal')
            when total_vigorous_hours = 1.25 then 'Met Weekly Goal'
            when total_vigorous_hours < 1.25 then concat(1.25 - total_vigorous_hours, ' Below Weekly Goal')
        end                                                     as metric_label,
        if(total_vigorous_hours >= 1.25, 1, 0)                  as has_met_goal
    from full_vigorous_count

)

select * from metrics

