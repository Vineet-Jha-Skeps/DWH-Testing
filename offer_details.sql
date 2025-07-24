SELECT *
FROM data_warehouse.v69__offer_details;


-- Check 1
SELECT *
FROM data_warehouse.v69__offer_details
WHERE application_id IS NULL;

-- Check 2
SELECT *
FROM data_warehouse.v69__offer_details
WHERE offer_id IS NULL;

-- Check 3
SELECT *
FROM data_warehouse.v69__offer_details
WHERE parent_offer_id IS NOT NULL 
AND parent_offer_id NOT IN (
SELECT offer_id
FROM data_warehouse.v69__offer_details
);

-- Check 4
SELECT *
FROM data_warehouse.v69__offer_details
WHERE CASE WHEN parent_offer_id IS NULL THEN is_incentivized = 1 ELSE is_incentivized = 0 END;

-- Check 5
SELECT *
FROM data_warehouse.v69__offer_details
WHERE term = 0 OR term IS NULL;
-- ROUND(term, 0) NOT IN (12, 18, 24, 36, 48, 60, 72, 84, 96, 108, 120);

-- Check 6
SELECT *
FROM data_warehouse.v69__offer_details
WHERE apr < 0;

-- Check 7
SELECT *
FROM data_warehouse.v69__offer_details
WHERE first_payment != 0;

-- Check 8
SELECT *
FROM data_warehouse.v69__offer_details
WHERE shown != 1;

-- Check 9
SELECT *
FROM data_warehouse.v69__offer_details
WHERE payment_amount < 0;

-- Check 10
SELECT *
FROM data_warehouse.v69__offer_details
WHERE mdr < 0;

-- Check 11
SELECT *
FROM data_warehouse.v69__offer_details
WHERE min_amount < 0;

-- Check 12
SELECT *
FROM data_warehouse.v69__offer_details
WHERE max_amount < 0;

-- Check 13
SELECT *
FROM data_warehouse.v69__offer_details
WHERE CASE WHEN parent_offer_id IS NULL THEN is_autopay_required = 1 ELSE is_autopay_required = 0 END;

