SELECT DISTINCT evaluation_type
FROM data_warehouse.v69__offer_evaluation;


-- Check 1
SELECT *
FROM data_warehouse.v69__offer_evaluation
WHERE application_id IS NULL;

-- Check 2
SELECT *
FROM data_warehouse.v69__offer_evaluation
WHERE evaluation_type IS NULL;
-- NOT IN ('INITIAL_EVALUATION', 'VALIDATE_EVALUATION');

-- Check 3
SELECT *
FROM data_warehouse.v69__offer_evaluation
WHERE decision IS NULL
OR (decision <> 'APPROVED' OR decision <> 'DECLINED');

-- Check 4
SELECT *
FROM data_warehouse.v69__offer_evaluation
WHERE decision_data IS NULL;

-- Check 5
SELECT *
FROM data_warehouse.v69__offer_evaluation
WHERE (evaluation_type = 'VALIDATE_EVALUATION' AND evaluation_data IS NOT NULL)
OR (evaluation_type != 'VALIDATE_EVALUATION' AND evaluation_data IS NULL);

-- Check 6
SELECT *
FROM data_warehouse.v69__offer_evaluation
WHERE is_customer_offer != 1;

-- Check 7
SELECT *
FROM data_warehouse.v69__offer_evaluation
WHERE evaluated_at IS NULL;
