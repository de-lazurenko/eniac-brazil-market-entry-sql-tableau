/*******************************************************************************
Project: Market Expansion Analysis (Eniac & Magist Partnership)
Author: [Denis Lazurenko]
Description: SQL analysis of the Magist database to evaluate the feasibility 
             of a 3-year partnership for Eniac's expansion into Brazil.
Focus Areas: 
    1. Product Catalog & Tech Segment Fit
    2. Customer & Seller Geographical Distribution
    3. Logistics Performance (Delivery Timelines)
*******************************************************************************/

USE magist;

-- =============================================================================
-- 0. DATABASE OVERVIEW
-- =============================================================================

-- General metrics to understand the scale of the product catalog
SELECT COUNT(*) AS total_products FROM products;

SELECT COUNT(DISTINCT product_category_name) AS total_categories FROM products;


-- =============================================================================
-- 1. PRODUCT ANALYSIS: Does Magist fit Eniac's Tech-heavy Catalog?
-- =============================================================================

/* Slide 3: Product Assortment by Category (2018)
   Analysis of the Tech segment's share compared to other categories.
*/

WITH category_segment AS (
    SELECT 'bed_bath_table' AS product_category_name_english, 'Home & Decor' AS excel_segment, 9.19 AS avg_price UNION ALL
    SELECT 'sports_leisure', 'Sports', 8.70 UNION ALL
    SELECT 'furniture_decor', 'Home & Decor', 4.50 UNION ALL
    SELECT 'health_beauty', 'Health & Beauty', 7.42 UNION ALL
    SELECT 'housewares', 'Home & Decor', 4.50 UNION ALL
    SELECT 'auto', 'Auto', 5.77 UNION ALL
    SELECT 'computers_accessories', 'Tech', 4.97 UNION ALL
    SELECT 'toys', 'Kids', 4.28 UNION ALL
    SELECT 'watches_gifts', 'Accessories', 4.50 UNION ALL
    SELECT 'telephony', 'Tech', 3.44 UNION ALL
    SELECT 'baby', 'Kids', 2.79 UNION ALL
    SELECT 'perfumery', 'Health & Beauty', 2.63 UNION ALL
    SELECT 'stationery', 'Home & Decor', 2.58 UNION ALL
    SELECT 'fashion_bags_accessories', 'Accessories', 2.58 UNION ALL
    SELECT 'cool_stuff', 'Accessories', 2.39 UNION ALL
    SELECT 'garden_tools', 'Home & Decor', 2.29 UNION ALL
    SELECT 'pet_shop', 'Other', 2.18 UNION ALL
    SELECT 'electronics', 'Tech', 1.57 UNION ALL
    SELECT 'construction_tools_construction', 'Home & Decor', 1.21 UNION ALL
    SELECT 'home_appliances', 'Tech', 4.50 UNION ALL
    SELECT 'luggage_accessories', 'Accessories', 4.50 UNION ALL
    SELECT 'consoles_games', 'Tech', 0.96 UNION ALL
    SELECT 'office_furniture', 'Home & Decor', 0.94 UNION ALL
    SELECT 'musical_instruments', 'Other', 0.88 UNION ALL
    SELECT 'small_appliances', 'Tech', 0.70 UNION ALL
    SELECT 'home_construction', 'Home & Decor', 0.68 UNION ALL
    SELECT 'books_general_interest', 'Other', 0.66 UNION ALL
    SELECT 'fashion_shoes', 'Accessories', 0.53 UNION ALL
    SELECT 'furniture_living_room', 'Home & Decor', 0.47 UNION ALL
    SELECT 'air_conditioning', 'Home & Decor', 0.38 UNION ALL
    SELECT 'books_technical', 'Tech', 0.37 UNION ALL
    SELECT 'fixed_telephony', 'Tech', 0.35 UNION ALL
    SELECT 'home_confort', 'Home & Decor', 0.34 UNION ALL
    SELECT 'market_place', 'Other', 0.32 UNION ALL
    SELECT 'food_drink', 'Other', 0.32 UNION ALL
    SELECT 'fashion_male_clothing', 'Other', 0.29 UNION ALL
    SELECT 'kitchen_dining_laundry_garden_furniture', 'Other', 0.29 UNION ALL
    SELECT 'signaling_and_security', 'Other', 0.28 UNION ALL
    SELECT 'construction_tools_safety', 'Other', 0.28 UNION ALL
    SELECT 'home_appliances_2', 'Other', 0.27 UNION ALL
    SELECT 'costruction_tools_garden', 'Other', 0.27 UNION ALL
    SELECT 'food', 'Other', 0.25 UNION ALL
    SELECT 'drinks', 'Other', 0.25 UNION ALL
    SELECT 'construction_tools_lights', 'Other', 0.24 UNION ALL
    SELECT 'agro_industry_and_commerce', 'Other', 0.22 UNION ALL
    SELECT 'industry_commerce_and_business', 'Other', 0.21 UNION ALL
    SELECT 'christmas_supplies', 'Other', 0.20 UNION ALL
    SELECT 'audio', 'Other', 0.18 UNION ALL
    SELECT 'art', 'Other', 0.17 UNION ALL
    SELECT 'fashion_underwear_beach', 'Other', 0.16 UNION ALL
    SELECT 'dvds_blu_ray', 'Other', 0.15 UNION ALL
    SELECT 'furniture_bedroom', 'Other', 0.14 UNION ALL
    SELECT 'costruction_tools_tools', 'Other', 0.12 UNION ALL
    SELECT 'books_imported', 'Other', 0.09 UNION ALL
    SELECT 'small_appliances_home_oven_and_coffee', 'Other', 0.09 UNION ALL
    SELECT 'computers', 'Tech', 0.09 UNION ALL
    SELECT 'cine_photo', 'Other', 0.08 UNION ALL
    SELECT 'fashio_female_clothing', 'Other', 0.08 UNION ALL
    SELECT 'music', 'Other', 0.08 UNION ALL
    SELECT 'party_supplies', 'Other', 0.08 UNION ALL
    SELECT 'fashion_sport', 'Other', 0.06 UNION ALL
    SELECT 'arts_and_craftmanship', 'Other', 0.06 UNION ALL
    SELECT 'flowers', 'Other', 0.04 UNION ALL
    SELECT 'diapers_and_hygiene', 'Other', 0.04 UNION ALL
    SELECT 'furniture_mattress_and_upholstery', 'Other', 0.03 UNION ALL
    SELECT 'la_cuisine', 'Other', 0.03 UNION ALL
    SELECT 'portable_kitchen_food_processors', 'Other', 0.03 UNION ALL
    SELECT 'tablets_printing_image', 'Tech', 0.03 UNION ALL
    SELECT 'fashion_childrens_clothes', 'Other', 0.02 UNION ALL
    SELECT 'home_comfort_2', 'Other', 0.02 UNION ALL
    SELECT 'pc_gamer', 'Tech', 0.01 UNION ALL
    SELECT 'security_and_services', 'Other', 0.01 UNION ALL
    SELECT 'cds_dvds_musicals', 'Other', 0.00
),
products_with_priority AS (
    SELECT 
        pct.product_category_name_english,
        COUNT(*) AS product_count,
        CASE
            WHEN ROUND(COUNT(*) / SUM(COUNT(*)) OVER () * 100, 2) >= 7.00 THEN 'High segment'
            WHEN ROUND(COUNT(*) / SUM(COUNT(*)) OVER () * 100, 2) <= 3.00 THEN 'Low segment'
            ELSE 'Middle segment'
        END AS Priority_segmentation
    FROM products p
    JOIN product_category_name_translation pct
        ON p.product_category_name = pct.product_category_name
    GROUP BY pct.product_category_name_english
),
category_totals AS (
    SELECT
        cs.excel_segment AS Category,
        COALESCE(SUM(CASE WHEN pw.Priority_segmentation = 'High segment' THEN pw.product_count END), 0) AS `High segment`,
        COALESCE(SUM(CASE WHEN pw.Priority_segmentation = 'Middle segment' THEN pw.product_count END), 0) AS `Middle segment`,
        COALESCE(SUM(CASE WHEN pw.Priority_segmentation = 'Low segment' THEN pw.product_count END), 0) AS `Low segment`,
        COALESCE(SUM(pw.product_count), 0) AS Total
    FROM products_with_priority pw
    LEFT JOIN category_segment cs
        ON pw.product_category_name_english = cs.product_category_name_english
    GROUP BY cs.excel_segment
    HAVING Category IS NOT NULL
)
SELECT 
    Category,
    Total AS Total_sum,
    ROUND(Total / SUM(Total) OVER () * 100, 2) AS category_percentage
