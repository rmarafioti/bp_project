{% for metric_model in [
        "avg_bp_readings",
    ]
%}

    select

        dim_person.person_key,
        dim_person.person_id,
        dim_person.person_display_name,
        dim_person.date_of_birth,
        dim_person.age,
        dim_person.gender,
        dim_person.height,
        dim_person.year,

        metric.metric_category,
        metric.metric_subcategory,
        metric.metric_name,
        metric.metric_period,
        metric.metric_reading,
        metric.metric_value,
        metric.metric_label,
        metric.has_met_goal,

    from {{ ref(metric_model) }} as metric
    left join {{ ref('dim_person')}} as dim_person
        on metric.person_key = dim_person.person_key

    {% if not loop.last %}union all{% endif -%}

{% endfor %}