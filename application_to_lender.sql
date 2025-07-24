SELECT *
FROM data_warehouse.v69__application_to_lender;


-- Check 1
SELECT *
FROM  data_warehouse.v69__application_to_lender
WHERE application_id IS NULL;

-- Check 2
SELECT *
FROM data_warehouse.v69__application_to_lender
WHERE lender_id != 1 OR lender_id IS NULL;

-- Check 3
SELECT *
FROM data_warehouse.v69__application_to_lender
WHERE CASE WHEN ind_manual_review IS NULL OR ind_manual_review = 0 THEN app_auto_decision = 'SOFT_PENDING' 
			WHEN ind_manual_review = 1 THEN app_auto_decision IN ('APPROVED', 'DECLINED') END;

-- Check 4 WIP
SELECT *
FROM data_warehouse.v69__application_to_lender AS atl
LEFT JOIN (SELECT application_id, decision
FROM data_warehouse.v69__offer_evaluation
WHERE evaluation_type = 'CLEAR_PENDING') AS oe
ON atl.application_id = oe.application_id
WHERE CASE WHEN ind_manual_review IS NULL OR ind_manual_review = 0 THEN app_final_decision != app_auto_decision
			WHEN ind_manual_review = 1 THEN app_final_decision != CASE WHEN latest_status = 'EXPIRED' THEN oe.decision ELSE 'placeholder' -- fix this latest_status 
            END END;


-- Check 5
SELECT *
FROM data_warehouse.v69__application_to_lender
WHERE max_loan_amt != LEAST(max_loan_amount_1_1, max_loan_amount_2_1, max_loan_amount_3_1, max_loan_amount_4_1);

-- Check 6
SELECT *
FROM data_warehouse.v69__application_to_lender
WHERE (CASE WHEN app_auto_decision IN ('SOFT_PENDING', 'APPROVED') THEN stated_income_max_loan_amt IS NULL END)
OR stated_income_max_loan_amt != LEAST(max_loan_amount_1_1, max_loan_amount_2_1, max_loan_amount_3_1, max_loan_amount_4_1);

-- Check 7
SELECT *
FROM data_warehouse.v69__application_to_lender
WHERE intermediate_max_loan_amt != LEAST(max_loan_amount_1_1, max_loan_amount_2_1, max_loan_amount_3_1, max_loan_amount_4_1);

-- Check 8
SELECT *
FROM data_warehouse.v69__application_to_lender AS atl
LEFT JOIN data_warehouse.v69__application_details AS ad
ON atl.application_id = ad.application_id
WHERE CASE WHEN stated_income_max_loan_amt > 50000 AND income_verification_method IS NULL THEN maximum_avl_amt != 50000
			WHEN verified_income > original_total_monthly_income * 12 OR stated_income_max_loan_amt < 50000 THEN maximum_avl_amt != stated_income_max_loan_amt
            ELSE maximum_avl_amt != 50000 END;

-- Check 9
SELECT *
FROM data_warehouse.v69__application_to_lender
WHERE app_auto_decision = 'SOFT_PENDING' AND ind_manual_review != 1;

-- Check 10
SELECT *
FROM data_warehouse.v69__application_to_lender
WHERE app_auto_decision = 'SOFT_PENDING' AND (pending_checks IS NULL OR pending_checks = '[]');

-- Check 11
SELECT *
FROM data_warehouse.v69__application_to_lender
WHERE ind_income_verification = 1 AND income_verification_method IS NULL;

-- Check 12
SELECT *
FROM data_warehouse.v69__application_to_lender
WHERE ind_income_verification = 1 AND verified_income IS NULL;

-- Check 13
-- Blocked
SELECT *
FROM data_warehouse.v69__application_to_lender;

-- Check 14
-- Blocked
SELECT *
FROM data_warehouse.v69__application_to_lender;

-- Check 15
SELECT *
FROM data_warehouse.v69__application_to_lender
WHERE (latest_status = 'DECLINED' OR app_auto_decision = 'DECLINED' OR app_final_decision = 'DECLINED') 
AND lender_decline_reason IS NULL;

-- Check 16
SELECT *
FROM data_warehouse.v69__application_to_lender
WHERE (lender_decline_reason IS NOT NULL AND lender_rejection_status IS NULL)
OR (lender_decline_reason IS NULL AND lender_rejection_status IS NOT NULL);

-- Check 17
SELECT *
FROM data_warehouse.v69__application_to_lender AS atl
LEFT JOIN data_warehouse.v69__application_details AS ad
ON atl.application_id = ad.application_id
WHERE atl.application_timestamp != ad.application_timestamp;


-- Check 18
SELECT atl.*, bd.response_data->"$.fico"
FROM data_warehouse.v69__application_to_lender AS atl
LEFT JOIN data_warehouse.v69__application_details AS ad
ON atl.application_id = ad.application_id
LEFT JOIN data_warehouse.v69__bureau_details AS bd
ON atl.application_id = bd.application_id
AND ad.bor_customer_id = bd.customer_id
WHERE bor_fico != bd.response_data->"$.fico";

-- Check 19
SELECT *
FROM data_warehouse.v69__application_to_lender
WHERE pre_funding_debt != monthly_debt_burden + other_monthly_debt_burden;

-- Check 20
SELECT *
FROM data_warehouse.v69__application_to_lender
WHERE (max_loan_amount_1_1 > max_loan_amount_1)
OR (max_loan_amount_1 - max_loan_amount_1_1 != pre_funding_debt + lender_adjustment_debt + active_contract_balance_merchant);

-- Check 21
SELECT *
FROM data_warehouse.v69__application_to_lender
WHERE (max_loan_amount_2_1 > max_loan_amount_2)
OR (max_loan_amount_2 - max_loan_amount_2_1 != pre_funding_debt + lender_adjustment_debt + active_contract_balance_merchant);

-- Check 22
SELECT *
FROM data_warehouse.v69__application_to_lender
WHERE (max_loan_amount_3_1 > max_loan_amount_3)
OR (max_loan_amount_3 - max_loan_amount_3_1 != pre_funding_debt + lender_adjustment_debt + active_contract_balance_merchant);

-- Check 23
SELECT *
FROM data_warehouse.v69__application_to_lender
WHERE (max_loan_amount_4_1 > max_loan_amount_4)
OR (max_loan_amount_4 - max_loan_amount_4_1 != pre_funding_debt + lender_adjustment_debt + active_contract_balance_merchant);

-- Check 24
SELECT *
FROM data_warehouse.v69__application_to_lender AS atl
LEFT JOIN data_warehouse.v69__application_details_v1 AS ad
ON atl.application_id = ad.application_id
WHERE calculated_dti != (pre_funding_debt/ad.bor_monthly_income);












