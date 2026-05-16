## Payment Intelligence — Fixing Misleading Metrics

An end-to-end analytics engineering project built with dbt Core and BigQuery (GCP), demonstrating production-grade data modeling, automated data quality testing, and metric validation.

### Problem
Standard BI dashboards reported Average Order Value (AOV) correctly — but the underlying data had a silent data failure. Payment-level aggregation was being mixed with order-level grain, inflating the AOV metric by ~16% and masking true discount behavior.

### Solution
Built a layered ELT pipeline (staging → intermediate → mart) using dbt Core with:
- Automated schema tests (not_null, unique, accepted_values) for data unit testing
- Cross-pipeline reconciliation checks for data observability
- Grain-level validation to detect join duplication and aggregation errors
- Documented data lineage across all transformation layers

### Key findings
- Corrected ~16% AOV miscalculation caused by payment-level vs. order-level grain mismatch
- Discovered ~65% of voucher revenue came from mixed-payment users — not voucher-only users
- Revealed discount strategy was being misinterpreted due to silent data failure in upstream aggregation

### Tech stack
dbt Core · BigQuery · GCP · Advanced SQL (CTEs, window functions, aggregations) · Git · Python
