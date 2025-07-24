SELECT *
FROM data_warehouse.v69__loan_details
WHERE application_id = '01JH7Q5NY53EF29Z4SVZZ0SGYW';


-- Check 1
SELECT *
FROM data_warehouse.v69__loan_details AS ld
LEFT JOIN data_warehouse.v69__application_approval_to_funding AS atf
ON ld.application_id = atf.application_id
WHERE (ld.application_id IS NULL)
OR atf.total_funded_amt <= 0;


-- Check 2
SELECT *
FROM data_warehouse.v69__loan_details
WHERE loan_id IS NULL;

-- Check 3
SELECT *
FROM data_warehouse.v69__loan_details
WHERE lms_customer_id IS NULL;

-- Check 4
SELECT *
FROM data_warehouse.v69__loan_details
WHERE amount <= 0 OR amount IS NULL;

-- Check 5
SELECT ld.*, od.*
FROM data_warehouse.v69__loan_details AS ld
LEFT JOIN data_warehouse.v69__application_approval_to_funding AS atf
ON ld.application_id = atf.application_id
LEFT JOIN data_warehouse.offer_details AS od
ON atf.selected_offer_id = od.offer_id
WHERE ld.apr < 0
OR ld.apr != od.apr;

-- Check 6
SELECT ld.*, od.*
FROM data_warehouse.v69__loan_details AS ld
LEFT JOIN data_warehouse.v69__application_approval_to_funding AS atf
ON ld.application_id = atf.application_id
LEFT JOIN data_warehouse.offer_details AS od
ON atf.selected_offer_id = od.offer_id
WHERE 
-- ld.term_value NOT IN (12, 18, 24, 36, 48, 60, 72)
-- OR 
ld.term_value != od.term;

-- Check 7
SELECT *
FROM data_warehouse.v69__loan_details
WHERE interest_begin_date IS NULL;

-- Check 8
SELECT ld.*, od.*
FROM data_warehouse.v69__loan_details AS ld
LEFT JOIN data_warehouse.v69__application_approval_to_funding AS atf
ON ld.application_id = atf.application_id
LEFT JOIN data_warehouse.offer_details AS od
ON atf.selected_offer_id = od.offer_id
WHERE (is_autopay_set <> 0 OR is_autopay_set <> 1)
OR is_autopay_set != is_autopay_required;

-- Check 9
SELECT *
FROM data_warehouse.v69__loan_details
WHERE effective_at IS NULL;