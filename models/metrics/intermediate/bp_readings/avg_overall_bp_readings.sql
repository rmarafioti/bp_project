with bp_readings as (
    
    select
        person_key,
        count(*)                as total_bp_readings,
        sum(systolic_reading)   as total_systolic_readings,
        sum(diastolic_reading)  as total_diastolic_readings,
    from {{ ref('fct_bp_readings')}}
    group by 1

),

avg_readings as (
    select
        person_key,
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

metric_avg_systolic_reading as (

    select
        person_key,
        'BP Readings'               as metric_category,
        'Systolic'                  as metric_subcategory,
        'Average Overall Reading'   as metric_name,
        cast(null as string)        as metric_period,
        cast(null as string)        as metric_reading,
        average_systolic_reading    as metric_value,
        cast(null as string)        as metric_label,
        if(average_systolic_reading <= 119, 1, 0) as has_met_goal
    from avg_readings
         
),

metric_avg_diastolic_reading as (

    select
        person_key,
        'BP Readings'               as metric_category,
        'Diastolic'                 as metric_subcategory,
        'Average Overall Reading'   as metric_name,
        cast(null as string)        as metric_period,
        cast(null as string)        as metric_reading,
        average_diastolic_reading   as metric_value,
        cast(null as string)        as metric_label,
        if(average_diastolic_reading <= 79, 1, 0) as has_met_goal
    from avg_readings
         
),

metric_avg_overall_reading as (

    select
        person_key,
        'BP Readings'               as metric_category,
        'Complete Reading'          as metric_subcategory,
        'Average Overall Reading'   as metric_name,
        cast(null as string)        as metric_period,
        bp_reading                  as metric_reading,
        cast(null as float64)       as metric_value,
        bp_category                 as metric_label,
        if(bp_category = 'Normal', 1, 0) as has_met_goal
    from full_reading
         
)

select * from metric_avg_systolic_reading

union all

select * from metric_avg_diastolic_reading

union all

select * from metric_avg_overall_reading