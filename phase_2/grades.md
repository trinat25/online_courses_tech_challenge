# **Analysis of Grade Influencers and Course Completion Drivers**

## **1. Grade Segmentation and Engagement Analysis****

| Grade Range | Avg. Active Days (`ndays_act`) | Avg. Interactions (`nevents`) | Avg. Chapters (`nchapters`) |
|------------|------------------|-----------------|----------------|
| **null**  | 3.23  | 117.05  | 2.81  |
| **0-0.2**  | 3.77  | 182.24  | 2.81  |
| **0.2-0.4**  | 24.28  | 2831.37  | 10.02  |
| **0.4-0.6**  | 32.30  | 3752.55  | 13.77  |
| **0.6-0.8**  | 44.09  | 5028.18  | 17.60  |
| **0.8-1.0**  | 48.87  | 5316.10  | 16.41  |

### **SQL Query for Grade Segmentation and Engagement**
```sql
WITH grade_bins AS (
    SELECT *,
           CASE 
               WHEN SAFE_CAST(grade AS FLOAT64) BETWEEN 0 AND 0.2 THEN '0-0.2'
               WHEN SAFE_CAST(grade AS FLOAT64) BETWEEN 0.2 AND 0.4 THEN '0.2-0.4'
               WHEN SAFE_CAST(grade AS FLOAT64) BETWEEN 0.4 AND 0.6 THEN '0.4-0.6'
               WHEN SAFE_CAST(grade AS FLOAT64) BETWEEN 0.6 AND 0.8 THEN '0.6-0.8'
               WHEN SAFE_CAST(grade AS FLOAT64) BETWEEN 0.8 AND 1.0 THEN '0.8-1.0'
           END AS grade_range
    FROM `genuine-ether-359405.montu.online_courses`
)
SELECT 
    grade_range,
    AVG(cast(ndays_act as int)) AS avg_active_days,
    AVG(cast(nevents as int)) AS avg_interactions,
    AVG(cast(nchapters as int)) AS avg_chapters
FROM grade_bins
GROUP BY grade_range
ORDER BY grade_range;
```

## **2. Key Insights**
- **Higher grades correlate with higher engagement:** Users with `grades 0.8-1.0` had **48.87 active days, 5316 interactions, and 16.4 chapters completed**, while those in `0-0.2` had only **3.77 active days, 182 interactions, and 2.8 chapters**.
- **Steady increase in engagement as grades improve:** Users with better grades consistently show more activity, interactions, and content engagement.
- **Encouraging engagement through structured interventions** (e.g., gamification, personalized content) could help improve course outcomes.
