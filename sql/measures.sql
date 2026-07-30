
-- Total Active subscribers

SELECT
	COUNT(user_id) AS total_subscribers
FROM subscriptions
WHERE status = 'Active';

-- Total churned users

SELECT
	COUNT(user_id) AS total_churned
FROM subscriptions
WHERE status = 'Churned';

-- Churned rate

WITH sub_churn AS (
    SELECT 
        (SELECT COUNT(user_id) FROM subscriptions WHERE status = 'Churned') AS total_churned,
        (SELECT COUNT(user_id) FROM subscriptions WHERE status = 'Active') AS total_subscribers
)
SELECT 
    total_churned,
    total_subscribers,
    ROUND(total_churned * 100.0 / NULLIF((total_subscribers + total_churned), 0), 2) AS churn_rate_percentage
FROM sub_churn;

-- MRR

SELECT SUM(plan_value) AS MRR
FROM subscriptions
WHERE status = 'Active' AND plan_type = 'Monthly';

-- ARR

SELECT SUM(plan_value) * 12 AS ARR
FROM subscriptions
WHERE status = 'Active' AND plan_type = 'Monthly';

-- ARPU

WITH arpu_cte AS (
    SELECT 
        (SELECT COUNT(user_id) FROM subscriptions WHERE status = 'Active') AS total_subscribers,
        (SELECT SUM(plan_value) FROM subscriptions WHERE status = 'Active' AND plan_type = 'Monthly') AS mrr
)
SELECT 
    ROUND(mrr / NULLIF((total_subscribers), 0), 2) AS ARPU
FROM arpu_cte;

-- LTV

WITH ltv_cte AS (
    SELECT 
        (SELECT SUM(plan_value) FROM subscriptions WHERE status = 'Active' AND plan_type = 'Monthly') AS mrr,
        (SELECT COUNT(user_id) FROM subscriptions WHERE status = 'Active') AS total_subscribers,
        (SELECT COUNT(user_id) FROM subscriptions WHERE status = 'Churned') AS total_churned
)
, Calculations AS (
    SELECT 
        ROUND(mrr / NULLIF(total_subscribers, 0), 2) AS arpu,
        (total_churned * 1.0) / NULLIF((total_subscribers + total_churned), 0) AS churn_rate
    FROM ltv_cte
)
SELECT 
    ROUND(arpu / NULLIF(churn_rate, 0), 2) AS LTV
FROM Calculations;

-- CAC

SELECT SUM(acquisition_cost) / NULLIF(COUNT(user_id), 0) AS CAC
FROM acquisition;

-- LTV:CAC

WITH ltv_cte AS (
    SELECT 
        (SELECT SUM(plan_value) FROM subscriptions WHERE status = 'Active' AND plan_type = 'Monthly') AS mrr,
        (SELECT COUNT(user_id) FROM subscriptions WHERE status = 'Active') AS total_subscribers,
        (SELECT COUNT(user_id) FROM subscriptions WHERE status = 'Churned') AS total_churned
), 
Calculations AS (
    SELECT 
        ROUND(mrr / NULLIF(total_subscribers, 0), 2) AS arpu,
        (total_churned * 1.0) / NULLIF((total_subscribers + total_churned), 0) AS churn_rate
    FROM ltv_cte
),
Final_LTV AS (
    SELECT ROUND(arpu / NULLIF(churn_rate, 0), 2) AS LTV
    FROM Calculations
),
Final_CAC AS (
    SELECT SUM(acquisition_cost) / NULLIF(COUNT(user_id), 0) AS CAC
    FROM acquisition
)
SELECT 
    l.LTV,
    c.CAC,
    ROUND(l.LTV / NULLIF(c.CAC, 0), 2) AS ltv_cac_ratio
FROM Final_LTV l, Final_CAC c;

-- Revenue lost to churn

SELECT 
    SUM(plan_value) AS revenue_lost_to_churn
FROM subscriptions
WHERE status = 'Churned';

-- completion and activation rate

WITH funnel_count AS (
SELECT
	COUNT(DISTINCT CASE WHEN step_name = 'Account Created' THEN user_id END) AS total_signed_up,
	COUNT(DISTINCT CASE WHEN step_name = 'Onboarding Complete' THEN user_id END) AS total_completed,
	COUNT(DISTINCT CASE WHEN step_name = 'Savings Setup' THEN user_id END) AS total_activated
FROM onboarding_events
)
SELECT
	total_signed_up,
	total_activated,
	total_completed,
	ROUND(
		(total_completed * 100.0) / NULLIF(total_signed_up, 0), 2) AS funnel_completion_rate,
	ROUND(
		(total_activated * 100.0) / NULLIF(total_signed_up, 0), 2) AS activation_rate
FROM funnel_count