FROM category_totals
ORDER BY total_sum DESC;


/* Slide 4: Items Sold & Average Prices
   Comparison of average pricing and sales volume across segments.
*/

WITH category_segment AS (
    SELECT 'bed_bath_table' AS product_category_name_english, 'Home & Decor' AS excel_segment UNION ALL
    SELECT 'sports_leisure', 'Sports' UNION ALL
    SELECT 'furniture_decor', 'Home & Decor' UNION ALL
    SELECT 'health_beauty', 'Health & Beauty' UNION ALL
    SELECT 'housewares', 'Home & Decor' UNION ALL
    SELECT 'auto', 'Auto' UNION ALL
    SELECT 'computers_accessories', 'Tech' UNION ALL
    SELECT 'toys', 'Kids' UNION ALL
    SELECT 'watches_gifts', 'Accessories' UNION ALL
    SELECT 'telephony', 'Tech' UNION ALL
    SELECT 'baby', 'Kids' UNION ALL
    SELECT 'perfumery', 'Health & Beauty' UNION ALL
    SELECT 'stationery', 'Home & Decor' UNION ALL
    SELECT 'fashion_bags_accessories', 'Accessories' UNION ALL
    SELECT 'cool_stuff', 'Accessories' UNION ALL
    SELECT 'garden_tools', 'Home & Decor' UNION ALL
    SELECT 'pet_shop', 'Other' UNION ALL
    SELECT 'electronics', 'Tech' UNION ALL
    SELECT 'construction_tools_construction', 'Home & Decor' UNION ALL
    SELECT 'home_appliances', 'Tech' UNION ALL
    SELECT 'luggage_accessories', 'Accessories' UNION ALL
    SELECT 'consoles_games', 'Tech' UNION ALL
    SELECT 'office_furniture', 'Home & Decor' UNION ALL
    SELECT 'musical_instruments', 'Other' UNION ALL
    SELECT 'small_appliances', 'Tech' UNION ALL
    SELECT 'home_construction', 'Home & Decor' UNION ALL
    SELECT 'books_general_interest', 'Other' UNION ALL
    SELECT 'fashion_shoes', 'Accessories' UNION ALL
    SELECT 'furniture_living_room', 'Home & Decor' UNION ALL
    SELECT 'air_conditioning', 'Home & Decor' UNION ALL
    SELECT 'books_technical', 'Tech' UNION ALL
    SELECT 'fixed_telephony', 'Tech' UNION ALL
    SELECT 'home_confort', 'Home & Decor' UNION ALL
    SELECT 'market_place', 'Other' UNION ALL
    SELECT 'food_drink', 'Other' UNION ALL
    SELECT 'fashion_male_clothing', 'Other' UNION ALL
    SELECT 'kitchen_dining_laundry_garden_furniture', 'Other' UNION ALL
    SELECT 'signaling_and_security', 'Other' UNION ALL
    SELECT 'construction_tools_safety', 'Other' UNION ALL
    SELECT 'home_appliances_2', 'Other' UNION ALL
    SELECT 'costruction_tools_garden', 'Other' UNION ALL
    SELECT 'food', 'Other' UNION ALL
    SELECT 'drinks', 'Other' UNION ALL
    SELECT 'construction_tools_lights', 'Other' UNION ALL
    SELECT 'agro_industry_and_commerce', 'Other' UNION ALL
    SELECT 'industry_commerce_and_business', 'Other' UNION ALL
    SELECT 'christmas_supplies', 'Other' UNION ALL
    SELECT 'audio', 'Other' UNION ALL
    SELECT 'art', 'Other' UNION ALL
    SELECT 'fashion_underwear_beach', 'Other' UNION ALL
    SELECT 'dvds_blu_ray', 'Other' UNION ALL
    SELECT 'furniture_bedroom', 'Other' UNION ALL
    SELECT 'costruction_tools_tools', 'Other' UNION ALL
    SELECT 'books_imported', 'Other' UNION ALL
    SELECT 'small_appliances_home_oven_and_coffee', 'Other' UNION ALL
    SELECT 'computers', 'Tech' UNION ALL
    SELECT 'cine_photo', 'Other' UNION ALL
    SELECT 'fashio_female_clothing', 'Other' UNION ALL
    SELECT 'music', 'Other' UNION ALL
    SELECT 'party_supplies', 'Other' UNION ALL
    SELECT 'fashion_sport', 'Other' UNION ALL
    SELECT 'arts_and_craftmanship', 'Other' UNION ALL
    SELECT 'flowers', 'Other' UNION ALL
    SELECT 'diapers_and_hygiene', 'Other' UNION ALL
    SELECT 'furniture_mattress_and_upholstery', 'Other' UNION ALL
    SELECT 'la_cuisine', 'Other' UNION ALL
    SELECT 'portable_kitchen_food_processors', 'Other' UNION ALL
    SELECT 'tablets_printing_image', 'Tech' UNION ALL
    SELECT 'fashion_childrens_clothes', 'Other' UNION ALL
    SELECT 'home_comfort_2', 'Other' UNION ALL
    SELECT 'pc_gamer', 'Tech' UNION ALL
    SELECT 'security_and_services', 'Other' UNION ALL
    SELECT 'cds_dvds_musicals', 'Other'
)
SELECT
    cs.excel_segment AS Segment_Name,
    CAST(COUNT(t2.order_item_id) AS UNSIGNED) AS Total_Items_Sold, 
    CAST(ROUND(AVG(t2.price), 2) AS DECIMAL(10, 2)) AS Average_Segment_Price
