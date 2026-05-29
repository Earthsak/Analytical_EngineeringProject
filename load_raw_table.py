from google.cloud import bigquery


client = bigquery.Client(project="brilliant-vent-489218-d2")

csv_path = "E:/Project/DatasetDBT/archive/BigQuery/"



def load_table(client,csv_path,table_id):
    job_config = bigquery.LoadJobConfig(
        source_format = bigquery.SourceFormat.CSV,
        skip_leading_rows = 1,
        autodetect = True,
        write_disposition = "WRITE_TRUNCATE"
    )
    with open(csv_path, "rb") as file:
        job = client.load_table_from_file(file,table_id,job_config=job_config)
   
    job.result()
    return job.output_rows



dataset = [ 
    {"csv": "raw_orders.csv", "table": "raw_orders"},
    {"csv": "raw_payments.csv", "table": "raw_payments"},
    {"csv": "raw_customers.csv", "table": "raw_customers"},
    {"csv": "raw_order_items.csv", "table": "raw_order_items"},
    {"csv": "raw_products.csv", "table": "raw_products"}
    ]




for r in dataset:
   
    try:
         rows = load_table(client, csv_path + r["csv"], f"brilliant-vent-489218-d2.analytics_engineering_raw.{r['table']}")
         print(f"{r['table']} loaded successfully — {rows} rows")
    except Exception as e:
           print(f"{r['table']} FAILED: {e}")