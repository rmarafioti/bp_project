select
    {{ dbt_utils.generate_surrogate_key(['person_id', 'year']) }}       as person_key,
    {{ dbt_utils.generate_surrogate_key(['month', 'year']) }}           as month_key,
    person_id,
    month,
    year,
    average_daily_caffeine_intake,
    percent_met_water_intake_goal,
from {{ ref('int_monthly_hydration_and_caffeine') }}