# 🔐 Vaultly SaaS Analytics Dashboard
**End-to-End BI Project | SQL Server · Power BI · Power Query · DAX · Figma · SaaS Metrics**

---

## 📌 Project Overview

Vaultly's marketing team was celebrating strong top-of-funnel numbers — high traffic, high sign-ups, big spend on paid social — while the executive team watched Monthly Recurring Revenue (MRR) growth flatline and churn quietly climb. Top-line growth and healthy retention are not the same thing, and nobody had a single source of truth to tell them apart.

This project puts me in the seat of an **Analytics Engineer / BI Developer** for **Vaultly**, a B2C personal finance SaaS startup. Vaultly's product helps everyday users track spending, set category budgets, and monitor savings goals on mobile and web, monetized entirely through monthly and annual subscription plans.

Leadership needed to move off manual spreadsheet reporting and get straight answers to five questions from three different stakeholders (CFO, Head of Marketing, Head of Product):

| # | Question | Who Is Asking | Why They Need It |
|---|---|---|---|
| 1 | Which users are churning before their second invoice, and what do they have in common? | CFO | Quantify revenue loss by segment and justify intervention spend |
| 2 | Are users acquired through paid social completing onboarding at the same rate as organic users? | Head of Marketing | Decide whether to cut, redirect, or restructure paid spend |
| 3 | At what point in the product flow do users disengage before cancelling? | Head of Product | Identify exactly where the onboarding fix needs to go |
| 4 | What is the lifetime value of a user who completes onboarding versus one who does not? | CFO | Quantify the financial case for building an onboarding intervention |
| 5 | Which subscription plan has the highest churn rate, and is it correlated with acquisition channel? | Head of Marketing | Reprice or reposition plans based on which ones attract the wrong users |

> **The goal:** build a full SQL Server → Power BI pipeline that turns raw operational exports into a two-page executive dashboard showing exactly where subscribers are lost, which acquisition channels bring durable revenue versus disposable sign-ups, and where product-led intervention will move the needle more than a marketing discount.

---

## 🛠️ Tech Stack

| Tool | Purpose |
|------|---------|
| SQL Server | Relational database design, bulk data load, data cleaning, metric validation |
| Power BI | Data modeling (star schema), DAX measures, dashboard build |
| Power Query | Connecting Power BI directly to SQL Server, transformation checks |
| DAX | Core SaaS measures — MRR, LTV, CAC, Churn Rate, funnel and activation metrics |
| Figma | Wireframing and pixel-perfect background design for both dashboard pages |
| Power BI Slicers | Country, Age Group, and Year filtering across both pages |

---

## 📂 Repository Structure

```
Vaultly_SaaS_Analytics/
│
├── assets/
│   ├── pg_1_exec_summary.png
│   ├── pg_2_marketing_products.png
│   └── business_questions.png
│
├── data/
│   ├── users.csv
│   ├── acquisition.csv
│   ├── subscriptions.csv
│   ├── invoices.csv
│   ├── onboarding_events.csv
│   ├── product_events.csv
│   └── date_dimension.csv
│
├── sql/
│   ├── 01_create_database.sql
│   ├── 02_bulk_insert.sql
│   └── 03_data_cleaning.sql
│
├── design/
│   └── Vaultly_Wireframes.fig
│
├── Vaultly SaaS Analytics.pbix
│
└── README.md
```

---

## ⚙️ Project Pipeline

```
Phase 1 → Database Design (SQL Server star schema: 6 source tables + Date dimension)
Phase 2 → Bulk Data Load (BULK INSERT from flat files into staging → production)
Phase 3 → Data Cleaning (SQL — standardize text, handle nulls, uniform date formats)
Phase 4 → Data Modeling (Power BI ↔ SQL Server, relationships, cross-filter direction)
Phase 5 → DAX Measures (MRR, LTV, CAC, Churn, Onboarding, Activation, Funnel)
Phase 6 → Metric Validation (SQL queries cross-checked against DAX matrix outputs)
Phase 7 → UI/UX Design (Figma wireframes → exported backgrounds → Power BI build)
Phase 8 → Insights & Recommendations
```

---

## 📊 Headline KPIs (Page 1 — Executive Summary)

| Metric | Value |
|---|---|
| MRR | $29.91K |
| Churn Rate | 43.26% |
| LTV | $14.17 |
| CAC | $20.59 |
| Revenue Mix — Annual | $1.25M (71.86%) |
| Revenue Mix — Monthly | $0.49M (28.14%) |

---

## 🧭 Page 1 — Executive Summary (CFO View)
**Question:** *Which users are churning before their second invoice, and what's the true lifetime value math behind each acquisition channel?*

