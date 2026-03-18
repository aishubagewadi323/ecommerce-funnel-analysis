# 📊 Power BI Dashboard Guide
## User Funnels Analysis

---

## 📁 STEP 1 — Import CSV Files

1. Open **Power BI Desktop**
2. Click **Home → Get Data → Text/CSV**
3. Import these 3 files:
   - `pbi_master.csv` ← main table (17,175 rows)
   - `pbi_funnel_summary.csv` ← stage-level summary
   - `pbi_conv_vs_dropped.csv` ← converted vs dropped per stage
4. Click **Load** for each

---

## 🔗 STEP 2 — No Relationships Needed
All files are pre-aggregated. Use `pbi_master.csv` as your main fact table.

---

## 🎨 STEP 3 — Build These 6 Visuals

### Visual 1 — Funnel Chart
- **Type:** Funnel Chart
- **Source:** `pbi_funnel_summary`
- **Category:** `stage`
- **Values:** `total_users`
- **Title:** "User Funnel — Homepage to Purchase"

### Visual 2 — KPI Cards (5 cards)
- **Type:** Card
- Values to show:
  - Total Homepage Users: `10,000`
  - Reached Cart: `1,500`
  - Reached Checkout: `450`
  - Completed Purchase: `225`
  - Overall Conversion: `2.25%`

### Visual 3 — Conversion Rate per Stage (Bar)
- **Type:** Clustered Column Chart
- **Source:** `pbi_funnel_summary`
- **X-axis:** `stage`
- **Y-axis:** `conv_rate_pct`
- **Title:** "Conversion Rate at Each Stage (%)"

### Visual 4 — Drop-off % per Stage (Bar)
- **Type:** Clustered Column Chart
- **Source:** `pbi_funnel_summary`
- **X-axis:** `stage`
- **Y-axis:** `dropoff_pct`
- **Data colors:** Red (#E8544C)
- **Title:** "Stage-to-Stage Drop-off (%)"

### Visual 5 — Converted vs Dropped (Stacked Bar)
- **Type:** Stacked Bar Chart
- **Source:** `pbi_conv_vs_dropped`
- **Y-axis:** `stage`
- **X-axis:** `users`
- **Legend:** `conversion_label`
- **Colors:** Converted = Green, Dropped = Red
- **Title:** "Converted vs Dropped per Stage"

### Visual 6 — Retention Line Chart
- **Type:** Line Chart
- **Source:** `pbi_funnel_summary`
- **X-axis:** `stage`
- **Y-axis:** `retention_pct`
- **Title:** "User Retention from Homepage (%)"

---

## 🧮 STEP 4 — DAX Measures

```dax
-- Overall Conversion Rate
Overall Conv % =
DIVIDE(
    CALCULATE(COUNTROWS(pbi_master), pbi_master[stage] = "purchase"),
    CALCULATE(COUNTROWS(pbi_master), pbi_master[stage] = "homepage")
) * 100

-- Total Converted
Total Converted =
CALCULATE(COUNTROWS(pbi_master), pbi_master[conversion_label] = "Converted")

-- Total Dropped
Total Dropped =
CALCULATE(COUNTROWS(pbi_master), pbi_master[conversion_label] = "Dropped")

-- Cart Drop-off Rate
Cart Dropoff % =
DIVIDE(
    CALCULATE(COUNTROWS(pbi_master),
              pbi_master[stage] = "cart",
              pbi_master[conversion_label] = "Dropped"),
    CALCULATE(COUNTROWS(pbi_master), pbi_master[stage] = "cart")
) * 100
```

---

## 🎛️ STEP 5 — Add Slicers

- **Slicer 1:** `stage` — filter by funnel stage
- **Slicer 2:** `conversion_label` — Converted / Dropped

---

## 🖥️ STEP 6 — Dashboard Layout

```
┌─────────────────────────────────────────────────────────┐
│  🛒 User Funnels Dashboard                              │
│  [Stage Slicer]  [Conversion Slicer]                    │
├──────────┬──────────┬──────────┬──────────┬────────────┤
│ 10,000   │  1,500   │   450    │   225    │  2.25%     │
│ Homepage │   Cart   │ Checkout │ Purchase │ Overall    │
├──────────┴──────────┴──────────┴──────────┴────────────┤
│                                                          │
│              Funnel Chart (Visual 1)                     │
│                                                          │
├────────────────────────┬────────────────────────────────┤
│  Conv Rate % (Bar)     │  Drop-off % (Bar)              │
│  (Visual 3)            │  (Visual 4)                    │
├────────────────────────┼────────────────────────────────┤
│  Conv vs Dropped       │  Retention Line                │
│  (Visual 5)            │  (Visual 6)                    │
└────────────────────────┴────────────────────────────────┘
```

---

## 🎨 STEP 7 — Styling Tips
- **Theme:** View → Themes → **Executive** (dark)
- **Funnel colors:** Blue → Teal → Orange → Red → Purple
- **Canvas:** 1280 × 720 (16:9)
- Save as `user_funnels_dashboard.pbix`

---

## ✅ Checklist
- [ ] 3 CSV files imported
- [ ] 6 visuals created
- [ ] 4 DAX measures added
- [ ] 2 slicers added
- [ ] Theme applied
- [ ] Saved as .pbix

---
*Dataset: Kaggle — User Funnels Dataset*
