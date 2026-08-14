select
    {{ dbt_utils.generate_surrogate_key(['person_id', 'date_day']) }}   as physical_activity_key,
    {{ dbt_utils.generate_surrogate_key(['person_id', 'year']) }}       as person_key,
    {{ dbt_utils.generate_surrogate_key(['date_day']) }}                as date_key,
    date_day,
    weight,
    average_heart_rate,
    physical_activity_distance,
    physical_activity_duration,
    calories_burned,
from {{ ref('stg_physical_activity') }}