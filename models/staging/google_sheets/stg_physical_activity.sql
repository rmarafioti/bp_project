select
    person_id,
    activity_date                                           as date_day,
    extract(year from activity_date)                        as year,
    time_of_day,
    person_weight                                           as weight,
    average_heart_rate,
    physical_activity_                                      as physical_activity,
    physical_activity_distance_                             as physical_activity_distance,
    physical_activity_duration,
    calories_burned,
    case
        when average_heart_rate >= 150 then 'Max Intensity'
        when average_heart_rate >= 124 then 'Vigorous Intensity'
        when average_heart_rate >= 88 then 'Moderate Intensity'
        else 'No Physical Intensity'
    end                                                     as physical_activity_intensity,
from {{ source('google_sheets', 'physical_activity_raw') }}