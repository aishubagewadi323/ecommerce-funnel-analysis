-- SECTION 1: DATABASE & TABLE SETUP

CREATE DATABASE IF NOT EXISTS user_funnels;
USE user_funnels;

DROP TABLE IF EXISTS user_data;

CREATE TABLE user_data (
    id         INT           AUTO_INCREMENT PRIMARY KEY,
    user_id    VARCHAR(20)   NOT NULL,
    stage      VARCHAR(30)   NOT NULL,
    conversion VARCHAR(10)   NOT NULL  -- store as 'True'/'False' text
);

-- SECTION 2: LOAD DATA
-- ============================================================
-- Update path to match where your CSV is saved
-- Use forward slashes even on Windows!


-- Verify load
SELECT COUNT(*) AS total_rows FROM user_data;
SELECT stage, COUNT(*) AS stage_rows FROM user_data GROUP BY stage;


-- ============================================================
-- SECTION 3: DATA QUALITY CHECK
-- ============================================================

-- Q1: Check for nulls
SELECT
    SUM(CASE WHEN user_id    IS NULL THEN 1 ELSE 0 END) AS null_user_id,
    SUM(CASE WHEN stage      IS NULL THEN 1 ELSE 0 END) AS null_stage,
    SUM(CASE WHEN conversion IS NULL THEN 1 ELSE 0 END) AS null_conversion
FROM user_data;

-- Q2: Check distinct stages (should be exactly 5)
SELECT DISTINCT stage FROM user_data ORDER BY stage;

-- Q3: Check conversion values (should only be 0 and 1)
SELECT DISTINCT conversion FROM user_data;


-- ============================================================
-- SECTION 4: FUNNEL ANALYSIS QUERIES
-- ============================================================

-- ── Q4: Users at each funnel stage ───────────────────────────
SELECT
    stage,
    COUNT(*)                              AS total_users,
    SUM(conversion)                       AS converted_users,
    COUNT(*) - SUM(conversion)            AS dropped_users,
    ROUND(SUM(conversion)/COUNT(*)*100,1) AS conversion_rate_pct
FROM user_data
GROUP BY stage
ORDER BY
    CASE stage
        WHEN 'homepage'     THEN 1
        WHEN 'product_page' THEN 2
        WHEN 'cart'         THEN 3
        WHEN 'checkout'     THEN 4
        WHEN 'purchase'     THEN 5
    END;


-- ── Q5: Stage-to-stage drop-off ──────────────────────────────
SELECT
    stage,
    COUNT(*)                                                   AS users,
    LAG(COUNT(*)) OVER (ORDER BY
        CASE stage
            WHEN 'homepage'     THEN 1
            WHEN 'product_page' THEN 2
            WHEN 'cart'         THEN 3
            WHEN 'checkout'     THEN 4
            WHEN 'purchase'     THEN 5
        END)                                                   AS prev_stage_users,
    ROUND(
        (LAG(COUNT(*)) OVER (ORDER BY
            CASE stage
                WHEN 'homepage'     THEN 1
                WHEN 'product_page' THEN 2
                WHEN 'cart'         THEN 3
                WHEN 'checkout'     THEN 4
                WHEN 'purchase'     THEN 5
            END) - COUNT(*))
        / LAG(COUNT(*)) OVER (ORDER BY
            CASE stage
                WHEN 'homepage'     THEN 1
                WHEN 'product_page' THEN 2
                WHEN 'cart'         THEN 3
                WHEN 'checkout'     THEN 4
                WHEN 'purchase'     THEN 5
            END) * 100
    , 1)                                                       AS dropoff_pct
FROM user_data
GROUP BY stage
ORDER BY
    CASE stage
        WHEN 'homepage'     THEN 1
        WHEN 'product_page' THEN 2
        WHEN 'cart'         THEN 3
        WHEN 'checkout'     THEN 4
        WHEN 'purchase'     THEN 5
    END;


