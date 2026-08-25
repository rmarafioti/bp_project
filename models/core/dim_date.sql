with date_spine as (

    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2026-01-01' as date)",
        end_date="cast('2030-01-01' as date)"
    ) }}

),

date_cleaned as (

    select
        cast(date_day as date)                              as date_day,
        extract(month from date_day)                        as month,
        format_date('%B', date_day)                         as month_name,
        extract(year from date_day)                         as year,
        cast(date_trunc(date_day, week(sunday)) as date)    as week_start_date,
        cast(date_add(date_trunc(date_day, week(sunday)), 
            interval 6 day) as date)                        as week_end_date,
    from date_spine

)

select
    {{ dbt_utils.generate_surrogate_key(['date_day']) }}        as date_key,
    {{ dbt_utils.generate_surrogate_key(['month', 'year']) }}   as month_key,
    date_day,
    month,
    month_name,
    year,
    week_start_date,
    week_end_date,
from date_cleaned
