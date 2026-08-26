select
    person_id,
    activity_date                           as date_day,
    extract(month from activity_date)       as month,
    extract(year from activity_date)        as year,
    caffien_drink_count                     as caffeine_drink_count,
    caffiene_description                    as caffeine_drink_description,
    daily_water_intake,
from {{ source('google_sheets', 'daily_hydration_raw') }}