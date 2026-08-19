with bp_category_counts as (
    
    select
        person_id,
        month,
        year,
        bp_category,
        count(bp_category)         as bp_category_count,

    from {{ ref('stg_bp_readings')}}
    group by 1,2,3,4 

),

most_common_category as (

    select
        person_id,
        month,
        year,
        bp_category,
        bp_category_count,
    from bp_category_counts
    qualify row_number() over (
        partition by
            person_id,
            month,
            year
        order by bp_category_count desc
    ) = 1

),

bp_readings as (
    
    select
        person_id,
        month,
        year,
        count(*)                                        as bp_reading_count,
        count(weight)                                   as weight_count,
        sum(weight)                                     as total_weight,
        sum(systolic_reading)                           as total_systolic_readings,
        sum(diastolic_reading)                          as total_diastolic_readings,
        sum(abs(systolic_change_from_previous_day))     as total_systolic_absolute_change_from_previous_day,
        sum(abs(diastolic_change_from_previous_day))    as total_diastolic_absolute_change_from_previous_day,
    from {{ ref('int_bp_readings') }}
    group by 1,2,3

)

select
    reading_calcs.person_id,
    reading_calcs.month,
    reading_calcs.year,
    reading_calcs.bp_reading_count,
    reading_calcs.weight_count,
    reading_calcs.total_weight,
    reading_calcs.total_systolic_readings,
    reading_calcs.total_diastolic_readings,
    reading_calcs.total_systolic_absolute_change_from_previous_day,
    reading_calcs.total_diastolic_absolute_change_from_previous_day,

    category_calcs.bp_category          as most_common_monthly_bp_category,
    category_calcs.bp_category_count    as most_common_monthly_bp_category_count, 
from bp_readings as reading_calcs
left join most_common_category as category_calcs
    on reading_calcs.person_id = category_calcs.person_id
    and reading_calcs.month = category_calcs.month
    and reading_calcs.year = category_calcs.year
