select
    {{ dbt_utils.generate_surrogate_key(['person_id', 'year']) }}       as person_key,
    {{ dbt_utils.generate_surrogate_key(['date_day']) }}                as date_key,
    date_day,
    caffeine_drink_count,
    caffeine_drink_description,
    water_intake_oz,
    hydration_band,
from {{ ref('int_hydration_and_caffeine') }}