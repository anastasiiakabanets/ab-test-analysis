WITH daily_dedup AS (
  SELECT *,
    ROW_NUMBER() OVER (PARTITION BY ad_id, date ORDER BY timestamp DESC) as rn
  FROM `workshop1-496316.workshop1.marketing_ads_raw`
)

SELECT
  DATE_TRUNC(date, MONTH) as campaign_month,
  source,
  ROUND(SUM(spend), 2) as total_spend,
  ROUND(SUM(spend) / NULLIF(SUM(registrations), 0), 2) as cac
FROM daily_dedup
WHERE rn = 1
GROUP BY 1, 2
ORDER BY campaign_month, source;