FROM products t1
JOIN order_items t2 ON t1.product_id = t2.product_id
JOIN product_category_name_translation t3 ON t1.product_category_name = t3.product_category_name
JOIN category_segment cs ON t3.product_category_name_english = cs.product_category_name_english
GROUP BY cs.excel_segment
ORDER BY Total_Items_Sold DESC;


/* Tech Segment Market Share
   Calculating the percentage of total sales generated by Tech products.
*/

WITH CategoryMapping AS (
    SELECT 'computers_accessories' AS cat, 'Tech' AS segment UNION ALL
    SELECT 'telephony', 'Tech' UNION ALL
    SELECT 'electronics', 'Tech' UNION ALL
    SELECT 'home_appliances', 'Tech' UNION ALL
    SELECT 'consoles_games', 'Tech' UNION ALL
    SELECT 'small_appliances', 'Tech' UNION ALL
    SELECT 'books_technical', 'Tech' UNION ALL
    SELECT 'fixed_telephony', 'Tech' UNION ALL
    SELECT 'computers', 'Tech' UNION ALL
    SELECT 'tablets_printing_image', 'Tech' UNION ALL
    SELECT 'pc_gamer', 'Tech'
),
TotalSales AS (
    SELECT COUNT(*) AS grand_total FROM order_items
)
SELECT 
    'Tech' AS segment_name,
    COUNT(oi.order_id) AS items_sold,
    ROUND((COUNT(oi.order_id) * 100.0) / (SELECT grand_total FROM TotalSales), 2) AS percentage_of_total_sales
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN product_category_name_translation t ON p.product_category_name = t.product_category_name
JOIN CategoryMapping m ON t.product_category_name_english = m.cat;


