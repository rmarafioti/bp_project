with hydration_counts as (

    select
        person_id,
        month,
        year,
        count(*)                    as total_recorded_hydration_count,
        sum(caffeine_drink_count)   as total_caffeine_drink_count,
        sum(if(water_intake_oz >= 86, 1, 0))        as total_water_goal_intake_count,
    from {{ ref('stg_daily_hydration') }}
    group by 1,2,3
),

results as (

    select
        person_id,
        month,
        year,
        round(
            safe_divide(
                total_caffeine_drink_count,
                total_recorded_hydration_count), 2
        ) as average_daily_caffeine_intake,
        round(
            safe_divide(
                total_water_goal_intake_count,
                total_recorded_hydration_count), 2
        ) as percent_met_water_intake_goal,
    from hydration_counts      

)

select * from results

