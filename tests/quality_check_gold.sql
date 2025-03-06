/*
===============================================================================
Quality Checks
===============================================================================
Script:
    Script này thực hiện các kiểm tra chất lượng để xác thực tính toàn vẹn, 
    nhất quán và chính xác của Gold Layer. Các kiểm tra này đảm bảo:
    - Tính duy nhất của khóa thay thế trong các bảng dimension.
    - Tính toàn vẹn tham chiếu giữa bảng fact và bảng dimension.
    - Xác thực mối quan hệ trong mô hình dữ liệu phục vụ phân tích.

Hướng dẫn sử dụng:
    - Kiểm tra và giải quyết bất kỳ sự sai lệch nào được phát hiện trong quá trình kiểm tra.
===============================================================================
*/

-- ====================================================================
-- Checking 'gold.dim_customers'
-- ====================================================================
-- Check for Uniqueness of Customer Key in gold.dim_customers
-- Expectation: No results 
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.product_key'
-- ====================================================================
-- Check for Uniqueness of Product Key in gold.dim_products
-- Expectation: No results 
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.fact_sales'
-- ====================================================================
-- Check the data model connectivity between fact and dimensions
SELECT * 
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL  