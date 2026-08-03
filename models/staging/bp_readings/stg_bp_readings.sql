select
    person_id,
    -- person_name will be in dim_person 
    person_name,
    bp_reading_date as day_date,
    time_of_day,
    systolic_reading,
    diastolic_reading,
    -- transform for the full bp reading string in stg
    bp_reading,
    -- computed in the fact table
    systolic_change_from_previous_day,
    diastolic_change_from_previous_day,
    -- transformed in staging
    bp_category,
    general_mood,
from {{ source('bp_readings', 'bp_readings_raw') }}