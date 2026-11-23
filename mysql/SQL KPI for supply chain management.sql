-- KPI 1:Total Sales(MTD,QTD,YTD)
SELECT
    SUM(CASE
        WHEN YEAR(date) = YEAR((SELECT MAX(date) FROM plugs_electronics_hands_on_lab_data))
        AND MONTH(date) = MONTH((SELECT MAX(date) FROM plugs_electronics_hands_on_lab_data))
        THEN quantity * price ELSE 0
    END) AS MTD_Sales,

    SUM(CASE
        WHEN YEAR(date) = YEAR((SELECT MAX(date) FROM plugs_electronics_hands_on_lab_data))
        AND QUARTER(date) = QUARTER((SELECT MAX(date) FROM plugs_electronics_hands_on_lab_data))
        THEN quantity * price ELSE 0
    END) AS QTD_Sales,

    SUM(CASE
        WHEN YEAR(date) = YEAR((SELECT MAX(date) FROM plugs_electronics_hands_on_lab_data))
        THEN quantity * price ELSE 0
    END) AS YTD_Sales

FROM plugs_electronics_hands_on_lab_data
WHERE date <= (SELECT MAX(date) FROM plugs_electronics_hands_on_lab_data);
-- KPI 2:Product Wise Sales
SELECT
    `Product Type`,
    SUM(quantity) AS Total_Quantity,
    SUM(quantity * price) AS Total_Sales
FROM plugs_electronics_hands_on_lab_data
GROUP BY `Product Type`
ORDER BY Total_Sales DESC;
-- KPI 3:Sales Growth 
WITH Yearly_Sales AS (
    SELECT
        YEAR(date) AS Year,
        SUM(quantity * price) AS Total_Sales
    FROM plugs_electronics_hands_on_lab_data
    GROUP BY YEAR(date)
),
Sales_Growth AS (
    SELECT
        Year,
        Total_Sales,
        LAG(Total_Sales) OVER (ORDER BY Year) AS Previous_Year_Sales
    FROM Yearly_Sales
)
SELECT
    Year,
    Total_Sales,
    Previous_Year_Sales,
    ROUND(
        ((Total_Sales - Previous_Year_Sales) / Previous_Year_Sales) * 100,
        2
    ) AS Sales_Growth_Percentage
FROM Sales_Growth
ORDER BY Year;
-- KPI 4: Daily Sales Trend
SELECT
    DATE(date) AS Sales_Date,
    SUM(quantity * price) AS Total_Sales
FROM plugs_electronics_hands_on_lab_data
GROUP BY DATE(date)
ORDER BY Sales_Date;
-- KPI 5:State Wise Sales
SELECT
    `Store State`,
    SUM(Quantity*cost) AS Total_Sales
FROM plugs_electronics_hands_on_lab_data
GROUP BY `Store State`
ORDER BY Total_Sales DESC;
-- KPI:6 Top 5 Store Wise Sales
SELECT
    `Store Name`,
    SUM(`Quantity` * `Price`) AS Total_Sales
FROM plugs_electronics_hands_on_lab_data
GROUP BY `Store Name`
ORDER BY Total_Sales DESC
LIMIT 5;
-- KPI :7 Region Wise Sales 
SELECT
    `Store Region`,
    SUM(quantity * cost) AS Total_Sales,
    ROUND(
        SUM(quantity * cost) * 100.0 /
        (SELECT SUM(quantity * cost)
         FROM plugs_electronics_hands_on_lab_data),
        2
    ) AS Sales_Percentage
FROM plugs_electronics_hands_on_lab_data
GROUP BY `Store Region`
ORDER BY Total_Sales DESC;
-- KPI:8 Total Inventory 
SELECT SUM(Quantity) AS Total_Inventory
FROM plugs_electronics_hands_on_lab_data;
-- KPI:9 Inventory Value
SELECT SUM(Quantity * Cost) AS Inventory_Value
FROM plugs_electronics_hands_on_lab_data;
-- KPI:10 Inventory Value
SELECT
    `Product Name`,
    Quantity,
    CASE
        WHEN Quantity = 0 THEN 'Out of Stock'
        WHEN Quantity <= 10 THEN 'Understock'
        ELSE 'Overstock'
    END AS Stock_Status
FROM plugs_electronics_hands_on_lab_data;
SELECT
    CASE
        WHEN Quantity = 0 THEN 'Out of Stock'
        WHEN Quantity <= 10 THEN 'Understock'
        ELSE 'Overstock'
    END AS Stock_Status,
    COUNT(*) AS Total_Products
FROM plugs_electronics_hands_on_lab_data
GROUP BY Stock_Status;






