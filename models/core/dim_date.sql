with date_spine as (

    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2026-01-01' as date)",
        end_date="cast('2030-01-01' as date)"
    ) }}

),

final as (

    select
        date_day,
        extract(month from date_day) as month_number,
        format_date('%B', date_day) as month_name,
        extract(year from date_day) as year_number,
    from date_spine

)

select * from final