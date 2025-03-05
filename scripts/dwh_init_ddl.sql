/*
=============================================================
Khởi tạo Database and Schemas
=============================================================
Mục đích:
	Tạo mới database 'DataWarehouse' sau khi kiểm tra có tồn tại hay không.
	Nếu tồn tại, nó sẽ bị xóa và tạo lại. Thêm vào đó sẽ tạo sẵn 3 schemas trong database tương ứng 
	với ba lớp của datawarehouse là bronze, sliver và gold.
	
Chú ý:
	Khi chạy script sẽ xóa toàn bộ database 'DataWarehouse' nếu tồn tại.
	Toàn bộ dữ liệu sẽ bị xóa vĩnh viễn. hãy backup cẩn thận trước khi chạy script.
*/

USE master;
GO

-- Xóa và tao lại 'DataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	-- Chuyển db về đơn người dùng, đảm bảo an toàn quá trình tạo. Rollback tất cả các giao dịch khác
	-- đạng chạy. Các giao dịch khác phải chờ khi thực hiện xong là quay trở lại chế độ đa người dùng.
	-- set multi_user
    DROP DATABASE DataWarehouse;
END;
GO

-- 

-- Tạo 'DataWarehouse' database
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Tạo Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO