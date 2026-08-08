select
    {{ dbt_utils.generate_surrogate_key(['person_id', 'date_day']) }} as bp_reading_key,
    bp_readings.time_of_day,
    bp_readings.bp_category,
    bp_readings.general_mood,
from {{ ref('stg_bp_readings') }} as bp_readings
