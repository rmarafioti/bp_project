select
    person_id,
    Date                                                            as date_day,
    extract(month from Date)                                        as month,
    extract(year from Date)                                         as year,
    bp_time_of_day,
    general_mood,
    systolic_reading,
    diastolic_reading,
    concat(systolic_reading, ' / ', diastolic_reading)              as bp_reading,
    case 
        when systolic_reading > 180 or diastolic_reading > 120 then 'Hypertensive Crisis'
        when systolic_reading >= 140 or diastolic_reading >= 90 then 'Stage 2 Hypertension'
        when systolic_reading >= 130 or (diastolic_reading >= 80 and diastolic_reading < 90) then 'Stage 1 Hypertension'
        when systolic_reading < 120 and diastolic_reading >= 80 and diastolic_reading < 90 then 'Isolated Diastolic Hypertension'
        when systolic_reading >= 120 and systolic_reading < 130 and diastolic_reading < 80 then 'Elevated'
        when systolic_reading < 120 and diastolic_reading < 80 then 'Normal'
        else 'Check Reading'
    end                                                             as bp_category,
    caffeine_drink_count,
    caffeine_drink_description,
    safe_cast(regexp_extract(daily_water_intake, r'\d+') as int64)  as water_intake_oz,
    physical_activity_time_of_day,
    cast(daily_weight as float64)                                   as weight,
    avg_heart_rate                                                  as average_heart_rate,                                        
    physical_activity,
    physical_activity_distance,
    cast(physical_activity_duration as float64)                     as physical_activity_duration,
    calories_burned,
    case
        when avg_heart_rate >= 150 then 'Max Intensity'
        when avg_heart_rate >= 124 then 'Vigorous Intensity'
        when avg_heart_rate >= 88 then 'Moderate Intensity'
        else 'No Physical Intensity'
    end                                                             as physical_activity_intensity,
    bed_time,
    wake_up_time,
from {{ source('google_sheets', 'daily_data_raw') }}