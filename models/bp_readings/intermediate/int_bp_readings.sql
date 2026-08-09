with 
bp_readings as (

    select
        person_id,
        date_day,
        systolic_reading,
        diastolic_reading,
        bp_reading,
    from {{ ref('stg_bp_readings') }}

),

previous_day_readings as (

    select
        person_id,
        date_day,
        lag(systolic_reading) over (order by date_day)  as previous_systolic_reading,
        lag(diastolic_reading) over (order by date_day) as previous_diastolic_reading,
    from bp_readings

),

person_weight as (
    select
        person_id,
        date_day,
        weight,
    from {{ ref('stg_physical_activity')}}
),

results as (

    select
        bp_readings.person_id,
        bp_readings.date_day,
        bp_readings.systolic_reading,
        bp_readings.diastolic_reading,
        bp_readings.bp_reading,

        person_weight.weight,

        bp_readings.systolic_reading - previous_day_readings.previous_systolic_reading      as systolic_change_from_previous_day,
        bp_readings.diastolic_reading - previous_day_readings.previous_diastolic_reading    as diastolic_change_from_previous_day,
    from bp_readings
    left join previous_day_readings
        on bp_readings.person_id = previous_day_readings.person_id
        and bp_readings.date_day = previous_day_readings.date_day
    left join person_weight
        on bp_readings.person_id = person_weight.person_id
        and bp_readings.date_day = person_weight.date_day

)

select * from results


   
