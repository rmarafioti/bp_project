with monthly_bp_count as (
    
    select
        fct_readings.person_key,
        dim_date.month_name,
        dim_readings.bp_category,
        count(dim_readings.bp_category)         as monthly_category_count,

    from {{ ref('fct_bp_readings')}} fct_readings
    left join {{ ref('dim_bp_readings')}} as dim_readings
        on fct_readings.bp_reading_key = dim_readings.bp_reading_key
    left join {{ ref('dim_date') }} as dim_date
        on fct_readings.date_key = dim_date.date_key
    group by 1,2,3 

),

most_common_category as (

    select
        person_key,
        month_name,
        bp_category,
        monthly_category_count,
    from monthly_bp_count
    qualify row_number() over (
        partition by
            person_key,
            month_name
        order by monthly_category_count desc
    ) = 1

)


    select
        person_key,
        'BP Readings'                       as metric_category,
        'BP Category'                       as metric_subcategory,
        'Most Common Monthly Category'      as metric_name,
        month_name                          as metric_period,
        cast(null as string)                as metric_reading,
        monthly_category_count              as metric_value,
        bp_category                         as metric_label,
        if(bp_category = 'Normal', 1, 0)    as has_met_goal
    from most_common_category