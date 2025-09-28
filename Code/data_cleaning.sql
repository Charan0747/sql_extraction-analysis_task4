--Standarized gender
UPDATE Sales_data
SET gender = CASE 
    WHEN LOWER(gender) IN ('m', 'male') THEN 'Male'
    WHEN LOWER(gender) IN ('f', 'female') THEN 'Female'
    ELSE 'Other'
END;

--Standarized age_group
UPDATE Sales_data
SET age_group = CASE
    WHEN age_group LIKE 'Teen%' THEN 'Teenager'
    WHEN age_group LIKE 'Adult%' THEN 'Adult'
    WHEN age_group LIKE 'Senior%' THEN 'Senior'
    ELSE 'Unknown'
END;

--Standarized order_status
UPDATE Sales_data
SET order_status = CASE
    WHEN LOWER(order_status) IN ('delivered', 'shipped') THEN 'Completed'
    WHEN LOWER(order_status) = 'pending' THEN 'Pending'
    WHEN LOWER(order_status) = 'returned' THEN 'Returned'
    WHEN LOWER(order_status) = 'cancelled' THEN 'Cancelled'
    ELSE 'Unknown'
END;

--Trimming the Uneccessary Spaces.
UPDATE Sales_data
SET first_name = TRIM(first_name),
    last_name  = TRIM(last_name);

-- Capitalize payment method (first letter uppercase, rest lowercase)
UPDATE Sales_data
SET payment_method = 
    UPPER(LEFT(payment_method, 1)) + 
    LOWER(SUBSTRING(payment_method, 2, LEN(payment_method)));
--Ensure Rating is between 1 and 5
UPDATE Sales_data
SET rating = CASE
    WHEN rating < 1 THEN 1
    WHEN rating > 5 THEN 5
    ELSE rating
END;



