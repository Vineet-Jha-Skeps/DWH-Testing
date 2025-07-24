SELECT *
FROM data_warehouse.v69__transaction_details;

-- Check 1
SELECT transaction_id
FROM data_warehouse.v69__transaction_details
WHERE order_id IS NULL;

-- Check 2
SELECT transaction_id
FROM data_warehouse.v69__transaction_details
WHERE flow_type IS NULL;

-- Check 3
SELECT *
FROM data_warehouse.v69__transaction_details_v1
WHERE application_id IS NULL
AND status IS NOT NULL
AND status NOT IN ('VERIFY', 'SSN_VERIFY', 'INITIATE_VERIFICATION');

-- Check 4
SELECT transaction_id
FROM data_warehouse.v69__transaction_details
WHERE merchant_id IS NULL;

-- Check 5
SELECT transaction_id
FROM data_warehouse.v69__transaction_details
WHERE store_id IS NULL;

-- Check 6
SELECT *
FROM data_warehouse.v69__transaction_details
WHERE entry_point IS NULL;

-- Check 7
SELECT *
FROM data_warehouse.v69__transaction_details
WHERE transaction_timestamp IS NULL;

-- Check 8
SELECT *
FROM data_warehouse.v69__transaction_details
WHERE status IS NULL;

-- Check 9
SELECT 
-- DISTINCT status
transaction_id, td.application_id, status, decline_reason_code, rejection_status, atl.application_id
FROM data_warehouse.v69__transaction_details AS td
INNER JOIN (SELECT application_id
FROM data_warehouse.v69__application_to_lender
WHERE app_final_decision = 'DECLINED') AS atl
ON td.application_id = atl.application_id
WHERE decline_reason_code IS NULL;
-- AND atl.application_id IS NULL;

SELECT 
-- DISTINCT status
transaction_id, td.transaction_timestamp, td.application_id, status, decline_reason_code, atl.lender_decline_reason, atl.application_timestamp,
rejection_status, atl.lender_rejection_status
FROM data_warehouse.v73__transaction_details AS td
INNER JOIN data_warehouse.v73__application_to_lender AS atl
ON td.application_id = atl.application_id
WHERE atl.app_final_decision = 'DECLINED'
AND ((decline_reason_code != atl.lender_decline_reason) OR (rejection_status != atl.lender_rejection_status));

-- Check 10
SELECT transaction_id, transaction_timestamp, application_id, decline_reason_code, rejection_status
FROM data_warehouse.v69__transaction_details
WHERE (decline_reason_code IS NOT NULL AND rejection_status IS NULL)
OR (decline_reason_code IS NULL AND rejection_status IS NOT NULL);

-- Check 11
SELECT transaction_id, transaction_timestamp, order_id, td.application_id, request_amount, max_loan_amt, is_counter_offer
FROM data_warehouse.v69__transaction_details AS td
INNER JOIN (SELECT application_id, max_loan_amt
FROM data_warehouse.v69__application_to_lender
GROUP BY 1, 2) AS atl
ON td.application_id = atl.application_id
WHERE request_amount > max_loan_amt
AND is_counter_offer != 1;

-- Check 12
SELECT *
FROM data_warehouse.v69__transaction_details AS td
LEFT JOIN (SELECT DISTINCT application_id, contract_amt FROM v69__application_approval_to_funding WHERE contract_amt > 0) AS atf
ON td.application_id = atf.application_id
WHERE (auto_pay_set = 1 AND atf.contract_amt IS NOT NULL AND autopay_method IS NULL);

-- Check 13
SELECT *
FROM data_warehouse.v69__transaction_details AS td
LEFT JOIN (SELECT DISTINCT application_id, contract_amt FROM v69__application_approval_to_funding WHERE contract_amt > 0) AS atf
ON td.application_id = atf.application_id
LEFT JOIN (SELECT DISTINCT application_id, offer_id, is_autopay_required FROM v69__offer_details) AS od
ON td.application_id = od.application_id
AND td.selected_offer_id = od.offer_id 
WHERE (od.is_autopay_required = 1 AND atf.contract_amt IS NOT NULL AND auto_pay_set != 1);

-- Check 14
SELECT *
FROM data_warehouse.v69__transaction_details
WHERE verification_payment_set = 1 AND verification_payment_method IS NULL;

-- Check 15
-- Blocked

-- Check 16
SELECT *
FROM data_warehouse.v69__transaction_details
WHERE ofee_payment_set = 1 AND ofee_payment_method IS NULL;

-- Check 17
-- Blocked

-- Check 18
-- Blocked

-- Check 19
-- Blocked






