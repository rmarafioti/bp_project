{% docs average_heart_rate %}
The person's recorded average heart rate during a physical activity measured in beats per minute
{% enddocs %}

{% docs bp_category %}
The bp category in which a daily bp reading falls, such as 'Normal', 'Elevated', 'Stage 1 Hypertension'
{% enddocs %}

{% docs bp_reading %}
The complete daily bp reading 'systolic reading' / 'diastolic reading' (e.g. '120 / 80')
{% enddocs %}

{% docs bp_reading_key %}
Surrogate key made up of the person_id and the day_date
{% enddocs %}

{% docs diastolic_change_from_previous_day %}
The numerical change between the daily diastolic reading and the previous day's diastolic reading
{% enddocs %}

{% docs diastolic_reading %}
The diastolic reading in a daily bp reading
{% enddocs %}

{% docs general_mood %}
The general mood of the person on the day the bp reading was recorded, conformed to 'Relaxed', 'Content', and 'Anxious'
{% enddocs %}

{% docs person_id %}
The unique primary key given to each person in the data set
{% enddocs %}

{% docs person_name %}
The full name of the person in the data set
{% enddocs %}

{% docs physical_activity %}
The person's description of the recorded physical activity Ex. 'Walking', 'Running', 'Rowing'
{% enddocs %}

{% docs physical_activity_distance %}
The distance of the person's recorded physical activity in miles, where distance applies or can be null
{% enddocs %}

{% docs physical_activity_duration %}
The amount of time of the person's recorded physical activity in hours
{% enddocs %}

{% docs physical_activity_intensity %}
The intensity of the recorded daily physical activity. Either Moderate, Vigorous or Max Intensity
{% enddocs %}

{% docs physical_activity_key %}
Surrogate key made up of the person_id and the day_date
{% enddocs %}

{% docs systolic_change_from_previous_day %}
The numerical change between the daily systolic reading and the previous day's systolic reading
{% enddocs %}

{% docs systolic_reading %}
The systolic reading in a daily bp reading
{% enddocs %}

{% docs time_of_day %}
The time of day an activity was recorded - 'Morning', 'Afternoon', or 'Evening'
{% enddocs %}

{% docs weight %}
The person's recorded daily weight, usually taken the first thing in the morning before eating
{% enddocs %}
