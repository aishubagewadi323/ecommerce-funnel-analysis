User Funnels Analysis

Executive Summary:

User conversion rates on this platform stand at 2.25%, with only 225 out of 10,000 homepage visitors completing a purchase. 
Using Python, MySQL, and Power BI, I analysed 17,175 funnel records across 5 stages to identify where users are dropping off and why. 
After identifying that the largest revenue opportunity is fixing the Cart → Checkout drop-off (70%), I recommend the product team implements the following:

1. Simplify the cart-to-checkout experience — reduce friction, add urgency signals.
2. Fix the homepage-to-product-page drop (50%) — improve CTAs and product discovery.
3. Address checkout-to-purchase failure (6.2%) — reduce payment friction.

Number impact: Improving Cart → Checkout conversion from 30% to 45% would generate ~225 additional users reaching checkout monthly —
a projected +50% lift in purchases.

Business Problem:
Users are visiting the platform but not completing purchases. Stakeholders need to understand where in the 5-stage funnel 
(Homepage → Product Page → Cart → Checkout → Purchase) users are dropping off, and what product changes would most improve revenue.

How can we identify the root cause of low conversion and make data-driven recommendations to increase purchase rates?

Methodology:

Using Python, I performed a full 7-step EDA on a 17,175-row funnel dataset, analysing user conversion and drop-off at each stage:

- Data wrangling — loaded and structured the 3-column funnel dataset
- Data cleaning — verified zero nulls, zero duplicates, validated stage and conversion values
- Data transformation — derived converted/dropped labels, stage-level aggregations
- Funnel analysis — computed conversion rates, drop-off %, and retention % per stage
- Visualisation — built 3 chart sets in Matplotlib (funnel, distributions, patterns)
- SQL analysis — 12 queries + master view in MySQL covering full funnel breakdown
- Dashboard — Power BI with funnel chart, KPI cards, DAX measures, and slicers

Skills:

`Data Wrangling` `Data Transformation` `Data Cleaning`

`Translating a Business Problem into Data` `Project Scoping` `Developing Insights`

`Business Recommendations` `Data Storytelling`

Results & Business Recommendations:**

Funnel Overview
| Stage | Users | Retention% | Stage Conv% | Drop-off% |
|---|---|---|---|---|
| Homepage | 10,000 | 100% | 100% | — |
| Product Page | 5,000 | 50.0% | 50.3% | -50.0% |
| Cart | 1,500 | 15.0% | 29.9% | -70.0% |
| Checkout | 450 | 4.5% | 8.0% | -70.0% |
| Purchase | 225 | 2.2% | 6.2% | -50.0% |

🔴 Finding 1 — Cart → Checkout: Biggest bottleneck (70% drop-off).

Only 450 out of 1,500 cart users proceed to checkout — the single largest leak in the funnel.

Recommendation: Add urgency signals (limited stock, countdown timers), simplify the checkout initiation step, and implement cart abandonment email sequences.

📉 Finding 2 — Homepage → Product Page: 50% drop-off.

Half of all homepage visitors don't click on any product.

Recommendation: A/B test homepage hero layout, improve product recommendations, make CTAs more prominent, and personalise the landing experience.

Finding 3 — Checkout → Purchase: Only 6.2% conversion.

36 out of 450 checkout users complete payment — this stage has the lowest conversion rate.

Recommendation: Reduce payment steps, offer multiple payment options (UPI, wallets, EMI), add trust badges and security indicators near the pay button.

🎯 Finding 4 — Overall conversion: 2.25%.

225 purchases from 10,000 homepage users. Industry average is 2–4% — this is at the lower end.

Recommendation: Fix Cart → Checkout first (highest volume drop-off), then address Checkout → Purchase (lowest conversion rate).


✅ Finding 5 — Homepage engagement is 100%.

All homepage users are counted as active — traffic quality is strong. The problem is entirely in the mid-to-lower funnel, not at the top.

Recommendation: No changes needed at the top of funnel. Focus all optimisation efforts from Product Page onwards.


Next Steps:

1. Fix Cart → Checkout — A/B test simplified cart flow; target 45%+ conversion at this stage
2. Improve Product Page CTAs — Redesign homepage-to-product journey; target 65%+ click-through
3. Reduce payment friction — Add UPI, wallets, buy-now-pay-later at checkout
4. Cart abandonment recovery — Email/SMS retargeting for users who added to cart but didn't checkout
5. Extended data collection — Add device, location, timestamp columns for deeper segmentation


Tech Stack

`Python` `Pandas` `Matplotlib` `MySQL` `Power BI` `Google Colab`

Dataset
[Kaggle — User Funnels Dataset](https://www.kaggle.com/datasets/amirmotefaker/user-funnels-dataset)
| 17,175 records | 3 columns | 5 funnel stages

Aishwarya Bagewadi | [LinkedIn](https://www.linkedin.com/in/aishwarya-bagewadi) | [GitHub](https://github.com/aishwarya-bagewadi)