- **Paid Social is the most expensive channel by far**: CAC of **$41.06** versus **$8.84** (Direct), **$8.47** (Organic Search), and **$10.68** (Referral) — roughly 4–5x the cost of every other channel.
- **Paid Social also has the highest churn (45.83%)** and the **lowest LTV ($13.15)** of any channel, meaning it is simultaneously the most expensive to acquire and the least durable once acquired — a direct hit to unit economics.
- **Referral is the healthiest channel on paper**: lowest CAC-to-LTV imbalance, with LTV ($15.28) comfortably outpacing CAC ($10.68), and mid-table churn (41.83%).
- **Churn is highest among older users**: the 35–44 age band churns at **13.16%**, nearly double the rate of 25–34 (**7.95%**), suggesting onboarding friction (rather than product-market fit) may be disproportionately affecting less digitally-native segments.
- Revenue is heavily annual-weighted (71.86% of net revenue), which cushions reported churn optics — a subscriber cancelling mid-contract doesn't show up in MRR the same month it happens, delaying the CFO's visibility into the problem.

**Insight:** Paid Social is funding the fastest top-of-funnel growth and the fastest revenue leak at the same time. Every dollar spent acquiring a Paid Social subscriber returns less lifetime value than a dollar spent on any other channel, while costing 4–5x more to spend in the first place.

---

## 🧭 Page 2 — Marketing & Product Insights
**Question:** *Are paid social users completing onboarding at the same rate as organic users, and exactly where in the product flow are they disengaging?*

**Onboarding funnel (per 16.04K accounts created):**

| Stage | Volume | % of Start |
|---|---|---|
| Account Created | 16.04K | 100% |
| Profile Setup | 16.04K | 100% |
| Bank Account Connect | 16.04K | 100% |
| Budget Setup | 9.41K | 58.7% |
| Savings Setup | 8.57K | 53.4% |
| Onboarding Complete | 7.81K | 48.7% |

- **The drop-off is sharp and singular**: every user connects their bank account, but the funnel collapses by more than 40 points the moment users hit **Budget Setup** — this is the exact bottleneck the Head of Product asked about.
- **Onboarding Completion sits at 48.69%** overall, and **Activation Rate at 53.40%**, meaning roughly half of all new subscribers never reach the point where the product delivers its core value.
- **Direct is the largest acquisition channel by volume**, followed by Paid Social, Organic Search, and Referral — but volume and quality diverge sharply once churn is layered in.
- **Churn by Plan × Channel** confirms the Paid Social problem is plan-agnostic: Paid Social churns highest on both Annual (27.34%) and Monthly (28.59%) plans, while Organic Search and Referral stay several points lower on both.
- **Subscriber distribution** shows Paid Social carrying the largest churned-user count relative to its base (1.6K churned of ~5.7K acquired), a visibly worse ratio than Organic Search, Direct, or Referral.

**Insight:** Paid Social users complete onboarding at a meaningfully lower rate than organic channels, and the specific point of failure — Budget Setup — is a product moment, not a marketing or landing-page moment. Fixing acquisition targeting alone won't move this number; the fix has to live inside the product.

---

## 🧱 Data Modeling — SQL Server Star Schema

Unlike a single flat export, Vaultly's data arrived as **six raw source tables**, which I loaded into a purpose-built SQL Server database and modeled as a star schema before ever touching Power BI.

**Source Tables (loaded via BULK INSERT)**
- `users` — subscriber demographics, country, age group
- `acquisition` — acquisition channel and campaign metadata per user
- `subscriptions` — plan type (Monthly/Annual), plan tier, subscription status
- `invoices` — billing history, used to derive MRR and identify pre-second-invoice churn
- `onboarding_events` — timestamped event log across the onboarding funnel
- `product_events` — in-product usage events post-onboarding

**Dimension Table**
- `date_dimension` — custom Date table covering 3 years of history (2024 – present) with Day, Week, Month, Quarter, and Year hierarchies for time intelligence

**Relationships**
In Power BI's Model View, all relationships were set one-to-many from dimension tables into the `subscriptions` and `invoices` fact tables, with single-direction cross-filtering to avoid ambiguous filter paths and "flatlining" errors in visuals that mix funnel, revenue, and demographic slicers on the same page.

---

## 🧹 Data Cleaning & Standardization (SQL Server)

All cleaning happened in SQL before the data ever reached Power BI, so every downstream DAX measure was built on a single verified source of truth:

- **Standardized text fields** — reconciled inconsistent naming across acquisition channels and user demographics (e.g. "paid_social" / "Paid Social" / "PaidSocial" collapsed into one canonical value)
- **Handled nulls** — replaced blank `cancellation_date` values with explicit logic to distinguish active subscribers from churned ones, rather than leaving ambiguous blanks
- **Uniform date formatting** — normalized all timestamp fields to `YYYY-MM-DD` to support clean joins against the Date dimension
- **Bulk load validation** — verified row counts and key integrity between staging and production tables after each `BULK INSERT`

