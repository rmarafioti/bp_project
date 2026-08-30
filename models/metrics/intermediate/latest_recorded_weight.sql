with latest_weight as (

    select
        person_id,
        date_day,
        year,
        weight,
    from {{ ref('stg_physical_activity') }}
    where 
        weight is not null
    qualify row_number() over (
        partition by
            person_id
        order by date_day desc
    ) = 1
)


select
    {{ dbt_utils.generate_surrogate_key(['person_id', 'year']) }}       as person_key,
    date_day,
    'Person Attributes'                 as metric_category,
    'Weight'                            as metric_subcategory,
    'Latest Recorded Weight'            as metric_name,
    cast(null as string)                as metric_period,
    cast(null as string)                as metric_reading,
    weight                              as metric_value,
    cast(null as string)                as metric_label,
    cast(null as int64)                 as has_met_goal
from latest_weight
