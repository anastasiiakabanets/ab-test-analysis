WITH user_metrics AS (
  SELECT 
    id_user,
    DATE(date_reg) AS reg_date,
    CASE WHEN date_first_payment IS NOT NULL THEN 1 ELSE 0 END AS is_payer
  FROM `homework3-496511.homework3.ab_test_task_historical_data`
),

daily_traffic AS (
  SELECT 
    reg_date,
    COUNT(DISTINCT id_user) AS new_users
  FROM user_metrics
  GROUP BY reg_date
)

SELECT 
  COUNT(DISTINCT id_user) AS total_historical_users,
  ROUND(AVG(is_payer) * 100, 2) AS baseline_conversion_rate_pct, 
  ROUND((SELECT AVG(new_users) FROM daily_traffic), 0) AS avg_daily_registrations 
FROM user_metrics;