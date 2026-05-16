SELECT 
  match AS group_id, 
  COUNT(DISTINCT id_user) AS total_users, 
  COUNT(DISTINCT CASE WHEN date_first_payment IS NOT NULL THEN id_user END) AS paying_users, 
  ROUND(COUNT(DISTINCT CASE WHEN date_first_payment IS NOT NULL THEN id_user END) / COUNT(DISTINCT id_user) * 100, 2) AS conversion_rate_pct 
FROM `homework3-496511.homework3.ab_test_task_data`
GROUP BY match;