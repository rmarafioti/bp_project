with sleep_amount as (

    select
        person_id,
        month,
        year,
        mod(
            time_diff(
                wake_up_time, bed_time ,minute) + 1440,
            1440
        ) / 60.0 as amount_of_sleep_hours,
    from {{ ref('stg_daily_sleep') }}

),

sleep_counts as (

    select
        person_id,
        month,
        year,
        count(*)                        as total_recorded_sleep_count,
        sum(amount_of_sleep_hours)      as total_amount_of_sleep_count,
        sum(if(amount_of_sleep_hours >= 7, 1, 0)) as total_amount_of_sleep_goal_count,
    from sleep_amount
    group by 1,2,3
),

results as (

    select
        person_id,
        month,
        year,
        round(
            safe_divide(
                total_amount_of_sleep_count,
                total_recorded_sleep_count), 2
        ) as average_nightly_sleep_hours,
        round(
            safe_divide(
                total_amount_of_sleep_goal_count,
                total_recorded_sleep_count), 2
        ) as percent_met_nightly_sleep_goal,
    from sleep_counts

)

select * from results