-- =============================================================================
-- 2. FINANCIAL & GEOGRAPHICAL REACH
-- =============================================================================

-- Distribution of payment values to identify typical order sizes
SELECT 
    payment_value,
    COUNT(order_id) AS number_of_orders
FROM order_payments
GROUP BY 1
ORDER BY 1;

-- Overall Average Order Value (AOV)
SELECT AVG(payment_value) AS average_order_value FROM order_payments;

-- AOV by state: Identifying regions with higher purchasing power
SELECT 
    c.customer_state,
    AVG(p.payment_value) AS avg_order_value_by_state
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_payments p ON o.order_id = p.order_id
GROUP BY c.customer_state
ORDER BY avg_order_value_by_state DESC;

-- TOP-3 states by Revenue & Customer concentration
SELECT 
    c.customer_state,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    SUM(p.payment_value) AS total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_payments p ON o.order_id = p.order_id
GROUP BY 1
ORDER BY total_revenue DESC
LIMIT 3;

-- Identifying the dominance of Sao Paulo (SP) in delivery volume
SELECT 
    customer_state,
    COUNT(order_id) AS order_count,
    ROUND(COUNT(order_id) * 100.0 / (SELECT COUNT(*) FROM orders), 2) AS percentage_of_total
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY customer_state
ORDER BY order_count DESC;

-- Geolocation data for customer density mapping
SELECT 
    g.geolocation_lat,
    g.geolocation_lng,
    c.customer_city
FROM customers c
JOIN geolocation g ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix
LIMIT 10000;

-- Analyzing seller concentration in Sao Paulo city
SELECT 
    city,
    COUNT(seller_id) AS seller_count,
    ROUND(COUNT(seller_id) * 100.0 / (SELECT COUNT(*) FROM sellers), 2) AS percentage
FROM sellers
GROUP BY city
ORDER BY seller_count DESC;

-- Global reach check: Confirming all sellers are domestic (Brazil-based)
SELECT 
    CASE WHEN seller_city IS NOT NULL THEN 'Brazil' ELSE 'Other' END AS country,
    COUNT(*) AS seller_count
FROM sellers
GROUP BY 1;


-- =============================================================================
-- 3. LOGISTICS PERFORMANCE: Delivery Time vs. Promises
-- =============================================================================

-- Percentage of orders delivered on-time vs. delayed
SELECT 
    CASE 
        WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 'On time'
        ELSE 'Delayed'
    END AS delivery_status,
    COUNT(order_id) AS order_count,
    ROUND(COUNT(order_id) * 100.0 / SUM(COUNT(order_id)) OVER(), 2) AS percentage
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL
GROUP BY 1;

-- Calculating the actual average delivery lead time (Purchase to Delivery)
SELECT 
    AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)) AS avg_delivery_days
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;

-- Comparison: Magist (Actual) vs. Eniac (Target)
SELECT 
    'Magist (Actual)' AS company,
    AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)) AS days
FROM orders
UNION ALL
SELECT 
    'Eniac (Target)' AS company, 
    3 AS days;