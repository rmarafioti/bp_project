select
    person_id,
    bp_reading_date as day_date,
    time_of_day,
    systolic_reading,
    diastolic_reading,
    concat(systolic_reading, ' / ', diastolic_reading) as bp_reading,
    -- computed in the fact table
    systolic_change_from_previous_day,
    diastolic_change_from_previous_day,
    case 
        when systolic_reading > 180 or diastolic_reading > 120 then 'Hypertensive Crisis'
        when systolic_reading >= 140 or diastolic_reading >= 90 then 'Stage 2 Hypertension'
        when systolic_reading >= 130 or diastolic_reading >= 80 and diastolic_reading < 90 then 'Stage 1 Hypertension'
        when systolic_reading < 120 and diastolic_reading >= 80 and diastolic_reading < 90 then 'Isolated Diastolic Hypertension'
        when systolic_reading >= 120 and systolic_reading < 130 and diastolic_reading < 80 then 'Elevated'
        when systolic_reading < 120 and diastolic_reading < 80 then 'Normal'
        else 'Check Reading'
    end as bp_category,
    general_mood,
from {{ source('google_sheets', 'bp_readings_raw') }}