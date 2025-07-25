-- Checks combined
WITH Check1 AS (
SELECT transaction_id
FROM data_warehouse.v69__transaction_details
WHERE order_id IS NULL)
,
Check2 AS (
SELECT transaction_id
FROM data_warehouse.v69__transaction_details
WHERE flow_type IS NULL)
,
Check3 AS (
SELECT transaction_id
FROM data_warehouse.v69__transaction_details_v1
WHERE application_id IS NULL
AND status IS NOT NULL
AND status NOT IN ('VERIFY', 'SSN_VERIFY', 'INITIATE_VERIFICATION')
)
,
Check4 AS (
SELECT transaction_id
FROM data_warehouse.v69__transaction_details
WHERE merchant_id IS NULL
)
,
Check5 AS (
SELECT transaction_id
FROM data_warehouse.v69__transaction_details
WHERE store_id IS NULL
)
,
Check6 AS (
SELECT *
FROM data_warehouse.v69__transaction_details
WHERE entry_point IS NULL)
,
Check7 AS (
SELECT *
FROM data_warehouse.v69__transaction_details
WHERE transaction_timestamp IS NULL)
,
Check8 AS (
SELECT *
FROM data_warehouse.v69__transaction_details
WHERE status IS NULL)
,
Check9_1 AS (
SELECT 
DISTINCT td.application_id
FROM data_warehouse.v69__transaction_details AS td
INNER JOIN (SELECT application_id
FROM data_warehouse.v69__application_to_lender
WHERE app_final_decision = 'DECLINED') AS atl
ON td.application_id = atl.application_id
WHERE decline_reason_code IS NULL)
,
Check9_2 AS (
SELECT 
DISTINCT td.application_id
FROM data_warehouse.v73__transaction_details AS td
INNER JOIN data_warehouse.v73__application_to_lender AS atl
ON td.application_id = atl.application_id
WHERE atl.app_final_decision = 'DECLINED'
AND ((decline_reason_code != atl.lender_decline_reason) OR (rejection_status != atl.lender_rejection_status)))
,
Check10 AS (
SELECT transaction_id, transaction_timestamp, application_id, decline_reason_code, rejection_status
FROM data_warehouse.v69__transaction_details
WHERE (decline_reason_code IS NOT NULL AND rejection_status IS NULL)
OR (decline_reason_code IS NULL AND rejection_status IS NOT NULL))
,
Check11 AS (
SELECT transaction_id, transaction_timestamp, order_id, td.application_id, request_amount, max_loan_amt, is_counter_offer
FROM data_warehouse.v69__transaction_details AS td
INNER JOIN (SELECT application_id, max_loan_amt
FROM data_warehouse.v69__application_to_lender
GROUP BY 1, 2) AS atl
ON td.application_id = atl.application_id
WHERE request_amount > max_loan_amt
AND is_counter_offer != 1)
,
Check12 AS (
SELECT DISTINCT td.application_id
FROM data_warehouse.v69__transaction_details AS td
LEFT JOIN (SELECT DISTINCT application_id, contract_amt FROM v69__application_approval_to_funding WHERE contract_amt > 0) AS atf
ON td.application_id = atf.application_id
WHERE (auto_pay_set = 1 AND atf.contract_amt IS NOT NULL AND autopay_method IS NULL))
,
Check13 AS (
SELECT DISTINCT td.application_id
FROM data_warehouse.v69__transaction_details AS td
LEFT JOIN (SELECT DISTINCT application_id, contract_amt FROM v69__application_approval_to_funding WHERE contract_amt > 0) AS atf
ON td.application_id = atf.application_id
LEFT JOIN (SELECT DISTINCT application_id, offer_id, is_autopay_required FROM v69__offer_details) AS od
ON td.application_id = od.application_id
AND td.selected_offer_id = od.offer_id 
WHERE (od.is_autopay_required = 1 AND atf.contract_amt IS NOT NULL AND auto_pay_set != 1))
,
Check14 AS (
SELECT *
FROM data_warehouse.v69__transaction_details
WHERE verification_payment_set = 1 AND verification_payment_method IS NULL
)
SELECT 'Order_Id Not Null' AS Check_Name, COUNT(*) AS Failed_Row_Count
FROM Check1
UNION ALL
SELECT 'Flow_Type Not Null' AS Check_Name, COUNT(*) AS Failed_Row_Count
FROM Check2
UNION ALL
SELECT 'Application_Id Not Null' AS Check_Name, COUNT(*) AS Failed_Row_Count
FROM Check3
UNION ALL
SELECT 'Merchant_Id Not Null' AS Check_Name, COUNT(*) AS Failed_Row_Count
FROM Check4
UNION ALL
SELECT 'Store_Id Not Null' AS Check_Name, COUNT(*) AS Failed_Row_Count
FROM Check5
UNION ALL
SELECT 'Entry_Point Not Null' AS Check_Name, COUNT(*) AS Failed_Row_Count
FROM Check6
UNION ALL
SELECT 'Transaction_Timestamp Not Null' AS Check_Name, COUNT(*) AS Failed_Row_Count
FROM Check7
UNION ALL
SELECT 'Status Not Null' AS Check_Name, COUNT(*) AS Failed_Row_Count
FROM Check8
UNION ALL
SELECT 'Decline Reason Code Not Null for DECLINED apps' AS Check_Name, COUNT(*) AS Failed_Row_Count
FROM Check9_1
UNION ALL
SELECT 'Decline Reason Code and Rejection Status Matches with Application To Lender Table' AS Check_Name, COUNT(*) AS Failed_Row_Count
FROM Check9_2
UNION ALL
SELECT 'Both Decline Reason Code and Rejection Status Present' AS Check_Name, COUNT(*) AS Failed_Row_Count
FROM Check10
UNION ALL
SELECT 'Counter Offer Should be 1 where request_amount > max_loan_amount' AS Check_Name, COUNT(*) AS Failed_Row_Count
FROM Check11
UNION ALL
SELECT 'Autopay_Method Not Null where Autopay_set = 1 and Contract_Amt Not Null' AS Check_Name, COUNT(*) AS Failed_Row_Count
FROM Check12
UNION ALL
SELECT 'Autopay_set Should be 1 where Contract_Amt Not Null and Autopay_required for Selected Offer' AS Check_Name, COUNT(*) AS Failed_Row_Count
FROM Check13
UNION ALL
SELECT 'Verification_Payment_Method Not Null where Verification_payment_set = 1' AS Check_Name, COUNT(*) AS Failed_Row_Count
FROM Check14;






