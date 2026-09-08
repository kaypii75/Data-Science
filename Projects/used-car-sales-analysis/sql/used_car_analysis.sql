-- =====================================================
-- USED CAR SALES ANALYSIS
-- SQL Analysis Project
-- =====================================================

USE used_car_analysis;


-- =====================================================
-- 1. DATA QUALITY CHECKS
-- =====================================================

-- Total number of records
SELECT
    COUNT(*) AS total_records
FROM used_cars;


-- Check table structure
DESCRIBE used_cars;


-- Check missing values: basic fields
SELECT
    COUNT(*) AS total_records,
    COUNT(CASE WHEN Make = '' THEN 1 END) AS missing_make,
    COUNT(CASE WHEN Model = '' THEN 1 END) AS missing_model,
    COUNT(CASE WHEN Year = '' THEN 1 END) AS missing_year,
    COUNT(CASE WHEN Fuel_Type = '' THEN 1 END) AS missing_fuel_type,
    COUNT(CASE WHEN Transmission = '' THEN 1 END) AS missing_transmission
FROM used_cars;


-- Check missing values: numeric and categorical fields
SELECT
    COUNT(CASE WHEN Engine_Size = '' THEN 1 END) AS missing_engine_size,
    COUNT(CASE WHEN Mileage = '' THEN 1 END) AS missing_mileage,
    COUNT(CASE WHEN Horsepower = '' THEN 1 END) AS missing_horsepower,
    COUNT(CASE WHEN Torque = '' THEN 1 END) AS missing_torque,
    COUNT(CASE WHEN Owners = '' THEN 1 END) AS missing_owners,
    COUNT(CASE WHEN Accident_History = '' THEN 1 END) AS missing_accident_history,
    COUNT(CASE WHEN Service_History = '' THEN 1 END) AS missing_service_history,
    COUNT(CASE WHEN Color = '' THEN 1 END) AS missing_color
FROM used_cars;


-- Check missing values: remaining fields
SELECT
    COUNT(CASE WHEN Drivetrain = '' THEN 1 END) AS missing_drivetrain,
    COUNT(CASE WHEN Fuel_Efficiency = '' THEN 1 END) AS missing_fuel_efficiency,
    COUNT(CASE WHEN Location = '' THEN 1 END) AS missing_location,
    COUNT(CASE WHEN Selling_Price = '' THEN 1 END) AS missing_selling_price
FROM used_cars;


-- Check zero values in numeric fields
SELECT
    COUNT(CASE WHEN Engine_Size = '0' THEN 1 END) AS zero_engine_size,
    COUNT(CASE WHEN Mileage = '0' THEN 1 END) AS zero_mileage,
    COUNT(CASE WHEN Horsepower = '0' THEN 1 END) AS zero_horsepower,
    COUNT(CASE WHEN Torque = '0' THEN 1 END) AS zero_torque,
    COUNT(CASE WHEN Owners = '0' THEN 1 END) AS zero_owners,
    COUNT(CASE WHEN Accident_History = '0' THEN 1 END) AS zero_accident_history,
    COUNT(CASE WHEN Fuel_Efficiency = '0' THEN 1 END) AS zero_fuel_efficiency
FROM used_cars;


-- =====================================================
-- 2. BRAND ANALYSIS
-- =====================================================

-- Average selling price by brand
SELECT
    Make,
    AVG(Selling_Price) AS avg_selling_price
FROM used_cars
GROUP BY Make
ORDER BY avg_selling_price DESC;


-- Top 5 brands by average selling price
SELECT
    Make,
    AVG(Selling_Price) AS avg_selling_price
FROM used_cars
GROUP BY Make
ORDER BY avg_selling_price DESC
LIMIT 5;


-- Analyze average selling price by brand and count the number of cars
SELECT
    Make,
    COUNT(*) AS car_count,
    AVG(Selling_Price) AS avg_selling_price
FROM used_cars
GROUP BY Make
HAVING COUNT(*) >= 100
ORDER BY avg_selling_price DESC;


-- Identify brands with at least 100 cars and an average selling price of at least 15,000
SELECT
    Make,
    COUNT(*) AS car_count,
    AVG(Selling_Price) AS avg_selling_price
FROM used_cars
GROUP BY Make
HAVING
    COUNT(*) >= 100
    AND AVG(Selling_Price) >= 15000
