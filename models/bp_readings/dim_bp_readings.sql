select
    {{ dbt_utils.generate_surrogate_key(['person_id', 'bp_reading_date']) }} as bp_reading_key,
    bp_readings.bp_reading_date,
    dim_date.month_number,
    dim_date.month_name,
    dim_date.year_number,
    bp_readings.time_of_day,
    bp_readings.bp_category,
    bp_readings.general_mood,
from {{ ref('stg_bp_readings') }} as bp_readings
left join {{ ref('dim_date') }} as dim_date
    on bp_readings.bp_reading_date = dim_date.date_day