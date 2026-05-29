from google.cloud import bigquery

client = bigquery.Client(project="brilliant-vent-489218-d2")


def run_check(client,check_name,query,pass_condition) :

    results = client.query(query).to_dataframe()
    value = results.iloc[0,0]
    status = "PASSED" if pass_condition(value) else "FAILED"
    return {"check_name": check_name, "value": value, "status" :status }


checks_results = []

checks_results.append(run_check(client,"raw_orders_row_count",
          "Select Count(*) as row_count FROM analytics_engineering_raw.raw_orders",lambda x : x > 10000))


checks_results.append(run_check(client,"raw_payments_row_count",
          "Select Count(*) as row_count from brilliant-vent-489218-d2.analytics_engineering_raw.raw_payments",lambda x : x > 50000))

checks_results.append(run_check(client,"null_check_raw_orderid", 
                            "SELECT COUNTIF(order_id IS NULL) AS null_order_ids FROM analytics_engineering_raw.raw_orders",lambda x: x == 0))


checks_results.append(run_check(client,"null_check_raw_paymentvalue", 
                            "SELECT CountIf(payment_value IS Null) as PaymentValue_NullCount from brilliant-vent-489218-d2.analytics_engineering_raw.raw_payments",lambda x: x == 0))


checks_results.append(run_check(client,"range_check_raw_paymentvalue", 
                            "SELECT Count(case when payment_value <= 0 then 1 END) as price_rangecount from brilliant-vent-489218-d2.analytics_engineering_raw.raw_payments",lambda x: x == 0))


for row in checks_results:
    print(f"checkname : {row['check_name']} status : {row['status']} value : {row['value']}")



failed = [r for r in checks_results if r["status"] == "FAILED"]

if failed:
    print("\nVALIDATION FAILED — DO NOT RUN DBT")
else:
    print("\nALL CHECKS PASSED — SAFE TO RUN DBT")