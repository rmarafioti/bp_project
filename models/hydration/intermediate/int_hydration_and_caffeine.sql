with hydration as (

    select
        person_id,
        date_day,
        year,
        caffeine_drink_count,
        caffeine_drink_description,
        water_intake_oz,
        case
            when water_intake_oz > 87 then 'Above Hydration Goal'
            when water_intake_oz >= 86 then 'Met Hydration Goal'
            when water_intake_oz >= 75 then 'Shortfall of Hydration Goal'
            when water_intake_oz >= 65 then 'Moderate Shortfall of Hydration Goal'
            when water_intake_oz < 65 then 'Poor Daily Hydration'
        end as hydration_band
    from {{ ref('stg_daily_hydration') }}

)

select * from hydration
