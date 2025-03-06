# **Analysis of Interaction Trends and Correlation Between `nevents` and `ndays_act`**

## **1. Correlation Analysis**
- The correlation between `nevents` (interactions) and `ndays_act` (active days) is **0.835**, indicating a **strong positive relationship**.
- This suggests that users with more active days tend to have significantly more interactions with the platform.

### **SQL Query for Correlation Analysis**
```sql
SELECT 
    CORR(nevents, ndays_act) AS correlation_nevents_ndays
FROM `genuine-ether-359405.montu.online_courses`;
```

## **2. Time-Series Trends**
- **Year-over-year decline observed:** Both `ndays_act` and `nevents` have decreased over time.
- The **interactions per active day ratio has also dropped significantly**, indicating that users are not only engaging for fewer days but are also interacting less when active.

### **SQL Query for Time-Series Trends**
```sql
WITH time_series AS (
    SELECT 
        DATE_TRUNC(start_time_DI, MONTH) AS month_year,
        AVG(ndays_act) AS avg_active_days,
        AVG(nevents) AS avg_interactions
    FROM `genuine-ether-359405.montu.online_courses`
    GROUP BY month_year
)
SELECT 
    month_year, 
    avg_active_days, 
    avg_interactions,
    (avg_interactions / NULLIF(avg_active_days, 0)) AS avg_interactions_per_active_day
FROM time_series
ORDER BY month_year;
```
<img width="735" alt="Screenshot 2025-03-06 at 11 00 20 pm" src="https://github.com/user-attachments/assets/70abf664-7d4c-4f50-82fb-13751b0417a7" />

## **3. Key Insights**
- **Engagement is declining**, as both the number of active days and interactions per user have decreased over time.
- **Lower interactions per active day suggest reduced user engagement intensity**, which may indicate content fatigue, a shift in user interest, or platform-related issues.
- **Intervention strategies** such as personalized content recommendations, engagement incentives, or re-engagement campaigns should be explored to reverse this trend.