ORDER BY avg_selling_price DESC;


-- =====================================================
-- 3. FUEL TYPE ANALYSIS
-- =====================================================

-- Average selling price by fuel type
SELECT
    Fuel_Type,
    AVG(Selling_Price) AS avg_selling_price
FROM used_cars
GROUP BY Fuel_Type
ORDER BY avg_selling_price DESC;


-- =====================================================
-- 4. TRANSMISSION ANALYSIS
-- =====================================================

-- Average selling price by transmission type
SELECT
    Transmission,
    AVG(Selling_Price) AS avg_selling_price
FROM used_cars
GROUP BY Transmission
ORDER BY avg_selling_price DESC;


-- =====================================================
-- 5. YEAR ANALYSIS
-- =====================================================

-- Average selling price by model year
SELECT
    Year,
    AVG(Selling_Price) AS avg_selling_price
FROM used_cars
GROUP BY Year
ORDER BY avg_selling_price DESC;


-- =====================================================
-- 6. MILEAGE ANALYSIS
-- =====================================================

-- Compare average selling price across different mileage ranges
SELECT
    CASE
        WHEN Mileage <= 50000 THEN '0-50K'
        WHEN Mileage <= 100000 THEN '50K-100K'
        WHEN Mileage <= 150000 THEN '100K-150K'
        WHEN Mileage <= 200000 THEN '150K-200K'
        ELSE '200K+'
    END AS Mileage_Band,
    AVG(Selling_Price) AS avg_selling_price
FROM used_cars
GROUP BY
    CASE
        WHEN Mileage <= 50000 THEN '0-50K'
        WHEN Mileage <= 100000 THEN '50K-100K'
        WHEN Mileage <= 150000 THEN '100K-150K'
        WHEN Mileage <= 200000 THEN '150K-200K'
        ELSE '200K+'
    END
ORDER BY avg_selling_price DESC;


-- =====================================================
-- 7. BODY TYPE ANALYSIS
-- =====================================================

-- Average selling price by body type
SELECT
    Body_Type,
    AVG(Selling_Price) AS avg_selling_price
FROM used_cars
GROUP BY Body_Type
ORDER BY avg_selling_price DESC;


-- =====================================================
-- 8. ACCIDENT HISTORY ANALYSIS
-- =====================================================

-- Average selling price by accident history
SELECT
    Accident_History,
    AVG(Selling_Price) AS avg_selling_price
FROM used_cars
GROUP BY Accident_History
ORDER BY avg_selling_price DESC;


-- =====================================================
-- 9. OWNERS ANALYSIS
-- =====================================================

-- Average selling price by number of previous owners
SELECT
    Owners,
    AVG(Selling_Price) AS avg_selling_price
FROM used_cars
GROUP BY Owners
ORDER BY avg_selling_price DESC;


-- =====================================================
-- 10. ADVANCED SQL ANALYSIS
-- =====================================================

-- Find the highest-priced car within each brand
SELECT
    uc.Make,
    uc.Model,
    uc.Year,
    uc.Selling_Price
FROM used_cars uc
JOIN (
    SELECT
        Make,
        MAX(CAST(Selling_Price AS DECIMAL(10,2))) AS max_price
    FROM used_cars
    GROUP BY Make
) m
    ON uc.Make = m.Make
    AND CAST(uc.Selling_Price AS DECIMAL(10,2)) = m.max_price
ORDER BY CAST(uc.Selling_Price AS DECIMAL(10,2)) DESC;


-- Identify cars priced at least 20% above their brand's average selling price
WITH car_analysis AS (
    SELECT
        Make,
        Model,
        Year,
        CAST(Selling_Price AS DECIMAL(10,2)) AS selling_price,
        AVG(CAST(Selling_Price AS DECIMAL(10,2)))
            OVER (PARTITION BY Make) AS brand_avg_price
    FROM used_cars
)

SELECT
    Make,
    Model,
    Year,
    selling_price,
    ROUND(brand_avg_price, 2) AS brand_avg_price,
    ROUND(
        ((selling_price - brand_avg_price) / brand_avg_price) * 100,
        2
    ) AS above_brand_avg_percent
FROM car_analysis
WHERE selling_price >= brand_avg_price * 1.20
ORDER BY above_brand_avg_percent DESC;