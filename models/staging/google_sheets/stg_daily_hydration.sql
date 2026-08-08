select
    person_id,
    activity_date                   as day_date,
    has_caffiene_                   as has_caffiene,
    caffiene_description,
    has_reached_target_hydration,
    water_hydration_goal,
from {{ source('google_sheets', 'daily_hydration_raw')}}