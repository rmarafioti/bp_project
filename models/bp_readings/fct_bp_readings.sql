select
    {{ dbt_utils.generate_surrogate_key(['person_id', 'year']) }}       as person_key,
    {{ dbt_utils.generate_surrogate_key(['date_day']) }}                as date_key,
    date_day,
    time_of_day,
    general_mood,
    weight,
    systolic_reading,
    diastolic_reading,
    bp_reading,
    bp_category,
    systolic_change_from_previous_day,
    diastolic_change_from_previous_day,
from {{ ref('int_bp_readings') }}
