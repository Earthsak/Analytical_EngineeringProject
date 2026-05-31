import subprocess
from google.cloud import bigquery

client = bigquery.Client(project="brilliant-vent-489218-d2")

dataset = [ 
    {"csv": "raw_orders.csv", "table": "raw_orders"},
    {"csv": "raw_payments.csv", "table": "raw_payments"},
    {"csv": "raw_customers.csv", "table": "raw_customers"},
    {"csv": "raw_order_items.csv", "table": "raw_order_items"},
    {"csv": "raw_products.csv", "table": "raw_product"}
    ]

csv_path = "E:/Project/DatasetDBT/archive/BigQuery/"



def load_table(client,csv_path,table_id):
    
    job_config = bigquery.LoadJobConfig(
        source_format = bigquery.SourceFormat.CSV,
        skip_leading_rows = 1,
        autodetect = True,
        write_disposition = "WRITE_TRUNCATE"
    )
    with open(csv_path,"rb") as file:
        job = client.load_table_from_file(file,table_id,job_config=job_config)

        job.result()

        return job.output_rows

load_results = []  

for r in dataset:
    result_entry = {
         "table" : r["table"],
         "status": "Pending",
         "rows_loaded":"0",
         "error":"none"
    }
    try:
           rows = load_table(client,csv_path + r["csv"],f"brilliant-vent-489218-d2.analytics_engineering_raw.{r['table']}") 
           print(f"{r['table']} loaded successfully — {rows} rows")
           result_entry["status"] = "PASSED"
           result_entry["rows_loaded"] = {rows}
    except Exception as e:
          print(f"{r['table']} FAILED: {e}")
          result_entry["status"] = "FAILED"
          result_entry["error"] = {e}

    load_results.append(result_entry)


failed = [r for r in load_results if r["status"] == "FAILED"]

if failed:
    print("\nLoad FAILED ")
    exit(1)
else:
    print("\n Data loaded sucessfully ..... running validation framework")


def run_check(  client,check_name,query,pass_condition):
    results = client.query(query).to_dataframe()
    value = results.iloc[0,0] 
    status = "PASSED" if pass_condition(value)  else "FAILED"
    return {"check_name": check_name ,"value":value, "status": status}

checks_results = []

checks_results.append(run_check(client,"raw_orders_row_count",
          "Select Count(*) as row_count FROM analytics_engineering_raw.raw_orders",lambda x : x > 10000))


checks_results.append(run_check(client,"raw_payments_row_count",
          "Select Count(*) as row_count FROM analytics_engineering_raw.raw_payments",lambda x : x > 50000))

checks_results.append(run_check(client,"raw_order_items_row_count",
          "Select Count(*) as row_count FROM analytics_engineering_raw.raw_order_items",lambda x : x > 20000))

checks_results.append(run_check(client,"raw_customers_row_count",
          "Select Count(*) as row_count FROM analytics_engineering_raw.raw_customers",lambda x : x > 10000))

checks_results.append(run_check(client,"raw_payments_row_count",
          "Select Count(*) as row_count FROM analytics_engineering_raw.raw_products",lambda x : x > 10000))


checks_results.append(run_check(client,"null_check_raw_orderid", 
                            "SELECT COUNTIF(order_id IS NULL) AS null_order_ids FROM analytics_engineering_raw.raw_orders",lambda x: x == 0))

checks_results.append(run_check(client,"null_check_raw_paymentvalue", 
                            "SELECT COUNTIF(payment_value IS NULL) AS null_payment_value FROM analytics_engineering_raw.raw_payments",lambda x: x == 0))

checks_results.append(run_check(client,"null_check_raw_order_itemId", 
                            "SELECT COUNTIF(order_item_id IS NULL) AS null_order_itemid FROM analytics_engineering_raw.raw_order_items",lambda x: x == 0))

checks_results.append(run_check(client,"null_check_raw_customerid", 
                            "SELECT COUNTIF(customer_id IS NULL) AS null_customer_ids FROM analytics_engineering_raw.raw_customers",lambda x: x == 0))

checks_results.append(run_check(client,"null_check_raw_productid", 
                            "SELECT COUNTIF(product_id IS NULL) AS null_product_ids FROM analytics_engineering_raw.raw_products",lambda x: x == 0))


checks_results.append(run_check(client,"range_check_raw_paymentvalue", 
                            "SELECT Count(case when payment_value <= 0 then 1 END) as price_rangecount from brilliant-vent-489218-d2.analytics_engineering_raw.raw_payments",lambda x: x == 0))



failed = [r for r in checks_results if r["status"] == "FAILED"]

if failed:
    for f in failed:
     print(f"FAILED CHECK: {f["check_name"]} | value: {f["value"]}")
   
    print("\nWARNINGS FOUND — PROCEEDING WITH DBT RUN")
    
else:
     print("\nALL CHECKS PASSED — SAFE TO RUN DBT")

final_result = subprocess.run(
     ["dbt","run","--project-dir", "E:/New_DBT/ecommerce_dbt"],
     capture_output=True,
     text=True)
if final_result.returncode == 0 :
          print("dbt run sucessfully")
          print(final_result.stdout)
else:
         print("dbt run failed")
         print(final_result.stderr)     