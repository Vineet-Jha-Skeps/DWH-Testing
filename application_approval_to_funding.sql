SELECT DISTINCT total_funded_amt
FROM data_warehouse.v69__application_approval_to_funding;


-- Check 1
SELECT *
FROM data_warehouse.v69__application_approval_to_funding
WHERE application_id IS NULL;

-- Check 2
SELECT *
FROM data_warehouse.v69__application_approval_to_funding
WHERE application_timestamp IS NULL;

-- Check 3
SELECT *
FROM data_warehouse.v69__application_approval_to_funding
WHERE lender_id != 1;

-- Check 4
SELECT *
FROM data_warehouse.v69__application_approval_to_funding
WHERE merchant_id IS NULL;

-- Check 5
SELECT *
FROM data_warehouse.v69__application_approval_to_funding
WHERE store_id IS NULL;

-- Check 6
SELECT *
FROM data_warehouse.v69__application_approval_to_funding
WHERE contract_amt != 0 AND selected_offer_id IS NULL;

-- Check 7 and 8
SELECT *
FROM data_warehouse.v69__application_approval_to_funding
WHERE (contract_amt = 0 AND contract_timestamp IS NOT NULL)
OR (contract_amt != 0 AND contract_timestamp IS NULL);


-- Check 9
SELECT *
FROM data_warehouse.v69__application_approval_to_funding AS atf
LEFT JOIN data_warehouse.v69__loan_details AS ld
ON atf.application_id = ld.application_id
WHERE (total_funded_amt > contract_amt)
OR (total_funded_amt != ld.amount)
OR (total_funded_amt > 0 AND ld.application_id IS NULL);

-- Check 10 and 11
SELECT atf.application_id, total_funded_amt, first_funding_timestamp, fft, last_funding_timestamp, lft
FROM data_warehouse.v69__application_approval_to_funding AS atf
LEFT JOIN (SELECT application_id, MIN(pcd.updated_at) AS fft, MAX(pcd.updated_at) AS lft
FROM v69__pos_card_disbursement AS pcd
LEFT JOIN v69__pos_card_account AS pca
ON pcd.account_id = pca.pos_card_account_id
GROUP BY application_id) AS pcd
ON atf.application_id = pcd.application_id
WHERE atf.first_funding_timestamp != pcd.fft
OR atf.last_funding_timestamp != pcd.lft
OR (total_funded_amt > 0 AND (first_funding_timestamp IS NULL OR last_funding_timestamp IS NULL));

-- Check 12
SELECT *
FROM data_warehouse.v69__application_approval_to_funding
WHERE (total_refunded_amt < 0) OR (total_refunded_amt > total_funded_amt);

-- Check 13
SELECT *
FROM data_warehouse.v69__application_approval_to_funding
WHERE voided_amt + total_funded_amt > contract_amt;

-- Check 14
SELECT *
FROM data_warehouse.v69__application_approval_to_funding;

-- Check 15
SELECT *
FROM data_warehouse.v69__application_approval_to_funding;

-- Check 16
SELECT *
FROM data_warehouse.v69__application_approval_to_funding
WHERE contract_amt IS NOT NULL
AND autopay_method IS NULL;

-- Check 17
SELECT *
FROM data_warehouse.v69__application_approval_to_funding;