select
    {{ dbt_utils.generate_surrogate_key(['person_id', 'day_date']) }} as bp_reading_key,
    bp_readings.day_date,
    dim_date.month,
    dim_date.month_name,
    dim_date.year,
    bp_readings.time_of_day,
    bp_readings.bp_category,
    bp_readings.general_mood,
from {{ ref('stg_bp_readings') }} as bp_readings
left join {{ ref('dim_date') }} as dim_date
    on bp_readings.day_date = dim_date.date_day