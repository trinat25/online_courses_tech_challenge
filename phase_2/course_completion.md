## **1. Comparing Engagement Metrics**
Users who complete courses (`certified = 1`) are likely more engaged. I analyse:
- **`ndays_act` (Active Days)** – Do certified users stay active longer?
- **`nevents` (Interactions)** – Are certified users more interactive?
- **`nchapters` (Chapters Completed)** – Do certified users cover more material?
- **`nforum_posts` (Forum Participation)** – Do discussions play a role in completion?

### **SQL Query: Engagement Comparison**
```sql
SELECT 
    certified,
    COUNT(*) AS user_count,
    AVG(cast(ndays_act as int)) AS avg_active_days,
    AVG(cast(nevents as int)) AS avg_interactions,
    AVG(cast(nchapters as int)) AS avg_chapters,
    AVG(cast(nforum_posts as int)) AS avg_forum_posts
FROM `genuine-ether-359405.montu.online_courses`
GROUP BY certified;
```

## **2. Comparing User Demographics**
User attributes such as **education level, age, and location** may influence completion rates.
- **`LoE_DI` (Level of Education)** – Do users with higher education complete courses more?
- **`YoB` (Year of Birth)** – Are younger or older users more likely to complete courses?
- **`final_cc_cname_DI` (Country)** – Are there geographic patterns in completion?

### **SQL Query: Demographic Analysis**
```sql
SELECT 
    certified,
    LoE_DI,
    COUNT(*) AS user_count,
    AVG(ndays_act) AS avg_active_days,
    AVG(SAFE_CAST(grade AS FLOAT64)) AS avg_grade
FROM `genuine-ether-359405.montu.online_courses`
GROUP BY certified, LoE_DI
ORDER BY certified DESC, avg_grade DESC;
```

## **3. Identifying Dropout Patterns**
To understand **why users don’t complete courses**, we analyze:
- **`incomplete_flag`** – How many users drop out early?
- **`last_event_DI` - `start_time_DI` (Time in Course)** – Do non-certified users drop off early?

### **SQL Query: Dropout Patterns**
```sql
SELECT 
    certified,
    COUNT(*) AS user_count,
    AVG(DATE_DIFF(date(last_event_DI), date(start_time_DI), DAY)) AS avg_days_active
FROM `genuine-ether-359405.montu.online_courses`
GROUP BY certified;
```

## **4. Grade Comparison**
Are higher grades linked to course completion?

### **SQL Query: Grade Comparison**
```sql
SELECT 
    certified,
    AVG(SAFE_CAST(grade AS FLOAT64)) AS avg_grade
FROM `genuine-ether-359405.montu.online_courses`
GROUP BY certified;
```

## **5. Key Insights**
- **Certified users have significantly higher engagement**, including more active days, interactions, and content completion.
- **Users with higher education levels may have better completion rates.**
- **Non-certified users likely disengage early, suggesting the need for early intervention strategies.**
- **Grades are strongly linked to course completion**, reinforcing the connection between engagement and performance.