-- ── Q6: Overall funnel conversion (Homepage → Purchase) ──────
SELECT
    MAX(CASE WHEN stage = 'homepage'     THEN cnt END) AS homepage_users,
    MAX(CASE WHEN stage = 'product_page' THEN cnt END) AS product_page_users,
    MAX(CASE WHEN stage = 'cart'         THEN cnt END) AS cart_users,
    MAX(CASE WHEN stage = 'checkout'     THEN cnt END) AS checkout_users,
    MAX(CASE WHEN stage = 'purchase'     THEN cnt END) AS purchase_users,
    ROUND(
        MAX(CASE WHEN stage = 'purchase'  THEN cnt END) /
        MAX(CASE WHEN stage = 'homepage'  THEN cnt END) * 100
    , 3)                                                AS overall_conv_pct
FROM (
    SELECT stage, COUNT(*) AS cnt
    FROM user_data
    GROUP BY stage
) sub;


-- ── Q7: Conversion rate by stage — converted vs not ──────────
SELECT
    stage,
    SUM(CASE WHEN conversion = 1 THEN 1 ELSE 0 END)  AS converted,
    SUM(CASE WHEN conversion = 0 THEN 1 ELSE 0 END)  AS not_converted,
    COUNT(*)                                           AS total,
    ROUND(SUM(conversion) / COUNT(*) * 100, 2)        AS conv_rate_pct
FROM user_data
GROUP BY stage
ORDER BY
    CASE stage
        WHEN 'homepage'     THEN 1
        WHEN 'product_page' THEN 2
        WHEN 'cart'         THEN 3
        WHEN 'checkout'     THEN 4
        WHEN 'purchase'     THEN 5
    END;


-- ── Q8: Users who passed all 5 stages (full journey) ─────────
SELECT
    user_id,
    COUNT(DISTINCT stage) AS stages_reached
FROM user_data
WHERE conversion = 1
GROUP BY user_id
HAVING COUNT(DISTINCT stage) = 5;


-- ── Q9: Users who dropped at each specific stage ─────────────
SELECT
    stage                                         AS dropped_at_stage,
    COUNT(*)                                      AS users_dropped
FROM user_data
WHERE conversion = 0
GROUP BY stage
ORDER BY
    CASE stage
        WHEN 'homepage'     THEN 1
        WHEN 'product_page' THEN 2
        WHEN 'cart'         THEN 3
        WHEN 'checkout'     THEN 4
        WHEN 'purchase'     THEN 5
    END;


-- ── Q10: Percentage of total users who dropped at each stage ─
SELECT
    stage                                                      AS dropped_at_stage,
    COUNT(*)                                                   AS users_dropped,
    ROUND(COUNT(*) / (SELECT COUNT(*) FROM user_data
                      WHERE conversion = 0) * 100, 1)         AS pct_of_all_dropoffs
FROM user_data
WHERE conversion = 0
GROUP BY stage
ORDER BY
    CASE stage
        WHEN 'homepage'     THEN 1
        WHEN 'product_page' THEN 2
        WHEN 'cart'         THEN 3
        WHEN 'checkout'     THEN 4
        WHEN 'purchase'     THEN 5
    END;


-- ── Q11: Stage-wise summary with cumulative retention ─────────
SELECT
    stage,
    COUNT(*)                                                   AS users,
    ROUND(COUNT(*) / 10000 * 100, 1)                          AS retention_from_homepage_pct,
    ROUND(SUM(conversion) / COUNT(*) * 100, 1)                AS stage_conv_rate_pct
FROM user_data
GROUP BY stage
ORDER BY
    CASE stage
        WHEN 'homepage'     THEN 1
        WHEN 'product_page' THEN 2
        WHEN 'cart'         THEN 3
        WHEN 'checkout'     THEN 4
        WHEN 'purchase'     THEN 5
    END;


-- ── Q12: Top 10 users by stages completed ────────────────────
SELECT
    user_id,
    COUNT(DISTINCT stage)                          AS stages_visited,
    SUM(conversion)                                AS total_conversions
FROM user_data
GROUP BY user_id
ORDER BY stages_visited DESC, total_conversions DESC
LIMIT 10;
