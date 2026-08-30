select
    {{ dbt_utils.generate_surrogate_key(['monthly_bp.person_id', 'monthly_bp.year']) }}       as person_key,
    {{ dbt_utils.generate_surrogate_key(['monthly_bp.month', 'monthly_bp.year']) }}           as month_key,
    monthly_bp.person_id,
    monthly_bp.month,
    monthly_bp.year,
    monthly_bp.bp_reading_count,
    monthly_bp.weight_count,
    monthly_bp.total_weight,
    monthly_bp.lastest_monthly_recorded_weight,
    monthly_bp.total_systolic_readings,
    monthly_bp.total_diastolic_readings,
    monthly_bp.total_systolic_absolute_change_from_previous_day,
    monthly_bp.total_diastolic_absolute_change_from_previous_day,
    monthly_bp.normal_bp_category_count,
    monthly_bp.most_common_monthly_bp_category,
    monthly_bp.most_common_monthly_bp_category_count,

    monthly_tod.time_of_day,
    monthly_tod.avg_monthly_morning_systolic_reading,
    monthly_tod.avg_monthly_morning_diastolic_reading,
    monthly_tod.avg_monthly_morning_reading,
    monthly_tod.monthly_morning_bp_category,

    monthly_tod.avg_monthly_afternoon_systolic_reading,
    monthly_tod.avg_monthly_afternoon_diastolic_reading,
    monthly_tod.avg_monthly_afternoon_reading,
    monthly_tod.monthly_afternoon_bp_category,

    monthly_tod.avg_monthly_evening_systolic_reading,
    monthly_tod.avg_monthly_evening_diastolic_reading,
    monthly_tod.avg_monthly_evening_reading,
    monthly_tod.monthly_evening_bp_category,

from {{ ref('int_monthly_bp_readings') }} as monthly_bp
    left join {{ ref('int_monthly_bp_readings_tod') }} as monthly_tod
        on monthly_bp.person_id = monthly_tod.person_id
        and monthly_bp.month = monthly_tod.month
        and monthly_bp.year = monthly_tod.year
