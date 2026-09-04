with sleep_amount as (

    select
        person_id,
        date_day,
        year,
        bed_time,
        wake_up_time,
        mod(
            time_diff(
                wake_up_time, bed_time ,minute) + 1440,
            1440
        ) / 60.0 as amount_of_nightly_sleep_hours,
    from {{ ref('stg_daily_sleep') }}

),

results as (

    select
        person_id,
        date_day,
        year,
        bed_time,
        wake_up_time,
        amount_of_nightly_sleep_hours,
        case
            when amount_of_nightly_sleep_hours > 8 then 'Above Sleep Goal'
            when amount_of_nightly_sleep_hours >= 7 then 'Met Sleep Goal'
            when amount_of_nightly_sleep_hours >= 6 then 'Shortfall of Sleep Goal'
            when amount_of_nightly_sleep_hours < 6 then 'Poor Sleep'
        end as sleep_band,
        from sleep_amount

)

select * from results