Welcome to your new dbt project!

### Using the starter project

Try running the following commands:
- dbt run
- dbt test

📊 Payment Intelligence: Fixing Misleading Metrics in E-commerce

🚨 Problem

Most dashboards analyze payment behavior using incomplete metrics.

Voucher usage appears high when measured by % of orders
But this hides the real impact on revenue and order value

Additionally, Average Order Value (AOV) is often calculated incorrectly at the payment level, leading to distorted insights.

🔍 What I Did

Built an end-to-end analytics pipeline using dbt + BigQuery
Modeled data across staging → intermediate → mart layers
Validated metric correctness and resolved aggregation & grain issues
Designed transformations to ensure accurate order-level analysis


⚠️ Key Issues Identified

Misleading Voucher Metrics
High order usage ≠ high revenue contribution
Incorrect AOV Calculation
Payment-level aggregation inflated AOV
Fixed by shifting to order-level grain
Complex Payment Behavior
Orders frequently use multiple payment types


📈 Key Insights

Voucher orders have ~16% lower AOV compared to non-voucher orders
Voucher-driven orders account for ~3.9% of orders but only ~3.3% of revenue
~65% of voucher revenue comes from mixed payment users (voucher + credit card)
Vouchers act as a discount layer, not just a standalone payment method


🏗️ Data Model

Staging Layer: Cleaned raw payment and order data
Intermediate Layer: Aggregated order-level metrics and payment combinations
Mart Layer: Business-ready datasets for analysis


✅ Key Outcomes

Improved metric accuracy by fixing aggregation logic
Ensured 100% revenue reconciliation across layers
Translated technical corrections into business-relevant insights


🛠️ Tech Stack

BigQuery
dbt
SQL



### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices


Power BI