---

## 🧮 DAX Measures

Core SaaS measures were built in Power BI and cross-verified line-by-line against equivalent SQL Server validation queries before the dashboard went to stakeholders:

| Measure | Purpose |
|---|---|
| MRR | Monthly Recurring Revenue, normalized across Monthly and Annual plans |
| Churn Rate % | Share of subscribers cancelling within the period, sliceable by plan, channel, and age group |
| LTV | Customer Lifetime Value, derived from invoice history and average subscriber lifespan |
| CAC | Customer Acquisition Cost, mapped by acquisition channel |
| Net Revenue | Revenue net of churned-user losses, by channel |
| Onboarding Completion Rate | Share of created accounts that finish all onboarding steps |
| Activation Rate | Share of users reaching defined "activated" product usage |
| Funnel Stage Volumes | Step-by-step counts across Account Created → Onboarding Complete |
| Revenue Plan Mix % | Monthly vs. Annual share of total net revenue |

**Metric verification:** every measure above was checked against a standalone SQL query on the same underlying tables — not just spot-checked, but compared row-for-row against the Power BI visual matrix — before being signed off as stakeholder-ready.

---

## 🎨 UI/UX Design Process

Rather than building visuals directly in Power BI, I designed both dashboard pages in **Figma** first:

1. Established a cohesive dark-green, financial-app aesthetic consistent with the Vaultly brand
2. Structured page real estate — high-level KPI cards up top, trend lines and channel breakdowns below
3. Exported pixel-perfect background layouts and imported them into Power BI, keeping native Power BI shapes to a minimum and reducing report-level rendering overhead

---

## 🎯 What I Focused On

| Focus Area | Approach |
|---|---|
| Metric selection | Paired every acquisition metric (volume, sign-ups) with a durability metric (churn, LTV) so growth couldn't be judged on volume alone |
| Funnel diagnosis | Broke onboarding into six discrete steps to isolate Budget Setup as the exact failure point, not just "onboarding" broadly |
| Channel accountability | Cross-tabbed churn by Plan × Channel and CAC/LTV by channel instead of reporting acquisition volume in isolation |
| Data integrity | Verified every DAX measure against a parallel SQL query before it reached a stakeholder view |
| Stakeholder framing | Split the two pages by audience — CFO-first financial view, then Marketing/Product operational view — instead of one undifferentiated dashboard |

---

## 💡 Key Insights & Recommendations

1. **The onboarding drop-off is concentrated, not diffuse.** Churn isn't a general market problem — it's heavily front-loaded at Budget Setup, the step immediately after Bank Account Connect. Fixing this single step has more leverage than any broad retention campaign.
2. **The Paid Social illusion.** Paid Social looks like the growth engine on sign-up volume alone, but it churns at nearly the highest rate of any channel and returns the lowest LTV — it is buying temporary users, not durable ones.
3. **The leaky revenue bucket.** Paid Social represents a large share of acquired users but an outsized share of churned revenue, driven by users selecting premium annual tiers and dropping out well before recouping their acquisition cost.
4. **Recommendation passed to stakeholders:** skip the blanket marketing discount. Build a **targeted, guided onboarding walkthrough for Budget Setup**, prioritized for users acquired via Paid Social, where the CAC-to-churn mismatch is most severe. This is a product-led fix, not a pricing or acquisition fix.
5. **Reprice or reposition Paid Social spend** once the onboarding fix is live — CAC of $41 only makes sense if churn and LTV move to match the other channels; otherwise budget should shift toward Referral and Organic Search, where LTV already outpaces CAC.

---

## 📄 Deliverables

| Deliverable | Description |
|---|---|
| `Vaultly SaaS Analytics.pbix` | Full Power BI file — data model, DAX measures, two-page dashboard |
| `sql/*.sql` | Database creation, bulk insert, and data cleaning scripts |
| `data/*.csv` | Six source tables (users, acquisition, subscriptions, invoices, onboarding_events, product_events) plus the Date dimension |
| `design/Vaultly_Wireframes.fig` | Original Figma wireframes used as Power BI backgrounds |
| `assets/*.png` | Screenshots of both dashboard pages and the stakeholder business-questions brief |
| `README.md` | Full project documentation |

---

## 👤 Author

**[Your Name]**
Data / Analytics Engineer

*An end-to-end SQL Server → Power BI analytics build for a B2C personal finance SaaS product — from raw operational exports to a stakeholder-ready churn, retention, and acquisition dashboard.*
