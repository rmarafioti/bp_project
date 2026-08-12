with
    distinct_years as (

        select distinct
            year,
        from {{ ref('stg_bp_readings')}}

    ),

person_age as (

    select
        person.person_id,
        person.person_first_name,
        person.person_last_name,
        person.person_display_name,
        person.date_of_birth,
        date_diff(date(distinct_years.year, 12, 31), person.date_of_birth, year) as age,
        person.gender,
        person.height,

        distinct_years.year

    from {{ ref('stg_person_information')}} as person
    cross join distinct_years

)

select
    {{ dbt_utils.generate_surrogate_key(['person_id', 'year']) }} as person_key,
    person_id,
    person_first_name,
    person_last_name,
    person_display_name,
    date_of_birth,
    age,
    gender,
    height,
    year,
from person_age