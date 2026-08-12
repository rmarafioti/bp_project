select
    person_id,
    person_first_name,
    person_last_name,
    person_display_name,
    date_of_birth,
    gender,
    height,
from {{ source('google_sheets', 'person_information_raw')}}