select
    {{ dbt_utils.generate_surrogate_key(['person_id', 'year']) }}       as person_key,
    {{ dbt_utils.generate_surrogate_key(['month', 'year']) }}           as month_key,
    person_id,
    month,
    year,
    average_nightly_sleep_hours,
    percent_met_nightly_sleep_goal,
from {{ ref('int_monthly_sleep') }}