with reading_averages as (

    select
        person_id,
        month,
        year,
        time_of_day,
        round(safe_divide(sum(systolic_reading), count(*)), 1)  as avg_systolic_reading,
        round(safe_divide(sum(diastolic_reading), count(*)), 1) as avg_diastolic_reading,
    from {{ ref('stg_bp_readings') }}
    group by 1, 2, 3, 4

),

categories as (

    select
        person_id,
        month,
        year,
        time_of_day,
        avg_systolic_reading,
        avg_diastolic_reading,
        {{ bp_category('avg_systolic_reading', 'avg_diastolic_reading') }} as bp_category,
    from reading_averages

),

results as (

    select
        person_id,
        month,
        year,
        time_of_day,
        max(case 
                when time_of_day = 'Morning' 
                then avg_systolic_reading end)    as avg_monthly_morning_systolic_reading,
        max(case 
                when time_of_day = 'Morning' 
                then avg_diastolic_reading end)    as avg_monthly_morning_diastolic_reading,
        max(case 
                when time_of_day = 'Morning' 
                then concat(avg_systolic_reading, ' / ', avg_diastolic_reading) end)    as avg_monthly_morning_reading,
        max(case 
                when time_of_day = 'Morning' 
                then bp_category end)                                                   as monthly_morning_bp_category,
        max(case 
                when time_of_day = 'Afternoon' 
                then avg_systolic_reading end)                                          as avg_monthly_afternoon_systolic_reading,
        max(case 
                when time_of_day = 'Afternoon' 
                then avg_diastolic_reading end)                                         as avg_monthly_afternoon_diastolic_reading,
        max(case 
                when time_of_day = 'Afternoon' 
                then concat(avg_systolic_reading, ' / ', avg_diastolic_reading) end)    as avg_monthly_afternoon_reading,
        max(case 
                when time_of_day = 'Afternoon' 
                then bp_category end)                                                   as monthly_afternoon_bp_category,
        max(case 
                when time_of_day = 'Evening' 
                then avg_systolic_reading end)                                          as avg_monthly_evening_systolic_reading,
        max(case 
                when time_of_day = 'Evening' 
                then avg_diastolic_reading end)                                         as avg_monthly_evening_diastolic_reading,
        max(case 
                when time_of_day = 'Evening' 
                then concat(avg_systolic_reading, ' / ', avg_diastolic_reading) end)    as avg_monthly_evening_reading,
        max(case 
                when time_of_day = 'Evening' 
                then bp_category end)                                                   as monthly_evening_bp_category,
    from categories
    group by 1, 2, 3, 4

)

select * from results