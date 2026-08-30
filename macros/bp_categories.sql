{% macro bp_category(systolic_col, diastolic_col) %}
    case
        when {{ systolic_col }} > 180 or {{ diastolic_col }} > 120 then 'Hypertensive Crisis'
        when {{ systolic_col }} >= 140 or {{ diastolic_col }} >= 90 then 'Stage 2 Hypertension'
        when {{ systolic_col }} >= 130 or ({{ diastolic_col }} >= 80 and {{ diastolic_col }} < 90) then 'Stage 1 Hypertension'
        when {{ systolic_col }} < 120 and {{ diastolic_col }} >= 80 and {{ diastolic_col }} < 90 then 'Isolated Diastolic Hypertension'
        when {{ systolic_col }} >= 120 and {{ systolic_col }} < 130 and {{ diastolic_col }} < 80 then 'Elevated'
        when {{ systolic_col }} < 120 and {{ diastolic_col }} < 80 then 'Normal'
        else 'Check Reading'
    end
{% endmacro %}