select
    person_id,
    person_first_name,
    person_last_name,
    person_display_name,
    date_of_birth,
    extract(year from current_date('America/Chicago')) - extract(year from date_of_birth)   as age,
    gender,
    height,
from {{ source('google_sheets', 'person_information_raw')}}