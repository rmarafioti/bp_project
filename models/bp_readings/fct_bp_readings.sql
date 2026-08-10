select
    {{ dbt_utils.generate_surrogate_key(['person_id', 'date_day']) }}   as bp_reading_key,
    {{ dbt_utils.generate_surrogate_key(['person_id']) }}               as person_key,
    {{ dbt_utils.generate_surrogate_key(['date_day']) }}                as date_key,
    person_id,
    date_day,
    weight,
    systolic_reading,
    diastolic_reading,
    bp_reading,
    systolic_change_from_previous_day,
    diastolic_change_from_previous_day,
from {{ ref('int_bp_readings') }}
