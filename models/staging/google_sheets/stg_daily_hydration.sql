select
    person_id,
    activity_date                           as date_day,
    extract(month from activity_date)       as month,
    extract(year from activity_date)        as year,
    caffien_drink_count                     as caffeine_drink_count,
    caffiene_description                    as caffeine_drink_description,
    safe_cast(regexp_extract(daily_water_intake, r'\d+') as int64) as water_intake_oz
from {{ source('google_sheets', 'daily_hydration_raw') }}