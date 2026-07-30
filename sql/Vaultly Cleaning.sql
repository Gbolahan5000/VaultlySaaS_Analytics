
-- Data cleaning priority

-- confirm step names in onboarding events

SELECT 
	DISTINCT step_name
FROM onboarding_events;
		
-- standardizing step names 

UPDATE onboarding_events
SET step_name = CASE 
    WHEN step_name LIKE '%bank%' OR step_name LIKE '%connect%' THEN 'Bank Account Connect'
    WHEN step_name LIKE '%onboarding%' THEN 'Onboarding Complete'
    WHEN step_name LIKE '%saving%' THEN 'Savings Setup'
    WHEN step_name LIKE '%budget%' THEN 'Budget Setup'
    ELSE TRIM(step_name) -- Cleans up any accidental trailing/leading spaces
END;

-- confirm step names in onboarding events

SELECT 
	DISTINCT channel
FROM acquisition;

-- standardizing channel in acquisition

UPDATE acquisition
SET channel = CASE 
    WHEN channel LIKE '%organic%' THEN 'Organic Search'
    WHEN channel LIKE '%paid%' THEN 'Paid Social'
    ELSE TRIM(channel) 
END;

-- change null cost to 0

UPDATE acquisition
SET acquisition_cost = CASE 
    WHEN acquisition_cost IS NULL THEN '0'
    ELSE acquisition_cost 
END;

-- remove exact row duplicates in invoices

WITH CTE_InvoiceDuplicates AS (
    SELECT invoice_id, user_id, subscription_id, invoice_date, amount, payment_status, invoice_number,
           ROW_NUMBER() OVER (
               PARTITION BY invoice_id, user_id, subscription_id, invoice_date, amount, payment_status, invoice_number 
               ORDER BY invoice_id
           ) as row_num
    FROM invoices
)
DELETE FROM CTE_InvoiceDuplicates 
WHERE row_num > 1;

-- Convert Timestamps to West Africa Time (WAT)
-- Shifting onboarding events timestamp

SELECT TOP 5
	*
FROM product_events;

-- 1. Shifting Onboarding Events
UPDATE oe
SET oe.event_timestamp = CASE 
    WHEN u.country = 'United Kingdom' THEN DATEADD(hour, 1, oe.event_timestamp)
    WHEN u.country = 'Canada' THEN DATEADD(hour, 6, oe.event_timestamp)
    ELSE oe.event_timestamp 
END
FROM onboarding_events oe
INNER JOIN users u ON oe.user_id = u.user_id;

-- 2. Shifting Product Events
UPDATE pe
SET pe.event_timestamp = CASE 
    WHEN u.country = 'United Kingdom' THEN DATEADD(hour, 1, pe.event_timestamp)
    WHEN u.country = 'Canada' THEN DATEADD(hour, 6, pe.event_timestamp)
    ELSE pe.event_timestamp 
END
FROM product_events pe
INNER JOIN users u ON pe.user_id = u.user_id;

-- I ran into problems bulk inserting onboarding_event, i changed completed column to NVARCHAR, now to change back
-- Standardize anything that looks like numbers with decimals

UPDATE onboarding_events
SET completed = CASE 
    WHEN completed LIKE '%1%' THEN '1'
    ELSE '0' -- this also handles the null values
END;

-- Convert the column type back to BIT
ALTER TABLE onboarding_events 
ALTER COLUMN completed BIT;

-- Fix inconsistent formatting in user columns

SELECT 
	DISTINCT plan_type
FROM users;
		
-- standardizing step names 

UPDATE users
SET age_group = CASE 
    WHEN age_group LIKE '%18/24%' OR age_group LIKE '%18 to 24%' THEN '18 - 24'
    WHEN age_group LIKE '%25/34%' OR age_group LIKE '%25 to 34%' THEN '25 - 34'
    WHEN age_group LIKE '%35/44%' OR age_group LIKE '%35 to 44%' THEN '35 - 44'
    ELSE '45+'
END;

-- standerdized gender column

UPDATE users
SET gender = CASE 
    WHEN gender LIKE 'MALE%' THEN 'Male'
    ELSE 'Female'
END;

-- standardize country

UPDATE users
SET country = CASE 
    WHEN country LIKE 'N%' THEN 'Nigeria'
    WHEN country LIKE 'C%' THEN 'Canada'
    WHEN country LIKE 'U%' OR country LIKE '%g%' THEN 'United Kingdom'
END;

-- fix NULL in plan type

UPDATE u
SET u.plan_type = CASE
    WHEN s.plan_value = 6.99 THEN 'Annual'
    WHEN s.plan_value = 9.99 THEN 'Monthly'
END
FROM users u
INNER JOIN subscriptions s ON u.user_id = s.user_id
WHERE u.plan_type IS NULL;

-- Fix inconsistent formatting in subscriptions columns

SELECT
    DISTINCT plan_value
FROM subscriptions;

UPDATE subscriptions
SET status = CASE 
    WHEN status LIKE 'act%' THEN 'Active'
    ELSE 'Churned'
END;

-- Fix inconsistent formatting in invoices columns

SELECT
    DISTINCT amount
FROM invoices;

UPDATE invoices
SET payment_status = CASE 
    WHEN payment_status LIKE 'pa%' OR payment_status LIKE 'su%' THEN 'Successful'
    ELSE 'Failed'
END;

-- amount NULL fix

UPDATE invoices
SET amount = 0 
    WHERE amount IS NULL;


-- Fix inconsistent formatting in product events columns

SELECT
    COUNT(*) 
FROM product_events
WHERE days_since_signup IS NULL;

UPDATE product_events
SET event_type = CASE 
    WHEN event_type LIKE '%budget%' THEN 'View Budget' 
    WHEN event_type LIKE '%dash%' THEN 'View Dashboard'
    WHEN event_type LIKE '%trans%' THEN 'Add Transaction'
    WHEN event_type LIKE '%data%' THEN 'Export Data'
    WHEN event_type LIKE '%goal%' THEN 'Update Goal'
    WHEN event_type LIKE '%saving%' THEN 'View Savings'
    WHEN event_type LIKE '%spending%' THEN 'View Spending Report'
    WHEN event_type LIKE '%alert%' THEN 'Set Alert'
    WHEN event_type LIKE '%ai%' THEN 'Ai Insight View'
END;



-- Check total cleaned rows

SELECT 'Onboarding Events' AS TableName, COUNT(*) FROM onboarding_events
UNION ALL
SELECT 'Acquisition', COUNT(*) FROM acquisition
UNION ALL
SELECT 'Invoices', COUNT(*) FROM invoices
UNION ALL
SELECT 'Users', COUNT(*) FROM users
UNION ALL
SELECT 'Product Events', COUNT(*) FROM product_events
UNION ALL
SELECT 'Subscriptions', COUNT(*) FROM subscriptions;

































