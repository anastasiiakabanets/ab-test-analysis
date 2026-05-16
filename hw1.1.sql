WITH filtered_ads AS (
  SELECT *,
    ROW_NUMBER() OVER (PARTITION BY ad_id, date ORDER BY timestamp DESC) as rn
  FROM `workshop1-496316.workshop1.marketing_ads_raw`

)

SELECT 
  source,
  ROUND(SUM(spend), 2) as total_spend,
  ROUND(SUM(spend) / NULLIF(SUM(impressions), 0) * 1000, 2) as cpm,
  ROUND(SUM(clicks) / NULLIF(SUM(impressions), 0) * 100, 2) as ctr,
  ROUND(SUM(installs) / NULLIF(SUM(clicks), 0) * 100, 2) as click_to_install,
  ROUND(SUM(registrations) / NULLIF(SUM(installs), 0) * 100, 2) as install_to_reg,
  ROUND(SUM(spend) / NULLIF(SUM(registrations), 0), 2) as cac,
  
  CASE 
    WHEN source = 'tiktok' THEN 8.50
    WHEN source = 'meta' THEN 6.20
    WHEN source = 'google' THEN 12.40
  END as ltv,
  
  ROUND(
    CASE 
      WHEN source = 'tiktok' THEN 8.50
      WHEN source = 'meta' THEN 6.20
      WHEN source = 'google' THEN 12.40
    END / NULLIF(SUM(spend) / NULLIF(SUM(registrations), 0), 0), 2
  ) as ltv_cac

FROM filtered_ads
WHERE rn = 1
GROUP BY 1;