select
    {{ dbt_utils.generate_surrogate_key(['person_id', 'year']) }}       as person_key,
    {{ dbt_utils.generate_surrogate_key(['date_day']) }}                as date_key,
    date_day,
    bed_time,
    wake_up_time,
    amount_of_nightly_sleep_hours,
    sleep_band,
from {{ ref('int_daily_sleep') }}