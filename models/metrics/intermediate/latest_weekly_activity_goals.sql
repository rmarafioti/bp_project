with current_week_dates as (

    -- every date within the current week
    select
        date_key,
        week_start_date
    from {{ ref('dim_date') }}
    where current_date("America/Chicago") between
        week_start_date and week_end_date

),

current_week as (

    -- the single current week start date
    select distinct week_start_date
    from current_week_dates

),

people as (

    -- each person who has logged activity ever
    select distinct person_key
    from {{ ref('fct_physical_activity') }}

),

weekly_activity as (

    -- all activity logged by a perosn for the current week
    select
        fct_table.person_key,
        sum(if(fct_table.physical_activity_intensity = 'Moderate Intensity',
               fct_table.physical_activity_duration, 0)) as moderate_hours,
        sum(if(fct_table.physical_activity_intensity in
               ('Vigorous Intensity', 'Max Intensity'),
               fct_table.physical_activity_duration, 0)) as vigorous_hours
    from {{ ref('fct_physical_activity') }} as fct_table
    inner join current_week_dates
        on fct_table.date_key = current_week_dates.date_key
    group by 1

),

results as (

    -- ever person gets a row whether they logged acitivity or not
    select
        people.person_key,
        cast(current_week.week_start_date as string)        as week_start_date,
        coalesce(weekly_activity.moderate_hours, 0)         as moderate_hours,
        coalesce(weekly_activity.vigorous_hours, 0)         as vigorous_hours
    from people
    cross join current_week
    left join weekly_activity
        on people.person_key = weekly_activity.person_key

),

metrics as (

    select
        person_key,
        'Physical Activity'                         as metric_category,
        'Activity Hours'                            as metric_subcategory,
        'Latest Weekly Moderate Activity Hours'     as metric_name,
        week_start_date                             as metric_period,
        cast(null as string)                        as metric_reading,
        moderate_hours                              as metric_value,
        case
            when moderate_hours > 2.5 then concat(moderate_hours - 2.5, ' Above Weekly Goal')
            when moderate_hours = 2.5 then 'Met Weekly Goal'
            when moderate_hours < 2.5 then concat(2.5 - moderate_hours, ' Below Weekly Goal')
        end                                         as metric_label,
        if(moderate_hours >= 2.5, 1, 0)             as has_met_goal
    from results

    union all

    select
        person_key,
        'Physical Activity'                         as metric_category,
        'Activity Hours'                            as metric_subcategory,
        'Latest Weekly Vigorous Activity Hours'     as metric_name,
        week_start_date                             as metric_period,
        cast(null as string)                        as metric_reading,
        vigorous_hours                              as metric_value,
        case
            when vigorous_hours > 1.25 then concat(vigorous_hours - 1.25, ' Above Weekly Goal')
            when vigorous_hours = 1.25 then 'Met Weekly Goal'
            when vigorous_hours < 1.25 then concat(1.25 - vigorous_hours, ' Below Weekly Goal')
        end                                         as metric_label,
        if(vigorous_hours >= 1.25, 1, 0)            as has_met_goal
    from results

)

select * from metrics
