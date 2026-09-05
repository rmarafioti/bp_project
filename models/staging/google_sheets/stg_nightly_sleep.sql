select
    person_id,
    sleep_date                              as date_day,
    extract(month from sleep_date)          as month,
    extract(year from sleep_date)           as year,
    parse_time('%I:%M:%S %p', bed_time)     as bed_time,
    parse_time('%I:%M:%S %p', wake_up_time) as wake_up_time,
from {{ source('google_sheets', 'daily_sleep_raw') }}