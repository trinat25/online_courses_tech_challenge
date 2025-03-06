# **User Engagement Analysis for Online Courses**

## **Overview of Engagement Metrics**
Engagement in online courses can be measured across key categories:

### **1. Course Interaction**
- `nevents` – Total platform interactions.
- `nchapters` – Chapters accessed.
- `nforum_posts` – Forum participation.

### **2. Progress & Completion**
- `viewed` – Course material viewed.
- `explored` – Engagement beyond requirements.
- `certified` – Course completion.
- `incomplete_flag` – Dropped-out status.

### **3. User Demographics**
- `LoE_DI` – Pre-existing education level.
- `YoB` – Learner's age.
- `gender` – Gender distribution.
- `final_cc_cname_DI` – Geographical location.

### **4. Activity Patterns**
- `start_time_DI` – Course start date.
- `last_event_DI` – Last recorded activity.
- `ndays_act` – Active days within the course.

### **5. Performance & Outcomes**
- `grade` – Course performance.
- `certification rate` – Completion percentage.
- `dropout rate` – Non-completion percentage.

## **Importance of Time-Series & Grouped Analysis**
To fully understand engagement, it is crucial to analyse these metrics over time and across different segments:
- **Time-Series Trends** – Tracking engagement patterns over time helps identify peak learning periods and drop-off points.
- **Group by Location (`final_cc_cname_DI`)** – Uncover regional engagement differences to tailor learning experiences.
- **Group by Education Level (`LoE_DI`)** – Assess how prior education impacts course interaction and completion.

## **Key Metric: `ndays_act`**
Correlation analysis suggests `ndays_act` (active days) is the strongest indicator of engagement, showing high correlation with:
- `nevents` (0.83) – More active days lead to more interactions.
- `nchapters` (0.69) – Higher engagement with course content.
- `grade` (0.74) – Better course performance.
- `certified` (0.68) – Higher completion rates.

## **SQL Queries**
### **1. Correlation Analysis**
```sql
SELECT
  CORR(ndays_act, CAST(nevents AS INTEGER)) AS corr_active_events,
  CORR(ndays_act, CAST(nchapters AS INTEGER)) AS corr_active_chapters,
  CORR(ndays_act, certified) AS corr_active_certified,
  CORR(ndays_act, SAFE_CAST(grade AS FLOAT64)) AS correlation_grade_active_days
FROM
  `genuine-ether-359405.montu.online_courses` ;
```

### **2. Engagement Trends Over Time**
```sql
WITH monthly_data AS (
    SELECT 
        DATE_TRUNC(start_time_DI, MONTH) AS month_year, -- Extracts month-year for time-series analysis
        AVG(ndays_act) AS avg_active_days, -- Calculates the average active days per month
        COUNT(*) AS user_count, -- Counts the number of users active in that month
        SUM(CASE WHEN ndays_act IS NULL THEN 1 ELSE 0 END) AS null_count, -- Counts null values for ndays_act
        APPROX_QUANTILES(ndays_act, 100)[OFFSET(50)] AS median_ndays_act -- Computes the median active days per month
    FROM `genuine-ether-359405.montu.online_courses`
    GROUP BY month_year
)
SELECT 
    month_year, 
    avg_active_days,
    median_ndays_act,
    user_count,
    (null_count / user_count) * 100 AS percent_nulls -- Calculates the percentage of nulls
FROM monthly_data
ORDER BY month_year;
```

### **3. Verify if Better Grades Users Have Higher `ndays_act`**
```sql
SELECT 
    CASE 
        WHEN SAFE_CAST(grade AS FLOAT64) >= 0.90 THEN '90-100'
        WHEN SAFE_CAST(grade AS FLOAT64) >= 0.80 THEN '80-89'
        WHEN SAFE_CAST(grade AS FLOAT64) >= 0.70 THEN '70-79'
        WHEN SAFE_CAST(grade AS FLOAT64) >= 0.60 THEN '60-69'
        WHEN SAFE_CAST(grade AS FLOAT64) >= 0.50 THEN '50-59'
        ELSE '<50'
    END AS grade_range,
    COUNT(*) AS user_count,
    AVG(ndays_act) AS avg_active_days
FROM `genuine-ether-359405.montu.online_courses`
WHERE SAFE_CAST(grade AS FLOAT64) IS NOT NULL AND ndays_act IS NOT NULL
GROUP BY grade_range
ORDER BY grade_range DESC;
```
