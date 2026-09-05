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

{% docs cumulative_weekly_moderate_intensity %}
Weekly running sum of moderate intensity hours
{% enddocs %}

{% docs cumulative_weekly_vigorous_intensity %}
Weekly running sum of vigorous intensity hours
{% enddocs %}

{% docs date_key %}
Surrogate key made up of the day_date
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

{% docs has_met_monthly_moderate_hours %}
Binary flag, 1 if person has met monthly goal of 10 hours of moderate physical activity, else 0
{% enddocs %}

{% docs has_met_monthly_vigorous_hours %}
Binary flag, 1 if person has met monthly goal of 5 hours of vigorous physical activity, else 0
{% enddocs %}

{% docs has_met_weekly_moderate_hours %}
Binary flag, 1 if person has met weekly goal of 2.5 hours of moderate physical activity, else 0
{% enddocs %}

{% docs has_met_weekly_vigorous_hours %}
Binary flag, 1 if person has met weekly goal of 1.25 hours of vigorous physical activity, else 0
{% enddocs %}

{% docs month_key %}
Surrogate key made up of the month and the year
{% enddocs %}

{% docs percent_met_nightly_sleep_goal %}
The percent of nights a person has met the sleep goal of 7 hours of sleep or more
{% enddocs %}

{% docs person_id %}
The unique primary key given to each person in the data set
{% enddocs %}

{% docs person_key %}
Surrogate key made up of the person_id and the year
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

{% docs sleep_band %}
Thresholds measuring the amount of a person's nightly sleep. Less than 6 hours = 'Poor Sleep', 6 hours = 'Below Goal', 7 - 8 = 'Met Goal', above 8 hours = 'Above Goal'
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

{% docs total_moderate_intensity_hours %}
The total amount of recorded hours of physical activity at an average heart rate above 88 bpms and below 123 bpms
{% enddocs %}

{% docs total_vigorous_intensity_hours %}
The total amount of recorded hours of physical activity at an average heart rate above 123 bpms and below 145 bpms
{% enddocs %}
