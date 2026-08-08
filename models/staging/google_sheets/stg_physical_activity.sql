select
    person_id,
    activity_date               as day_date,
    time_of_day,
    person_weight               as weight,
    average_heart_rate,
    physical_activity_          as physical_activity,
    physical_activity_distance_ as physical_activity_distance,
    calories_burned,
    physical_activity_intensity,
from {{ source('google_sheets', 'physical_activity_raw') }}