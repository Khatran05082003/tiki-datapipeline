from google.cloud import bigquery
from google.cloud.bigquery import LoadJobConfig, SourceFormat
import os

service_account_path = "service_account.json"
os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = service_account_path

client = bigquery.Client()

tables_files = {
    "dwproject-424604.dataset.product": "/home/kha_tran_0508/astro/include/data/data.csv"
}

def load_data_from_file(table_id, file_path):
    try:
        job_config = LoadJobConfig(
            source_format=SourceFormat.CSV,
            skip_leading_rows=1,  
            autodetect=True  
        )

        with open(file_path, "rb") as source_file:
            load_job = client.load_table_from_file(source_file, table_id, job_config=job_config)
        
        # Chờ đợi kết quả của công việc tải
        load_job.result()
        print(f"Loaded {file_path} into {table_id}")
    
    except Exception as e:
        print(f"Failed to load {file_path} into {table_id}. Error: {str(e)}")


for table_id, file_name in tables_files.items():
    load_data_from_file(table_id, file_name)
