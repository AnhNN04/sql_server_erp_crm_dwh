/*
===============================================================================
DDL Script: Tạo bảng trong lược đồ Silver (Layer 2)
===============================================================================
Mục đích Script:
	Tạo bảng trong lược đồ bronze, xóa và tạo lại nếu bảng đã tồn tại.
===============================================================================
*/
-- Chú ý: thêm cột 'dwh_insert_date' để lưu thông tin thời gian tải dữ liệu vào bảng

-- kiểm tra đối tượng do 'U': user-defined với object_id: 'silver.crm_cust_info' có tồn tại chưa 
IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_cust_info;
GO
-- thông tin khách hàng 
CREATE TABLE silver.crm_cust_info (
    cst_id             INT,
    cst_key            NVARCHAR(50),
    cst_firstname      NVARCHAR(50),
    cst_lastname       NVARCHAR(50),
    cst_marital_status NVARCHAR(50),
    cst_gndr           NVARCHAR(50),
    cst_create_date    DATE,
    dwh_insert_date    DATETIME2 DEFAULT GETDATE()
);
GO


IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_prd_info;
GO
-- thông tin sản phẩm 
CREATE TABLE silver.crm_prd_info (
    prd_id          INT,
    cat_id          NVARCHAR(50),
    prd_key         NVARCHAR(50),
    prd_nm          NVARCHAR(50),
    prd_cost        INT,
    prd_line        NVARCHAR(50),
    prd_start_dt    DATE,
    prd_end_dt      DATE,
    dwh_insert_date DATETIME2 DEFAULT GETDATE()
);
GO


IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_details;
GO
-- thông tin chi tiết bán hàng 
CREATE TABLE silver.crm_sales_details (
    sls_ord_num     NVARCHAR(50),
    sls_prd_key     NVARCHAR(50),
    sls_cust_id     INT,
    sls_order_dt    DATE,
    sls_ship_dt     DATE,
    sls_due_dt      DATE,
    sls_sales       INT,
    sls_quantity    INT,
    sls_price       INT,
    dwh_insert_date DATETIME2 DEFAULT GETDATE()
);
GO


IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE silver.erp_loc_a101;
GO
-- thông tin địa chỉ (location) khách hàng 
CREATE TABLE silver.erp_loc_a101 (
    cid             NVARCHAR(50),
    cntry           NVARCHAR(50),
    dwh_insert_date DATETIME2 DEFAULT GETDATE()
);
GO


IF OBJECT_ID('silver.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE silver.erp_cust_az12;
GO
-- thông tin thêm về khách hàng 
CREATE TABLE silver.erp_cust_az12 (
    cid             NVARCHAR(50),
    bdate           DATE,
    gen             NVARCHAR(50),
    dwh_insert_date DATETIME2 DEFAULT GETDATE()
);
GO


IF OBJECT_ID('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE silver.erp_px_cat_g1v2;
GO
-- thông tin về phân loại (category) sản phẩm 
CREATE TABLE silver.erp_px_cat_g1v2 (
    id              NVARCHAR(50),
    cat             NVARCHAR(50),
    subcat          NVARCHAR(50),
    maintenance     NVARCHAR(50),
    dwh_insert_date DATETIME2 DEFAULT GETDATE()
);
GO