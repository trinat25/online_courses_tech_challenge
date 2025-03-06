/*
Ensuring Data Quality Before Deriving Insights
Before drawing actionable insights, it is crucial to assess data quality to avoid biases or misleading recommendations. The key checks include:
1.Completeness Check:
- Assess the percentage of missing (NULL) values in each column.
- Determine if missing values are significant enough to impact analysis.
2.Logical Consistency Check:
Ensure data integrity by verifying logical constraints, such as:
- YoB (Year of Birth): It should be a reasonable value and not exceed start_time_DI.
3.Impact of Missing Data:
- Evaluate whether incomplete data skews insights or introduces bias.
- If data is missing at random, it may not affect conclusions significantly, but systematic gaps could distort findings.
4.Handling Missing Data:
- Determine the most appropriate treatment method based on context:
- Use mean/median for numerical values if appropriate.
- Replace categorical gaps with "Unknown" or mode if necessary.
- Retain missing values if analysis does not require them. 
*/

-- Data Quality Check: Assessing Null Values in the online_courses Table
WITH null_checks AS (
    SELECT 'registered' AS column_name, COUNT(*) AS total_rows, 
           SUM(CASE WHEN registered IS NULL THEN 1 ELSE 0 END) AS null_count FROM `genuine-ether-359405.montu.online_courses`
    UNION ALL
    SELECT 'viewed', COUNT(*), SUM(CASE WHEN viewed IS NULL THEN 1 ELSE 0 END) FROM `genuine-ether-359405.montu.online_courses`
    UNION ALL
    SELECT 'explored', COUNT(*), SUM(CASE WHEN explored IS NULL THEN 1 ELSE 0 END) FROM `genuine-ether-359405.montu.online_courses`
    UNION ALL
    SELECT 'certified', COUNT(*), SUM(CASE WHEN certified IS NULL THEN 1 ELSE 0 END) FROM `genuine-ether-359405.montu.online_courses`
    UNION ALL
    SELECT 'final_cc_cname_DI', COUNT(*), SUM(CASE WHEN final_cc_cname_DI IS NULL THEN 1 ELSE 0 END) FROM `genuine-ether-359405.montu.online_courses`
    UNION ALL
    SELECT 'LoE_DI', COUNT(*), SUM(CASE WHEN LoE_DI IS NULL THEN 1 ELSE 0 END) FROM `genuine-ether-359405.montu.online_courses`
    UNION ALL
    SELECT 'YoB', COUNT(*), SUM(CASE WHEN YoB IS NULL THEN 1 ELSE 0 END) FROM `genuine-ether-359405.montu.online_courses`
    UNION ALL
    SELECT 'gender', COUNT(*), SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) FROM `genuine-ether-359405.montu.online_courses`
    UNION ALL
    SELECT 'grade', COUNT(*), SUM(CASE WHEN grade IS NULL THEN 1 ELSE 0 END) FROM `genuine-ether-359405.montu.online_courses`
    UNION ALL
    SELECT 'start_time_DI', COUNT(*), SUM(CASE WHEN start_time_DI IS NULL THEN 1 ELSE 0 END) FROM `genuine-ether-359405.montu.online_courses`
    UNION ALL
    SELECT 'last_event_DI', COUNT(*), SUM(CASE WHEN last_event_DI IS NULL THEN 1 ELSE 0 END) FROM `genuine-ether-359405.montu.online_courses`
    UNION ALL
    SELECT 'nevents', COUNT(*), SUM(CASE WHEN nevents IS NULL THEN 1 ELSE 0 END) FROM `genuine-ether-359405.montu.online_courses`
    UNION ALL
    SELECT 'ndays_act', COUNT(*), SUM(CASE WHEN ndays_act IS NULL THEN 1 ELSE 0 END) FROM `genuine-ether-359405.montu.online_courses`
    UNION ALL
    SELECT 'nchapters', COUNT(*), SUM(CASE WHEN nchapters IS NULL THEN 1 ELSE 0 END) FROM `genuine-ether-359405.montu.online_courses`
    UNION ALL
    SELECT 'nforum_posts', COUNT(*), SUM(CASE WHEN nforum_posts IS NULL THEN 1 ELSE 0 END) FROM `genuine-ether-359405.montu.online_courses`
    UNION ALL
    SELECT 'roles', COUNT(*), SUM(CASE WHEN roles IS NULL THEN 1 ELSE 0 END) FROM `genuine-ether-359405.montu.online_courses`
    UNION ALL
    SELECT 'incomplete_flag', COUNT(*), SUM(CASE WHEN incomplete_flag IS NULL THEN 1 ELSE 0 END) FROM `genuine-ether-359405.montu.online_courses`
)
SELECT 
    column_name,
    total_rows,
    null_count,
    ROUND((null_count / total_rows) * 100, 2) AS percent_nulls
FROM null_checks
ORDER BY percent_nulls DESC;


