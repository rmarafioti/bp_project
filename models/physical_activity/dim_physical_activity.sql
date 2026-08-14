select
    {{ dbt_utils.generate_surrogate_key(['person_id', 'date_day']) }} as physical_activity_key,
    time_of_day,
    physical_activity,
    physical_activity_intensity,
from {{ ref('stg_physical_activity') }}