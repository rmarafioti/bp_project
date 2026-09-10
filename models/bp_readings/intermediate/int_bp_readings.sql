with 
bp_readings as (

    select
        readings.person_id,
        readings.date_day,
        readings.month,
        readings.year,

        weight.weight,

        readings.time_of_day,
        readings.general_mood,
        readings.systolic_reading,
        readings.diastolic_reading,
        readings.bp_reading,
    -- these records are now archived
    from {{ ref('stg_bp_readings') }} as readings
    left join {{ ref('stg_physical_activity')}} as weight
        on readings.person_id = weight.person_id
        and readings.date_day = weight.date_day

    union all

    select
        person_id,
        date_day,
        month,
        year,
        weight,
        bp_time_of_day as time_of_day,
        general_mood,
        systolic_reading,
        diastolic_reading,
        bp_reading,
    -- these records are now live and ongoing data
    from {{ ref('stg_daily_data_raw') }}

),

previous_day_readings as (

    select
        person_id,
        date_day,
        lag(systolic_reading) over (order by date_day)  as previous_systolic_reading,
        lag(diastolic_reading) over (order by date_day) as previous_diastolic_reading,
    from bp_readings

),

results as (

    select
        bp_readings.person_id,
        bp_readings.date_day,
        bp_readings.month,
        bp_readings.year,
        bp_readings.time_of_day,
        bp_readings.general_mood,
        bp_readings.weight,
        bp_readings.systolic_reading,
        bp_readings.diastolic_reading,
        bp_readings.bp_reading,
        {{ bp_category('bp_readings.systolic_reading', 'bp_readings.diastolic_reading') }}  as bp_category,
        bp_readings.systolic_reading - previous_day_readings.previous_systolic_reading      as systolic_change_from_previous_day,
        bp_readings.diastolic_reading - previous_day_readings.previous_diastolic_reading    as diastolic_change_from_previous_day,
    from bp_readings
    left join previous_day_readings
        on bp_readings.person_id = previous_day_readings.person_id
        and bp_readings.date_day = previous_day_readings.date_day

)

select * from results


   
