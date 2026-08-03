{% docs person_id %}
The unique primary key given to each person in the data set
{% enddocs %}

{% docs person_name %}
The full name of the person in the data set
{% enddocs %}

{% docs time_of_day %}
The time of day an activity was recorded - 'Morning', 'Afternoon', or 'Evening'
{% enddocs %}

{% docs systolic_reading %}
The systolic reading in a daily bp reading
{% enddocs %}

{% docs diastolic_reading %}
The diastolic reading in a daily bp reading
{% enddocs %}

{% docs bp_category %}
The bp category in which a daily bp reading falls, such as 'Normal', 'Elevated', 'Stage 1 Hypertension'
{% enddocs %}

{% docs bp_reading %}
The complete daily bp reading 'systolic reading' / 'diastolic reading' (e.g. '120 / 80')
{% enddocs %}

{% docs general_mood %}
The general mood of the person on the day the bp reading was recorded, conformed to 'Relaxed', 'Content', and 'Anxious'
{% enddocs %}

{% docs bp_reading_key %}
Surrogate key made up of the person_id and the day_date
{% enddocs %}
