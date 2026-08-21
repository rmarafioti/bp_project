with bp_readings as (
    
    select
        fct_readings.person_key,
        fct_readings.time_of_day,
        count(fct_readings.date_day)            as total_bp_readings,
        sum(fct_readings.systolic_reading)      as total_systolic_readings,
        sum(fct_readings.diastolic_reading)     as total_diastolic_readings,

    from {{ ref('fct_bp_readings')}} as fct_readings
    group by 1,2

),

avg_readings as (
    select
        person_key,
        time_of_day,
        round(
            safe_divide(
                total_systolic_readings,
                total_bp_readings), 1
        )                           as average_systolic_reading,
        round(
            safe_divide(
                total_diastolic_readings,
                total_bp_readings), 1
        )                           as average_diastolic_reading,
    from bp_readings

),

full_reading as (

    select
        person_key,
        time_of_day,
        concat(average_systolic_reading, ' / ', average_diastolic_reading) as bp_reading,
        case 
            when average_systolic_reading > 180 or average_diastolic_reading > 120 then 'Hypertensive Crisis'
            when average_systolic_reading >= 140 or average_diastolic_reading >= 90 then 'Stage 2 Hypertension'
            when average_systolic_reading >= 130 or (average_diastolic_reading >= 80 and average_diastolic_reading < 90) then 'Stage 1 Hypertension'
            when average_systolic_reading < 120 and average_diastolic_reading >= 80 and average_diastolic_reading < 90 then 'Isolated Diastolic Hypertension'
            when average_systolic_reading >= 120 and average_systolic_reading < 130 and average_diastolic_reading < 80 then 'Elevated'
            when average_systolic_reading < 120 and average_diastolic_reading < 80 then 'Normal'
        else 'Check Reading'
    end as bp_category,
    from avg_readings

),

metric_avg_morning_reading as (

    select
        person_key,
        'BP Readings'                       as metric_category,
        'Complete Reading'                  as metric_subcategory,
        'Average Overall Morning Reading'   as metric_name,
        cast(null as string)                as metric_period,
        bp_reading                          as metric_reading,
        cast(null as int64)                 as metric_value,
        bp_category                         as metric_label,
        if(bp_category = 'Normal', 1, 0)    as has_met_goal
    from full_reading
    where time_of_day = 'Morning'
),

metric_avg_afternoon_reading as (

    select
        person_key,
        'BP Readings'                       as metric_category,
        'Complete Reading'                  as metric_subcategory,
        'Average Overall Afternoon Reading'   as metric_name,
        cast(null as string)                as metric_period,
        bp_reading                          as metric_reading,
        cast(null as int64)                 as metric_value,
        bp_category                         as metric_label,
        if(bp_category = 'Normal', 1, 0)    as has_met_goal
    from full_reading
    where time_of_day = 'Afternoon'
),

metric_avg_evening_reading as (

    select
        person_key,
        'BP Readings'                       as metric_category,
        'Complete Reading'                  as metric_subcategory,
        'Average Overall Evening Reading'   as metric_name,
        cast(null as string)                as metric_period,
        bp_reading                          as metric_reading,
        cast(null as int64)                 as metric_value,
        bp_category                         as metric_label,
        if(bp_category = 'Normal', 1, 0)    as has_met_goal
    from full_reading
    where time_of_day = 'Evening'
)

select * from metric_avg_morning_reading

union all

select * from metric_avg_afternoon_reading

union all

select * from metric_avg_evening_reading